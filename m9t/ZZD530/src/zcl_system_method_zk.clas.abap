class ZCL_SYSTEM_METHOD_ZK definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_USMD_SSW_SYST_METHOD_CALLER .
protected section.
private section.
ENDCLASS.



CLASS ZCL_SYSTEM_METHOD_ZK IMPLEMENTATION.


METHOD if_usmd_ssw_syst_method_caller~call_system_method.
  CASE iv_service_name.
    WHEN 'ZS_SYSTEM_METHOD_ZK'.

      SELECT SINGLE * FROM zcds_creq_status_para( p_crequest = @iv_cr_number , p_langu = @sy-langu )
         INTO @DATA(ls_crequest).
      IF sy-subrc = 0.
        NEW zcl_zk_email(  )->send_email_requester(
    EXPORTING
      im_user     = ls_crequest-usmd_created_by
      im_crequest =  ls_crequest-usmd_crequest
                                        ).

      ENDIF.

  ENDCASE.
ENDMETHOD.
ENDCLASS.
