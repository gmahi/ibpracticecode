
*----------------------------------------------------------------------*
*       CLASS lcl_Mdg_Idm_Get_Lcl_Sys_Exampl DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_mdg_idm_get_lcl_sys_exampl DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
.
*?#<asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">
*?<asx:values>
*?<TESTCLASS_OPTIONS>
*?<TEST_CLASS>lcl_Mdg_Idm_Get_Lcl_Sys_Exampl
*?</TEST_CLASS>
*?<TEST_MEMBER>f_Cut
*?</TEST_MEMBER>
*?<OBJECT_UNDER_TEST>CL_MDG_IDM_GET_LCL_SYS_EXAMPLE
*?</OBJECT_UNDER_TEST>
*?<OBJECT_IS_LOCAL/>
*?<GENERATE_FIXTURE>X
*?</GENERATE_FIXTURE>
*?<GENERATE_CLASS_FIXTURE>X
*?</GENERATE_CLASS_FIXTURE>
*?<GENERATE_INVOCATION>X
*?</GENERATE_INVOCATION>
*?<GENERATE_ASSERT_EQUAL>X
*?</GENERATE_ASSERT_EQUAL>
*?</TESTCLASS_OPTIONS>
*?</asx:values>
*?</asx:abap>
  PRIVATE SECTION.
* ================
    DATA:
      f_cut TYPE REF TO cl_mdg_idm_get_lcl_sys_example.  "class under test

    CLASS-METHODS: class_setup.
    CLASS-METHODS: class_teardown.
    METHODS: setup.
    METHODS: teardown.
    METHODS: get_local_system FOR TESTING.
ENDCLASS.       "lcl_Mdg_Idm_Get_Lcl_Sys_Exampl


*----------------------------------------------------------------------*
*       CLASS lcl_Mdg_Idm_Get_Lcl_Sys_Exampl IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_mdg_idm_get_lcl_sys_exampl IMPLEMENTATION.
* ====================================================

  METHOD class_setup.

  ENDMETHOD.       "class_Setup


  METHOD class_teardown.

  ENDMETHOD.       "class_Teardown


  METHOD setup.
    CREATE OBJECT f_cut.
  ENDMETHOD.       "setup


  METHOD teardown.

  ENDMETHOD.       "teardown


  METHOD get_local_system.

    DATA:
      lv_local_system       TYPE sld_bskey,
      lv_own_logical_system TYPE logsys,
      ls_bs_tech            TYPE mdg_s_bus_sys_tech,
      lv_not_found          TYPE boole_d.

    CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
      IMPORTING
        own_logical_system = lv_own_logical_system
      EXCEPTIONS
        OTHERS             = 0.

    cl_mdg_bs_access_cust_data=>select_bs_data_for_logsys(
      EXPORTING
        iv_logsys = lv_own_logical_system
      IMPORTING
        es_bs_tech   = ls_bs_tech
        ev_not_found = lv_not_found ).

    CHECK lv_not_found IS INITIAL.

    f_cut->if_mdg_idm_get_lcl_system~get_local_system( IMPORTING ev_local_system = lv_local_system ).

    cl_abap_unit_assert=>assert_equals( act = lv_local_system  exp = ls_bs_tech-business_system ).

  ENDMETHOD.       "get_Local_System

ENDCLASS.       "lcl_Mdg_Idm_Get_Lcl_Sys_Exampl
