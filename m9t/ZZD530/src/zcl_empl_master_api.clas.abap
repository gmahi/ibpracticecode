CLASS zcl_empl_master_api DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS: search_employee IMPORTING iv_string   TYPE string
                                             iv_max_hits TYPE genilt_unsigned_int4
                                   EXPORTING et_results  TYPE zttbol_empl_key,
      read_employee   IMPORTING is_empl_key  TYPE zbol_empl_master_key
                      EXPORTING es_emply_att TYPE zbol_empl_master_attr.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_empl_master_api IMPLEMENTATION.
  METHOD search_employee.
    REFRESH et_results.
    IF iv_string IS NOT INITIAL.
      SELECT employee_id FROM zbol_empl_master UP TO iv_max_hits ROWS
                         INTO TABLE et_results
                         WHERE (iv_string).
    ELSE.
      SELECT employee_id FROM zbol_empl_master UP TO iv_max_hits ROWS
                         INTO TABLE et_results.
    ENDIF.

  ENDMETHOD.

  METHOD read_employee.
  SELECT SINGLE * FROM zbol_empl_master INTO CORRESPONDING FIELDS OF es_emply_att
                                        WHERE employee_id = is_empl_key-employee_id.

  ENDMETHOD.

ENDCLASS.
