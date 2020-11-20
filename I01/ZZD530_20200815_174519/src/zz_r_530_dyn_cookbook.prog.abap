*&---------------------------------------------------------------------*
*& Report zz_r_530_dyn_cookbook
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zz_r_530_dyn_cookbook.

*DATA: lv_name(10) TYPE c VALUE 'Sree Rama'.
*
*FIELD-SYMBOLS: <lfs> TYPE char4.
*
*ASSIGN lv_name+0(4) TO  <lfs>.
*WRITE:/ <lfs>.
*
*DATA: lv_field_name TYPE string VALUE 'LV_FIELD',
*      lv_field      TYPE i VALUE 50.
*FIELD-SYMBOLS: <lfs_i> TYPE i.
*ASSIGN (lv_field_name) TO <lfs_i>.
*WRITE: / <lfs_i>.

*DATA: lv_type TYPE c,
*      lv_components TYPE i.
*
*FIELD-SYMBOLS: <lfs_component> TYPE any.
*
*SELECT SINGLE * FROM sflight INTO @data(ls_flight) WHERE carrid = 'AA'.
*
*DESCRIBE FIELD ls_flight TYPE lv_type COMPONENTS lv_components.
*
*do lv_components TIMES.
*ASSIGN COMPONENT sy-index of STRUCTURE ls_flight to <lfs_component>.
*WRITE:/ 'Component valus is', <lfs_component>.
*
*ENDDO.
*
*WRITE:/ lv_type.

*DATA: gr_dref TYPE REF TO data.
*
*FIELD-SYMBOLS: <lfs_counter> TYPE any.
*
*START-OF-SELECTION.
*
*  IF gr_dref IS INITIAL.
*    WRITE:/ 'Not bound intially'.
*  ENDIF.
*  PERFORM some_procedure.
*
*  IF gr_dref IS INITIAL.
*    WRITE:/ 'Date reference is not bound'.
*  ELSE.
*    WRITE:/ 'Still bound'.
*  ENDIF.
*
*  ASSIGN gr_dref->* TO <lfs_counter>.
*  IF sy-subcs IS INITIAL.
*    WRITE:/ 'Counter is: ', <lfs_counter>.
*  ELSE.
*    WRITE:/ 'Where is my counter'.
*  ENDIF.
*
*FORM some_procedure.
*
*  DATA: lv_counter TYPE i VALUE 5.
*  GET REFERENCE OF lv_counter INTO gr_dref.
*
*
*  IF gr_dref IS NOT INITIAL.
*
*    WRITE:/ 'Dref is bound '.
*    ASSIGN gr_dref->* TO <lfs_counter>.
*    WRITE:/ 'Counter is ', <lfs_counter>.
*  ENDIF.
*
*ENDFORM..

DATA: lr_fname_ref TYPE REF TO DATA,
      lo_fname_type  TYPE REF TO cl_abap_elemdescr.

FIELD-SYMBOLS:
  <lfs_fname>  TYPE any.


  lo_fname_type ?= cl_abap_typedescr=>describe_by_name( p_name =  'AD_NAMEFIR')    .


  CREATE DATA lr_fname_ref TYPE HANDLE lo_fname_type.


  ASSIGN lr_fname_ref->* TO <lfs_fname> CASTING TYPE HANDLE lo_fname_type.


  <lfs_fname>  = ' Sree Rama'.

  WRITE:/ | First name is : { <lfs_fname> } |.
