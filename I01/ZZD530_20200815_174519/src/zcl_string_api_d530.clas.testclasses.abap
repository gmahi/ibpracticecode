*"* use this source file for your ABAP unit test classes
CLASS ltcl_string DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      equals_ignore_case_test FOR TESTING,
      trim     FOR TESTING,
      length FOR TESTING,
      get_char_at FOR TESTING,
      equals FOR TESTING,
      compare_to FOR TESTING,
      append FOR TESTING,
      split_at FOR TESTING,
      substring_raw FOR TESTING,
      substring FOR TESTING,
      convert_to_lower_case FOR TESTING,
      convert_to_upper_case FOR TESTING,
      as_lower_case FOR TESTING,
      as_upper_case FOR TESTING,
      starts_with FOR TESTING,
      ends_with FOR TESTING,
      contains_any FOR TESTING,
      contains_only FOR TESTING,
      contains_not_any FOR TESTING,
      contains_not_only FOR TESTING,
      get_first_index_of FOR TESTING,
      get_last_index_of FOR TESTING,
      matches FOR TESTING,
      replace_section FOR TESTING,
      replace_all FOR TESTING,
      replace_first FOR TESTING,
      create_from_int FOR TESTING,
      create_from_float FOR TESTING,
      create_from_packed FOR TESTING,
      find_patter FOR TESTING.




ENDCLASS.


