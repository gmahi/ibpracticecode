*&---------------------------------------------------------------------*
*& Report zr_test_custom_entity
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr_test_custom_entity.


SELECT TRAVEL_ID,AGENCY_ID,CUSTOMER_ID,BEGIN_DATE,END_DATE,BOOKING_FEE,TOTAL_PRICE,CURRENCY_CODE,STATUS,LASTCHANGEDAT FROM /dmo/travel
                              WHERE BEGIN_DATE >= '20200926' AND  END_DATE <= '20210926' AND DESCRIPTION LIKE '%%' into table @data(lt_data).



 cl_demo_output=>display(
   EXPORTING
     data = lt_data

 ).
