*"* use this source file for your ABAP unit test classes
class ltcl_mdg_util definition final for testing
  duration short
  risk level harmless.

  private section.
    methods:
      get_matnr for testing .
endclass.


class ltcl_mdg_util implementation.

  method get_matnr.
   DATA(lo_mdg_util) = new zcl_mdg_util_api( iv_model = 'MM' ).

   cl_abap_unit_assert=>assert_equals(
     EXPORTING
       act                  = lo_mdg_util->get_matnr( iv_crequest =  834 )
       exp                  = 41
       msg                  = 'Get Matnr'


   ).

  endmethod.

endclass.
