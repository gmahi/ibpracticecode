class ZCL_Z_D530_PO_DPC_EXT definition
  public
  inheriting from ZCL_Z_D530_PO_DPC
  create public .

  public section.
  protected section.

    methods POHEADERSET_GET_ENTITY
        redefinition .
    methods POHEADERSET_GET_ENTITYSET
        redefinition .
    methods POITEMSET_GET_ENTITYSET
        redefinition .
    methods POITEMSET_GET_ENTITY
        redefinition .
    methods ekkoekposet_get_entityset
        redefinition.
    methods ekkoekposet_get_entity
        redefinition.


  private section.
ENDCLASS.



CLASS ZCL_Z_D530_PO_DPC_EXT IMPLEMENTATION.


  method POHEADERSET_GET_ENTITY.
    DATA: lv_ebeln type ekko-EBELN.

    DATA: lv_source_entityset TYPE /iwbep/mgw_tech_name.
    LV_SOURCE_ENTITYSET = IO_TECH_REQUEST_CONTEXT->GET_ENTITY_SET_NAME( ).
    IF  LV_SOURCE_ENTITYSET =    'POHeaderSet'.
      IO_TECH_REQUEST_CONTEXT->GET_CONVERTED_KEYS(
        IMPORTING
          ES_KEY_VALUES =  ER_ENTITY   " Source Entity Key Values - converted
      ).



      try.

          data(ls_ekko) =  new ZCL_D530_PURCHASEORDER( IF_EBELN = ER_ENTITY-EBELN  )->GET_PO_HEADER( ).
          er_entity = ls_ekko.

        CATCH ZCX_D530_PURCHASEORDER into data(lx_porder).
*        mo_context->get_message_container( )->ADD_MESSAGE(
*          EXPORTING
*            IV_MSG_TYPE               =   'E' " Message Type
*            IV_MSG_ID                 = lx_porder->if_t100_message~t100key-msgid     " Message Class
*            IV_MSG_NUMBER             =  lx_porder->if_t100_message~t100key-msgno   " Message Number
**            IV_MSG_TEXT               =     " Message Text
*            IV_MSG_V1                 = conv #( lx_porder->if_t100_message~t100key-attr1 )   " Message Variable
**            IV_MSG_V2                 =     " Message Variable
**            IV_MSG_V3                 =     " Message Variable
**            IV_MSG_V4                 =     " Message Variable
**            IV_ERROR_CATEGORY         =     " Error Category
**            IV_IS_LEADING_MESSAGE     = ABAP_TRUE
*            IV_ENTITY_TYPE            =   iv_entity_name  " Entity type/name
**            IT_KEY_TAB                =     " Entity key as name-value pair
**            IV_ADD_TO_RESPONSE_HEADER = ABAP_FALSE    " Flag for adding or not the message to the response header
**            IV_MESSAGE_TARGET         =     " Target (reference) (e.g. Property ID) of a message
*        ).

    raise exception type  /IWBEP/CX_MGW_BUSI_EXCEPTION
      EXPORTING
        TEXTID                 = /iwbep/cx_mgw_busi_exception=>business_error
        PREVIOUS               = lx_porder
*        MESSAGE_CONTAINER      =   mo_context->get_message_container( )
*        HTTP_STATUS_CODE       = GCS_HTTP_STATUS_CODES-BAD_REQUEST
*        HTTP_HEADER_PARAMETERS =
*        SAP_NOTE_ID            =
*        MSG_CODE               =
        ENTITY_TYPE            = iv_entity_name
*        MESSAGE                =
*        MESSAGE_UNLIMITED      =
*        FILTER_PARAM           =
*        OPERATION_NO           =
    .


      endtry.





    ENDIF.



**ENDTRY.
  endmethod.


  method POHEADERSET_GET_ENTITYSET.
    select * UP TO 10 ROWS FROM ekko INTO CORRESPONDING FIELDS OF TABLE ET_ENTITYSET.

