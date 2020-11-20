*&---------------------------------------------------------------------*
*& Report zsample_reduce
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsample_reduce.
CLASS lcl_reduce_demo DEFINITION CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-METHODS demo.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_reduce_demo IMPLEMENTATION.

  METHOD demo.
    TYPES: BEGIN OF ty_ekpo,
             ebeln TYPE ekpo-ebeln,
             ebelp TYPE ekpo-ebelp,
             netwr TYPE ekpo-netwr,
           END OF ty_ekpo,
           tt_ekpo TYPE SORTED TABLE OF ty_ekpo
                          WITH UNIQUE KEY ebeln ebelp,
           BEGIN OF ty_komv,
             knumv TYPE komv-knumv,
             kposn TYPE komv-kposn,
             kschl TYPE komv-kschl,
             kwert TYPE komv-kwert,
           END OF ty_komv,
           tt_komv TYPE SORTED TABLE OF ty_komv
                                    WITH NON-UNIQUE KEY knumv kposn kschl
                                    WITH NON-UNIQUE SORTED KEY key_kposn COMPONENTS kposn kschl.

    DATA: it_ekpo TYPE tt_ekpo,
          it_komv TYPE tt_komv.


    it_ekpo =
         VALUE #(
           ( ebeln = '0040000000' ebelp = '10'  )
           ( ebeln = '0040000000' ebelp = '20'  )
           ( ebeln = '0040000000' ebelp = '30'  )
                 ).

    it_komv =
      VALUE #(
        ( knumv = '0000000001' kposn = '10' kschl = 'RA01' kwert = '10.00'  )
        ( knumv = '0000000001' kposn = '10' kschl = 'PBXX' kwert = '350.00' )
        ( knumv = '0000000001' kposn = '20' kschl = 'RA01' kwert = '2.00'   )
        ( knumv = '0000000001' kposn = '20' kschl = 'RA01' kwert = '3.50'   )
        ( knumv = '0000000001' kposn = '20' kschl = 'PBXX' kwert = '400.00' )
        ( knumv = '0000000001' kposn = '10' kschl = 'RA01' kwert = '5.00'   )
        ( knumv = '0000000001' kposn = '10' kschl = 'PBXX' kwert = '200.00' )
              ).

    DATA(out) = cl_demo_output=>new( )->write_data( it_ekpo ).
    out->write_data( it_komv ).
**********************************************************************
* Using loop and work area
**********************************************************************
    LOOP AT it_ekpo INTO DATA(ls_ekpo).

      DATA(ls_ekpox) = ls_ekpo.

      AT NEW  ebelp.
        LOOP AT it_komv INTO DATA(ls_komv) USING KEY key_kposn
                                       WHERE kposn EQ ls_ekpo-ebelp.
          ls_ekpo-netwr = ls_ekpo-netwr + ls_komv-kwert.
        ENDLOOP.
        MODIFY it_ekpo FROM ls_ekpo TRANSPORTING netwr.
      ENDAT.

    ENDLOOP.

    out->write_text( 'Using LOOP and Work area:' ).

    out->write_data( it_ekpo ).

**********************************************************************
* Using reduce
**********************************************************************

    LOOP AT it_ekpo ASSIGNING FIELD-SYMBOL(<fs_ekpo>).

      <fs_ekpo>-netwr = REDUCE netwr( INIT val TYPE netwr
                            FOR wa IN
                            FILTER #( it_komv USING KEY key_kposn
                                 WHERE kposn  = CONV #( <fs_ekpo>-ebelp )
                               )
                            NEXT val = val +  wa-kwert ).

    ENDLOOP.


    out->write_text( 'Using REDUCE:' ).

    out->write_data( it_ekpo ).

**********************************************************************
* Using Group by
**********************************************************************

    LOOP AT it_komv ASSIGNING   FIELD-SYMBOL(<ls_komv>)
                         GROUP BY ( key = <ls_komv>-kposn )
                         ASSIGNING FIELD-SYMBOL(<group_key>).
      ASSIGN it_ekpo[ ebelp = CONV #( <group_key> ) ]   TO FIELD-SYMBOL(<ls_ekpo>) .
      <ls_ekpo>-netwr = 0.
      LOOP AT GROUP <group_key> ASSIGNING FIELD-SYMBOL(<member>).
        ADD <member>-kwert TO <ls_ekpo>-netwr.
      ENDLOOP.


    ENDLOOP.

  out->write_text( 'Using Group by:' ).

    out->write_data( it_ekpo )->display( ).



  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.
  lcl_reduce_demo=>demo(  ).
