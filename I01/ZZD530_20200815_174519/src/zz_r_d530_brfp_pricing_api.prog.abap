*&---------------------------------------------------------------------*
*& Report zz_r_d530_brfp_pricing_api
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zz_r_d530_brfp_pricing_api.




DATA: lo_factory     TYPE REF TO if_fdt_factory,
      lo_application TYPE REF TO if_fdt_application,
      lt_messages    TYPE  if_fdt_types=>t_message,
      lv_boolean     TYPE abap_bool.

FIELD-SYMBOLS: <ls_message> TYPE if_fdt_types=>s_message.


DEFINE write_errors.
  IF &1 IS NOT INITIAL.
  LOOP AT &1 ASSIGNING <ls_message>.
  WRITE: <ls_message>-text.
  ENDLOOP.
  RETURN.
  ENDIF.
END-OF-DEFINITION.
lo
lo_factory = cl_fdt_factory=>if_fdt_factory~get_instance( ).
lo_application = lo_factory->get_application( ).
lo_application->if_fdt_transaction~enqueue( ).
lo_application->set_development_package('ZZD530').
lo_application->if_fdt_admin_data~set_name( iv_name =  'PRICING_API').
lo_application->if_fdt_admin_data~set_texts(
  EXPORTING
    iv_text          =   'Pricing app'  " Text (sy-langu)
    iv_short_text    =   'Pricing'  " Short Text (sy-langu)
).

lo_application->if_fdt_transaction~activate(

  IMPORTING
    et_message           =   lt_messages  " Messages
    ev_activation_failed =   lv_boolean  " ABAP_TRUE: activation not successful
*    EV_ACTIVE_VERSION    =     " Active version
).
write_errors lt_messages.

lo_application->if_fdt_transaction~save( ).
lo_application->if_fdt_transaction~dequeue( ).
lo_factory = cl_fdt_factory=>if_fdt_factory~get_instance(
iv_application_id = lo_application->mv_id
 ).
