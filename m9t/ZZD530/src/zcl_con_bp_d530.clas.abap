CLASS zcl_con_bp_d530 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS: write_data IMPORTING it_data           TYPE  mdc_tt_but_adr6_src
                        RETURNING VALUE(et_message) TYPE bapiret2_t.

  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS: set_return_message IMPORTING iv_type            TYPE bapi_mtype
                                          iv_id              TYPE symsgid
                                          iv_number          TYPE symsgno
                                          iv_message_v1      TYPE symsgv OPTIONAL
                                          iv_message_v2      TYPE symsgv OPTIONAL
                                          iv_message_v3      TYPE symsgv OPTIONAL
                                          iv_message_v4      TYPE symsgv OPTIONAL
                                RETURNING VALUE(et_messages) TYPE bapiret2_t.

ENDCLASS.



CLASS zcl_con_bp_d530 IMPLEMENTATION.
  METHOD write_data.


    LOOP AT it_data ASSIGNING FIELD-SYMBOL(<ls_data>).
      IF  <ls_data>-source_system IS INITIAL OR
          <ls_data>-source_id IS INITIAL     OR
          <ls_data>-source_addrnumber IS INITIAL OR
          <ls_data>-date_from IS INITIAL OR
          <ls_data>-consnumber IS INITIAL .

        et_message =     set_return_message(
                           EXPORTING
                                iv_type       = 'E'
                                iv_id         = 'SD024'
                                iv_number     =  000
                                iv_message_v1 =  TEXT-001
                                ).
      ENDIF.

    ENDLOOP.

    MODIFY but_adr6_src FROM TABLE it_data.

    IF sy-subrc = 0.
      et_message =     set_return_message(
                          EXPORTING
                               iv_type       = 'I'
                               iv_id         = 'SD024'
                               iv_number     =  000
                               iv_message_v1 =  TEXT-002
                               ).

    ENDIF.



  ENDMETHOD.



  METHOD set_return_message.

    et_messages = VALUE #( BASE et_messages ( type = iv_type
                                              id = iv_id
                                              number = iv_number
                                              message_v1 = iv_message_v1
                                              message_v2 = iv_message_v2
                                              message_v3 = iv_message_v3
                                              message_v4 = iv_message_v4  ) ).

  ENDMETHOD.

ENDCLASS.
