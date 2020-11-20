class ZCL_D530_CALC_VAT_US definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces ZZ_D530_IF_CALC_VAT .
protected section.
private section.
ENDCLASS.



CLASS ZCL_D530_CALC_VAT_US IMPLEMENTATION.


  method ZZ_D530_IF_CALC_VAT~GET_VAT.
    DATA: percent type p value 4.
    ex_amount_vat = im_amount * percent / 100 .
    ex_percent_vat = percent .

  endmethod.
ENDCLASS.
