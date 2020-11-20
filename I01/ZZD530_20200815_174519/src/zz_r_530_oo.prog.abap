*&---------------------------------------------------------------------*
*& Report zz_r_530_oo
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zz_r_530_oo.

CLASS lcl_sel DEFINITION.

  PUBLIC SECTION.
*    Types for the Attributes
    TYPES:
      tt_msgnr_range TYPE RANGE OF t100-msgnr .

    DATA v_arbgb TYPE t100-arbgb .
    DATA t_msgnr_range TYPE tt_msgnr_range .
     METHODS get_default RETURNING VALUE(rv_arbgb) TYPE t100-arbgb.
    METHODS validate_message_class
      IMPORTING
        iv_arbgb TYPE t100-arbgb.
  PROTECTED SECTION.
  PRIVATE SECTION.


ENDCLASS.




CLASS lcl_sel IMPLEMENTATION.

  METHOD get_default.
    "     returning value(RV_ARBGB) type T100-ARBGB .
    rv_arbgb = '00'.
  ENDMETHOD.
*
  METHOD validate_message_class.
    "    importing !IV_ARBGB type T100-ARBGB
    "    raising   ZCX_MSG .
    DATA: ls_msg TYPE symsg.
    SELECT SINGLE arbgb
      INTO v_arbgb
      FROM t100
      WHERE arbgb = iv_arbgb.

  ENDMETHOD.


ENDCLASS.
