*&---------------------------------------------------------------------*
*& Report zz_r_get_userlist
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zz_r_get_userlist.

DATA: lt_user TYPE STANDARD TABLE OF xubname.
select * from usr01 INTO TABLE @DATA(lt_usr01) UP TO 10 ROWS.

lt_user = VALUE #(  (  'd530' ) ( 'd531' ) ).

*LOOP AT lt_usr01 INTO DATA(ls_usr01).
*
*lt_user = VALUE #( BASE lt_user  ( ls_usr01-bname ) ).
*
*ENDLOOP.


lt_user = VALUE #(  BASE lt_user for wa in lt_usr01
                        ( wa-bname )

                        ).


cl_demo_output=>display(
  EXPORTING
    data =  lt_user
*    name =
).
