**********************************************************************
*
* Message handler class - travel instances
*
**********************************************************************

CLASS lcl_message_helper DEFINITION CREATE PRIVATE.

  PUBLIC SECTION.
    TYPES tt_travel_failed TYPE TABLE FOR FAILED zi_travel_u.
    TYPES tt_travel_reported TYPE TABLE FOR REPORTED zi_travel_u.
    CLASS-METHODS handle_travel_messages
      IMPORTING iv_cid       TYPE string OPTIONAL
                iv_travel_id TYPE /dmo/travel_id OPTIONAL
                it_messages  TYPE zif_flight_legacy=>tt_message
      CHANGING
                failed       TYPE tt_travel_failed
                reported     TYPE tt_travel_reported.

ENDCLASS.

CLASS lcl_message_helper IMPLEMENTATION.


  METHOD handle_travel_messages.

    LOOP AT it_messages INTO DATA(ls_message) WHERE msgty = 'E' OR msgty = 'A'.

      INSERT VALUE #( %cid =  iv_cid  travelid = iv_travel_id ) INTO TABLE failed.



    ENDLOOP.

  ENDMETHOD.

ENDCLASS.



**********************************************************************
*
* Handler class for managing travels
*
**********************************************************************

CLASS lhc_travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS create_travel
      FOR MODIFY
      IMPORTING it_travel_create FOR CREATE travel.

    METHODS delete_travel FOR MODIFY
      IMPORTING it_travel_delete FOR DELETE travel.

    METHODS update_travel FOR MODIFY
      IMPORTING it_travel_update FOR UPDATE travel.

    METHODS read_travel FOR READ
      IMPORTING it_travel FOR READ travel RESULT et_travel.

    METHODS cba_BOOKING FOR MODIFY
      IMPORTING it_booking_create_ba FOR CREATE travel\_booking.

*    METHODS rba_BOOKING FOR READ
*      IMPORTING keys_rba FOR READ travel\_booking FULL result_requested RESULT result LINK association_links.
*
    METHODS set_status_booked FOR MODIFY
      IMPORTING it_travel_set_status_booked FOR ACTION travel~set_status_booked RESULT et_travel_set_status_booked.

ENDCLASS.

