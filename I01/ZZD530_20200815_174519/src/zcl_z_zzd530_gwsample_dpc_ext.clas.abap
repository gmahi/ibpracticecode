"! <p class="shorttext synchronized" lang="en">Data Provider Secondary Class</p>
class ZCL_Z_ZZD530_GWSAMPLE_DPC_EXT definition
  public
  inheriting from ZCL_Z_ZZD530_GWSAMPLE_DPC
  create public .

public section.
protected section.

  methods PRODUCTSET_CREATE_ENTITY
    redefinition .
  methods PRODUCTSET_GET_ENTITY
    redefinition .
  methods PRODUCTSET_GET_ENTITYSET
    redefinition .
  methods SUPPLIERSET_GET_ENTITY
    redefinition .
  methods SUPPLIERSET_GET_ENTITYSET
    redefinition .
  methods FLIGHTSET_GET_ENTITYSET
    redefinition .
  private section.
ENDCLASS.



CLASS ZCL_Z_ZZD530_GWSAMPLE_DPC_EXT IMPLEMENTATION.


  method FLIGHTSET_GET_ENTITYSET.
    DATA ls_entity LIKE LINE OF ET_ENTITYSET.
    DATA lv_date type d.
   select carrid, connid, fldate,  planetype from sflight into TABLE @DATA(lt_flight).

    LOOP AT lt_flight INTO data(ls_flight).
      LS_ENTITY-CARRID = ls_flight-CARRID.
      LS_ENTITY-CONNID = ls_flight-CONNID.
      LS_ENTITY-PLANETYPE = LS_FLIGHT-PLANETYPE.
*      lv_date = ls_flight-FLDATE.
       LS_ENTITY-FLDATE = ls_flight-FLDATE.
      APPEND LS_ENTITY to ET_ENTITYSET.

    ENDLOOP.

**TRY.
*CALL METHOD SUPER->FLIGHTSET_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    IO_TECH_REQUEST_CONTEXT  =
**  IMPORTING
**    ET_ENTITYSET             =
**    ES_RESPONSE_CONTEXT      =
*    .
** CATCH /IWBEP/CX_MGW_BUSI_EXCEPTION .
** CATCH /IWBEP/CX_MGW_TECH_EXCEPTION .
**ENDTRY.
  endmethod.


  METHOD PRODUCTSET_CREATE_ENTITY.
*    data: ls_headerdata type bapi_epm_product_header,
*          ls_product    like   er_entity,
*          lt_return     type standard table of bapiret2.
*
*    io_data_provider->READ_ENTRY_DATA(
*      IMPORTING
*        ES_DATA                      =  ls_product
*    ).
*
*ls_headerdata-product_id = ls_product-productid.
*ls_headerdata-category = ls_product-category.
*ls_headerdata-name = ls_product-name.
*ls_headerdata-supplier_id = ls_product-supplierid.
*ls_headerdata-measure_unit = 'EA'.
*ls_headerdata-currency_code = 'EUR'.
*ls_headerdata-tax_tarif_code = '1'.
*ls_headerdata-type_code = 'PR'.
*
*
*    call function 'BAPI_EPM_PRODUCT_CREATE'
*      EXPORTING
*        HEADERDATA = ls_headerdata    " EPM: Product header data of BOR object SEPM002
**       PERSIST_TO_DB      = ABAP_TRUE    " Flag: Save data to DB (yes/no)
**  TABLES
**       CONVERSION_FACTORS =     " EPM: Product conversion factor data of BOR object SEPM002
*       RETURN     =  lt_return   " Return Parameter
*      .
*      if lt_return is not initial.
*        mo_context->GET_MESSAGE_CONTAINER( )->ADD_MESSAGES_FROM_BAPI(
*          EXPORTING
*            IT_BAPI_MESSAGES          =   lt_return  " Return parameter table
**            IV_ERROR_CATEGORY         =     " Error Category
*            IV_DETERMINE_LEADING_MSG  =  /iwbep/if_message_container=>gcs_leading_msg_search_option-first    " Use no/first/last as leading message
**            IV_ENTITY_TYPE            =     " Entity type/name
**            IT_KEY_TAB                =     " Entity key as name-value pair
**            IV_ADD_TO_RESPONSE_HEADER = ABAP_FALSE    " Flag for adding or not the message to the response header
*        ).
*
*        raise exception type /IWBEP/CX_MGW_BUSI_EXCEPTION
*          EXPORTING
*            TEXTID                 = /IWBEP/CX_MGW_BUSI_EXCEPTION=>business_error
**            PREVIOUS               =
**            MESSAGE_CONTAINER      =
**            HTTP_STATUS_CODE       = GCS_HTTP_STATUS_CODES-BAD_REQUEST
**            HTTP_HEADER_PARAMETERS =
**            SAP_NOTE_ID            =
**            MSG_CODE               =
**            ENTITY_TYPE            =
**            MESSAGE                =
**            MESSAGE_UNLIMITED      =
**            FILTER_PARAM           =
**            OPERATION_NO           =
*        .
*
*      endif.




  ENDMETHOD.


  METHOD PRODUCTSET_GET_ENTITY.

    data: ls_product    like er_entity,
          ls_product_id type bapi_epm_product_id,
          ls_headerdata type bapi_epm_product_header.

    io_tech_request_context->GET_CONVERTED_KEYS(
      importing
        ES_KEY_VALUES =   ls_product  " Entity Key Values - converted
    ).

    ls_product_id-product_id = ls_product-productid.

    call function 'BAPI_EPM_PRODUCT_GET_DETAIL'
      exporting
        PRODUCT_ID = ls_product_id " EPM: Product header data of BOR object SEPM002
      importing
        HEADERDATA = ls_headerdata    " EPM: Product header data of BOR object SEPM002