CLASS ltcl_string IMPLEMENTATION.

  METHOD equals_ignore_case_test.
    DATA(lo_string) = NEW zcl_string_api_d530( im_value = 'Test Case1'  ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  =  lo_string->equals_ignore_case( io_string = NEW zcl_string_api_d530( im_value =  'Test CASE1') )  " Data object with current value
        exp                  =   abap_true  " Data object with expected type
        msg                  =  'Test Case Success'   " Description

    ).

    cl_abap_unit_assert=>assert_equals(
    EXPORTING
      act                  =  lo_string->equals_ignore_case( io_string = NEW zcl_string_api_d530( im_value =  'Test CASE2') )  " Data object with current value
      exp                  =   abap_false " Data object with expected type
      msg                  =  'Test Case Failure'   " Description

  ).

  ENDMETHOD.

  METHOD trim.
    DATA(lo_string) = NEW zcl_string_api_d530( '   Test Case1   ' ).
    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  =  lo_string->trim( )->get_value( )   " Data object with current value
        exp                  = 'Test Case1'    " Data object with expected type
        msg                  =  'Trim'    " Description
    ).

  ENDMETHOD.

  METHOD length.
    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  =   NEW zcl_string_api_d530( im_value = 'Test Case1' )->get_length( )
        exp                  =  10   " Data object with expected type
       msg                  = 'Length'

    ).
  ENDMETHOD.



  METHOD get_char_at.

    cl_abap_unit_assert=>assert_equals(
       EXPORTING
         act                  =   NEW zcl_string_api_d530( im_value = 'Test Case1' )->get_char_at( im_index =  3 )
         exp                  =  't'  " Data object with expected type
        msg                  = 'get_char_at'

     ).

  ENDMETHOD.

  METHOD equals.
    DATA(lo_string) = NEW zcl_string_api_d530( im_value = 'Test Case1'  ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  =  lo_string->equals( io_string = NEW zcl_string_api_d530( im_value =  'Test Case1') )  " Data object with current value
        exp                  =   abap_true  " Data object with expected type
        msg                  =  'Test Case Success'   " Description

    ).

    cl_abap_unit_assert=>assert_equals(
    EXPORTING
      act                  =  lo_string->equals( io_string = NEW zcl_string_api_d530( im_value =  'Test CASE1') )  " Data object with current value
      exp                  =   abap_false " Data object with expected type
      msg                  =  'Test Case Failure'   " Description

  ).


  ENDMETHOD.

  METHOD compare_to.
    DATA(lo_string) = NEW zcl_string_api_d530( im_value = 'BCDE' ).

    cl_abap_unit_assert=>assert_equals(
        EXPORTING
          act                  =  lo_string->compare_to( io_string = NEW zcl_string_api_d530( im_value =  'BCDE') )  " Data object with current value
          exp                  =   0  " Data object with expected type
          msg                  =  'Test Case Equal'   " Description

      ).

    cl_abap_unit_assert=>assert_equals(
     EXPORTING
       act                  =  lo_string->compare_to( io_string = NEW zcl_string_api_d530( im_value =  'ACDE') )  " Data object with current value
       exp                  =   1  " Data object with expected type
       msg                  =  'Test Case less than'   " Description

   ).

    cl_abap_unit_assert=>assert_equals(
     EXPORTING
       act                  =  lo_string->compare_to( io_string = NEW zcl_string_api_d530( im_value =  'CDE') )  " Data object with current value
       exp                  =   -1  " Data object with expected type
       msg                  =  'Test Case greater than'   " Description

   ).


  ENDMETHOD.

  METHOD append.

    DATA(lo_string) = NEW zcl_string_api_d530( 'Test Case' ).
    lo_string->append( im_string = 'Append'  ) .

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  =   lo_string->get_value( )    " Data object with current value
        exp                  = 'Test CaseAppend'  " Data object with expected type
        msg                  =  'Append'    " Description
    ).



  ENDMETHOD.

  METHOD split_at.
    DATA(lo_string) = NEW zcl_string_api_d530( 'Test Case' ).

    cl_abap_unit_assert=>assert_equals(
       EXPORTING
         act                  =  lines( lo_string->split_at( im_delimiter = space ) )    " Data object with current value
         exp                  = 2  " Data object with expected type
         msg                  =  'Split at'    " Description
     ).

  ENDMETHOD.

  METHOD substring_raw.
    DATA(lo_string) = NEW zcl_string_api_d530( 'Test Case' ).

    cl_abap_unit_assert=>assert_equals(
       EXPORTING
         act                  =  lo_string->substring_raw(
                                     im_start_index = 1
                                     im_end_index   = 4
                                 )    " Data object with current value
         exp                  = 'Test'  " Data object with expected type
         msg                  =  'Substring_raw'    " Description
     ).

    cl_abap_unit_assert=>assert_equals(
         EXPORTING
           act                  =  lo_string->substring_raw(
                                       im_start_index = 1

                                   )    " Data object with current value
           exp                  =  'Test Case'  " Data object with expected type
           msg                  =  'Substring_raw'    " Description
       ).


  ENDMETHOD.

  METHOD substring.

    DATA(lo_string) = NEW zcl_string_api_d530( 'Test Case' ).

    cl_abap_unit_assert=>assert_equals(
       EXPORTING
         act                  =  lo_string->substring(
                                     im_start_index = 1
                                     im_end_index   = 4
                                 )->get_value( )    " Data object with current value
         exp                  = 'Test'  " Data object with expected type
         msg                  =  'Substring'    " Description
     ).


  ENDMETHOD.

  METHOD convert_to_lower_case.

    DATA(lo_string) = NEW zcl_string_api_d530( 'Test Case' ).
    lo_string->convert_to_lower_case( ).

    cl_abap_unit_assert=>assert_equals(
       EXPORTING
         act                  = lo_string->get_value( )  " Data object with current value
         exp                  = 'test case'   " Data object with expected type
         msg                  =  'convert_to_lower_case'    " Description
     ).


  ENDMETHOD.

  METHOD convert_to_upper_case.

    DATA(lo_string) = NEW zcl_string_api_d530( 'Test Case' ).
    lo_string->convert_to_upper_case( ).

    cl_abap_unit_assert=>assert_equals(
       EXPORTING
         act                  = lo_string->get_value( )  " Data object with current value
         exp                  = 'TEST CASE'   " Data object with expected type
         msg                  =  'convert_to_upper_case'    " Description
     ).


  ENDMETHOD.

  METHOD as_lower_case.

    DATA(lo_string) = NEW zcl_string_api_d530( 'Test Case' ).

    cl_abap_unit_assert=>assert_equals(
       EXPORTING
         act                  = lo_string->as_lower_case( )->get_value( )  " Data object with current value
         exp                  = 'test case'   " Data object with expected type
         msg                  =  'as_lower_case'    " Description
     ).


  ENDMETHOD.

  METHOD as_upper_case.
    DATA(lo_string) = NEW zcl_string_api_d530( 'Test Case' ).

    cl_abap_unit_assert=>assert_equals(
       EXPORTING
         act                  = lo_string->as_upper_case( )->get_value( )  " Data object with current value
         exp                  = 'TEST CASE'  " Data object with expected type
         msg                  =  'as_upper_case'    " Description
     ).

  ENDMETHOD.

  METHOD starts_with.

    DATA(lo_string) = NEW zcl_string_api_d530( 'Test Case' ).

    cl_abap_unit_assert=>assert_equals(
       EXPORTING
         act                  = lo_string->starts_with(
                                    im_pattern     = 'Te'
*                                    im_ignore_case = ABAP_FALSE
                                ) " Data object with current value
         exp                  = abap_true  " Data object with expected type
         msg                  =  'starts_with'    " Description
     ).

  ENDMETHOD.

  METHOD ends_with.

    DATA(lo_string) = NEW zcl_string_api_d530( 'Test Case' ).
    cl_abap_unit_assert=>assert_equals(
       EXPORTING
         act                  = lo_string->ends_with(
                                    im_pattern     = 'se'
*                                    im_ignore_case = ABAP_FALSE
                                ) " Data object with current value
         exp                  = abap_true  " Data object with expected type
         msg                  =  'ends_with'    " Description
     ).


  ENDMETHOD.

  METHOD contains_any.

    DATA(lo_string) = NEW zcl_string_api_d530( 'Test Case' ).
    cl_abap_unit_assert=>assert_equals(
       EXPORTING
         act                  = lo_string->contains_any(
                                    im_pattern     = 'ce'
*                                    im_ignore_case = ABAP_FALSE
                                ) " Data object with current value
         exp                  = abap_true  " Data object with expected type
         msg                  =  'contains_any'    " Description
     ).

    cl_abap_unit_assert=>assert_equals(
         EXPORTING
           act                  = lo_string->contains_any(
                                      im_pattern     = 'zf'
*                                    im_ignore_case = ABAP_FALSE
                                  ) " Data object with current value
           exp                  = abap_false  " Data object with expected type
           msg                  =  'contains_any'    " Description
       ).



  ENDMETHOD.

  METHOD contains_only.

    DATA(lo_string) = NEW zcl_string_api_d530( 'Test' ).
    cl_abap_unit_assert=>assert_equals(
       EXPORTING
         act                  = lo_string->contains_only(
                                    im_pattern     = 'Test'
*                                    im_ignore_case = ABAP_FALSE
                                ) " Data object with current value
         exp                  = abap_true  " Data object with expected type
         msg                  =  'contains_only'    " Description
     ).

    cl_abap_unit_assert=>assert_equals(
         EXPORTING
           act                  = lo_string->contains_only(
                                      im_pattern     = 'Ca'
*                                    im_ignore_case = ABAP_FALSE
                                  ) " Data object with current value
           exp                  = abap_false  " Data object with expected type
           msg                  =  'contains_only'    " Description
       ).



  ENDMETHOD.

  METHOD contains_not_any.

    DATA(lo_string) = NEW zcl_string_api_d530( 'Test Case' ).
    cl_abap_unit_assert=>assert_equals(
       EXPORTING
         act                  = lo_string->contains_not_any(
                                    im_pattern     = 'zf'
*                                    im_ignore_case = ABAP_FALSE
                                ) " Data object with current value
         exp                  = abap_true  " Data object with expected type
         msg                  =  'contains_not_any'    " Description
     ).

    cl_abap_unit_assert=>assert_equals(
         EXPORTING
           act                  = lo_string->contains_not_any(
                                      im_pattern     = 'Ca'
*                                    im_ignore_case = ABAP_FALSE
                                  ) " Data object with current value
           exp                  = abap_false  " Data object with expected type
           msg                  =  'contains_not_any'    " Description
       ).


  ENDMETHOD.

  METHOD contains_not_only.

    DATA(lo_string) = NEW zcl_string_api_d530( 'Test CaseB' ).
    cl_abap_unit_assert=>assert_equals(
       EXPORTING
         act                  = lo_string->contains_not_only(
                                    im_pattern     = 'Test Case'
*                                    im_ignore_case = ABAP_FALSE
                                ) " Data object with current value
         exp                  = abap_true  " Data object with expected type
         msg                  =  'contains_not_only'    " Description
     ).

    cl_abap_unit_assert=>assert_equals(
         EXPORTING
           act                  = lo_string->contains_not_only(
                                      im_pattern     = 'Test CaseB'
*                                    im_ignore_case = ABAP_FALSE
                                  ) " Data object with current value
           exp                  = abap_false  " Data object with expected type
           msg                  =  'contains_not_only'    " Description
       ).

  ENDMETHOD.

  METHOD find_patter.

    DATA(lo_string) = NEW zcl_string_api_d530( 'Test Case' ).

    cl_abap_unit_assert=>assert_equals(
       EXPORTING
         act                  = lines( lo_string->find_pattern(
                                    im_pattern              = 'Test'
*                                      im_is_regex             = ABAP_FALSE
*                                      im_ignore_case          = ABAP_FALSE
                                )
*                                    CATCH cx_sy_regex.  "
*                                    CATCH cx_sy_regex_too_complex.  "


          )
         exp                  = 1  " Data object with expected type
         msg                  =  'contains_not_only'    " Description
     ).


  ENDMETHOD.

  METHOD get_first_index_of.
    DATA(lo_string) = NEW zcl_string_api_d530( 'Test Case' ).
    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  =  lo_string->get_first_index_of(
                                    im_pattern              = 'Case'
*                                   im_is_regex             = ABAP_FALSE
*                                   im_ignore_case          = ABAP_FALSE
                                )
