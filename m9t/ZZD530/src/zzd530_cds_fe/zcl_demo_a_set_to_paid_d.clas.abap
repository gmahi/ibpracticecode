CLASS zcl_demo_a_set_to_paid_d DEFINITION
  PUBLIC
  INHERITING FROM /bobf/cl_lib_a_supercl_simple
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS /bobf/if_frw_action~execute
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_demo_a_set_to_paid_d IMPLEMENTATION.


  METHOD /bobf/if_frw_action~execute.

    " Typed with node's combined table type
    DATA(lt_sales_order) = VALUE ztdemo_i_salesorder_tp_d(  ).

    " READING BO data ----------------------------------------------

    " Retrieve the data of the requested node instance

    io_read->retrieve(
      EXPORTING
        iv_node                 = is_ctx-node_key
        it_key                  =  it_key

      IMPORTING
        eo_message              = DATA(lo_message)
        et_data                 =  lt_sales_order
    ).

    " WRITING BO data ---------------------------------------------

    LOOP AT lt_sales_order ASSIGNING FIELD-SYMBOL(<s_sales_order>).

      " Set the attribue billing_status to new value
      <s_sales_order>-overallstatus = 'P' . "PAID

      " Update the changed data (billig_status) of the node instance

      io_modify->update(
        EXPORTING
          iv_node           = is_ctx-node_key
          iv_key            =  <s_sales_order>-key
          iv_root_key       =  <s_sales_order>-root_key
          is_data           = REF #( <s_sales_order>-node_data )
          it_changed_fields =  VALUE #( ( zif_demo_i_salesorder_tp_d_c=>sc_node_attribute-zdemo_i_salesorder_tp_d-overallstatus )  )
      ).


    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