*      tables
*       CONVERSION_FACTORS =     " EPM: Product conversion factor data of BOR object SEPM002
*       RETURN     =     " Return Parameter
      .

    er_entity-productid = ls_headerdata-product_id.
    er_entity-category = ls_headerdata-category.
    er_entity-name = ls_headerdata-name.
    er_entity-supplierid = ls_headerdata-supplier_id.

  ENDMETHOD.


  method PRODUCTSET_GET_ENTITYSET.

    data: lt_filter_select_options type /iwbep/t_mgw_select_option,
          ls_filter_select_options type /iwbep/s_mgw_select_option,
          ls_select_options        TYPE /iwbep/s_cod_select_option,
          lr_filter                type ref to /iwbep/if_mgw_req_filter,
          lt_selparamproductid     TYPE STANDARD TABLE OF bapi_epm_product_id_range,
          ls_selparamproductid     TYPE bapi_epm_product_id_range,
          lv_max_rows              type bapi_epm_max_rows,
*          lv_top                   type i,
*          lv_skip                  type i
          lv_end                   type  i.

    DATA: ls_headerdata type BAPI_EPM_PRODUCT_HEADER,
          lt_headerdata TYPE STANDARD TABLE OF BAPI_EPM_PRODUCT_HEADER,
          ls_product    LIKE LINE OF ET_ENTITYSET.



    lr_filter = io_tech_request_context->GET_FILTER( ).
    lt_filter_select_options = lr_filter->GET_FILTER_SELECT_OPTIONS( ).

    loop at lt_filter_select_options into ls_filter_select_options.
      if ls_filter_select_options-property eq 'PRODUCTID'.
        loop at ls_filter_select_options-select_options into ls_select_options.
          ls_selparamproductid-low = ls_select_options-low.
          ls_selparamproductid-high = ls_select_options-high.
          ls_selparamproductid-sign = ls_select_options-sign.
          ls_selparamproductid-option = ls_select_options-option.
          append ls_selparamproductid to lt_selparamproductid.
        endloop.
      endif.


    endloop.


    lv_max_rows-bapimaxrow = 0.

    data(lv_top) = io_tech_request_context->GET_TOP( ).
    data(lv_skip) = io_tech_request_context->GET_SKIP( ).
    data(lv_has_inline_count) = io_tech_request_context->HAS_INLINECOUNT( ).

    if lv_top is not initial and lv_has_inline_count eq abap_false.

      lv_max_rows-bapimaxrow = lv_top + lv_skip.

    endif.

    call FUNCTION 'BAPI_EPM_PRODUCT_GET_LIST'
      exporting
        MAX_ROWS          = lv_max_rows " Maximum number of lines of hits
      tables
        HEADERDATA        = lt_headerdata  " EPM: Product header data of BOR object SEPM002
        SELPARAMPRODUCTID = lt_selparamproductid  " EPM: BAPI range table for product ids
