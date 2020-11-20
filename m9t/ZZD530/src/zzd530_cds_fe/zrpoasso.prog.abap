*&---------------------------------------------------------------------*
*& Report zrpoasso
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrpoasso.


SELECT FROM zipoasso FIELDS ebeln, bukrs, \_poitems-pono, \_poitems[ (1)  WHERE poitem = '00010' ]-poitem, \_poitems-material INTO TABLE @DATA(podata).

cl_salv_table=>factory(

  IMPORTING
    r_salv_table   = DATA(salvtable)
  CHANGING
    t_table        = podata
).
*CATCH cx_salv_msg.

salvtable->display( ).
