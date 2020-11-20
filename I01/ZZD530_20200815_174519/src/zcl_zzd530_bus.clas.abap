class ZCL_ZZD530_BUS definition
  public .
  public section.
  methods: contructor,
           head_north.
  protected section.
  private section.
  data: navigation_device type ref to zif_zzd530_navigation_unit1.
ENDCLASS.



CLASS ZCL_ZZD530_BUS IMPLEMENTATION.

  METHOD CONTRUCTOR.
*  navigation_device = new zcl_zzd530_aquarious( ).
navigation_device = new zcl_zzd530_capricorn_adapter( ).
  ENDMETHOD.

  METHOD HEAD_NORTH.
 navigation_device->SET_HEADING( HEADING = zif_zzd530_navigation_unit1=>north ).
  ENDMETHOD.

ENDCLASS.