*       SELPARAMSUPPLIERNAMES =     " EPM: BAPI range table for company names
*       SELPARAMCATEGORIES    =     " EPM: Range table for product categories
*       RETURN            =     " Return Parameter
      .
    if lv_has_inline_count EQ abap_true.
      es_response_context-inlinecount = lines( lt_headerdata ).

    endif.



    data(lv_start) = 1.
    if lv_skip is not initial.
      lv_start = lv_skip + 1.
    endif.

    if lv_top is not initial.

      lv_end = lv_start + lv_top - 1.

    else.
      lv_end = lines( lt_headerdata ).
    endif.


    LOOP AT LT_HEADERDATA INTO LS_HEADERDATA
        from lv_start to lv_end.
      LS_PRODUCT-productid = LS_HEADERDATA-PRODUCT_ID.
      LS_PRODUCT-CATEGORY = LS_HEADERDATA-CATEGORY.
      LS_PRODUCT-NAME = LS_HEADERDATA-NAME.
      ls_product-supplierid = ls_headerdata-supplier_id.
      APPEND LS_PRODUCT TO ET_ENTITYSET.

    ENDLOOP.



  endmethod.


  METHOD SUPPLIERSET_GET_ENTITY.

    data: ls_entity     like er_entity,
          ls_headerdata type bapi_epm_bp_header,
          ls_bp_id      type bapi_epm_bp_id.
    data: lv_source_entity_set_name type /iwbep/mgw_tech_name,
          ls_product                type zcl_z_zzd530_gwsample_mpc=>ts_product,
          ls_product_id             type  bapi_epm_product_id,
          ls_prd_headerdata         type bapi_epm_product_header.

    lv_source_entity_set_name = io_tech_request_context->GET_SOURCE_ENTITY_SET_NAME( ).

    if lv_source_entity_set_name EQ 'ProductSet'.

      io_tech_request_context->get_converted_source_keys(
  IMPORTING
    ES_KEY_VALUES = ls_product    " Entity Key Values - converted
).

      ls_product_id-product_id = ls_product-productid.
      call function 'BAPI_EPM_PRODUCT_GET_DETAIL'
        EXPORTING
          PRODUCT_ID = ls_product_id   " EPM: Product header data of BOR object SEPM002
        IMPORTING
          HEADERDATA = ls_prd_headerdata   " EPM: Product header data of BOR object SEPM002
*      TABLES
*         CONVERSION_FACTORS =     " EPM: Product conversion factor data of BOR object SEPM002
*         RETURN     =     " Return Parameter
        .

      ls_bp_id-bp_id = ls_prd_headerdata-supplier_id.

    else.
      io_tech_request_context->GET_CONVERTED_KEYS(
       IMPORTING
         ES_KEY_VALUES = ls_entity    " Entity Key Values - converted
     ).
      ls_bp_id-bp_id = ls_entity-supplierid.

    endif.






    call function 'BAPI_EPM_BP_GET_DETAIL'
      EXPORTING
        BP_ID      = ls_bp_id   " EPM: Business Partner ID to be used in BAPIs
      IMPORTING
        HEADERDATA = ls_headerdata      " EPM: Business Partner header data ( BOR SEPM004 )
*  TABLES
*       CONTACTDATA =     " EPM: Business Partner contact data ( BOR SEPM004 )
*       RETURN     =     " Return Parameter
      .
    er_entity-supplierid = ls_headerdata-bp_id.
    er_entity-suppliername = ls_headerdata-company_name.



  ENDMETHOD.


  METHOD SUPPLIERSET_GET_ENTITYSET.
    data: lt_bpheaderdata type standard table of bapi_epm_bp_header,
          ls_supplier     like line of et_entityset.

    call function 'BAPI_EPM_BP_GET_LIST'
*    EXPORTING
*      MAX_ROWS            =     " EPM: Max row specifictation
      TABLES
*       SELPARAMBPID =     " EPM: Range for Business Partner IDs
*       SELPARAMCOMPANYNAME =     " EPM: Range for Company name
        BPHEADERDATA = lt_bpheaderdata   " EPM: Business Partner header data ( BOR SEPM004 )
*       BPCONTACTDATA       =     " EPM: Business Partner contact data ( BOR SEPM004 )
*       RETURN       =     " Return Parameter
      .
    loop at lt_bpheaderdata into data(ls_bpheaderdata).

      ls_supplier-supplierid = ls_bpheaderdata-bp_id.
      ls_supplier-suppliername = ls_bpheaderdata-company_name.
      append ls_supplier to et_entityset.

    endloop.



  ENDMETHOD.
ENDCLASS.
