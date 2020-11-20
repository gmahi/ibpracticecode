*&---------------------------------------------------------------------*
*& Report ZZD530_TABLE_DATA
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

REPORT zzd530_table_data.

*&---------------------------------------------------------------------*
*&       Class lcl_xslx_from_itab
*&---------------------------------------------------------------------*
*        Text
*----------------------------------------------------------------------*
CLASS lcl_xslx_from_itab DEFINITION.

  PUBLIC SECTION.
    CLASS-METHODS:  create_xls_from_itab IMPORTING
                                                   it_fieldcat TYPE lvc_t_fcat OPTIONAL
                                                   it_sort     TYPE lvc_t_sort OPTIONAL
                                                   it_filt     TYPE lvc_t_filt OPTIONAL
                                                   is_layout   TYPE lvc_s_layo OPTIONAL
                                                   i_xlsx      TYPE flag OPTIONAL
                                         EXPORTING e_xstring   TYPE xstring
                                         CHANGING  ct_data     TYPE STANDARD TABLE.





ENDCLASS.


*&---------------------------------------------------------------------*
*&       Class (Implementation)  lcl_xslx_from_itab
*&---------------------------------------------------------------------*
*        Text
*----------------------------------------------------------------------*
CLASS lcl_xslx_from_itab IMPLEMENTATION.

  METHOD create_xls_from_itab.

    DATA: mt_fcat TYPE lvc_t_fcat.
    DATA: mt_data       TYPE REF TO data.
    DATA: m_flavour TYPE string.
    DATA: m_version TYPE string.
    DATA: mo_result_data TYPE REF TO cl_salv_ex_result_data_table.
    DATA: mo_columns  TYPE REF TO cl_salv_columns_table.
    DATA: mo_aggreg   TYPE REF TO cl_salv_aggregations.
    DATA: mo_salv_table  TYPE REF TO cl_salv_table.
    DATA: m_file_type TYPE salv_bs_constant.
    FIELD-SYMBOLS <tab> TYPE ANY TABLE.

    GET REFERENCE OF ct_data INTO mt_data.

*if we didn't pass fieldcatalog we need to create it
    IF it_fieldcat[] IS INITIAL.
      ASSIGN mt_data->* TO <tab>.
      TRY .
          cl_salv_table=>factory(
          EXPORTING
            list_display = abap_false
          IMPORTING
            r_salv_table = mo_salv_table
          CHANGING
            t_table      = <tab> ).
        CATCH cx_salv_msg.

      ENDTRY.
      "get colums & aggregation infor to create fieldcat
      mo_columns  = mo_salv_table->get_columns( ).
      mo_aggreg   = mo_salv_table->get_aggregations( ).
      mt_fcat     =  cl_salv_controller_metadata=>get_lvc_fieldcatalog(
                                    r_columns      = mo_columns
                                    r_aggregations = mo_aggreg ).
    ELSE.
*else we take the one we passed
      mt_fcat[] = it_fieldcat[].
    ENDIF.


    IF cl_salv_bs_a_xml_base=>get_version( ) EQ if_salv_bs_xml=>version_25 OR
       cl_salv_bs_a_xml_base=>get_version( ) EQ if_salv_bs_xml=>version_26.

      mo_result_data = cl_salv_ex_util=>factory_result_data_table(
          r_data                      = mt_data
          s_layout                    = is_layout
          t_fieldcatalog              = mt_fcat
          t_sort                      = it_sort
          t_filter                    = it_filt
      ).

      CASE cl_salv_bs_a_xml_base=>get_version( ).
        WHEN if_salv_bs_xml=>version_25.
          m_version = if_salv_bs_xml=>version_25.
        WHEN if_salv_bs_xml=>version_26.
          m_version = if_salv_bs_xml=>version_26.
      ENDCASE.

      "if we flag i_XLSX then we'll create XLSX if not then MHTML excel file
      IF i_xlsx IS NOT INITIAL.
        m_file_type = if_salv_bs_xml=>c_type_xlsx.
      ELSE.
        m_file_type = if_salv_bs_xml=>c_type_mhtml.
      ENDIF.


      m_flavour = if_salv_bs_c_tt=>c_tt_xml_flavour_export.
      "transformation of data to excel
      CALL METHOD cl_salv_bs_tt_util=>if_salv_bs_tt_util~transform
        EXPORTING
          xml_type      = m_file_type
          xml_version   = m_version
          r_result_data = mo_result_data
          xml_flavour   = m_flavour
          gui_type      = if_salv_bs_xml=>c_gui_type_gui
        IMPORTING
          xml           = e_xstring.
    ENDIF.


  ENDMETHOD.

