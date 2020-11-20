*&---------------------------------------------------------------------*
*& Report zr_amdp_test
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr_amdp_test.

try.

    DATA(lo_flights) = NEW zcl_amdp_test( ).
    lo_flights->get_utilization(
      EXPORTING
        iv_mandt       = sy-mandt
        iv_carrid      =  'AA'
      IMPORTING
        et_utilization = DATA(lt_utilazation)
    ).

   cl_demo_output=>display(
     EXPORTING
       data = lt_utilazation

   ).
  catch cx_amdp_error into DATA(lx_error).
  WRITE: lx_error->get_longtext(
         ).
endtry.
