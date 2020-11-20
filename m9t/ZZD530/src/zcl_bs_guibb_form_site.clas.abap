CLASS zcl_bs_guibb_form_site DEFINITION
  PUBLIC
  INHERITING FROM cl_mdg_bs_guibb_form
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS if_fpm_guibb_form~process_event
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_bs_guibb_form_site IMPLEMENTATION.


  METHOD if_fpm_guibb_form~process_event.



    super->if_fpm_guibb_form~process_event(
      EXPORTING
        io_event            = io_event
        iv_raised_by_own_ui = iv_raised_by_own_ui
      IMPORTING
        ev_result           = ev_result
        et_messages         = et_messages
    ).





    IF io_event->mv_event_id = 'FPM_EDIT' AND mo_entity IS BOUND.

      mo_entity->if_bol_bo_property_access~set_property(
        EXPORTING
          iv_attr_name = 'COUNTRY'
          iv_value     =  'DE'
      ).

    ENDIF.






  ENDMETHOD.
ENDCLASS.
