*&---------------------------------------------------------------------*
*& Report zz_r_key_mapping
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zz_r_key_mapping.

CLASS lcx_key_mapping  DEFINITION
                        INHERITING FROM cx_static_check.
  PUBLIC SECTION.
    DATA local_text TYPE string.
    METHODS constructor IMPORTING text TYPE string.
ENDCLASS.

CLASS lcx_key_mapping IMPLEMENTATION.
  METHOD constructor.
    super->constructor( ).
    local_text = text.
  ENDMETHOD.
ENDCLASS.


CLASS lcl_key_mapping DEFINITION.

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_s_return,
             bpid_s  TYPE bu_partner,
             Success TYPE abap_bool,
             msg     TYPE msg,
           END OF ty_s_return,
           tt_s_return TYPE STANDARD TABLE OF ty_s_return WITH EMPTY KEY.


    METHODS constructor
      IMPORTING target_system TYPE sld_bskey
      RAISING   lcx_key_mapping.

    METHODS create_key_mapping RETURNING VALUE(rt_message) TYPE tt_s_return
                               RAISING   lcx_key_mapping .
    METHODS delete_key_mapping RETURNING VALUE(rt_message) TYPE tt_s_return
                               RAISING   lcx_key_mapping .
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:BEGIN OF ty_km_record,
            bpid_s   TYPE bu_partner,
            bpguid_s TYPE bu_partner_guid_bapi,
            bpid_t   TYPE bu_partner,
            bpguid_t TYPE bu_partner_guid_bapi,
            customer TYPE xflag,
            vendor   TYPE xflag,
            kunnr    TYPE kunnr,
            lifnr    TYPE lifnr,
          END OF ty_km_record.
    CONSTANTS: BEGIN OF gc_mdg_object_type_code,
                 bp       TYPE  mdg_object_type_code_bs VALUE '147',
                 customer TYPE  mdg_object_type_code_bs VALUE '159',
                 supplier TYPE  mdg_object_type_code_bs VALUE '266',
               END OF gc_mdg_object_type_code,
               BEGIN OF gc_mdg_id_type_code,
                 bp_id    TYPE mdg_ids_type_code_bs  VALUE '888',
                 bp_uuid  TYPE mdg_ids_type_code_bs VALUE '889',
                 customer TYPE mdg_ids_type_code_bs VALUE '918',
                 supplier TYPE mdg_ids_type_code_bs VALUE '892',
               END OF gc_mdg_id_type_code.

    DATA: gv_target_system TYPE sld_bskey.
*    METHODS:extract_excel_data RAISING lcx_key_mapping,
    METHODS:get_customer IMPORTING im_bp_guid      TYPE bu_partner_guid
                         RETURNING VALUE(rv_kunnr) TYPE kunnr
                         RAISING   lcx_key_mapping,
      get_vendor IMPORTING im_bp_guid      TYPE bu_partner_guid
                 RETURNING VALUE(rv_lifnr) TYPE lifnr
                 RAISING   lcx_key_mapping,
      get_uuid
        IMPORTING
                   iv_guid        TYPE bu_partner_guid_bapi
        RETURNING
                   VALUE(rv_uuid) TYPE mdg_object_id_bs
        EXCEPTIONS cx_gdt_conversion.


ENDCLASS.


SELECTION-SCREEN BEGIN OF BLOCK b04 WITH FRAME TITLE TEXT-b04.
  PARAMETERS  p_create RADIOBUTTON GROUP radi USER-COMMAND action DEFAULT 'X'.
  PARAMETERS  p_delete RADIOBUTTON GROUP radi.
SELECTION-SCREEN END OF BLOCK b04.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01.

*  PARAMETERS p_file TYPE localfile MODIF ID gp1 OBLIGATORY MEMORY ID hf.

  PARAMETERS  p_target TYPE sld_bskey OBLIGATORY MATCHCODE OBJECT  rs_logsys.

SELECTION-SCREEN END OF BLOCK b01.


SELECTION-SCREEN BEGIN OF BLOCK b02 WITH FRAME TITLE TEXT-b02.
  PARAMETERS p_sim TYPE simulcon.
SELECTION-SCREEN END OF BLOCK b02.

