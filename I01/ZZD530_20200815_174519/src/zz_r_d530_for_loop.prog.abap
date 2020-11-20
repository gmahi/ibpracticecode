*&---------------------------------------------------------------------*
*& Report zz_r_d530_for_loop
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zz_r_d530_for_loop.

TYPES :BEGIN OF ty_city,
         city1 TYPE spfli-cityfrom,
         city2 TYPE spfli-cityto,

       END OF ty_city.

*TYPES: tt_city TYPE STANDARD TABLE OF ty_city WITH EMPTY KEY.
DATA:  lt_city TYPE STANDARD TABLE OF ty_city WITH EMPTY KEY.

SELECT FROM spfli FIELDS  connid, cityfrom, cityto INTO TABLE  @DATA(lt_spfli).


*DATA(lt_city) = VALUE tt_city( FOR ls_spfli IN lt_spfli
*                                    ( city1   = ls_spfli-cityfrom
*                                    city2  = ls_spfli-cityto       )
*
*).




cl_demo_output=>display( lt_city ).
