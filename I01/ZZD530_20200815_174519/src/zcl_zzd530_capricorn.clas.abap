class ZCL_ZZD530_CAPRICORN definition
  public
 .

  public section.
    types: degrees type n length 3.
    methods: get_bearing exporting bearing type degrees,
      set_bearing importing bearing type degrees.
  protected section.
  private section.
    data: bearing type degrees.
ENDCLASS.



CLASS ZCL_ZZD530_CAPRICORN IMPLEMENTATION.
  METHOD GET_BEARING.
    bearing =  me->bearing .

  ENDMETHOD.

  METHOD SET_BEARING.
    me->bearing = bearing.
  ENDMETHOD.

ENDCLASS.
