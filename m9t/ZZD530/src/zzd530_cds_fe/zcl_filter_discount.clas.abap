CLASS zcl_filter_discount DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:
      if_sadl_exit_filter_transform.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_filter_discount IMPLEMENTATION.

  METHOD if_sadl_exit_filter_transform~map_atom.
    IF iv_element <> 'GROSSAMOUNTWITHDISCOUNT'.
      RAISE EXCEPTION TYPE zcx_filter_exit EXPORTING textid = zcx_filter_exit=>element_not_expected.
    ENDIF.

    DATA(lo_cfac) = cl_sadl_cond_prov_factory_pub=>create_simple_cond_factory( ).
    DATA(amount) = lo_cfac->element( 'CONVERTEDGROSSAMOUNT' ).
    DATA(lv_originalvalue) = 1000 + ( iv_value - 1000 ) / '0.9'.

    CASE iv_operator.

      WHEN if_sadl_exit_filter_transform~co_operator-equals.

        ro_condition = amount->less_than(    1000 )->and( amount->equals( iv_value )
                )->or( amount->greater_than( 1000 )->and( amount->equals( lv_originalvalue ) ) ).

      WHEN if_sadl_exit_filter_transform~co_operator-less_than.

        ro_condition = amount->less_than(    1000 )->and( amount->less_than( iv_value )
                )->or( amount->greater_than( 1000 )->and( amount->less_than( lv_originalvalue ) ) ).

      WHEN if_sadl_exit_filter_transform~co_operator-greater_than.
        ro_condition = amount->less_than(    1000 )->and( amount->greater_than( iv_value )
                )->or( amount->greater_than( 1000 )->and( amount->greater_than( lv_originalvalue ) ) ).

      WHEN if_sadl_exit_filter_transform~co_operator-is_null.
        ro_condition = amount->is_null( ).

      WHEN if_sadl_exit_filter_transform~co_operator-covers_pattern.
        RAISE EXCEPTION TYPE zcx_filter_exit.

    ENDCASE.
  ENDMETHOD.


  ENDCLASS.
