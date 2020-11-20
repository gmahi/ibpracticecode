*&---------------------------------------------------------------------*
*& Report zz_r_d530_badi
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zz_r_d530_badi.
data: lr_badi type ref to  ZZ_D530_BADI_CALC_VAT.
      get badi lr_badi.
      call badi lr_badi->GET_VAT
        EXPORTING
          IM_AMOUNT      =  125
        IMPORTING
          EX_AMOUNT_VAT  = data(lv_vat_amount)
          EX_PERCENT_VAT =  data(lv_vat)
        .

write: |Percentage: { lv_vat }, Vat: { lv_vat_amount }!. |.
