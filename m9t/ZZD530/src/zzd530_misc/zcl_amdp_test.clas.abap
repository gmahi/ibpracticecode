CLASS zcl_amdp_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_amdp_marker_hdb.
    TYPES:BEGIN OF ty_flight_utilization,
            carrid      TYPE s_carr_id,
            connid      TYPE s_conn_id,
            utilization TYPE p LENGTH 5 DECIMALS 2,
          END OF ty_flight_utilization.
    TYPES: tt_flight_utilization TYPE STANDARD TABLE OF ty_flight_utilization WITH EMPTY KEY.
    METHODS get_utilization IMPORTING
                              VALUE(iv_mandt)       TYPE mandt
                              VALUE(iv_carrid)      TYPE s_carr_id
                            EXPORTING
                              VALUE(et_utilization) TYPE tt_flight_utilization.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_amdp_test IMPLEMENTATION.
  METHOD get_utilization BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT OPTIONS READ-ONLY USING sflight.

    et_utilization =
    SELECT carrid,
            connid,
            avg(to_decimal(seatsocc + seatsocc_b + seatsocc_f) / to_decimal(seatsmax + seatsmax_b +  seatsmax_f) * 100 ) AS utilization
                 FROM sflight
                           WHERE mandt = :iv_mandt
                           AND carrid = :iv_carrid
                           GROUP BY carrid, connid;
  ENDMETHOD.

ENDCLASS.
