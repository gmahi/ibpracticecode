*&---------------------------------------------------------------------*
*& Report zz_r_530_dynamic_prog
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zz_r_530_dynamic_prog.
*DATA: lv_num TYPE i VALUE 2.
*DATA lr_num TYPE REF TO i.
*CREATE DATA lr_num.
*lr_num = NEW #( ).
**get REFERENCE OF lv_num INTO lr_num.
*DATA(lr_num) = ref #( lv_num ).
*lr_num->* = 4.
**WRITE:/ lr_num->*.
*WRITE:/ lv_num.

*DATA: lr_str TYPE REF TO DATA.
*      FIELD-SYMBOLS: <str> TYPE any,
*                     <data> TYPE any.
*
*  lr_str =  new mara( ).
*  ASSIGN lr_str->* TO <str>.
*  ASSIGN COMPONENT 'MATNR' OF STRUCTURE <str> TO <data>.
*  <data> = '112'.

PARAMETERS: p_tab TYPE tabname.

DATA: r_tab TYPE REF TO data.
FIELD-SYMBOLS: <tab> TYPE ANY TABLE.
CREATE DATA r_tab TYPE TABLE OF (p_tab).

ASSIGN  r_tab->* TO <tab>.
IF sy-subrc = 0.
SELECT * FROM (p_tab) INTO TABLE <tab> UP TO 10 ROWS.
cl_demo_output=>display( <tab> ).
ENDIF.
