CLASS zcl_sflight_connector DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_fpm_connector,
      if_fpm_connector_def,
      if_fpm_connector_run.
    CLASS-DATA: gv_fpm_connector_def TYPE fpm_model_namespace,
                GO_DAta              TYPE REF TO zcl_sflight_container.
    CLASS-METHODS class_constructor.
    DATA: if_fpm_connector_def_str    TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_sflight_connector IMPLEMENTATION.
  METHOD class_constructor.
    if_fpm_connector_def~sv_namespace = 'sflight'.
  ENDMETHOD.

  METHOD if_fpm_connector_run~create_entity.

  ENDMETHOD.

  METHOD if_fpm_connector_run~get_output.
   ro_output = go_data.
  ENDMETHOD.

  METHOD if_fpm_connector_def~get_parameter_list.

  ENDMETHOD.

  METHOD if_fpm_connector_def~get_parameter_value_set.

  ENDMETHOD.

  METHOD if_fpm_connector_def~initialize.

  ENDMETHOD.

  METHOD if_fpm_connector_run~is_create_allowed.

  ENDMETHOD.

  METHOD if_fpm_connector_def~set_input.
          go_data = CAST #( io_input ).
  ENDMETHOD.

ENDCLASS.
