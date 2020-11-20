*&---------------------------------------------------------------------*
*& Report zz_r_d530_af_ch2_4
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zz_r_d530_af_ch2_4.

TYPES: BEGIN OF ty_monsters,
         monster_number TYPE i,
         monster_type   TYPE char4,
         people_scared  TYPE i,
       END OF ty_monsters.

TYPES: tt_monsters TYPE STANDARD TABLE OF ty_monsters
       WITH DEFAULT KEY.

      DATA: monster_sub_set TYPE tt_monsters,
            total_scared TYPE i.
