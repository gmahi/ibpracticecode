class ZCL_ZZD530_AQUARIOUS definition
  public .

  public section.
  interfaces: zif_zzd530_navigation_unit1.
  aliases    : get_heading for ZIF_ZZD530_NAVIGATION_UNIT1~GET_HEADING,
              set_heading  for ZIF_ZZD530_NAVIGATION_UNIT1~SET_HEADING.
  protected section.
  private section.
  data: heading type zif_zzd530_navigation_unit1=>compass_point.
ENDCLASS.



CLASS ZCL_ZZD530_AQUARIOUS IMPLEMENTATION.


  METHOD GET_HEADING.
   heading = me->heading.
  ENDMETHOD.

  METHOD SET_HEADING.
   me->heading = heading.
  ENDMETHOD.

ENDCLASS.
