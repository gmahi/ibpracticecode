interface ZIF_ZZD530_NAVIGATION_UNIT1
  public .
    types         :compass_point type char1.
  constants     :north         type compass_point value 'N',
                 south         type compass_point value 'S',
                 west          type compass_point value 'W',
                 east          type compass_point value 'E'.
 methods: get_heading
            exporting heading type compass_point,
          set_heading
            importing heading type compass_point.


endinterface.

