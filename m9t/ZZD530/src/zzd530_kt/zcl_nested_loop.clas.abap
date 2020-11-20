CLASS zcl_nested_loop DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.



    METHODS: fill_data,
      fil_data_std.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA: lt_customer           TYPE tt_customer,
          ls_customer_sale      TYPE ty_customer_sales,
          lt_customer_sales     TYPE tt_customer_sales,
          lt_customer_std       TYPE tt_customer_std,
          lt_customer_sales_std TYPE tt_customer_sales_std.

    METHODS: total_sales_nested_loop IMPORTING out TYPE REF TO if_oo_adt_classrun_out,
      total_sales_par_cursor IMPORTING out TYPE REF TO if_oo_adt_classrun_out,
      total_sales_par_cursor_bs IMPORTING out TYPE REF TO if_oo_adt_classrun_out,
      total_sales_reduce IMPORTING out TYPE REF TO if_oo_adt_classrun_out,
      total_sales_select IMPORTING out TYPE REF TO if_oo_adt_classrun_out,
      total_sales_nested_loop_std IMPORTING out TYPE REF TO if_oo_adt_classrun_out.



ENDCLASS.



CLASS zcl_nested_loop IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    fill_data( ).
    fil_data_std( ).
    total_sales_nested_loop( out ).
    total_sales_nested_loop_std( out ).
    total_sales_par_cursor( out ).
    total_sales_par_cursor_bs( out ).
    total_sales_reduce( out  ).
    total_sales_select( out ).
  ENDMETHOD.

  METHOD fill_data.
    DATA:   lo_ran TYPE REF TO cl_abap_random_int.

    lo_ran =      cl_abap_random_int=>create( min = 100 max = 1000 seed = CONV #( sy-timlo )  ).

    SELECT kunnr, name1  FROM kna1   INTO CORRESPONDING FIELDS OF TABLE @lt_customer UP TO 200 ROWS.

    LOOP AT lt_customer INTO DATA(ls_customer).

      DO 12 TIMES.
        ls_customer_sale-kunnr = ls_customer-kunnr.
        ls_customer_sale-month = sy-index.
        ls_customer_sale-sales =  sy-index * lo_ran->get_next( ).
        APPEND ls_customer_sale TO lt_customer_sales.
        CLEAR ls_customer_sale.
      ENDDO.

    ENDLOOP.

  ENDMETHOD.

  METHOD fil_data_std.

    DATA:   lo_ran TYPE REF TO cl_abap_random_int.

    lo_ran =      cl_abap_random_int=>create( min = 100 max = 1000 seed = CONV #( sy-timlo )  ).

    SELECT kunnr, name1  FROM kna1   INTO CORRESPONDING FIELDS OF TABLE @lt_customer_std UP TO 200 ROWS.
    SORT lt_customer_std BY kunnr.

    LOOP AT lt_customer_std INTO DATA(ls_customer).

      DO 12 TIMES.
        ls_customer_sale-kunnr = ls_customer-kunnr.
        ls_customer_sale-month = sy-index.
        ls_customer_sale-sales =  sy-index * lo_ran->get_next( ).
        APPEND ls_customer_sale TO lt_customer_sales_std.
        CLEAR ls_customer_sale.
      ENDDO.
      SORT lt_customer_sales_std BY kunnr.
    ENDLOOP.


  ENDMETHOD.

  METHOD total_sales_nested_loop.

    DATA: ls_customer_total_sales TYPE ty_customer_total_sales,
          lt_customer_total_sales TYPE tt_customer_total_sales.


    LOOP AT lt_customer INTO DATA(ls_customer).

      ls_customer_total_sales-kunnr = ls_customer-kunnr.
      ls_customer_total_sales-name1 = ls_customer-name1.
      LOOP AT lt_customer_sales INTO ls_customer_sale WHERE kunnr = ls_customer-kunnr.
        ls_customer_total_sales-total_sales = ls_customer_total_sales-total_sales + ls_customer_sale-sales.
      ENDLOOP.
      APPEND ls_customer_total_sales TO lt_customer_total_sales.
      CLEAR ls_customer_total_sales.
    ENDLOOP.
    out->write(
      EXPORTING
        data   = lt_customer_total_sales

    ).

  ENDMETHOD.

  METHOD total_sales_nested_loop_std.

    DATA: ls_customer_total_sales TYPE ty_customer_total_sales,
          lt_customer_total_sales TYPE tt_customer_total_sales.

    LOOP AT lt_customer_std INTO DATA(ls_customer).
      ls_customer_total_sales-kunnr = ls_customer-kunnr.
      ls_customer_total_sales-name1 = ls_customer-name1.
      LOOP AT lt_customer_sales_std INTO ls_customer_sale WHERE kunnr = ls_customer-kunnr.
        ls_customer_total_sales-total_sales = ls_customer_total_sales-total_sales + ls_customer_sale-sales.
      ENDLOOP.
      APPEND ls_customer_total_sales TO lt_customer_total_sales.
      CLEAR ls_customer_total_sales.
    ENDLOOP.
    out->write(
      EXPORTING
        data   = lt_customer_total_sales

    ).

  ENDMETHOD.


  METHOD total_sales_par_cursor.

    DATA: ls_customer_total_sales TYPE ty_customer_total_sales,
          lt_customer_total_sales TYPE tt_customer_total_sales.


    LOOP AT lt_customer INTO DATA(ls_customer).
      ls_customer_total_sales-kunnr = ls_customer-kunnr.
      ls_customer_total_sales-name1 = ls_customer-name1.

      DATA(lv_index) = line_index( lt_customer_sales[ kunnr = ls_customer-kunnr ] ).
      LOOP AT lt_customer_sales FROM lv_index INTO ls_customer_sale .
        IF ls_customer_sale-kunnr <> ls_customer-kunnr .
          EXIT.
        ENDIF.
        ls_customer_total_sales-total_sales = ls_customer_total_sales-total_sales + ls_customer_sale-sales.
      ENDLOOP.

      APPEND ls_customer_total_sales TO lt_customer_total_sales.
      CLEAR ls_customer_total_sales.
    ENDLOOP.
    out->write(
      EXPORTING
        data   = lt_customer_total_sales

    ).


  ENDMETHOD.

  METHOD total_sales_par_cursor_bs.

    DATA: ls_customer_total_sales TYPE ty_customer_total_sales,
          lt_customer_total_sales TYPE tt_customer_total_sales.


    LOOP AT lt_customer INTO DATA(ls_customer).

      ls_customer_total_sales-kunnr = ls_customer-kunnr.
      ls_customer_total_sales-name1 = ls_customer-name1.

*      DATA(lv_index) = line_index( lt_customer_sales[ kunnr = ls_customer-kunnr ] ).
      READ TABLE lt_customer_sales TRANSPORTING NO FIELDS WITH KEY kunnr = ls_customer-kunnr BINARY SEARCH .
      DATA(lv_index) = sy-tabix.
      LOOP AT lt_customer_sales FROM lv_index INTO ls_customer_sale .
        IF ls_customer_sale-kunnr <> ls_customer-kunnr .
          EXIT.
        ENDIF.
        ls_customer_total_sales-total_sales = ls_customer_total_sales-total_sales + ls_customer_sale-sales.
      ENDLOOP.

      APPEND ls_customer_total_sales TO lt_customer_total_sales.
      CLEAR ls_customer_total_sales.

    ENDLOOP.
    out->write(
      EXPORTING
        data   = lt_customer_total_sales

    ).


  ENDMETHOD.

  METHOD total_sales_reduce.
    DATA: ls_customer_total_sales TYPE ty_customer_total_sales,
          lt_customer_total_sales TYPE tt_customer_total_sales.


    LOOP AT lt_customer INTO DATA(ls_customer).

      ls_customer_total_sales-kunnr = ls_customer-kunnr.
      ls_customer_total_sales-name1 = ls_customer-name1.
      ls_customer_total_sales-total_sales = REDUCE #( INIT val TYPE i
                                             FOR wa IN FILTER #( lt_customer_sales WHERE kunnr = ls_customer-kunnr )
                                             NEXT    val = val + wa-sales
                                          ).
      APPEND ls_customer_total_sales TO lt_customer_total_sales.
      CLEAR ls_customer_total_sales.


    ENDLOOP.
    out->write(
      EXPORTING
        data   = lt_customer_total_sales

    ).


  ENDMETHOD.

  METHOD total_sales_select.

    DATA: ls_customer_total_sales TYPE ty_customer_total_sales,
          lt_customer_total_sales TYPE tt_customer_total_sales.

    IF cl_abap_dbfeatures=>use_features(  requested_features =  VALUE #( (  cl_abap_dbfeatures=>itabs_in_from_clause ) )  ).

*SELECT    from @lt_customer as customer INNER JOIN @lt_customer_sales as sales ON customer~kunnr = sales~kunnr
*          FIELDS customer~kunnr as kunnr, customer~name1 as name1, sum( sales~sales ) as total_sales
*          INTO TABLE @lt_customer_total_sales.

      LOOP AT lt_customer INTO DATA(ls_customer).
        ls_customer_total_sales-kunnr = ls_customer-kunnr.
        ls_customer_total_sales-name1 = ls_customer-name1.

        SELECT SUM( sales )  FROM @lt_customer_sales AS cust_sales WHERE kunnr = @ls_customer-kunnr
                                                             INTO @ls_customer_total_sales-total_sales.
        APPEND ls_customer_total_sales TO lt_customer_total_sales.
        CLEAR ls_customer_total_sales.
      ENDLOOP.
    ENDIF.

    out->write(
      EXPORTING
        data   = lt_customer_total_sales

    ).

  ENDMETHOD.





ENDCLASS.
