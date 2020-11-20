CLASS zcl_d_demo_i_salesorder_tx_act DEFINITION
  PUBLIC
  INHERITING FROM /bobf/cl_lib_d_supercl_simple
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS /bobf/if_frw_determination~execute
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_d_demo_i_salesorder_tx_act IMPLEMENTATION.


  METHOD /bobf/if_frw_determination~execute.
    "Find the highest used sales order number in both active and draft data

    WITH +both AS ( SELECT salesorder FROM zdemo_soh  "active dat
    UNION ALL
    SELECT salesorder FROM zdemo_soh_d
    )

    SELECT SINGLE FROM +both FIELDS MAX( salesorder ) AS salesorder
     INTO @DATA(lv_max_salesorder).

    "If there are no entries, set a start value
    IF lv_max_salesorder IS INITIAL.
      lv_max_salesorder = '0700000000'.
    ENDIF.

    "Read data with the given keys
    DATA lt_data TYPE ztdemo_i_salesorder_tp_d.


    io_read->retrieve(
        EXPORTING
            iv_node                 = is_ctx-node_key   " uuid of node name
            it_key                  = it_key            " keys given to the determination
        IMPORTING
            eo_message              = eo_message        " pass message object
            et_data                 = lt_data           " itab with node data
            et_failed_key           = et_failed_key     " pass failures
    ).

    "Assign numbers to each newly created line and tell BOPF about the modification
    LOOP AT lt_data REFERENCE INTO DATA(lr_data).
      IF lr_data->salesorder IS INITIAL.
        ADD 1 TO lv_max_salesorder.
        lr_data->salesorder = lv_max_salesorder.

        " Fill leading zeros for ALPHANUM field on database
        lr_data->salesorder = |{ lr_data->salesorder ALPHA = IN }|.

        io_modify->update(
          EXPORTING
            iv_node           = is_ctx-node_key    " uuid of node
            iv_key            = lr_data->key    " key of line
            is_data           = lr_data            " ref to modified data
            it_changed_fields = VALUE #( ( zif_demo_i_salesorder_tp_d_c=>sc_node_attribute-zdemo_i_salesorder_tp_d-salesorder ) )
        ).
      ENDIF.
    ENDLOOP.



  ENDMETHOD.
ENDCLASS.
