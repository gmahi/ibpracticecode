CLASS zcl_calculation_discount DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:
      if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_calculation_discount IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.
    CHECK NOT it_original_data IS INITIAL.

    DATA lt_calculated_data TYPE  STANDARD TABLE OF zdemo_c_sorderitem_vf WITH DEFAULT KEY.

    MOVE-CORRESPONDING it_original_data TO lt_calculated_data.

    LOOP AT lt_calculated_data ASSIGNING FIELD-SYMBOL(<s_calculated_data>).
      <s_calculated_data>-GrossAmountWithDiscount =
      COND #( WHEN <s_calculated_data>-ConvertedGrossAmount > 1000
                 THEN 1000 + ( <s_calculated_data>-ConvertedGrossAmount - 1000 ) * '0.9'
                 ELSE <s_calculated_data>-ConvertedGrossAmount
       ).

    ENDLOOP.
    MOVE-CORRESPONDING lt_calculated_data TO ct_calculated_data.

  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

    IF iv_entity <> 'ZDEMO_C_SORDERITEM_VF'.
      RAISE EXCEPTION TYPE zcx_calc_exit EXPORTING textid = zcx_calc_exit=>entity_not_known.
    ELSE.

      IF line_exists(  it_requested_calc_elements[ table_line = 'GROSSAMOUNTWITHDISCOUNT' ] ).

        APPEND 'CONVERTEDGROSSAMOUNT' TO  et_requested_orig_elements.

      ENDIF.

    ENDIF.

  ENDMETHOD.

ENDCLASS.
