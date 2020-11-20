
**********************************************************************
*
* Local class for handling messages of bookings
*
**********************************************************************

CLASS lcl_message_helper DEFINITION CREATE PRIVATE.
  PUBLIC SECTION.
    TYPES tt_booking_failed     TYPE TABLE FOR FAILED   zi_booking_u.
    TYPES tt_booking_reported   TYPE TABLE FOR REPORTED zi_booking_u.

    CLASS-METHODS handle_booking_messages
      IMPORTING iv_cid        TYPE string OPTIONAL
                iv_travel_id  TYPE /dmo/travel_id OPTIONAL
                iv_booking_id TYPE /dmo/booking_id OPTIONAL
                it_messages   TYPE /dmo/if_flight_legacy=>tt_message
      CHANGING
                failed        TYPE tt_booking_failed
                reported      TYPE tt_booking_reported.
ENDCLASS.

CLASS lcl_message_helper IMPLEMENTATION.

  METHOD handle_booking_messages.

    LOOP AT it_messages INTO DATA(ls_message) WHERE msgty = 'E' OR msgty = 'A'.
      INSERT VALUE #( %cid = iv_cid
                      travelid    = iv_travel_id
                      bookingid   = iv_booking_id ) INTO TABLE failed.

      INSERT zcl_travel_auxiliary=>map_booking_message(
                                          iv_travel_id  = iv_travel_id
                                          iv_booking_id = iv_booking_id
                                          is_message    = ls_message )
                                      INTO TABLE reported.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.





**********************************************************************
*
* Handler class implements UPDATE for booking instances
*
**********************************************************************


CLASS lhc_booking DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    TYPES tt_booking_update TYPE TABLE FOR UPDATE zi_booking_u.
*    METHODS create FOR MODIFY
*      IMPORTING entities FOR CREATE booking.

    METHODS delete_booking FOR MODIFY
      IMPORTING it_booking_delete FOR DELETE booking.

    METHODS update_booking FOR MODIFY
      IMPORTING it_booking_update FOR UPDATE booking.

    METHODS _fill_booking_inx
      IMPORTING is_booking_update     TYPE LINE OF tt_booking_update
      RETURNING VALUE(rs_booking_inx) TYPE zif_flight_legacy=>ts_booking_inx   .

*    METHODS read FOR READ
*      IMPORTING keys FOR READ booking RESULT result.

ENDCLASS.

CLASS lhc_booking IMPLEMENTATION.

*  METHOD create.
*  ENDMETHOD.

  METHOD delete_booking.
    DATA lt_messages TYPE zif_flight_legacy=>tt_message.

    LOOP AT it_booking_delete INTO DATA(ls_booking_delete).

      CALL FUNCTION '/DMO/FLIGHT_TRAVEL_UPDATE'
        EXPORTING
          is_travel   = VALUE /dmo/if_flight_legacy=>ts_travel_in( travel_id = ls_booking_delete-travelid )
          is_travelx  = VALUE /dmo/if_flight_legacy=>ts_travel_inx( travel_id = ls_booking_delete-travelid )
          it_booking  = VALUE /dmo/if_flight_legacy=>tt_booking_in( ( booking_id = ls_booking_delete-bookingid ) )
          it_bookingx = VALUE /dmo/if_flight_legacy=>tt_booking_inx( ( booking_id  = ls_booking_delete-bookingid
                                                                       action_code = zif_flight_legacy=>action_code-delete ) )
        IMPORTING
          et_messages = lt_messages.

      IF lt_messages IS NOT INITIAL.

        lcl_message_helper=>handle_booking_messages(
         EXPORTING
           iv_cid       = ls_booking_delete-%cid_ref
           iv_travel_id = ls_booking_delete-travelid
           iv_booking_id = ls_booking_delete-bookingid
           it_messages  = lt_messages
         CHANGING
           failed       = failed-booking
           reported     = reported-booking ).

      ENDIF.

    ENDLOOP.


  ENDMETHOD.

  METHOD update_booking.
    DATA lt_messages TYPE /dmo/if_flight_legacy=>tt_message.

**********************************************************************
* Implements the UPDATE operation for a set of booking instances
**********************************************************************
    LOOP AT it_booking_update ASSIGNING FIELD-SYMBOL(<fs_booking_update>).
      CALL FUNCTION '/DMO/FLIGHT_TRAVEL_UPDATE'
        EXPORTING
          is_travel   = VALUE /dmo/if_flight_legacy=>ts_travel_in( travel_id = <fs_booking_update>-travelid )
          is_travelx  = VALUE /dmo/if_flight_legacy=>ts_travel_inx( travel_id = <fs_booking_update>-travelid )
          it_booking  = VALUE /dmo/if_flight_legacy=>tt_booking_in( ( /dmo/cl_travel_auxiliary=>map_booking_cds_to_db( CORRESPONDING #( <fs_booking_update> ) ) ) )
          it_bookingx = VALUE /dmo/if_flight_legacy=>tt_booking_inx( ( _fill_booking_inx( <fs_booking_update> ) ) )
        IMPORTING
          et_messages = lt_messages.


      lcl_message_helper=>handle_booking_messages(
        EXPORTING
          iv_cid       = <fs_booking_update>-%cid_ref
          iv_travel_id = <fs_booking_update>-travelid
          iv_booking_id = <fs_booking_update>-bookingid
          it_messages  = lt_messages
        CHANGING
          failed       = failed-booking
          reported     = reported-booking ).

    ENDLOOP.

  ENDMETHOD.

*  METHOD read.
*  ENDMETHOD.

  METHOD _fill_booking_inx.

    CLEAR rs_booking_inx.
    rs_booking_inx-booking_id    = is_booking_update-bookingid.
    rs_booking_inx-action_code   = /dmo/if_flight_legacy=>action_code-update.

    rs_booking_inx-booking_date  = xsdbool( is_booking_update-%control-bookingdate  = if_abap_behv=>mk-on ).
    rs_booking_inx-customer_id   = xsdbool( is_booking_update-%control-customerid   = if_abap_behv=>mk-on ).
    rs_booking_inx-carrier_id    = xsdbool( is_booking_update-%control-airlineid    = if_abap_behv=>mk-on ).
    rs_booking_inx-connection_id = xsdbool( is_booking_update-%control-connectionid = if_abap_behv=>mk-on ).
    rs_booking_inx-flight_date   = xsdbool( is_booking_update-%control-flightdate   = if_abap_behv=>mk-on ).
    rs_booking_inx-flight_price  = xsdbool( is_booking_update-%control-flightprice  = if_abap_behv=>mk-on ).
    rs_booking_inx-currency_code = xsdbool( is_booking_update-%control-currencycode = if_abap_behv=>mk-on ).

  ENDMETHOD.

ENDCLASS.
