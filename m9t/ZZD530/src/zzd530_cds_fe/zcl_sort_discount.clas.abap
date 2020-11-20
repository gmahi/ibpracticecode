CLASS zcl_sort_discount DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
      INTERFACES:
      if_sadl_exit_sort_transform.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_sort_discount IMPLEMENTATION.


  METHOD if_sadl_exit_sort_transform~map_element.
    IF iv_element <> 'GROSSAMOUNTWITHDISCOUNT'.
      RAISE EXCEPTION TYPE zcx_filter_exit EXPORTING textid = zcx_filter_exit=>element_not_expected.
    ENDIF.
      APPEND value #( name = `CONVERTEDGROSSAMOUNT` ) TO et_sort_elements.
  ENDMETHOD.

ENDCLASS.