**TRY.
*CALL METHOD SUPER->POHEADERSET_GET_ENTITYSET
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


  method POITEMSET_GET_ENTITYSET.

    DATA: ls_poheader type ZCL_Z_D530_PO_MPC=>TS_POHEADER,
          lv_ebeln    TYPE ekko-EBELN.
    data(lv_source_entity_set_name) =  IO_TECH_REQUEST_CONTEXT->GET_ENTITY_SET_NAME( ).

    IF  LV_SOURCE_ENTITY_SET_NAME = 'POHeaderSet'.
      IO_TECH_REQUEST_CONTEXT->GET_CONVERTED_SOURCE_KEYS(
        IMPORTING
          ES_KEY_VALUES =  LS_POHEADER   " Source Entity Key Values - converted
      ).
      LV_EBELN = LS_POHEADER-EBELN.
      select *  FROM ekpo INTO CORRESPONDING FIELDS OF TABLE ET_ENTITYSET WHERE EBELN =
        LV_EBELN.
    else.
      select * UP TO 10 ROWS FROM ekpo INTO CORRESPONDING FIELDS OF TABLE ET_ENTITYSET.
    ENDIF.





**TRY.
*CALL METHOD SUPER->POITEMSET_GET_ENTITYSET
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
  METHOD POITEMSET_GET_ENTITY.

    DATA: lv_ebelp type ekpo-ebelp,
          lv_ebeln type ekpo-ebeln.

    DATA: lv_source_entityset TYPE /iwbep/mgw_tech_name.
    LV_SOURCE_ENTITYSET = IO_TECH_REQUEST_CONTEXT->GET_ENTITY_SET_NAME( ).
    IF IO_TECH_REQUEST_CONTEXT->GET_ENTITY_SET_NAME( ) =   'POItemSet'.
      IO_TECH_REQUEST_CONTEXT->GET_CONVERTED_KEYS(
        IMPORTING
          ES_KEY_VALUES =  ER_ENTITY   " Source Entity Key Values - converted
      ).

      lv_ebelp = ER_ENTITY-ebelp.
      lv_ebeln = ER_ENTITY-ebeln.
      SELECT SINGLE * FROM ekpo INTO CORRESPONDING FIELDS OF ER_ENTITY WHERE EBELN
        = lv_ebeln and ebelp = lv_ebelp.

    ENDIF.



  ENDMETHOD.

  METHOD EKKOEKPOSET_GET_ENTITY.

    DATA: ls_ekkoekpo type ZCL_Z_D530_PO_MPC=>ts_ekkoekpo.
*          lv_ebeln    TYPE ekko-EBELN.
    data(lv_source_entity_set_name) =  IO_TECH_REQUEST_CONTEXT->GET_ENTITY_SET_NAME( ).

    if  LV_SOURCE_ENTITY_SET_NAME = 'ekkoekpoSet'  .
      IO_TECH_REQUEST_CONTEXT->GET_CONVERTED_SOURCE_KEYS(
          IMPORTING
            ES_KEY_VALUES =  ls_ekkoekpo   " Source Entity Key Values - converted
        ).

      select single *  FROM  ZZD530_EKKOEXPO INTO CORRESPONDING FIELDS of  er_entity WHERE EBELN =
        ls_ekkoekpo-ebeln and ebelp = ls_ekkoekpo-ebelp.

    endif.
  endmethod.



  METHOD EKKOEKPOSET_GET_ENTITYSET.


    DATA: ls_poitem type ZCL_Z_D530_PO_MPC=>ts_poitem,
          lv_ebeln  TYPE ekko-EBELN.
*    data(lv_source_entity_set_name) =  IO_TECH_REQUEST_CONTEXT->GET_ENTITY_SET_NAME( ).

    IF  IO_TECH_REQUEST_CONTEXT->GET_ENTITY_SET_NAME( ) = 'POItemSet'.
      IO_TECH_REQUEST_CONTEXT->GET_CONVERTED_SOURCE_KEYS(
        IMPORTING
          ES_KEY_VALUES =  ls_poitem   " Source Entity Key Values - converted
      ).
*      LV_EBELN = LS_POHEADER-EBELN.
      select *  FROM ekpo INTO CORRESPONDING FIELDS OF TABLE ET_ENTITYSET WHERE EBELN =
        ls_poitem-ebeln and ebelp = ls_poitem-ebelp.
    else.
      select * UP TO 10 ROWS FROM ekpo INTO CORRESPONDING FIELDS OF TABLE ET_ENTITYSET.
    ENDIF.




  ENDMETHOD.

ENDCLASS.