CLASS lhc_travel IMPLEMENTATION.

  METHOD create_travel.

    DATA lt_messages TYPE zif_flight_legacy=>tt_message.
    DATA ls_travel_in TYPE zif_flight_legacy=>ts_travel_in.
    DATA ls_travel_out  TYPE /dmo/travel.

    LOOP AT it_travel_create ASSIGNING FIELD-SYMBOL(<ls_travel_create>).
      CLEAR ls_travel_in.
      ls_travel_in = CORRESPONDING #( zcl_travel_auxiliary=>map_travel_cds_to_db( CORRESPONDING #( <ls_travel_create> )   ) ).

      CALL FUNCTION '/DMO/FLIGHT_TRAVEL_CREATE'
        EXPORTING
          is_travel   = ls_travel_in
        IMPORTING
          es_travel   = ls_travel_out
          et_messages = lt_messages.
      IF lt_messages IS INITIAL.

        INSERT VALUE #( %cid = <ls_travel_create>-%cid travelid = ls_travel_out-travel_id  ) INTO TABLE mapped-travel .
      ELSE.
        lcl_message_helper=>handle_travel_messages(
          EXPORTING
            iv_cid       = <ls_travel_create>-%cid
            it_messages  = lt_messages
          CHANGING
            failed       = failed-travel
            reported     =  reported-travel
        ).

      ENDIF.




    ENDLOOP.



  ENDMETHOD.

  METHOD delete_travel.

    DATA lt_messages TYPE /dmo/if_flight_legacy=>tt_message.

    LOOP AT it_travel_delete ASSIGNING FIELD-SYMBOL(<fs_travel_delete>).

      CALL FUNCTION '/DMO/FLIGHT_TRAVEL_DELETE'
        EXPORTING
          iv_travel_id = <fs_travel_delete>-travelid
        IMPORTING
          et_messages  = lt_messages.

      lcl_message_helper=>handle_travel_messages(
        EXPORTING
          iv_cid       = <fs_travel_delete>-%cid_ref
          iv_travel_id = <fs_travel_delete>-travelid
          it_messages  = lt_messages
        CHANGING
          failed       = failed-travel
          reported     = reported-travel ).

    ENDLOOP.

  ENDMETHOD.

  METHOD update_travel.
    DATA lt_messages    TYPE /dmo/if_flight_legacy=>tt_message.
    DATA ls_travel      TYPE /dmo/if_flight_legacy=>ts_travel_in.
    DATA ls_travelx TYPE /dmo/if_flight_legacy=>ts_travel_inx. "flag structure (> BAPIs)

    LOOP AT it_travel_update ASSIGNING FIELD-SYMBOL(<ls_travel_update>).
      CLEAR ls_travel.

      ls_travel = CORRESPONDING #( zcl_travel_auxiliary=>map_travel_cds_to_db(  CORRESPONDING #( <ls_travel_update> ) ) ).

      ls_travelx-travel_id = ls_travel-travel_id.
      ls_travelx-agency_id = xsdbool( <ls_travel_update>-%control-AgencyID = if_abap_behv=>mk-on ).
      ls_travelx-customer_id = xsdbool( <ls_travel_update>-%control-CustomerID = if_abap_behv=>mk-on ).
      ls_travelx-begin_date = xsdbool( <ls_travel_update>-%control-BeginDate = if_abap_behv=>mk-on ).
      ls_travelx-end_date = xsdbool( <ls_travel_update>-%control-EndDate = if_abap_behv=>mk-on ).
      ls_travelx-booking_fee = xsdbool( <ls_travel_update>-%control-BookingFee = if_abap_behv=>mk-on ).
      ls_travelx-total_price = xsdbool( <ls_travel_update>-%control-TotalPrice = if_abap_behv=>mk-on ).
      ls_travelx-currency_code = xsdbool( <ls_travel_update>-%control-CurrencyCode = if_abap_behv=>mk-on ).
      ls_travelx-description = xsdbool( <ls_travel_update>-%control-Memo = if_abap_behv=>mk-on ).
      ls_travelx-status = xsdbool( <ls_travel_update>-%control-Status = if_abap_behv=>mk-on ).

      CALL FUNCTION '/DMO/FLIGHT_TRAVEL_UPDATE'
        EXPORTING
          is_travel   = ls_travel
          is_travelx  = ls_travelx
        IMPORTING
          et_messages = lt_messages.

      lcl_message_helper=>handle_travel_messages(
    EXPORTING
      iv_cid       = <ls_travel_update>-%cid_ref
      iv_travel_id = <ls_travel_update>-travelid
      it_messages  = lt_messages
    CHANGING
      failed       = failed-travel
      reported     = reported-travel ).






    ENDLOOP.


  ENDMETHOD.

  METHOD read_travel.


    DATA: ls_travel_out TYPE /dmo/travel.

    LOOP AT it_travel INTO DATA(ls_travel_to_read).
      CALL FUNCTION '/DMO/FLIGHT_TRAVEL_READ'
        EXPORTING
          iv_travel_id = ls_travel_to_read-travelid
        IMPORTING
          es_travel    = ls_travel_out.

      INSERT VALUE #( travelid      = ls_travel_to_read-travelid
                      agencyid      = ls_travel_out-agency_id
                      customerid    = ls_travel_out-customer_id
                      begindate     = ls_travel_out-begin_date
                      enddate       = ls_travel_out-end_date
                      bookingfee    = ls_travel_out-booking_fee
                      totalprice    = ls_travel_out-total_price
                      currencycode  = ls_travel_out-currency_code
                      memo          = ls_travel_out-description
                      status        = ls_travel_out-status
                      lastchangedat = ls_travel_out-lastchangedat ) INTO TABLE et_travel.
    ENDLOOP.




  ENDMETHOD.

  METHOD cba_BOOKING.
  ENDMETHOD.

*  METHOD rba_BOOKING.
*  ENDMETHOD.

  METHOD set_status_booked.

    DATA lt_messages TYPE zif_flight_legacy=>tt_message.
    DATA ls_travel_out TYPE /dmo/travel.

    CLEAR et_travel_set_status_booked.

    LOOP AT it_travel_set_status_booked ASSIGNING FIELD-SYMBOL(<fs_travel_set_status_booked>).

      DATA(lv_travelid) = <fs_travel_set_status_booked>-travelid.

      CALL FUNCTION '/DMO/FLIGHT_TRAVEL_SET_BOOKING'
        EXPORTING
          iv_travel_id = lv_travelid
        IMPORTING
          et_messages  = lt_messages.
      IF lt_messages IS INITIAL.
        APPEND VALUE #( travelid        = lv_travelid
                        %param-travelid = lv_travelid )
               TO et_travel_set_status_booked.
      ELSE.
        lcl_message_helper=>handle_travel_messages(
          EXPORTING
            iv_cid       = <fs_travel_set_status_booked>-%cid_ref
            iv_travel_id = lv_travelid
            it_messages  = lt_messages
          CHANGING
            failed       = failed-travel
            reported     = reported-travel ).
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZI_TRAVEL_U DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.
    METHODS cleanup           REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_TRAVEL_U IMPLEMENTATION.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD finalize.
  ENDMETHOD.

  METHOD save.
    CALL FUNCTION '/DMO/FLIGHT_TRAVEL_SAVE'.
  ENDMETHOD.

  METHOD cleanup.
    CALL FUNCTION '/DMO/FLIGHT_TRAVEL_INITIALIZE'.

  ENDMETHOD.

ENDCLASS.
