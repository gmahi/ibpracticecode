class ZCL_MDG_IDM_GET_LCL_SYS definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_MDG_IDM_GET_LCL_SYSTEM .
protected section.
private section.
ENDCLASS.



CLASS ZCL_MDG_IDM_GET_LCL_SYS IMPLEMENTATION.


METHOD IF_MDG_IDM_GET_LCL_SYSTEM~GET_LOCAL_SYSTEM.
*! This method determines the local business system via the ALE logical system assigned to it.
* If no business system is maintained, it returns an empty value.

  DATA:
    lv_own_logical_system TYPE logsys,
    ls_bs_tech            TYPE mdg_s_bus_sys_tech,
    lv_not_found          TYPE boole_d.

  CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
    IMPORTING
      own_logical_system             = lv_own_logical_system
    EXCEPTIONS
      own_logical_system_not_defined = 1
      OTHERS                         = 2.

  cl_mdg_bs_access_cust_data=>select_bs_data_for_logsys(
    EXPORTING
      iv_logsys = lv_own_logical_system
    IMPORTING
      es_bs_tech   = ls_bs_tech
      ev_not_found = lv_not_found ).

  IF lv_not_found = abap_false.
    ev_local_system = ls_bs_tech-business_system.
  ENDIF.

ENDMETHOD.
ENDCLASS.