*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
**  call function 'F4_FILENAME'
**    exporting
**      field_name = 'P_FILE'
**    importing
**      file_name  = p_file.
*
*  DATA(title) = |Select Excel File, e.g. *.xlsx|.
*  DATA(defaultextension) = |.xlsx|.
*  DATA(filefilter) = `Excel Files (*.xlsx)|*.xlsx`.
*  DATA it_tab TYPE filetable.
*  DATA returncode TYPE i.
*
*  CALL METHOD cl_gui_frontend_services=>file_open_dialog
*    EXPORTING
*      window_title      = title
*      default_extension = defaultextension
*    CHANGING
*      file_table        = it_tab
*      rc                = returncode.
*  IF sy-subrc <> 0.
**   Implement suitable error handling here
*  ENDIF.
*
*  READ TABLE it_tab ASSIGNING FIELD-SYMBOL(<selectedfilename>) INDEX 1.
*  IF sy-subrc = 0.
*    p_file = <selectedfilename>-filename.
*  ENDIF.

START-OF-SELECTION.

  DATA(lo_km) = NEW lcl_key_mapping(   p_target  ).

  TRY.
      IF p_create IS NOT INITIAL .
        DATA(lt_messages)   =  lo_km->create_key_mapping( ).
        IF NOT  lt_messages IS INITIAL.
          LOOP AT lt_messages INTO DATA(lv_message).
*            WRITE:/ lv_message.
          ENDLOOP.
        ENDIF.
      ELSE.
        lo_km->delete_key_mapping( ).
        IF sy-subrc = 0.
*          WRITE:/ 'Selected key mapping objects succesfully deleted.'.
        ENDIF.
      ENDIF.
    CATCH lcx_key_mapping INTO DATA(lx_key_mapping).
      WRITE:/ lx_key_mapping->get_longtext( ).
  ENDTRY.

END-OF-SELECTION.


CLASS lcl_key_mapping IMPLEMENTATION.

  METHOD constructor .
    IF  target_system IS INITIAL.
      RAISE EXCEPTION TYPE lcx_key_mapping
        EXPORTING
          text = | Target System { target_system } should be provided|.
    ENDIF.
*    me->gv_filefullpath = filefullpath.
    me->gv_target_system = target_system.

  ENDMETHOD.

