*&---------------------------------------------------------------------*
*& Include zr_excle_import_export_inc
*&---------------------------------------------------------------------*

class lcx_configuration definition
                         inheriting from cx_static_check.
  public section.
    data local_text type string.
    methods constructor importing text type string.
endclass.

class lcx_configuration implementation.
  method constructor.
    super->constructor( ).
    local_text = text.
  endmethod.
endclass.
*&---------------------------------------------------------------------*
*& Class lcl_configuration
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
class lcl_configuration definition.
  public section.
    data filefullpath type string.
    data tablename type string.
    data sqlscript type string.
    data tableinfo type tadir.
    data tablestructure type ref to cl_abap_structdescr.
    data tabletype      type ref to cl_abap_tabledescr.
    data tabledata type ref to data.

    class-methods validate_sql_script
      changing sqlscript type string.

    class-methods validate_table
      changing checkedtablename type string
      raising  lcx_configuration.

    methods constructor "Constructore method
      importing filefullpath type string
                tablename    type string
                sqlscript    type string
      raising   lcx_configuration.
    methods import raising   lcx_configuration.
    methods export raising   lcx_configuration.
  protected section.
    methods get_filecontent
      returning value(filecontent) type xstring
      raising   lcx_configuration.
    methods extract_data_from_table
      raising lcx_configuration.
    methods check_file
      raising lcx_configuration.
    methods extract_data_from_excel
      raising lcx_configuration.
    methods get_tablecontent
      exporting tablecontent type any table
      raising   lcx_configuration.
  private section.
endclass.

