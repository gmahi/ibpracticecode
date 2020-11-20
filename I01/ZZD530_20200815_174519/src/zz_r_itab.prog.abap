*&---------------------------------------------------------------------*
*& Report zz_r_itab
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zz_r_itab.
TYPES:BEGIN OF ty_city,
      city1 TYPE spfli-cityfrom,
      city2 TYPE spfli-cityfrom,
      END OF TY_CITY.

   TYPES: tt_city TYPE STANDARD TABLE OF ty_city WITH EMPTY KEY.

select * from spfli into table @DATA(lt_spfli).

DATA(lt_city) = CORRESPONDING tt_city(  lt_spfli

                EXCEPT
).
