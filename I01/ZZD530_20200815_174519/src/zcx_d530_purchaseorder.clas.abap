class ZCX_D530_PURCHASEORDER definition
  public
  inheriting from CX_STATIC_CHECK
  create public .

public section.

  interfaces IF_T100_DYN_MSG .
  interfaces IF_T100_MESSAGE .

  constants:
    begin of INVALID_PURCHASE_ORDER,
      msgid type symsgid value 'Z_D530_MSG',
      msgno type symsgno value '000',
      attr1 type scx_attrname value 'EBELN',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of INVALID_PURCHASE_ORDER .
  data EBELN type EBELN .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !EBELN type EBELN optional .
  protected section.
  private section.
ENDCLASS.



CLASS ZCX_D530_PURCHASEORDER IMPLEMENTATION.


  METHOD CONSTRUCTOR ##ADT_SUPPRESS_GENERATION.

    SUPER->CONSTRUCTOR( PREVIOUS = PREVIOUS ).

    ME->EBELN = EBELN.

    CLEAR ME->TEXTID.
    IF TEXTID IS INITIAL.
      IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
    ELSE.
      IF_T100_MESSAGE~T100KEY = TEXTID.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
