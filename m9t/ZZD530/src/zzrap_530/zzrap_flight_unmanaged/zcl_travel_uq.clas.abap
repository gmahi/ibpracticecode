CLASS zcl_travel_uq DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES  if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_travel_uq IMPLEMENTATION.
  METHOD if_rap_query_provider~select.

    TRY.

        CASE io_request->get_entity_id( ).
          WHEN 'ZI_TRAVEL_UQ'.
**query implementation for travel entity
**filter
            DATA(lv_sql_filter)      = io_request->get_filter(  )->get_as_sql_string( ).
            TRY.
                DATA(lt_filter) = io_request->get_filter(  )->get_as_ranges( ).
              CATCH cx_rap_query_filter_no_range.
            ENDTRY.

** parameters
            DATA(lt_parameters) = io_request->get_parameters( ).
            DATA(lv_next_year) = CONV syst_datum( cl_abap_context_info=>get_system_date( ) + 365  ).
            DATA(lv_par_filter) = |BEGIN_DATE >= '{ cl_abap_dyn_prg=>escape_quotes( VALUE #( lt_parameters[ parameter_name = 'P_START_DATE' ]-value
            DEFAULT cl_abap_context_info=>get_system_date( ) )   )  }'| &&
            | AND | &&
              | END_DATE <= '{ cl_abap_dyn_prg=>escape_quotes( VALUE #( lt_parameters[ parameter_name = 'P_END_DATE' ]-value
                                                                                                        DEFAULT lv_next_year ) ) }'| .
            IF lv_sql_filter IS INITIAL.
              lv_sql_filter = lv_par_filter.
            ELSE.
              lv_sql_filter = |( { lv_sql_filter } AND { lv_par_filter } )|.
            ENDIF.

** Search
            DATA(lv_search_string) = io_request->get_search_expression( ).
            DATA(lv_search_sql)  = |DESCRIPTION LIKE '%{ cl_abap_dyn_prg=>escape_quotes( lv_search_string ) }%'|.
            IF lv_sql_filter IS INITIAL.
              lv_sql_filter = lv_search_sql.
            ELSE.
              lv_sql_filter = |{ lv_sql_filter } AND { lv_search_sql }|.
            ENDIF.

** request data
            IF io_request->is_data_requested( ).
**paging
              DATA(lv_offset) = io_request->get_paging( )->get_offset( ).
              DATA(lv_page_size) = io_request->get_paging( )->get_page_size( ).
              DATA(lv_max_rows) = COND #( WHEN lv_page_size = if_rap_query_paging=>page_size_unlimited
                                      THEN 0 ELSE lv_page_size ).
** sorting
              DATA(sort_elements) = io_request->get_sort_elements( ).
              DATA(lt_sort_criteria)  = VALUE string_table( FOR sort_element IN sort_elements
                                         ( sort_element-element_name && COND #( WHEN sort_element-descending = abap_true THEN 'descending'
                                          ELSE 'ascending' ) ) )           .
              DATA(lv_sort_string)      = COND #( WHEN lt_sort_criteria IS INITIAL THEN 'primary key' ELSE concat_lines_of( table = lt_sort_criteria sep = ',' ) )  .
** requested elements
              DATA(lt_requested_elements)      = io_request->get_requested_elements( ).

** aggregate
              DATA(lt_aggr_element) = io_request->get_aggregation( )->get_aggregated_elements( ).

              IF lt_aggr_element IS NOT INITIAL.
                LOOP AT lt_aggr_element ASSIGNING FIELD-SYMBOL(<fs_aggr_element>).
                  DELETE lt_requested_elements WHERE table_line = <fs_aggr_element>-result_element.
                  DATA(lv_aggretation) = |{ <fs_aggr_element>-aggregation_method }( { <fs_aggr_element>-input_element } ) as { <fs_aggr_element>-result_element }|.

                  APPEND lv_aggretation TO lt_requested_elements.

                ENDLOOP.
              ENDIF.
              DATA(lv_req_element) = concat_lines_of( table = lt_requested_elements sep = ',' ).
**grouping
              DATA(lt_grouped_element) = io_request->get_aggregation( )->get_grouped_elements( ).
              DATA(lv_grouping) = concat_lines_of( table = lt_grouped_element sep = ',' ).
*** selected data
              DATA lt_travel_response TYPE STANDARD TABLE OF zi_travel_uq.
              SELECT (lv_req_element)  FROM   /dmo/travel WHERE (lv_sql_filter)
                                                          GROUP BY (lv_grouping)
                                                          ORDER BY (lv_sort_string)
                                                          INTO CORRESPONDING FIELDS OF TABLE @lt_travel_response
                                                          OFFSET @lv_offset UP TO @lv_max_rows ROWS.
** fill response
              io_response->set_data( lt_travel_response ).
*CATCH cx_rap_query_response_set_twic.

            ENDIF.

** request count
            IF io_request->is_total_numb_of_rec_requested( ).
** select count
              SELECT COUNT( * ) FROM /dmo/travel WHERE (lv_sql_filter) INTO @DATA(lv_traveL_count).
** fill response
              io_response->set_total_number_of_records( lv_travel_count ).
*CATCH cx_rap_query_response_set_twic.

            ENDIF.

        ENDCASE.

      CATCH cx_rap_query_provider.
    ENDTRY.


  ENDMETHOD.

ENDCLASS.
