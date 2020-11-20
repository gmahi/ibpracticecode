class ZCL_D530_PURCHASEORDER definition
  public
  .

  public section.
    methods:constructor importing
                          if_ebeln type ebeln,
      get_po_header
        returning value(rs_header)      type ekko
        raising  ZCX_D530_PURCHASEORDER.


  protected section.
  private section.
    data: f_ebeln type ebeln.
ENDCLASS.



CLASS ZCL_D530_PURCHASEORDER IMPLEMENTATION.
  METHOD CONSTRUCTOR.
    f_ebeln = if_ebeln.
  ENDMETHOD.



  METHOD GET_PO_HEADER.
    select single * from ekko into rs_header where ebeln = f_ebeln.
    if sy-subrc <> 0.
    raise exception type ZCX_D530_PURCHASEORDER
      EXPORTING
        TEXTID   = ZCX_D530_PURCHASEORDER=>INVALID_PURCHASE_ORDER
        EBELN    = f_ebeln
    .

    endif.
  ENDMETHOD.

ENDCLASS.
