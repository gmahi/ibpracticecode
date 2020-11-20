CLASS zcl_demo_d_get_item_position DEFINITION
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



CLASS zcl_demo_d_get_item_position IMPLEMENTATION.


  METHOD /bobf/if_frw_determination~execute.

    " Find the highest used item number in both active and draft data (draft table)
    WITH +both AS (  SELECT salesorderitem FROM zdemo_soi
    UNION ALL
    SELECT salesorderitem FROM zdemo_soid )
        SELECT SINGLE
        FROM +both
        FIELDS MAX( salesorderitem ) AS salesorderitem
    INTO @DATA(lv_max_salesorderitem).

    " If there are no entries, set a start value
    IF lv_max_salesorderitem IS INITIAL.
      lv_max_salesorderitem = '0000000000'.
    ENDIF.

    "Read data with the given keys (typed with combined type table)
    DATA lt_data TYPE ztdemo_i_salesorderitem_tp_d.

    io_read->retrieve(
      EXPORTING
        iv_node                 = is_ctx-node_key   " uuid of node name
        it_key                  = it_key            " keys given to the determination
      IMPORTING
        eo_message              = eo_message        " pass message object
        et_data                 = lt_data           " itab with node data
        et_failed_key           = et_failed_key     " pass failures
    ).


    " Assign numbers to each newly created item and trigger the modification in BOPF
    LOOP AT lt_data REFERENCE INTO DATA(lr_data).
      IF lr_data->salesorderitem IS INITIAL.
        ADD 10 TO lv_max_salesorderitem.
        lr_data->salesorderitem = lv_max_salesorderitem.

        io_modify->update(
          EXPORTING
            iv_node           = is_ctx-node_key    " uuid of node
            iv_key            = lr_data->key   " key of line
            is_data           = lr_data            " ref to modified data
            it_changed_fields = VALUE #( ( zif_demo_i_salesorder_tp_d_c=>sc_node_attribute-zdemo_i_salesorderitem_tp_d-salesorderitem ) )
        ).
      ENDIF.
    ENDLOOP.


  ENDMETHOD.
ENDCLASS.
