"!@testing Z_I_PURCHDOCOVERALLPRICE_UM
CLASS ltc_Z_I_PURCHDOCOVERALLPRICE_U
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
      act_results                   TYPE STANDARD TABLE OF z_i_purchdocoverallprice_um WITH EMPTY KEY,
      lt_z_i_purchasedocument_um    TYPE STANDARD TABLE OF z_i_purchasedocument_um WITH EMPTY KEY,
      lt_z_i_purchasedocumentitem_u TYPE STANDARD TABLE OF z_i_purchasedocumentitem_um WITH EMPTY KEY.

    METHODS:
      "! SETUP method creates a common start state for each test method,
      "! clear_doubles clears the test data for all the doubles used in the test method before each test method execution.
      setup RAISING cx_static_check,
      prepare_testdata_set_no_items,
      prepare_testdata_set,
      "!  In this method test data is inserted into the generated double(s) and the test is executed and
      "!  the results should be asserted with the actuals.
      overall_price_no_items FOR TESTING RAISING cx_static_check,
      overall_price FOR TESTING RAISING cx_static_check.

ENDCLASS.


CLASS ltc_Z_I_PURCHDOCOVERALLPRICE_U IMPLEMENTATION.

  METHOD class_setup.
    environment = cl_cds_test_environment=>create( i_for_entity = 'Z_I_PURCHDOCOVERALLPRICE_UM' ).
  ENDMETHOD.

  METHOD setup.
    environment->clear_doubles( ).
  ENDMETHOD.

  METHOD class_teardown.
    environment->destroy( ).
  ENDMETHOD.

  METHOD overall_price_no_items.
    prepare_testdata_set_no_items( ).
    SELECT * FROM z_i_purchdocoverallprice_um INTO TABLE @act_results.
    cl_abap_unit_assert=>assert_equals( exp = 0 act = act_results[ 1 ]-OverallPrice ).
  ENDMETHOD.

  METHOD overall_price.
    prepare_testdata_set(  ).
    SELECT * FROM z_i_purchdocoverallprice_um INTO TABLE @act_results.
    cl_abap_unit_assert=>assert_equals( exp = 20 act = act_results[ 1 ]-OverallPrice ).
  ENDMETHOD.

  METHOD prepare_testdata_set_no_items.

    "Prepare test data for 'z_i_purchasedocument_um'
    lt_z_i_purchasedocument_um = VALUE #(
      (
        pruchasedocument = '1'
        description = 'Doc with no Items'
      ) ).
    environment->insert_test_data( i_data =  lt_z_i_purchasedocument_um ).

    "Prepare test data for 'z_i_purchasedocumentitem_um'
    "TODO: Provide the test data here
    lt_z_i_purchasedocumentitem_u = VALUE #(


      ).
    environment->insert_test_data( i_data =  lt_z_i_purchasedocumentitem_u ).

  ENDMETHOD.

    METHOD prepare_testdata_set.

    "Prepare test data for 'z_i_purchasedocument_um'
    lt_z_i_purchasedocument_um = VALUE #(
      (
        pruchasedocument = '1'
        description = 'Doc with no Items'
      ) ).
    environment->insert_test_data( i_data =  lt_z_i_purchasedocument_um ).

    "Prepare test data for 'z_i_purchasedocumentitem_um'
    "TODO: Provide the test data here
    lt_z_i_purchasedocumentitem_u = VALUE #(
      ( PurchaseDocument = '1' PurchaseDocumentItem = '1' OverallItemPrice = '10'
      )
       ( PurchaseDocument = '1' PurchaseDocumentItem = '1' OverallItemPrice = '10'
      )

      ).
    environment->insert_test_data( i_data =  lt_z_i_purchasedocumentitem_u ).

  ENDMETHOD.

ENDCLASS.
