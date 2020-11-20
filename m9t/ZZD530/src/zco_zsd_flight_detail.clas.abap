class ZCO_ZSD_FLIGHT_DETAIL definition
  public
  inheriting from CL_PROXY_CLIENT
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !LOGICAL_PORT_NAME type PRX_LOGICAL_PORT_NAME optional
    raising
      CX_AI_SYSTEM_FAULT .
  methods FLIGHT_GETDETAIL
    importing
      !INPUT type ZFLIGHT_GETDETAIL
    exporting
      !OUTPUT type ZFLIGHT_GETDETAIL_RESPONSE
    raising
      CX_AI_SYSTEM_FAULT .
protected section.
private section.
ENDCLASS.



CLASS ZCO_ZSD_FLIGHT_DETAIL IMPLEMENTATION.


  method CONSTRUCTOR.

  super->constructor(
    class_name          = 'ZCO_ZSD_FLIGHT_DETAIL'
    logical_port_name   = logical_port_name
  ).

  endmethod.


  method FLIGHT_GETDETAIL.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'FLIGHT_GETDETAIL'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.
ENDCLASS.