class lcl_configuration implementation.
  method constructor.
    if filefullpath is initial or tablename is initial.
      raise exception type lcx_configuration
        exporting
          text = |File Name { filefullpath } and Table Name { tablename } should be provided|.
    endif.
    me->filefullpath = filefullpath.
    me->tablename = tablename.
    me->sqlscript = sqlscript.

    lcl_configuration=>validate_table( changing checkedtablename = me->tablename ).

    me->tablestructure ?= cl_abap_typedescr=>describe_by_name( me->tablename  ).
    if not me->tablestructure is bound.
      raise exception type lcx_configuration
        exporting
          text = |Exception occurs when parsing Table Structure for { tablename } |.
    endif.
    try.
        me->tabletype = cl_abap_tabledescr=>create( p_line_type = me->tablestructure ).
      catch cx_sy_table_creation into data(tabletypeexception).
        raise exception type lcx_configuration
          exporting
            text = |Exception occurs when parsing Table Type for { tablename } |.
    endtry.
    create data tabledata type handle me->tabletype.
  endmethod.
  method import.
    "Update DDIC table content from (client PC) excel file
    me->extract_data_from_excel( ).

    field-symbols <finaltabledata> type standard table.
    data finaltabledata type ref to data.
    create data finaltabledata type handle me->tabletype.
    assign finaltabledata->* to <finaltabledata>.

    field-symbols <tabledata> type standard table.
    assign me->tabledata->* to <tabledata>.
    loop at <tabledata> assigning field-symbol(<currenttabledata>).
      assign component 'MANDT' of structure <currenttabledata> to field-symbol(<lv_client>).
      if sy-subrc = 0.
        <lv_client> = ''.
        if not <currenttabledata> is initial.
          <lv_client> = sy-mandt.
          append <currenttabledata> to <finaltabledata>.
        else.
          "delete <tabledata> from <currenttabledata>.
        endif.
      else.
        if <currenttabledata> is initial.
          "delete <tabledata> from <currenttabledata>.
        endif.
      endif.
    endloop.

    data(checkedtablename) = me->tablename.
    lcl_configuration=>validate_table( changing checkedtablename = checkedtablename ).

    if not <finaltabledata> is initial.
      modify (checkedtablename) from  table <finaltabledata>.
      "break-point.
      if sy-subrc <> 0.
        rollback work.
        raise exception type lcx_configuration
          exporting
            text = |Exception occurs when modifying table:  { tablename } |.
      else.
        message s001(00) with |Table:  { tablename } is modified successfully.|.
      endif.
    endif.

  endmethod.
  method export.
    "Create client PC excel file from DDIC table
    data(filecontent) = me->get_filecontent( ).

    cl_scp_change_db=>xstr_to_xtab( exporting im_xstring = filecontent
                                    importing ex_xtab    = data(filecontenttab) ).

    cl_gui_frontend_services=>gui_download(
      exporting
        bin_filesize              = xstrlen( filecontent )
        filename                  = |{ me->filefullpath }|
        filetype                  = 'BIN'
        confirm_overwrite         = abap_true
      importing
        filelength                = data(bytestransferred)
      changing
        data_tab                  = filecontenttab
      exceptions
        file_write_error          = 1
        no_batch                  = 2
        gui_refuse_filetransfer   = 3
        invalid_type              = 4
        no_authority              = 5
        unknown_error             = 6
        header_not_allowed        = 7
        separator_not_allowed     = 8
        filesize_not_allowed      = 9
        header_too_long           = 10
        dp_error_create           = 11
        dp_error_send             = 12
        dp_error_write            = 13
        unknown_dp_error          = 14
        access_denied             = 15
        dp_out_of_memory          = 16
        disk_full                 = 17
        dp_timeout                = 18
        file_not_found            = 19
        dataprovider_exception    = 20
        control_flush_error       = 21
        not_supported_by_gui      = 22
        error_no_gui              = 23
        others                    = 24
    ).
    if sy-subrc <> 0.
      message id sy-msgid type sy-msgty number sy-msgno
                 with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    else.
      message s001(00) with bytestransferred ' bytes transferred'.
    endif.
  endmethod.

  method get_filecontent.
    me->extract_data_from_table( ).

    if me->tabledata is initial.
      raise exception type lcx_configuration
        exporting
          text = |Table { tablename } has no entry.|.
    endif.

    "Get file content from table
    clear filecontent.
    try.
        data(xlsx_handling) = cl_ehfnd_xlsx=>get_instance( ).
        data(xlsx_document) = xlsx_handling->create_doc( ).
        data(xlsx_sheets) = xlsx_document->get_sheets( ).
        data(first_xlsx_sheet) = xlsx_document->get_sheet_by_id( xlsx_sheets[ 1 ]-sheet_id ).
        first_xlsx_sheet->change_sheet_name( 'Data' ).
        data(lv_column) = 1.

        loop at me->tablestructure->components reference into data(component).
          first_xlsx_sheet->set_cell_content( iv_row = 1 iv_column = lv_column iv_value = component->name ).
          lv_column = lv_column + 1.
        endloop.

        data(lv_row) = 2.
        field-symbols <tabledata> type standard table.
        assign me->tabledata->* to <tabledata>.
        loop at <tabledata> assigning field-symbol(<currenttabledata>).
          lv_column = 1.
          loop at me->tablestructure->components reference into component.
            assign component component->name of structure <currenttabledata> to field-symbol(<columnvalue>).
            first_xlsx_sheet->set_cell_content( iv_row = lv_row iv_column = lv_column iv_value = <columnvalue> ).
            lv_column = lv_column + 1.
          endloop.
          lv_row = lv_row + 1.
        endloop.
        filecontent = xlsx_document->save( ).

      catch cx_openxml_format  into data(openxml_format_exception).
        raise exception type lcx_configuration
          exporting
            text = |Error occurs when constructing excel file instance. cx_openxml_format|.
      catch cx_openxml_not_found into data(openxml_not_found_exception).
        raise exception type lcx_configuration
          exporting
            text = |Error occurs when constructing excel file instance. CX_OPENXML_NOT_FOUND |.

      catch cx_openxml_not_allowed into data(openxml_not_allowed_exception).
        raise exception type lcx_configuration
          exporting
            text = |Error occurs when constructing excel file instance. CX_OPENXML_NOT_ALLOWED |.

    endtry.
  endmethod.

  method get_tablecontent.
    "Get table content from file

  endmethod.
  method validate_table.
    "raise exception if table does not exist
    select single * from tadir into @data(tableinfo) where obj_name = @checkedtablename and object = 'TABL'. "#EC CI_GENBUFF.
    if sy-subrc <> 0.
      raise exception type lcx_configuration
        exporting
          text = |Table { checkedtablename } does not exist.|.
    endif.

    try.
        checkedtablename =
           cl_abap_dyn_prg=>check_table_or_view_name_str(
            val = checkedtablename
            packages = conv #( tableinfo-devclass )
            incl_sub_packages = abap_true
            ).
      catch cx_abap_not_a_table
            cx_abap_not_in_package.
        return.
    endtry.
  endmethod.
  method extract_data_from_table.
    data sql_script type string.
    data checkedtablename type string.
    sql_script = me->sqlscript.
    checkedtablename = me->tablename.

    lcl_configuration=>validate_sql_script( changing sqlscript = sql_script ).
    lcl_configuration=>validate_table( changing checkedtablename = checkedtablename ).

    field-symbols <tabledata> type standard table.
    assign tabledata->* to <tabledata>.
    if me->sqlscript is initial.
      select * from (checkedtablename) into table <tabledata>.
    else.
      select * from (checkedtablename) into table <tabledata> where (sql_script).
    endif.

  endmethod.

  method validate_sql_script.
    if sqlscript is initial.
      return.
    endif.

    sqlscript = replace( val  = sqlscript
                          sub  = `'`
                          with = `''`
                          occ  = 0 ).
    concatenate `'`  sqlscript `'` into sqlscript separated by space.
    try.
        sqlscript =
         cl_abap_dyn_prg=>check_char_literal( sqlscript ).

        data(lv_len) = strlen( sqlscript ) - 2.
        sqlscript = sqlscript+1(lv_len).
        sqlscript = replace( val  = sqlscript
                                   sub  = `''`
                                   with = `'`
                                   occ  = 0 ).

      catch cx_abap_invalid_value into data(lo_exception).
        clear sqlscript.
    endtry.
  endmethod.

  method check_file.

  endmethod.
  method extract_data_from_excel.
    field-symbols <exceldata> type standard table.
    assign me->tabledata->* to <exceldata>.

    data(xlsxhandler) = cl_ehfnd_xlsx=>get_instance( ).
    check not xlsxhandler is initial.

    try.
        data(xstring_excel) = cl_openxml_helper=>load_local_file( me->filefullpath ).
      catch cx_openxml_not_found into data(openxml_not_found).
        return.
    endtry.

    try.
        data(xlsxdocument) = xlsxhandler->load_doc( iv_file_data = xstring_excel ).
      catch cx_openxml_format into data(openxml_format).
        return.
      catch cx_openxml_not_allowed into data(openxml_not_allowed).
        return.
      catch cx_dynamic_check into data(dynamic_check).
        return.
    endtry.

    "extract data from first sheet
    try.
        data(firstsheet) = xlsxdocument->get_sheet_by_id( iv_sheet_id = 1 ).
      catch cx_openxml_format  into openxml_format.
        raise exception type lcx_configuration
          exporting
            text = |Error occurs when extract data from first sheet: CX_OPENXML_FORMAT |.
      catch cx_openxml_not_found  into openxml_not_found.
        raise exception type lcx_configuration
          exporting
            text = |Error occurs when extract data from first sheet: OPENXML_NOT_FOUND |.
      catch cx_dynamic_check  into dynamic_check.
        RAISE EXCEPTION TYPE lcx_configuration
          EXPORTING
            text = |Error occurs when extract data from first sheet: CX_DYNAMIC_CHECK |.
    endtry.
    "return if no sheet in xlsx file
    check not firstsheet is initial.

    "check file structure, first line of excel file
    data(columncount) = firstsheet->get_last_column_number_in_row( 1 ).
    data column type i value 1.
    "data tablecomponents type cl_abap_structdescr=>component_table.
    data(tablecomponents) = me->tablestructure->get_components( ).

    data invalidcolumn type string.
    types: begin of columninfo,
             column     type i,
             columnname type string,
           end of columninfo.
    types columnsinfo type standard table of columninfo with empty key.

    data columnfromfile type columnsinfo.

    do columncount times.
      data(cellvalue) = firstsheet->get_cell_content(
                            exporting
                              iv_row     = 1
                              iv_column  = column ).

      append initial line to columnfromfile assigning field-symbol(<columnfromfile>).
      <columnfromfile>-column = column.
      <columnfromfile>-columnname = cellvalue.

      if line_exists( tablecomponents[ name = cellvalue ]   ).
        delete tablecomponents where name = cellvalue.
      else.
        invalidcolumn = invalidcolumn && |,{ cellvalue }|.
      endif.
      column = column + 1.
    enddo.
    data missingcolumns type string.
    loop at tablecomponents reference into data(currentcomponent).
      missingcolumns = missingcolumns && |, { currentcomponent->*-name }|.
    endloop.
    if not invalidcolumn is initial.
      raise exception type lcx_configuration
        exporting
          text = |Find invalid columns: { invalidcolumn } |.
    endif.

    if not missingcolumns is initial.
      raise exception type lcx_configuration
        exporting
          text = |Columns do not exist in excel file: { missingcolumns } |.
    endif.

    tablecomponents = me->tablestructure->get_components( ).
    data(rowcount) = firstsheet->get_last_row_number( ).
    data currentrow type i value 2.
    while currentrow <= rowcount.
      append initial line to <exceldata> assigning field-symbol(<currentrow>).
      loop at columnfromfile reference into data(currentcolumn).
        cellvalue = firstsheet->get_cell_content(
                              exporting
                                iv_row     = currentrow
                                iv_column  = currentcolumn->*-column ).
        assign component currentcolumn->*-columnname of structure <currentrow> to field-symbol(<cellvalue>).
        <cellvalue> = cellvalue.
      endloop.
      currentrow = currentrow + 1.
    endwhile.
  endmethod.
endclass.
