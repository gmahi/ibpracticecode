*&---------------------------------------------------------------------*
*& Report zz_r_zzd530_brose
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zz_r_zzd530_brose.


SELECT SINGLE * FROM vekp INTO  @data(ls_vekp).
 DATA(descriptor) = CAST CL_ABAP_STRUCTDESCR( CL_ABAP_DATADESCR=>DESCRIBE_BY_DATA( LS_VEKP ) ).
 FIELD-SYMBOLS: <ls_fieldvalue> TYPE any.
LOOP AT  DESCRIPTOR->COMPONENTS into data(ls_component).
     ASSIGN COMPONENT ls_component-NAME OF STRUCTURE LS_VEKP TO <LS_FIELDVALUE>.
   WRITE: / ls_component-NAME, <LS_FIELDVALUE>  .

ENDLOOP.
*interface lif_output.
*  methods: write.
*
*endinterface.
*
*class lcl_pdf definition create public.
*
*  public section.
*    interfaces: lif_output.
*    aliases: write for lif_output~write.
*  protected section.
*  private section.
*
*endclass.
*
*class lcl_pdf implementation.
*
*  method write.
*    write: 'PDF'.
*  endmethod.
*
*endclass.
*
*class lcl_text definition create public.
*
*  public section.
*    interfaces: lif_output.
*    aliases: write for lif_output~write.
*  protected section.
*  private section.
*
*endclass.
*
*class lcl_text implementation.
*
*  method write.
*    write: 'TEXT'.
*  endmethod.
*
*endclass.
*class lcl_factory definition create private.
*
*  public section.
*    class-methods: get_instance importing output_type      TYPE kschl
*                                returning value(ro_output) type ref to lif_output.
*  protected section.
*  private section.
*
*endclass.
*
*class lcl_factory implementation.
*
*  method get_instance.
*    case output_type.
*      when 'PDF'.
*        ro_output = new LCL_PDF( ).
*      when 'TEXT'.
*        ro_output = new lcl_text( ).
*
*    endcase.
*
*  endmethod.
*
*endclass.
*
*start-of-selection.
*
*data(lo_pdf) = lcl_factory=>GET_INSTANCE( 'PDF' ).
*data(lo_text) = lcl_factory=>GET_INSTANCE( 'TEXT' ).
*
*lo_pdf->WRITE( ).
*lo_text->WRITE( ).
