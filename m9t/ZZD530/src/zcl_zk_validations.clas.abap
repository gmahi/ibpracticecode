CLASS zcl_zk_validations DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_ex_usmd_rule_service .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_zk_validations IMPLEMENTATION.

  METHOD if_ex_usmd_rule_service~check_crequest.

  ENDMETHOD.

  METHOD if_ex_usmd_rule_service~check_crequest_final.

  ENDMETHOD.

  METHOD if_ex_usmd_rule_service~check_crequest_hierarchy.

  ENDMETHOD.

  METHOD if_ex_usmd_rule_service~check_crequest_start.

  ENDMETHOD.

  METHOD if_ex_usmd_rule_service~check_edition.

  ENDMETHOD.

  METHOD if_ex_usmd_rule_service~check_edition_final.

  ENDMETHOD.

  METHOD if_ex_usmd_rule_service~check_edition_hierarchy.

  ENDMETHOD.

  METHOD if_ex_usmd_rule_service~check_edition_start.

  ENDMETHOD.

  METHOD if_ex_usmd_rule_service~check_entity.


    FIELD-SYMBOLS:
      <lt_site> TYPE SORTED TABLE,
      <lv_name> TYPE any.

    DATA(lr_site) = zcl_zk_usmd_model_ext=>get_entity_data(
                       io_model     = io_model
                       iv_fieldname = CONV #( id_entitytype )
                       iv_crequest  = id_crequest
                     ).
    ASSIGN  lr_site->*     TO <lt_site>.

    LOOP AT <lt_site> ASSIGNING FIELD-SYMBOL(<ls_site>).
      ASSIGN COMPONENT 'NAME' OF STRUCTURE <ls_site> TO <lv_name>.

    ENDLOOP.

    IF <lv_name> IS INITIAL.

      et_message = VALUE #( BASE et_message  (
                                  msgid = 'ZMSG_ZK'
                                  msgv1 = zcl_zk_usmd_model_ext=>get_filed_description(
                                            iv_tabname   = 'ZSZK_S_ZK_FP_SITE'
                                            iv_fieldname =  'NAME'
                                            iv_language  = sy-langu
                                          )
                                  msgno  = '000'
                                  msgty = 'E'     ) ).

    ENDIF.

  ENDMETHOD.

  METHOD if_ex_usmd_rule_service~check_entity_hierarchy.

  ENDMETHOD.

  METHOD if_ex_usmd_rule_service~derive_entity.

    FIELD-SYMBOLS: <lt_data> TYPE INDEX TABLE.


    CASE id_entitytype.
      WHEN 'SITE'.
        ASSIGN ct_data TO <lt_data>.
        IF <lt_data> IS ASSIGNED.

          READ TABLE <lt_data> INDEX 1 ASSIGNING FIELD-SYMBOL(<ls_site>).
          ASSIGN COMPONENT 'DESCR' OF STRUCTURE <ls_site> TO FIELD-SYMBOL(<lv_descr>).
          IF sy-subrc NE 0.
            RETURN.
          ENDIF.
          ASSIGN COMPONENT 'SITE' OF STRUCTURE <ls_site> TO FIELD-SYMBOL(<lv_site>).
          ASSIGN COMPONENT 'name' OF STRUCTURE <ls_site> TO FIELD-SYMBOL(<lv_name>).

          <lv_descr> = |{ <lv_site> }-{ <lv_name> }|.



        ENDIF.

    ENDCASE.



  ENDMETHOD.

ENDCLASS.
