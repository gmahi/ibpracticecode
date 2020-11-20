*&---------------------------------------------------------------------*
*& Report zbopf_r_product
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbopf_r_product.


CLASS lcl_demo DEFINITION CREATE PRIVATE.
  PUBLIC SECTION.

    CLASS-METHODS main.

  PRIVATE SECTION.
    DATA: mo_transaction_mgr TYPE REF TO /bobf/if_tra_transaction_mgr,
          mo_service_mgr     TYPE REF TO /bobf/if_tra_service_manager,
          mo_configration    TYPE REF TO /bobf/if_frw_configuration.
    METHODS constructor RAISING /bobf/cx_frw.
    METHODS: create_product,
      display_message IMPORTING io_message TYPE REF TO /bobf/if_frw_message.


ENDCLASS.

CLASS lcl_demo IMPLEMENTATION.
  METHOD main.
    DATA: lo_demo TYPE REF TO lcl_demo.
    DATA: lo_cx TYPE REF TO /bobf/cx_frw.

    TRY.
        CREATE OBJECT lo_demo.

        lo_demo->create_product( ).

      CATCH /bobf/cx_frw INTO lo_cx.
        WRITE lo_cx->get_text( ).
    ENDTRY.

  ENDMETHOD.

  METHOD constructor.

    TRY.
        mo_transaction_mgr = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).
        mo_service_mgr     = /bobf/cl_tra_serv_mgr_factory=>get_service_manager(
                             iv_bo_key                     = /bobf/if_demo_product_c=>sc_bo_key

                         ).

        mo_configration    = /bobf/cl_frw_factory=>get_configuration(  /bobf/if_demo_product_c=>sc_bo_key ).
      CATCH /bobf/cx_frw INTO DATA(lx_frw).
        WRITE: lx_frw->get_longtext( ) .

    ENDTRY.

  ENDMETHOD.

  METHOD create_product.
    "Modification variables used to make change on object
    DATA: lt_modification TYPE /bobf/t_frw_modification.
    FIELD-SYMBOLS: <ls_modification> TYPE /bobf/s_frw_modification.
    DATA: lo_change TYPE REF TO /bobf/if_tra_change.

*  This part is related to errors and success message handling

    DATA: lo_message    TYPE REF TO /bobf/if_frw_message,
          lv_issue      TYPE boolean,
          lo_exception  TYPE REF TO /bobf/cx_frw,
          lv_err_return TYPE string,
          lv_rejected   TYPE boolean.

    "Combined data model structure, fields of product BO
    DATA: lr_product_hdr TYPE REF TO /bobf/s_demo_product_hdr_k.
    DATA: lr_short_text  TYPE REF TO /bobf/s_demo_short_text_k.

    lr_product_hdr = NEW #(  ).

    lr_product_hdr->key = /bobf/cl_frw_factory=>get_new_key( ).
    lr_product_hdr->product_id = '101'.
    lr_product_hdr->product_type = 'FOOD'.
    lr_product_hdr->base_uom = 'KG'.
    lr_product_hdr->buy_price = 1.
    lr_product_hdr->buy_price_curr = 'USD'.
    lr_product_hdr->sell_price_curr = 'USD'.
    lr_product_hdr->sell_price = 2.

    "Add product header to modification table

    APPEND INITIAL LINE TO lt_modification ASSIGNING <ls_modification>.
    <ls_modification>-node = /bobf/if_demo_product_c=>sc_node-root.
    <ls_modification>-change_mode = /bobf/if_frw_c=>sc_modify_create.
    <ls_modification>-key = lr_product_hdr->key.
    <ls_modification>-data = lr_product_hdr.

    "Now, we will do the same for the short text data:
*Create short text data

    CREATE DATA lr_short_text.
    lr_short_text->key = /bobf/cl_frw_factory=>get_new_key( ).
    lr_short_text->language = sy-langu.
    lr_short_text->text    = 'Banana'.

*'Add short text data to modification table
    APPEND INITIAL LINE TO lt_modification ASSIGNING <ls_modification>.
    <ls_modification>-node = /bobf/if_demo_product_c=>sc_node-root_text.
    <ls_modification>-change_mode = /bobf/if_frw_c=>sc_modify_create.
    <ls_modification>-source_node = /bobf/if_demo_product_c=>sc_node-root.
    <ls_modification>-source_node = /bobf/if_demo_product_c=>sc_node-root.
    <ls_modification>-association = /bobf/if_demo_product_c=>sc_association-root-root_text.
    <ls_modification>-key = lr_short_text->key.
    <ls_modification>-source_key = lr_product_hdr->key.
    <ls_modification>-data = lr_short_text.


    me->mo_service_mgr->modify(
      EXPORTING
        it_modification =   lt_modification  " Changes
      IMPORTING
        eo_change       = lo_change    " Interface of Change Object
        eo_message      =  lo_message   " Interface of Message Object
    ).

    IF lo_message IS BOUND.
      IF lo_message->check( ) EQ abap_true.
        me->display_message( io_message = lo_message ).
      ENDIF.

    ENDIF.

    mo_transaction_mgr->save(
      IMPORTING
        ev_rejected            =  lv_rejected   " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
        eo_message             =  lo_message   " Interface of Message Object
    ).

    IF lv_rejected EQ abap_true.
      me->display_message( lo_message ).
      RETURN.
    ENDIF.


  ENDMETHOD.

  METHOD display_message.

    DATA: lt_message TYPE /bobf/t_frw_message_k.
    FIELD-SYMBOLS: <ls_message> TYPE  /bobf/s_frw_message_k .

    IF io_message IS BOUND.
      io_message->get_messages(
        IMPORTING
          et_message              =  lt_message   " Table of msg instance that are contained in the msg object
      ).
      LOOP AT lt_message ASSIGNING <ls_message>.

        WRITE: <ls_message>-message->get_text( ).
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.
  lcl_demo=>main( ).
