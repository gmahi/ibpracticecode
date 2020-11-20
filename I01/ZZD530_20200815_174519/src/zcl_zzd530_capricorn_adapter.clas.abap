*clss scope with inheritance
*class ZCL_ZZD530_CAPRICORN_ADAPTER definition inheriting from zcl_zzd530_capricorn

class ZCL_ZZD530_CAPRICORN_ADAPTER definition
  public.
  public section.
    interfaces: zif_zzd530_navigation_unit1.
    aliases    : get_heading for ZIF_ZZD530_NAVIGATION_UNIT1~GET_HEADING,
                set_heading  for ZIF_ZZD530_NAVIGATION_UNIT1~SET_HEADING.
*object scope
    methods constructor.
*  object scope  end
  protected section.
  private section.
    constants: bearing_north type zcl_zzd530_capricorn=>degrees value 000,
               bearing_east  type zcl_zzd530_capricorn=>degrees value 090,
               bearing_south type zcl_zzd530_capricorn=>degrees value 180,
               bearing_west  type zcl_zzd530_capricorn=>degrees value 270.
    data: heading type zif_zzd530_navigation_unit1=>compass_point,
          capricorn_unit type ref to zcl_zzd530_capricorn.
ENDCLASS.



CLASS ZCL_ZZD530_CAPRICORN_ADAPTER IMPLEMENTATION.

method CONSTRUCTOR.
  capricorn_unit = new ZCL_ZZD530_CAPRICORN( ).

endmethod.


  METHOD GET_HEADING.
    capricorn_unit->GET_BEARING(
      IMPORTING
        BEARING = data(bearing)
    ).
    case bearing.
      when bearing_north.
        heading =  ZIF_ZZD530_NAVIGATION_UNIT1=>north.
      when bearing_east.
        heading =  ZIF_ZZD530_NAVIGATION_UNIT1=>east.
      when bearing_south.
        heading =  ZIF_ZZD530_NAVIGATION_UNIT1=>south.
      when bearing_west.
        heading =  ZIF_ZZD530_NAVIGATION_UNIT1=>west.
    endcase.

  ENDMETHOD.

  METHOD SET_HEADING.
    data: bearing type ZCL_ZZD530_CAPRICORN=>degrees.
    case heading.
      when ZIF_ZZD530_NAVIGATION_UNIT1=>north.
        bearing = ZIF_ZZD530_NAVIGATION_UNIT1=>north.
      when ZIF_ZZD530_NAVIGATION_UNIT1=>east.
        bearing = ZIF_ZZD530_NAVIGATION_UNIT1=>east.
      when ZIF_ZZD530_NAVIGATION_UNIT1=>south.
        bearing = ZIF_ZZD530_NAVIGATION_UNIT1=>south.
      when ZIF_ZZD530_NAVIGATION_UNIT1=>west.
        bearing = ZIF_ZZD530_NAVIGATION_UNIT1=>west.
    endcase.

   capricorn_unit->SET_BEARING( BEARING = bearing ).

  ENDMETHOD.

ENDCLASS.