*  METHOD extract_excel_data.
*
*    TYPES: BEGIN OF ty_columninfo,
*             column     TYPE i,
*             columnname TYPE string,
*           END OF ty_columninfo,
*           tt_columninfo TYPE STANDARD TABLE OF ty_columninfo.
*    DATA  lt_columninfo TYPE tt_columninfo.
*
*    DATA(lo_xlsxhandler) = cl_ehfnd_xlsx=>get_instance( ).
*    CHECK NOT lo_xlsxhandler IS INITIAL.
*
*    TRY.
*        DATA(xstring_excel)  = cl_openxml_helper=>load_local_file( gv_filefullpath  ).
*      CATCH cx_openxml_not_found INTO DATA(lx_openxml_not_found).
*        RETURN.
*    ENDTRY.
*    TRY.
*        DATA(lo_xlsxdocument) = lo_xlsxhandler->load_doc( iv_file_data = xstring_excel ).
*      CATCH cx_openxml_format INTO DATA(lx_openxml_format).
*        RETURN.
*      CATCH cx_openxml_not_allowed INTO DATA(lx_openxml_not_allowed).
*        RETURN.
*      CATCH cx_dynamic_check INTO DATA(lx_dynamic_check).
*        RETURN.
*    ENDTRY.
*    "extract data from first sheet
*    TRY.
*        DATA(lo_first_sheet)  = lo_xlsxdocument->get_sheet_by_id( iv_sheet_id = 1 ).
*      CATCH cx_openxml_format INTO lx_openxml_format.
*        RAISE EXCEPTION TYPE lcx_key_mapping
*          EXPORTING
*            text = |Error occurs when extract data from first sheet: CX_OPENXML_FORMAT |.
*        .
*      CATCH cx_openxml_not_found INTO lx_openxml_not_found.
*        RAISE EXCEPTION TYPE lcx_key_mapping
*          EXPORTING
*            text = |Error occurs when extract data from first sheet: OPENXML_NOT_FOUND |.
*        .
*      CATCH cx_dynamic_check INTO lx_dynamic_check.
*        RAISE EXCEPTION TYPE lcx_key_mapping
*          EXPORTING
*            text = |Error occurs when extract data from first sheet: CX_DYNAMIC_CHECK |.
*
*    ENDTRY.
*
*    CHECK NOT  lo_first_sheet IS INITIAL.
*
*    "check file structure, first line of excel file
*    DATA(column_count) = lo_first_sheet->get_last_column_number_in_row( 1  ).
*    DATA column TYPE i VALUE 1.
*    DO column_count TIMES.
*
*      DATA(cell_value) = lo_first_sheet->get_cell_content(
*                           iv_row    = 1
*                           iv_column = column
*                         ).
*      APPEND INITIAL LINE TO lt_columninfo ASSIGNING FIELD-SYMBOL(<ls_columninfo>) .
*      <ls_columninfo>-column = column.
*      <ls_columninfo>-columnname = cell_value.
*      ADD 1 TO column.
*    ENDDO.
*
*
*    DATA(row_count)   = lo_first_sheet->get_last_row_number(  ).
*    DATA current_row TYPE i VALUE 2.
*
*    WHILE current_row <= row_count.
*
*      APPEND INITIAL LINE TO gt_km_record ASSIGNING FIELD-SYMBOL(<ls_km_record>).
*      LOOP AT lt_columninfo INTO DATA(ls_columninfo).
*        cell_value = lo_first_sheet->get_cell_content(
*                       iv_row    = current_row
*                       iv_column =  ls_columninfo-column
*                     ).
*        ASSIGN COMPONENT ls_columninfo-columnname OF STRUCTURE  <ls_km_record> TO  FIELD-SYMBOL(<lv_cellvalue>).
*        <lv_cellvalue> = cell_value.
*      ENDLOOP.
*      ADD 1 TO current_row.
*    ENDWHILE.
*
*
*
*  ENDMETHOD.

  METHOD create_key_mapping.

    DATA  ls_message LIKE LINE OF rt_message.
    DATA: ls_matching          TYPE mdg_s_matching_grp_data_bs,
          lt_matching          TYPE mdg_t_matching_grp_data_bs,
          ls_matching_objects  TYPE mdg_s_matching_obj_data_inp_bs,
          ls_object_identifier TYPE mdg_s_identifier_bs.

*get km  data from table
*    extract_excel_data( ).
    SELECT * FROM ztkeymapping INTO TABLE @DATA(lt_km_data).

    TRY.
        cl_mdg_id_matching_api_bs=>get_instance(
          EXPORTING
            iv_direct_db_insert       = abap_false
            iv_set_lcl_system_by_api  = abap_true
          IMPORTING
            er_if_mdg_id_matching_api = DATA(lo_match_api)
            ev_lcl_business_system    = DATA(lv_local_sys)
        ).
      CATCH               cx_mdg_id_matching_bs INTO DATA(lx_mdg_id_matching_bs).
        RAISE EXCEPTION TYPE lcx_key_mapping
          EXPORTING
            text = lx_mdg_id_matching_bs->get_longtext( ).

      CATCH               cx_mdg_no_api_instance INTO DATA(lx_no_api_instance).

        RAISE EXCEPTION TYPE lcx_key_mapping
          EXPORTING
            text = lx_no_api_instance->get_longtext( ).

      CATCH  cx_mdg_lcl_bus_sys_not_found INTO DATA(lx_bus_sys_not_found).
        RAISE EXCEPTION TYPE lcx_key_mapping
          EXPORTING
            text = lx_bus_sys_not_found->get_longtext( ).

    ENDTRY.

    CHECK lo_match_api IS NOT INITIAL.
    CHECK lv_local_sys IS NOT INITIAL.

* & --- Adding new Matching.

    LOOP AT lt_km_data INTO DATA(ls_km_record).

* fill BP ID / HUB system
      IF NOT ls_km_record-bpid_s IS INITIAL.

        ls_object_identifier = VALUE #( ident_defining_scheme_code = gc_mdg_id_type_code-bp_id
                                        business_system_id         = lv_local_sys
                                        id_value                   =  ls_km_record-bpid_s
                                                                                                  ).
        APPEND ls_object_identifier TO ls_matching_objects-object_identifier.
        CLEAR ls_object_identifier.
      ENDIF.
