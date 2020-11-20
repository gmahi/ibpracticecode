CLASS zcl_zk_usmd_model_ext DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS:  get_entity_data IMPORTING io_model              TYPE REF TO if_usmd_model_ext
                                              iv_fieldname          TYPE usmd_fieldname
                                              iv_CREQUEST           TYPE usmd_crequest
                                    RETURNING VALUE(rt_entity_data) TYPE REF TO data.
    CLASS-METHODS get_filed_description
      IMPORTING
        !iv_tabname           TYPE ddobjname
        !iv_fieldname         TYPE dfies-fieldname
        !iv_language          TYPE sy-langu DEFAULT sy-langu
      RETURNING
        VALUE(rv_description) TYPE as4text .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_zk_usmd_model_ext IMPLEMENTATION.
  METHOD get_entity_data.

    DATA: lt_sel       TYPE usmd_ts_sel,
          ls_sel       TYPE usmd_s_sel,
          lv_site      TYPE  ortid,
          ls_site_key  TYPE zszk_s_zk_kf_site,
          lrs_key_data TYPE REF TO data.


    FIELD-SYMBOLS: <lt_key>         TYPE SORTED TABLE,
                   <lt_entity_data> TYPE SORTED TABLE,
                   <lt_site_key>    TYPE ANY TABLE,
                   <ls_key>         TYPE any,
                   <lv_matr>        TYPE matnr,
                   <lv_field>       TYPE any,
                   <lv_value>       TYPE any.

    io_model->create_data_reference(
      EXPORTING
        i_fieldname          = iv_fieldname                " Field Name
        i_struct             = io_model->gc_struct_key    " Structure
        i_tabtype            = io_model->gc_tabtype_sorted " Single-Character Indicator
      IMPORTING
        er_data              =  DATA(lrt_key_data)
        et_message           =  DATA(lt_message)                 " Messages
    ).
    ASSERT lt_message IS INITIAL.

    ASSIGN   lrt_key_data->* TO  <lt_key>.
    CREATE DATA lrs_key_data LIKE LINE OF <lt_key>.
    ASSIGN lrs_key_data->*  TO <ls_key>.


    io_model->create_data_reference(
      EXPORTING
        i_fieldname          =  iv_fieldname                 " Field Name
        i_struct             = io_model->gc_struct_key_attr    " Structure
        i_tabtype            = io_model->gc_tabtype_sorted " Single-Character Indicator
      IMPORTING
        er_data              = rt_entity_data
*        er_data              = rt_entity_data
        et_message           = lt_message                  " Messages
    ).

    ASSERT lt_message IS INITIAL.
    ASSIGN rt_entity_data->* TO <lt_entity_data>.



    io_model->get_cr_objectlist(
      EXPORTING
        i_crequest     =  iv_crequest                " Change Request
      IMPORTING
        et_key_all     =  DATA(lt_key)                " Keys of Objects in Change Request

    ).

    READ TABLE lt_key INTO DATA(ls_key) WITH KEY entity =  'SITE'.

    ASSIGN ls_key-r_data->* TO <lt_site_key>.
    LOOP AT <lt_site_key> INTO ls_site_key.
      lv_site = ls_site_key-site.
    ENDLOOP.

*     Selection Criteria
    ls_sel-option    = 'EQ'.         "equal
    ls_sel-sign      = 'I'.          "including
    ls_sel-fieldname = 'SITE'.
    ls_sel-low       = lv_site.
    INSERT ls_sel INTO TABLE lt_sel.

    io_model->read_char_value(
      EXPORTING
        i_fieldname       = iv_fieldname                 " Field Name
        it_sel            = lt_sel                   " Sorted Table: Selection Condition (Range per Field)
        i_readmode        = io_model->gc_readmode_all_inact   " Read mode

      IMPORTING
        et_data           =  <lt_entity_data>
        et_message        =   lt_message                  " Messages
    ).

    ASSERT lt_message IS INITIAL.

  ENDMETHOD.

  METHOD get_filed_description.

    DATA: lt_dfies TYPE STANDARD TABLE OF dfies.

    CALL FUNCTION 'DDIF_FIELDINFO_GET'
      EXPORTING
        tabname   = iv_tabname
        fieldname = iv_fieldname
        langu     = sy-langu
      TABLES
        dfies_tab = lt_dfies.
    IF sy-subrc = 0.
      rv_description = lt_dfies[ 1 ]-fieldtext.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
