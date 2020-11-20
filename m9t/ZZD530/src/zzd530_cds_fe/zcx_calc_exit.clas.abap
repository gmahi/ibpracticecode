CLASS zcx_calc_exit DEFINITION
  PUBLIC
  INHERITING FROM cx_sadl_exit
  FINAL
  CREATE PUBLIC .



  PUBLIC SECTION.
    CONSTANTS:
      BEGIN OF entity_not_known,
        msgid TYPE symsgid VALUE '<MY_MESSAGE_ID>',
        msgno TYPE symsgno VALUE '<MY_MESSAGE_NR>',
        attr1 TYPE scx_attrname VALUE '<ATTR1>',
        attr2 TYPE scx_attrname VALUE '<ATTR2>',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF entity_not_known.
    INTERFACES if_t100_dyn_msg .
    INTERFACES if_t100_message .

    METHODS constructor
      IMPORTING
        !textid   LIKE if_t100_message=>t100key OPTIONAL
        !previous LIKE previous OPTIONAL .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcx_calc_exit IMPLEMENTATION.
  METHOD constructor ##ADT_SUPPRESS_GENERATION.

    super->constructor( previous = previous ).
    CLEAR me->textid.

    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