* fill BP UUID / HUB system
      IF NOT ls_km_record-bpguid_s IS INITIAL.

        ls_object_identifier = VALUE #( ident_defining_scheme_code = gc_mdg_id_type_code-bp_uuid
                                        business_system_id         = lv_local_sys
                                        id_value                   = get_uuid( iv_guid = ls_km_record-bpguid_s ) ).
        APPEND ls_object_identifier TO ls_matching_objects-object_identifier.
        CLEAR ls_object_identifier.
      ENDIF.

      IF NOT ls_matching_objects IS INITIAL.
        ls_matching_objects-group_reference = abap_true.
        ls_matching_objects-system_reference = abap_true.
        ls_matching_objects-object_type_code = gc_mdg_object_type_code-bp.
        APPEND ls_matching_objects TO ls_matching-matching_objects.
        CLEAR ls_matching_objects.
      ENDIF.

*       Fill KUNNR / HUB system
      DATA(customer_source) = get_customer( im_bp_guid = CONV #( ls_km_record-bpguid_s ) ).
*                             CATCH lcx_key_mapping.

      IF NOT customer_source IS  INITIAL AND ls_km_record-customer = abap_true.
        ls_object_identifier-ident_defining_scheme_code = gc_mdg_id_type_code-customer.
        ls_object_identifier-business_system_id = lv_local_sys.
        ls_object_identifier-id_value = customer_source.
        APPEND ls_object_identifier TO ls_matching_objects-object_identifier.
        CLEAR ls_object_identifier.
        ls_matching_objects-group_reference = abap_true.
        ls_matching_objects-system_reference = abap_true.
        ls_matching_objects-object_type_code = gc_mdg_object_type_code-customer.
        APPEND ls_matching_objects TO ls_matching-matching_objects.
        CLEAR ls_matching_objects.

      ENDIF.

*  Fill LIFNR / Target system
      DATA(supplier_source) = get_vendor( im_bp_guid = CONV #( ls_km_record-bpguid_s )  ).
*                        CATCH lcx_key_mapping.

      IF NOT  supplier_source IS  INITIAL AND ls_km_record-vendor = abap_true.
        ls_object_identifier-ident_defining_scheme_code = gc_mdg_id_type_code-supplier.
        ls_object_identifier-business_system_id = lv_local_sys.
        ls_object_identifier-id_value = supplier_source.
        APPEND ls_object_identifier TO ls_matching_objects-object_identifier.
        CLEAR ls_object_identifier.
        ls_matching_objects-group_reference = abap_true.
        ls_matching_objects-system_reference = abap_true.
        ls_matching_objects-object_type_code = gc_mdg_object_type_code-supplier.
        APPEND ls_matching_objects TO ls_matching-matching_objects.
        CLEAR ls_matching_objects.

      ENDIF.

*Fill BP ID target system

      IF NOT  ls_km_record-bpid_t IS INITIAL.
        ls_object_identifier = VALUE #( ident_defining_scheme_code = gc_mdg_id_type_code-bp_id
                                       business_system_id         = gv_target_system
                                       id_value                   =  ls_km_record-bpid_t
                                                                                                 ).
        APPEND ls_object_identifier TO ls_matching_objects-object_identifier.
        CLEAR ls_object_identifier.

      ENDIF.

*   fill BP UUID / HUB system
      IF NOT ls_km_record-bpguid_t IS INITIAL.

        ls_object_identifier = VALUE #( ident_defining_scheme_code = gc_mdg_id_type_code-bp_uuid
                                        business_system_id         = gv_target_system
                                        id_value                   = get_uuid( iv_guid = ls_km_record-bpguid_t ) ).
        APPEND ls_object_identifier TO ls_matching_objects-object_identifier.
        CLEAR ls_object_identifier.
      ENDIF.

      IF NOT ls_matching_objects IS INITIAL.
        ls_matching_objects-group_reference = abap_true.
        ls_matching_objects-system_reference = abap_true.
        ls_matching_objects-object_type_code = gc_mdg_object_type_code-bp.
        APPEND ls_matching_objects TO ls_matching-matching_objects.
        CLEAR ls_matching_objects.
      ENDIF.

