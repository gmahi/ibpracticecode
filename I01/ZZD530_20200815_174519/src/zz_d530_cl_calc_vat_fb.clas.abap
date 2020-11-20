class ZZ_D530_CL_CALC_VAT_FB definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces ZZ_D530_IF_CALC_VAT .
protected section.
private section.
ENDCLASS.



CLASS ZZ_D530_CL_CALC_VAT_FB IMPLEMENTATION.


  method ZZ_D530_IF_CALC_VAT~GET_VAT.
    DATA: lv_percent type p VALUE 20.
    EX_AMOUNT_VAT = IM_AMOUNT * LV_PERCENT / 100.
    EX_PERCENT_VAT = LV_PERCENT.
  endmethod.
ENDCLASS.