ENDCLASS.               "lcl_xslx_from_itab






DATA: gt_file TYPE filetable WITH HEADER LINE.
DATA: g_rc TYPE i.
DATA: gt_spfli TYPE STANDARD TABLE OF spfli.
DATA: g_xstring TYPE xstring.
DATA: g_size TYPE i.
DATA: gt_bintab TYPE solix_tab.
DATA: g_filename TYPE string.
DATA: g_path TYPE string.
"get path
PARAMETERS: p_path TYPE string OBLIGATORY.



AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_path.

  cl_gui_frontend_services=>file_save_dialog(
    EXPORTING
*      window_title         = window_title
      default_extension    = 'XLS'
*      default_file_name    = default_file_name
*      with_encoding        = with_encoding
*      file_filter          = file_filter
*      initial_directory    = initial_directory
*      prompt_on_overwrite  = 'X'
    CHANGING
      filename             = g_filename
      path                 = g_path
      fullpath             = p_path
*      user_action          = user_action
*      file_encoding        = file_encoding
    EXCEPTIONS
      cntl_error           = 1
      error_no_gui         = 2
      not_supported_by_gui = 3
      OTHERS               = 4
         ).
  IF sy-subrc <> 0.
*   Implement suitable error handling here
  ENDIF.


START-OF-SELECTION.


  TYPES:BEGIN OF  ty_tabname,
          tabname TYPE tabname,
        END OF ty_tabname.
  TYPES: tt_tabname TYPE RANGE OF tabname.

  DATA: lv_tabname TYPE tabname VALUE 'SPFLI'
*      lt_tables  TYPE STANDARD TABLE OF ty_tabname
        .



  SELECT obj_name INTO TABLE @DATA(lt_result) FROM tadir AS dir INNER JOIN dd02l AS tt ON dir~obj_name
  = tt~tabname
*FOR ALL ENTRIES IN t_descendant
  WHERE pgmid = 'R3TR' AND object = 'TABL' AND tt~tabclass = 'TRANSP' AND dir~devclass = 'ZZD530'.

  DATA(lt_tables)  = VALUE tt_tabname(
    "( sign = 'I' option = 'BT' low = '001' high = '002' )
    FOR ls_tab IN lt_result
      LET s = 'I'
          o = 'EQ'
        IN sign     = s
           option   = o
    ( low = ls_tab-obj_name )
  ).

*
*lt_tables = VALUE #( FOR tab IN lt_result
*                       ( tabname = tab )        ).

  SELECT FROM dd03vt AS a INNER JOIN dd04l AS b ON a~rollname = b~rollname
    FIELDS a~tabletype, a~tabname, a~fieldname, a~ddtext, a~keyflag, a~rollname, a~datatype, a~leng, length( b~shlpname ) AS srh_len,
    CASE WHEN length( b~shlpname ) > 0   THEN 'Srch Help'
         WHEN length( b~shlpname ) = 0  THEN 'Domain'
    END AS srh_type,
     CASE WHEN length( b~shlpname ) > 0  THEN b~shlpname
         WHEN length( b~shlpname ) = 0  THEN b~domname
    END AS srhelp
    WHERE a~tabname IN @lt_tables  AND   a~ddlanguage = 'E'

    INTO TABLE @DATA(lt_fields)
    .

**a~tabname = @lv_tabname
**                AND
*
*  cl_demo_output=>display(
*    EXPORTING
*      data =  lt_fields   " Text  oder Daten
**    name =
*  ).


  "call creation of xls
 lcl_xslx_from_itab=>create_xls_from_itab(
*    exporting
*    it_fieldcat       = it_fieldcat
*    it_sort           = it_sort
*    it_filt           = it_filt
*    is_layout         = is_layout
*    i_xlsx             = 'X'
    IMPORTING
      e_xstring         = g_xstring
    CHANGING
      ct_data           =  lt_fields
         ).

  IF g_xstring IS NOT INITIAL.
    "save file
    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer        = g_xstring
*       APPEND_TO_TABLE = ' '
      IMPORTING
        output_length = g_size
      TABLES
        binary_tab    = gt_bintab.

    cl_gui_frontend_services=>gui_download(
      EXPORTING
        bin_filesize              = g_size
        filename                  = p_path
        filetype                  = 'BIN'
      CHANGING
        data_tab                  = gt_bintab
      EXCEPTIONS
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
        OTHERS                    = 24
           ).
    IF sy-subrc <> 0.
*     Implement suitable error handling here
    ENDIF.

  ENDIF.
