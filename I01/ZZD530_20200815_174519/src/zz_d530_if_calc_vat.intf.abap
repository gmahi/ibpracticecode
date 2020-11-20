interface ZZ_D530_IF_CALC_VAT
  public .


  interfaces IF_BADI_INTERFACE .

  methods GET_VAT
    importing
      !IM_AMOUNT type P
    exporting
      value(EX_AMOUNT_VAT) type P
      !EX_PERCENT_VAT type P .
endinterface.
