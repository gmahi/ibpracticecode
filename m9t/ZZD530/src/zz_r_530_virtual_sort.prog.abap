*&---------------------------------------------------------------------*
*& Report zz_r_530_virtual_sort
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zz_r_530_virtual_sort.

TYPES:
  BEGIN OF flight,
    carrid   TYPE s_carr_id,
    connid   TYPE s_conn_id,
    cityfrom TYPE s_city,
    cityto   TYPE s_city,
  END OF flight,
  flights TYPE STANDARD TABLE OF flight
          WITH EMPTY KEY,
  BEGIN OF city,
    city      TYPE  s_city,
    latitude  TYPE  s_lati,
    longitude TYPE  s_long,
  END OF city,
  cities TYPE STANDARD TABLE OF city
              WITH EMPTY KEY.

DATA:
  flight_tab    TYPE flights,
  from_city_tab TYPE cities,
  to_city_tab   TYPE cities.


 SELECT carrid, connid, cityfrom, cityto
       FROM spfli
       INTO CORRESPONDING FIELDS OF TABLE @flight_tab.

SELECT city, latitude, longitude
       FROM sgeocity
       INTO TABLE @DATA(cities).


   TRY.
    from_city_tab = VALUE #( FOR <fs> IN flight_tab
                             ( cities[ city = <fs>-cityfrom ] ) ).
    to_city_tab   = VALUE #( FOR <fs> IN flight_tab
                             ( cities[ city = <fs>-cityto ] ) ).
  CATCH cx_sy_itab_line_not_found.
    MESSAGE 'Flight model data not consistent,' &&
            ' use program SAPBC_DATA_GENERATOR' &&
            ' to create the data.' TYPE 'X'.
ENDTRY.



DATA(sort_asc) = cl_abap_itab_utilities=>virtual_sort(
                   im_virtual_source =
                   VALUE #(

                        ( source = REF #( from_city_tab )

                          components = VALUE #( ( name = 'latitude' )
                                                ( name = 'longitude' )
                                                 )
                                                )

                         ( source = REF #( to_city_tab )

                           components = VALUE #( ( name = 'latitude' )
                                                 ( name = 'longitude' ) ) )

                         ( source = REF #( flight_tab )

                           components = VALUE #( ( name = 'carrid' )
                                                 ( name = 'connid' )  )  )
                   ) ).


cl_demo_output=>display( sort_asc ).

DATA sorted_tab TYPE flights.

LOOP AT sort_asc ASSIGNING FIELD-SYMBOL(<idx>).
  APPEND flight_tab[ <idx> ] TO sorted_tab.
ENDLOOP.

cl_demo_output=>display( sorted_tab ).

*CLEAR sorted_tab.
*LOOP AT sort_desc ASSIGNING <idx>.
*  APPEND flight_tab[ <idx> ] TO sorted_tab.
*ENDLOOP.
*
*cl_demo_output=>display( sorted_tab ).


*