* Fill KUNNR / Target system

      IF NOT ls_km_record-kunnr IS  INITIAL AND NOT customer_source IS INITIAL.
        ls_object_identifier-ident_defining_scheme_code = gc_mdg_id_type_code-customer.
        ls_object_identifier-business_system_id = gv_target_system.
        ls_object_identifier-id_value = ls_km_record-kunnr.
        APPEND ls_object_identifier TO ls_matching_objects-object_identifier.
        CLEAR ls_object_identifier.
        ls_matching_objects-group_reference = abap_true.
        ls_matching_objects-system_reference = abap_true.
        ls_matching_objects-object_type_code = gc_mdg_object_type_code-customer.
        APPEND ls_matching_objects TO ls_matching-matching_objects.
        CLEAR ls_matching_objects.

      ENDIF.

*  Fill LIFNR / Target system

      IF NOT ls_km_record-lifnr IS  INITIAL AND NOT supplier_source IS INITIAL.
        ls_object_identifier-ident_defining_scheme_code = gc_mdg_id_type_code-supplier.
        ls_object_identifier-business_system_id = gv_target_system.
        ls_object_identifier-id_value = ls_km_record-lifnr.
        APPEND ls_object_identifier TO ls_matching_objects-object_identifier.
        CLEAR ls_object_identifier.
        ls_matching_objects-group_reference = abap_true.
        ls_matching_objects-system_reference = abap_true.
        ls_matching_objects-object_type_code = gc_mdg_object_type_code-supplier.
        APPEND ls_matching_objects TO ls_matching-matching_objects.
        CLEAR ls_matching_objects.

      ENDIF.

      IF NOT ls_matching IS INITIAL.
        APPEND ls_matching TO lt_matching.

      ENDIF.

*& --- Adding Matching data - Key Mapping
      TRY.
          lo_match_api->add_matching(
            EXPORTING
              it_matching_complex        =  lt_matching
              iv_update_central_registry = abap_false
          ).
        CATCH cx_mdg_missing_input_parameter INTO DATA(lx_mdg_missing_input_parameter).
          DATA(lv_msg) = lx_mdg_missing_input_parameter->get_longtext( ).

        CATCH cx_mdg_missing_id_data INTO DATA(lx_missing_id_data).
          lv_msg = lx_missing_id_data->get_longtext( ).

        CATCH cx_mdg_otc_idm_error INTO DATA(lx_otc_idm_error).
          lv_msg = lx_otc_idm_error->get_longtext( ).

        CATCH cx_mdg_idsc_invalid INTO DATA(lx_idsc_invalid).
          lv_msg = lx_idsc_invalid->get_longtext( ).

        CATCH cx_mdg_id_matching_bs INTO DATA(lx_id_matching_bs).
          lv_msg = lx_id_matching_bs->get_longtext( ).

        CATCH cx_mdg_km_same_identifier INTO DATA(lx_km_same_identifier).
          lv_msg = lx_km_same_identifier->get_longtext( ).

        CATCH cx_mdg_no_ctrl_reg_defined INTO DATA(lx_no_ctrl_reg_defined).
          lv_msg = lx_no_ctrl_reg_defined->get_longtext( ).

        CATCH cx_mdg_different_bus_systems INTO DATA(lx_different_bus_systems).
          lv_msg = lx_missing_id_data->get_longtext( ).

        CATCH cx_mdg_km_invalid_id_value INTO DATA(lx_km_invalid_id_value).
          lv_msg = lx_missing_id_data->get_longtext( ).
      ENDTRY.
      IF p_sim = abap_true.
*      Save key mapping
        TRY.
            lo_match_api->save(
              EXPORTING
                iv_save_in_update_task = abap_false
                iv_no_exclusive_locks  = abap_false
              IMPORTING
                ev_save_successful     = DATA(lv_check)
            ).
          CATCH cx_mdg_id_matching_bs INTO lx_mdg_id_matching_bs.
            lv_msg = lx_mdg_id_matching_bs->get_longtext(  ).

        ENDTRY.
      ENDIF.


* Return structure
      ls_message = VALUE #( bpid_s = ls_km_record success = lv_check msg = lv_msg  ).
      APPEND ls_message TO rt_message.
      CLEAR lv_msg.

    ENDLOOP.

  ENDMETHOD.

  METHOD get_customer.

    SELECT SINGLE FROM cvi_cust_link FIELDS customer WHERE partner_guid = @im_bp_guid
    INTO @rv_kunnr .
  ENDMETHOD.

  METHOD get_vendor.

    SELECT SINGLE FROM cvi_vend_link FIELDS vendor WHERE partner_guid = @im_bp_guid
   INTO @rv_lifnr .

  ENDMETHOD.

  METHOD delete_key_mapping.

    DATA lt_delete_km      TYPE mdg_t_delete_id_matching_bs.
    DATA ls_delete_id      TYPE mdg_s_delete_id_matching_bs.

