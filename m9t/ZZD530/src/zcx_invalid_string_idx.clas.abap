CLASS zcx_invalid_string_idx DEFINITION
  PUBLIC
  INHERITING FROM cx_dynamic_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
 constants ZCX_INVALID_STRING_IDX type SOTR_CONC value 'DE2EB047CC992AF1BECE00238B646D5D'. "#EC NOTEXT
    INTERFACES if_t100_dyn_msg .
    INTERFACES if_t100_message .

    METHODS constructor
      IMPORTING
        !textid   like textid  OPTIONAL
        !previous LIKE previous OPTIONAL .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcx_invalid_string_idx IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
      textid = textid
        previous = previous.
    CLEAR me->textid.
    IF textid IS INITIAL.
     me->textid = zcx_invalid_string_idx.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
