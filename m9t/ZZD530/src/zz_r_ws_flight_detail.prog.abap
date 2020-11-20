*&---------------------------------------------------------------------*
*& Report ZZ_R_WS_FLIGHT_DETAIL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zz_r_ws_flight_detail.

CLASS lcl_flight_service DEFINITION CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-METHODS:
      get_flight_details IMPORTING im_airline_id    TYPE s_carr_id
                                   im_connection_id TYPE s_conn_id
                                   iM_flight_date   TYPE s_date.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_flight_service IMPLEMENTATION.

  METHOD get_flight_details.

*  Method-Local data declarations
    DATA: lo_ws_proxy TYPE REF TO zco_zsd_flight_detail,
          ls_input    TYPE zflight_getdetail,
          ls_output   TYPE  zflight_getdetail_response.
    TRY.
        lo_ws_proxy = NEW #(  )  .
*   Fill in the required parameters
        ls_input = VALUE #( airlineid = im_airline_id connectionid = im_connection_id
        flightdate =  |{ im_flight_date+0(4) }-{ im_flight_date+4(2) }-{ im_flight_date+6(2) }| ) .
*Excute the web service method
        lo_ws_proxy->flight_getdetail(
          EXPORTING
            input  = ls_input
          IMPORTING
            output = ls_output
        ).

*Display the results
        WRITE: / 'Flight', ls_output-flight_data-connectid,
                 'from', ls_output-flight_data-cityfrom,
                 'to',  ls_output-flight_data-cityto,
                 'departing on', ls_output-flight_data-flightdate MM/DD/YYYY.

      CATCH cx_root INTO DATA(lx_root).
        WRITE:lx_root->get_longtext(  ).
    ENDTRY.

  ENDMETHOD.

ENDCLASS.



PARAMETERS:
  p_carr TYPE s_carr_id,
  p_conn TYPE s_conn_id,
  p_date TYPE s_date.

  START-OF-SELECTION.

  lcl_flight_service=>get_flight_details(
    EXPORTING
      im_airline_id    = p_carr
      im_connection_id = p_conn
      im_flight_date   = p_date
  ).