*    extract_excel_data( ).
    SELECT * FROM ztkeymapping INTO TABLE @DATA(lt_km_data).
    CHECK NOT  lt_km_data IS INITIAL.

    TRY.
        cl_mdg_id_matching_api_bs=>get_instance(
          IMPORTING
            er_if_mdg_id_matching_api = DATA(lo_id_matching_api)
            ev_lcl_business_system    = DATA(lv_business_system)
        ).
      CATCH               cx_mdg_id_matching_bs INTO DATA(lx_mdg_id_matching_bs).
        RAISE EXCEPTION TYPE lcx_key_mapping
          EXPORTING
            text = lx_mdg_id_matching_bs->get_longtext( ).

      CATCH               cx_mdg_no_api_instance INTO DATA(lx_no_api_instance).

        RAISE EXCEPTION TYPE lcx_key_mapping
          EXPORTING
            text = lx_no_api_instance->get_longtext( ).

      CATCH  cx_mdg_lcl_bus_sys_not_found INTO DATA(lx_bus_sys_not_found).
        RAISE EXCEPTION TYPE lcx_key_mapping
          EXPORTING
            text = lx_bus_sys_not_found->get_longtext( ).

    ENDTRY.

    LOOP AT lt_km_data INTO DATA(ls_km_record).

      IF ls_km_record-bpid_s IS NOT INITIAL.
        ls_delete_id-delete_objects                                 = abap_true.
        ls_delete_id-object_type_code                               =  if_mdg_otc_const=>bpartner.
        ls_delete_id-identifier_key-business_system_id              = lv_business_system.
        ls_delete_id-identifier_key-ident_defining_scheme_code      = gc_mdg_id_type_code-bp_id.
        ls_delete_id-identifier_key-id_value                        = ls_km_record-bpid_s.
        APPEND ls_delete_id TO lt_delete_km.
        CLEAR ls_delete_id.
      ENDIF.

    ENDLOOP.

    TRY.

        lo_id_matching_api->delete_matching( it_identifier_keys = lt_delete_km  ).
        IF  p_sim = abap_true .
          lo_id_matching_api->save(  iv_save_in_update_task = abap_false  ).
        ENDIF.


      CATCH cx_mdg_missing_id_data INTO DATA(lx_mdg_missing_id_data).

        RAISE EXCEPTION TYPE lcx_key_mapping
          EXPORTING
            text = lx_mdg_missing_id_data->get_longtext( ).

      CATCH cx_mdg_otc_idm_error INTO DATA(lx_mdg_otc_idm_error).

        RAISE EXCEPTION TYPE lcx_key_mapping
          EXPORTING
            text = lx_mdg_otc_idm_error->get_longtext( ).

      CATCH cx_mdg_id_matching_bs INTO lx_mdg_id_matching_bs.
        RAISE EXCEPTION TYPE lcx_key_mapping
          EXPORTING
            text = lx_mdg_id_matching_bs->get_longtext( ).
      CATCH cx_mdg_idsc_invalid INTO DATA(lx_mdg_idsc_invalid).
        RAISE EXCEPTION TYPE lcx_key_mapping
          EXPORTING
            text = lx_mdg_idsc_invalid->get_longtext( ).
      CATCH cx_mdg_km_invalid_id_value INTO DATA(lx_mdg_km_invalid_id_value).
        RAISE EXCEPTION TYPE lcx_key_mapping
          EXPORTING
            text = lx_mdg_km_invalid_id_value->get_longtext( ).
    ENDTRY.

  ENDMETHOD.

  METHOD get_uuid.

    cl_gdt_conversion=>guid_outbound(
      EXPORTING
        im_guid_x         = CONV #( iv_guid )    " GUID in X Form (binary)
      IMPORTING
        ex_value          = rv_uuid    " GUID / UUID in XML Display
    ).

  ENDMETHOD.

ENDCLASS.
