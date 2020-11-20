"!@testing Z_C_PURCHASEDOCUMENTLRP_UM
CLASS ltc_Z_C_PURCHASEDOCUMENTLRP_UM
DEFINITION FINAL FOR TESTING
DURATION SHORT
RISK LEVEL HARMLESS.
  PRIVATE SECTION.

    CLASS-DATA:
      environment TYPE REF TO if_cds_test_environment.

    CLASS-METHODS:
      "! In CLASS_SETUP, corresponding doubles and clone(s) for the CDS view under test and its dependencies are created.
      class_setup RAISING cx_static_check,
      "! In CLASS_TEARDOWN, Generated database entities (doubles & clones) should be deleted at the end of test class execution.
      class_teardown.

    DATA:
      act_results                   TYPE STANDARD TABLE OF z_c_purchasedocumentlrp_um WITH EMPTY KEY,
      lt_z_i_purchdocoverallprice_u TYPE STANDARD TABLE OF z_i_purchdocoverallprice_um WITH EMPTY KEY.

    METHODS:
      "! SETUP method creates a common start state for each test method,
      "! clear_doubles clears the test data for all the doubles used in the test method before each test method execution.
      setup RAISING cx_static_check,
      prepare_testdata_set IMPORTING iv_price TYPE float,
      "!  In this method test data is inserted into the generated double(s) and the test is executed and
      "!  the results should be asserted with the actuals.
      price_1k_medium_critical FOR TESTING RAISING cx_static_check,
      price_10001_critical FOR TESTING RAISING cx_static_check,
      price_10k_medium_critical FOR TESTING RAISING cx_static_check,
      price_0_not_critical FOR TESTING RAISING cx_static_check,
      price_no_approval_required FOR TESTING RAISING cx_static_check,
      price_approval_required FOR TESTING RAISING cx_static_check.

ENDCLASS.


CLASS ltc_Z_C_PURCHASEDOCUMENTLRP_UM IMPLEMENTATION.

  METHOD class_setup.
    environment = cl_cds_test_environment=>create( i_for_entity = 'Z_C_PURCHASEDOCUMENTLRP_UM' ).
  ENDMETHOD.

  METHOD setup.
    environment->clear_doubles( ).
  ENDMETHOD.

  METHOD class_teardown.
    environment->destroy( ).
  ENDMETHOD.

  METHOD price_1k_medium_critical.
    prepare_testdata_set( '1000').
    SELECT * FROM z_c_purchasedocumentlrp_um INTO TABLE @act_results.
    cl_abap_unit_assert=>assert_equals(  exp = 2  act = act_results[ 1 ]-OverallPriceCriticality  ).
  ENDMETHOD.

    METHOD price_10001_critical.
    prepare_testdata_set( '10001').
    SELECT * FROM z_c_purchasedocumentlrp_um INTO TABLE @act_results.
    cl_abap_unit_assert=>assert_equals(  exp = 1  act = act_results[ 1 ]-OverallPriceCriticality  ).
  ENDMETHOD.


   METHOD price_10K_medium_critical.
    prepare_testdata_set( '10000').
    SELECT * FROM z_c_purchasedocumentlrp_um INTO TABLE @act_results.
    cl_abap_unit_assert=>assert_equals(  exp = 2  act = act_results[ 1 ]-OverallPriceCriticality  ).
  ENDMETHOD.

     METHOD price_0_not_critical.
    prepare_testdata_set( '0').
    SELECT * FROM z_c_purchasedocumentlrp_um INTO TABLE @act_results.
    cl_abap_unit_assert=>assert_equals(  exp = 3  act = act_results[ 1 ]-OverallPriceCriticality  ).
  ENDMETHOD.
  METHOD price_no_approval_required.
    prepare_testdata_set( '100').
    SELECT * FROM z_c_purchasedocumentlrp_um INTO TABLE @act_results.
    cl_abap_unit_assert=>assert_equals(  exp = space  act = act_results[ 1 ]-IsApprovalRequired  ).
  ENDMETHOD.

    METHOD price_approval_required.
    prepare_testdata_set( '1001').
    SELECT * FROM z_c_purchasedocumentlrp_um INTO TABLE @act_results.
    cl_abap_unit_assert=>assert_equals(  exp = 'X' act = act_results[ 1 ]-IsApprovalRequired  ).
  ENDMETHOD.

  METHOD prepare_testdata_set.

    "Prepare test data for 'z_i_purchdocoverallprice_um'
    lt_z_i_purchdocoverallprice_u = VALUE #(
      (
        pruchasedocument = '1'
        overallprice = iv_price
      ) ).
    environment->insert_test_data( i_data =  lt_z_i_purchdocoverallprice_u ).

  ENDMETHOD.

ENDCLASS.
