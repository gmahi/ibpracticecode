INTERFACE zif_monster_model_pers_layer
  PUBLIC .
  METHODS create_monster_record
    IMPORTING it_monster_items      TYPE ztt_monster_items
              is_monster_header     TYPE zstr_monster_header
    EXPORTING ef_creation_succesful TYPE abap_bool
    RAISING  zcx_monster_exceptions.
              .


  METHODS retrieve_headers_by_attribute
    IMPORTING it_selections      TYPE rpm_tt_cosel
    EXPORTING
              et_monster_headers TYPE ztt_monster_header.
  METHODS retrieve_monster_record
    IMPORTING id_monster_number TYPE zde_monster_number
              id_edit_mode      TYPE lrm_crud_mode DEFAULT 'R'
    EXPORTING
              es_monster_header TYPE zstr_monster_header
              et_monster_items  TYPE ztt_monster_items
    RAISING   zcx_monster_exceptions .

    methods UPDATE_MONSTER_RECORD
    importing
      !IT_MONSTER_ITEMS type ZTT_MONSTER_ITEMS
      !IS_MONSTER_HEADER type ZSTR_MONSTER_HEADER
    exporting
      !EF_UPDATE_SUCCESSFUL type ABAP_BOOL
    raising
      ZCX_MONSTER_EXCEPTIONS .





ENDINTERFACE.
