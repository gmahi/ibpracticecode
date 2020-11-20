class ZCL_ZK_FILED_PROPERTIES definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_USMD_ACC_FLD_PROP_CDS .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ZK_FILED_PROPERTIES IMPLEMENTATION.


METHOD IF_EX_USMD_ACC_FLD_PROP_CDS~IS_FIELD_PROP_HIDDEN_SUPPORTED.
  RETURN.
ENDMETHOD.


method IF_EX_USMD_ACC_FLD_PROP_CDS~MODIFY_ENTITY_PROPERTIES.
endmethod.


METHOD if_ex_usmd_acc_fld_prop_cds~modify_fld_prop_attr.

* Define field symbol based on structure configured for Field Properties
  DATA: it_fld TYPE TABLE OF zdk_fldpro,
        ls_fld TYPE zdk_fldpro.
* Ensure this is the correct data model
  IF io_model->d_usmd_model NE 'ZK'.
    EXIT.
  ENDIF.

* Change Field properties for Carrier
  IF iv_entity = 'SITE'.
    LOOP AT  ct_fld_prop ASSIGNING FIELD-SYMBOL(<ls_fld_prop_site>).
      ASSIGN COMPONENT 'USMD_FP' OF STRUCTURE <ls_fld_prop_site> TO FIELD-SYMBOL(<ls_usmd_fp>).
      ASSIGN COMPONENT 'NAME' OF STRUCTURE <ls_usmd_fp> TO FIELD-SYMBOL(<lv_field>).
      IF <lv_field> IS ASSIGNED.
        <lv_field> = if_usmd_fld_prop_const=>required.
      ENDIF.

    ENDLOOP.
  ENDIF.
*Change field property for specific CR type
  IF iv_creq_type = 'ZKD564'.
    SELECT * FROM zdk_fldpro INTO TABLE it_fld WHERE crtype EQ iv_creq_type AND
                                                     crstep EQ iv_fld_prop_wfs AND
                                                     entity EQ iv_entity.
    IF sy-subrc EQ 0.
      LOOP AT it_fld ASSIGNING FIELD-SYMBOL(<ls_fld>).
        LOOP AT ct_fld_prop ASSIGNING FIELD-SYMBOL(<ls_fld_prop>).
          ASSIGN COMPONENT 'USMD_FP' OF STRUCTURE <ls_fld_prop> TO FIELD-SYMBOL(<ls_usmd>).
          ASSIGN COMPONENT <ls_fld>-field OF STRUCTURE <ls_usmd> TO FIELD-SYMBOL(<lv_value>).
          IF <lv_value> IS ASSIGNED.
            <lv_value> = <ls_fld>-flpro.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
    ENDIF.
  ENDIF.

  IF sy-uname EQ 'D518'.

    CHECK iv_entity EQ 'SITE' AND iv_creq_type EQ 'ZK601CR3' AND iv_creq_status EQ '02'.

        LOOP AT  ct_fld_prop ASSIGNING <ls_fld_prop_site>.
      ASSIGN COMPONENT 'USMD_FP' OF STRUCTURE <ls_fld_prop_site> TO <ls_usmd_fp>.
      ASSIGN COMPONENT 'CITY' OF STRUCTURE <ls_usmd_fp> TO <lv_field>.
      IF <lv_field> IS ASSIGNED.
        <lv_field> = if_usmd_fld_prop_const=>required.
      ENDIF.

    ENDLOOP.

  ENDIF.
ENDMETHOD.
ENDCLASS.