*                                 CATCH cx_sy_regex.  "
*                                 CATCH cx_sy_regex_too_complex.  "    " Data object with current value
        exp                  =  6   " Data object with expected type
       msg                  =  'Get first index of'

    ).


  ENDMETHOD.

  METHOD get_last_index_of.

    DATA(lo_string) = NEW zcl_string_api_d530( 'Test Case Case' ).
    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  =  lo_string->get_last_index_of(
                                    im_pattern              = 'Case'
*                                   im_is_regex             = ABAP_FALSE
*                                   im_ignore_case          = ABAP_FALSE
                                )
*                                 CATCH cx_sy_regex.  "
*                                 CATCH cx_sy_regex_too_complex.  "    " Data object with current value
        exp                  =  11   " Data object with expected type
       msg                  =  'Get last index of'

    ).

  ENDMETHOD.

  METHOD matches.
    DATA(lo_string) = NEW zcl_string_api_d530( 'Test Case' ).

    cl_abap_unit_assert=>assert_equals(
          EXPORTING
            act                  = lo_string->matches(
                                       im_pattern     = 'Test Case'
*                                    im_ignore_case = ABAP_FALSE
                                   ) " Data object with current value
            exp                  = abap_true  " Data object with expected type
            msg                  =  'matches'    " Description
        ).

    cl_abap_unit_assert=>assert_equals(
       EXPORTING
         act                  = lo_string->matches(
                                    im_pattern     = 'Cass'
*                                    im_ignore_case = ABAP_FALSE
                                ) " Data object with current value
         exp                  = abap_false  " Data object with expected type
         msg                  =  'matches'    " Description
     ).



  ENDMETHOD.

  METHOD replace_section.

    DATA(lo_string) = NEW zcl_string_api_d530( 'Test Case Case' ).

    cl_abap_unit_assert=>assert_equals(
          EXPORTING
            act                  = lo_string->replace_section(
                                       im_offset      = 5
                                       im_length      = 5
                                       im_replacement = 'match'
                                   )->get_value( )
            exp                  = 'Test matchCase'  " Data object with expected type
            msg                  =  'replace_section'    " Description
        ).

  ENDMETHOD.

  METHOD replace_all.

    DATA(lo_string) = NEW zcl_string_api_d530( 'Test Case Case' ).

    cl_abap_unit_assert=>assert_equals(
          EXPORTING
            act                  = lo_string->replace_all(
                                       im_pattern              = 'Case'
*                                       im_is_regex             = ABAP_FALSE
*                                       im_ignore_case          = ABAP_FALSE
                                       im_replacement          = 'match'
                                   )->get_value( )
*                                     CATCH cx_sy_regex_too_complex.  "
            exp                  = 'Test match match'   " Data object with expected type
            msg                  =  'replace_all'    " Description
        ).

  ENDMETHOD.

  METHOD replace_first.

    DATA(lo_string) = NEW zcl_string_api_d530( 'Test Case Case' ).

    cl_abap_unit_assert=>assert_equals(
          EXPORTING
            act                  = lo_string->replace_first(
                                       im_pattern              = 'Case'
*                                       im_is_regex             = ABAP_FALSE
*                                       im_ignore_case          = ABAP_FALSE
                                       im_replacement          = 'match'
                                   )->get_value( )
*                                     CATCH cx_sy_regex_too_complex.  "
            exp                  = 'Test match Case'   " Data object with expected type
            msg                  =  'replace_first'    " Description
        ).

  ENDMETHOD.



  METHOD create_from_int.

    DATA(lo_string) = zcl_string_api_d530=>create_from_int( im_int_value = 123456 ).

    cl_abap_unit_assert=>assert_equals(
          EXPORTING
            act                  = lo_string->get_value( )

            exp                  = 123456   " Data object with expected type
            msg                  =  'create_from_int'    " Description
        ).

  ENDMETHOD.

  METHOD create_from_float.


    DATA(lo_string) = zcl_string_api_d530=>create_from_float( im_flo_value = '123456.76688' ).

    cl_abap_unit_assert=>assert_equals(
          EXPORTING
            act                  = lo_string->get_value( )

            exp                  = '1.2345676688000000E+05'  "
            msg                  =  'create_from_int'    " Description
        ).


  ENDMETHOD.

  METHOD create_from_packed.

DATA: lv_packed TYPE p DECIMALS 4 VALUE '12345.50'.
  DATA(lo_string) = zcl_string_api_d530=>create_from_packed( im_packed_value = '12345.50' ).

    cl_abap_unit_assert=>assert_equals(
          EXPORTING
            act                  = lo_string->get_value( )

            exp                  = lv_packed "
            msg                  =  'create_from_packed'    " Description
        ).

  ENDMETHOD.

ENDCLASS.
