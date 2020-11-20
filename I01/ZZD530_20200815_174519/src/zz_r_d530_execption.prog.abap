*&---------------------------------------------------------------------*
*& Report zz_r_d530_execption
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zz_r_d530_execption.

class lcx_mandatory_missing definition
  inheriting from cx_static_check.

endclass.

class lcl_test_exception definition .

  public section.
    methods: calculate importing iv_num1        type i optional
                                 iv_num2        type i optional
                       returning value(rv_calc) type i
                       raising   lcx_mandatory_missing
                                 cx_sy_arithmetic_error.
  protected section.
  private section.
    methods: do_div raising cx_sy_arithmetic_error,
      do_check raising lcx_mandatory_missing.
    data: v_num1   type i,
          v_num2   type i,
          v_result type i.

endclass.

class lcl_test_exception implementation.

  method calculate.
    v_num1 = iv_num1.
    v_num2 = iv_num2.
    me->do_check( ).
    me->DO_DIV( ).
*     CATCH CX_SY_ARITHMETIC_ERROR.    "
    rv_calc = v_result.

  endmethod.

  method do_check.
    if v_num1 is initial.
      raise exception type lcx_mandatory_missing.
    endif.

  endmethod.

  method do_div.
    v_result  = v_num1 div v_num2.

  endmethod.

endclass.


start-of-selection.

  data: lo_obj      type  ref to lcl_test_exception,
        lo_exc_root type ref to cx_root.

  lo_obj = new #( ).

  try.
      lo_obj->CALCULATE(
        EXPORTING
          IV_NUM1                = 10
*          IV_NUM2                =
        RECEIVING
          RV_CALC                = data(lv_ret)
         ).
        CATCH LCX_MANDATORY_MISSING.
        write:/ 'Madatory parameter is missing' .  "
       CATCH CX_SY_ARITHMETIC_ERROR into lo_exc_root.    "
data(lv_msg) = lo_exc_root->GET_TEXT( ).
      write: lv_msg.

  endtry.
