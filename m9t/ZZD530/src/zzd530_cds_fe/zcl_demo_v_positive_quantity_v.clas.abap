CLASS zcl_demo_v_positive_quantity_v DEFINITION
  PUBLIC
  INHERITING FROM /bobf/cl_lib_v_supercl_simple
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS /bobf/if_frw_validation~execute
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_demo_v_positive_quantity_v IMPLEMENTATION.


  METHOD /bobf/if_frw_validation~execute.

    " Typed with node's combined table type
    DATA lt_sales_order_item TYPE ztdemo_i_salesorderitem_tp_d.

    " Retrieve the data of the requested node instance
    io_read->retrieve(
      EXPORTING
        iv_node         = is_ctx-node_key
        it_key          = it_key
      IMPORTING
        et_data         = lt_sales_order_item
        eo_message      = eo_message
        et_failed_key   = et_failed_key
      ).

    LOOP AT lt_sales_order_item ASSIGNING FIELD-SYMBOL(<s_sales_order_item>).

      IF <s_sales_order_item>-quantity < 0.

        IF <s_sales_order_item>-isactiveentity = abap_false.

          DATA(lv_lifetime) = /bobf/cm_frw=>co_lifetime_state. "draft
        ELSE.
          lv_lifetime = /bobf/cm_frw=>co_lifetime_transition.  "active
        ENDIF.
        eo_message = /bobf/cl_frw_factory=>get_message( ).
        eo_message->add_message(
          EXPORTING is_msg  = VALUE #( msgid = 'CM_SEPMRA_SALESORDER'  " example
                        msgno = 5
                        msgv1 = 'The number is negative: ' ##no_text
                        msgv2 = <s_sales_order_item>-quantity
                        msgty = /bobf/cm_frw=>co_severity_error
                        )
                   iv_node = is_ctx-node_key
                  iv_key  = <s_sales_order_item>-key
                  iv_attribute = zif_demo_i_salesorder_tp_d_c=>sc_node_attribute-zdemo_i_salesorderitem_tp_d-quantity
                  iv_lifetime  = lv_lifetime
          ).

        APPEND VALUE #( key = <s_sales_order_item>-key ) TO et_failed_key.

      ENDIF.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
