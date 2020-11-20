CLASS zcl_string_api_d530 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.



    "! <p class="shorttext synchronized" lang="en"></p>
    "! Constructor
    "! @parameter im_value | type string <p class="shorttext synchronized" lang="en"></p>
    METHODS constructor IMPORTING im_value TYPE clike.

    "! <p class="shorttext synchronized" lang="en"></p>
    "! This methods checks string equality by ignoring the case
    "! @parameter im_string | importing TYPE zcl_string_api_d530 <p class="shorttext synchronized" lang="en"></p>
    "! @parameter re_result | RETURNING TYPE ABAP_BOOL <p class="shorttext synchronized" lang="en"></p>
    METHODS equals_ignore_case IMPORTING io_string        TYPE REF TO zcl_string_api_d530
                               RETURNING VALUE(re_result) TYPE abap_bool.

    "! <p class="shorttext synchronized" lang="en"></p>
    "! This methods removes leading/trailing whitespace from the string
    "! @parameter ro_string | TYPE zcl_d530_string <p class="shorttext synchronized" lang="en"></p>
    METHODS trim RETURNING VALUE(ro_string) TYPE REF TO zcl_string_api_d530.

    "! <p class="shorttext synchronized" lang="en"></p>
    "! Return String value
    "! @parameter re_string | type String<p class="shorttext synchronized" lang="en"></p>
    METHODS get_value RETURNING VALUE(re_string) TYPE string.

    "! <p class="shorttext synchronized" lang="en"></p>
    "! Returns String length
    "! @parameter re_length | type I <p class="shorttext synchronized" lang="en"></p>
    METHODS get_length RETURNING VALUE(re_length) TYPE i.

    "! <p class="shorttext synchronized" lang="en"></p>
    "! Return character at given index
    "! @parameter im_index | type i<p class="shorttext synchronized" lang="en"></p>
    "! @parameter re_char | type char1<p class="shorttext synchronized" lang="en"></p>
    METHODS get_char_at IMPORTING im_index       TYPE i
                        RETURNING VALUE(re_char) TYPE char1.

    "! <p class="shorttext synchronized" lang="en"></p>
    "! This methods checks string equality
    "! @parameter im_string | importing TYPE zcl_string_api_d530 <p class="shorttext synchronized" lang="en"></p>
    "! @parameter re_result | RETURNING TYPE ABAP_BOOL <p class="shorttext synchronized" lang="en"></p>
    METHODS equals IMPORTING io_string        TYPE REF TO zcl_string_api_d530
                   RETURNING VALUE(re_result) TYPE abap_bool.

    "! <p class="shorttext synchronized" lang="en"></p>
    "!
    "! @parameter io_string | importing TYPE zcl_string_api_d53 <p class="shorttext synchronized" lang="en"></p>
    "! @parameter iv_ignore_case | importing TYPE I if value x ignores the case <p class="shorttext synchronized" lang="en"></p>
    "! @parameter re_result | type  i  value 0 equal, -1 less than , 1 greater than  <p class="shorttext synchronized" lang="en"></p>
    METHODS compare_to IMPORTING io_string        TYPE  REF TO zcl_string_api_d530
                                 iv_ignore_case   TYPE abap_bool OPTIONAL
                       RETURNING VALUE(re_result) TYPE i.
    "! <p class="shorttext synchronized" lang="en"></p>
    "! Appends the provided string  at the end of the string
    "! @parameter io_string | importing TYPE zcl_string_api_d53<p class="shorttext synchronized" lang="en"></p>
    METHODS append IMPORTING im_string TYPE clike.

    "! <p class="shorttext synchronized" lang="en"></p>
    "! spilts string at given delimiter
    "! @parameter im_delimiter | importing type clike<p class="shorttext synchronized" lang="en"></p>
    "! @parameter rt_string | returning type string_table  <p class="shorttext synchronized" lang="en"></p>
    METHODS split_at IMPORTING im_delimiter     TYPE clike
                     RETURNING VALUE(rt_string) TYPE string_table.
    "! <p class="shorttext synchronized" lang="en"></p>
    "! Returns Substring of current string object
    "! @parameter im_start_index | importing type i <p class="shorttext synchronized" lang="en"></p>
    "! @parameter im_end_index | importing type i <p class="shorttext synchronized" lang="en"></p>
    "! @parameter ro_string | returns type zcl_string_api_d53<p class="shorttext synchronized" lang="en"></p>
    METHODS substring IMPORTING im_start_index   TYPE i
                                im_end_index     TYPE  i
                      RETURNING VALUE(ro_string) TYPE REF TO zcl_string_api_d530.

    "! <p class="shorttext synchronized" lang="en"></p>
    "! Returns Raw substring of current string object
    "! @parameter im_start_index | importing type i <p class="shorttext synchronized" lang="en"></p>
    "! @parameter im_end_index | importing type i <p class="shorttext synchronized" lang="en"></p>
    "! @parameter ro_string | returns type string<p class="shorttext synchronized" lang="en"></p>
    METHODS substring_raw IMPORTING im_start_index   TYPE i
                                    im_end_index     TYPE  i OPTIONAL
                          RETURNING VALUE(re_string) TYPE string.

    "! <p class="shorttext synchronized" lang="en"></p>
    "! Translate the currrent string to lower case
    METHODS convert_to_lower_case.
    "! <p class="shorttext synchronized" lang="en"></p>
    "! Translate the currrent string to Upper case
    METHODS convert_to_upper_case.
    "! <p class="shorttext synchronized" lang="en"></p>
    "! Returns copy of  string as lower case
    "! @parameter ro_string |YPE REF TO zcl_string_api_d530 <p class="shorttext synchronized" lang="en"></p>
    METHODS as_lower_case RETURNING VALUE(ro_string) TYPE REF TO zcl_string_api_d530.

    "! <p class="shorttext synchronized" lang="en"></p>
    "! Returns copy of  string as upper case
    "! @parameter ro_string |YPE REF TO zcl_string_api_d530 <p class="shorttext synchronized" lang="en"></p>
    METHODS as_upper_case RETURNING VALUE(ro_string) TYPE REF TO zcl_string_api_d530.

    "! <p class="shorttext synchronized" lang="en"></p>
    "! Determines if string begins with a character sequence
    "! @parameter im_pattern |importing type clike <p class="shorttext synchronized" lang="en"></p>
    "! @parameter im_ignore_case |importing  type abap_bool <p class="shorttext synchronized" lang="en"></p>
    "! @parameter re_result | returning type abap_bool<p class="shorttext synchronized" lang="en"></p>
    METHODS starts_with
      IMPORTING
        !im_pattern      TYPE clike
        !im_ignore_case  TYPE abap_bool DEFAULT abap_false
      RETURNING
        VALUE(re_result) TYPE abap_bool .

    "! <p class="shorttext synchronized" lang="en"></p>
    "! Determines if string ends with a character sequence
    "! @parameter im_pattern |importing type clike <p class="shorttext synchronized" lang="en"></p>
    "! @parameter im_ignore_case |importing  type abap_bool <p class="shorttext synchronized" lang="en"></p>
    "! @parameter re_result | returning type abap_bool<p class="shorttext synchronized" lang="en"></p>
    METHODS ends_with
      IMPORTING
        !im_pattern      TYPE clike
        !im_ignore_case  TYPE abap_bool DEFAULT abap_false
      RETURNING
        VALUE(re_result) TYPE abap_bool .

    "! <p class="shorttext synchronized" lang="en"></p>
    "! Checks if string containd any of the pattern
    "! @parameter IM_PATTERN | importing type clike  <p class="shorttext synchronized" lang="en"></p>
    "! @parameter RE_RESULT | importing type abap_bool   <p class="shorttext synchronized" lang="en"></p>
    METHODS contains_any
      IMPORTING
        !im_pattern      TYPE clike
      RETURNING
        VALUE(re_result) TYPE abap_bool .

    "! <p class="shorttext synchronized" lang="en"></p>
    "! Checks if string contains only of the pattern
    "! @parameter IM_PATTERN |importing type clike  <p class="shorttext synchronized" lang="en"></p>
    "! @parameter RE_RESULT | importing type abap_bool<p class="shorttext synchronized" lang="en"></p>
    METHODS contains_only
      IMPORTING
        !im_pattern      TYPE clike
      RETURNING
        VALUE(re_result) TYPE abap_bool .

    "! <p class="shorttext synchronized" lang="en"></p>
    "! Checks if string doesn't contains any of the pattern
    "! @parameter IM_PATTERN |importing type clike  <p class="shorttext synchronized" lang="en"></p>
    "! @parameter RE_RESULT | importing type abap_bool<p class="shorttext synchronized" lang="en"></p>
    METHODS contains_not_any
      IMPORTING
        !im_pattern      TYPE clike
      RETURNING
        VALUE(re_result) TYPE abap_bool .

    "! <p class="shorttext synchronized" lang="en"></p>
    "! Checks if string doesn't contains only  of the pattern
    "! @parameter IM_PATTERN |importing type clike  <p class="shorttext synchronized" lang="en"></p>
    "! @parameter RE_RESULT | importing type abap_bool<p class="shorttext synchronized" lang="en"></p>

    METHODS contains_not_only
      IMPORTING
        !im_pattern      TYPE clike
      RETURNING
        VALUE(re_result) TYPE abap_bool .

    "! <p class="shorttext synchronized" lang="en"></p>
    "!
    "! @parameter IM_PATTERN | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter IM_IS_REGEX | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter IM_IGNORE_CASE | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter RE_MATCHES | <p class="shorttext synchronized" lang="en"></p>
    "! @raising CX_SY_REGEX | <p class="shorttext synchronized" lang="en"></p>
    "! @raising CX_SY_REGEX_TOO_COMPLEX | <p class="shorttext synchronized" lang="en"></p>
    METHODS find_pattern
      IMPORTING
        !im_pattern       TYPE clike
        !im_is_regex      TYPE abap_bool DEFAULT abap_false
        !im_ignore_case   TYPE abap_bool DEFAULT abap_false
      RETURNING
        VALUE(re_matches) TYPE match_result_tab
      RAISING
        cx_sy_regex
        cx_sy_regex_too_complex .

    "! <p class="shorttext synchronized" lang="en"></p>
    "!
    "! @parameter im_pattern | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter im_is_regex | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter im_ignore_case | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter re_index | <p class="shorttext synchronized" lang="en"></p>
    "! @raising cx_sy_regex | <p class="shorttext synchronized" lang="en"></p>
    "! @raising cx_sy_regex_too_complex | <p class="shorttext synchronized" lang="en"></p>
    METHODS get_first_index_of
      IMPORTING
        !im_pattern     TYPE clike
        !im_is_regex    TYPE abap_bool DEFAULT abap_false
        !im_ignore_case TYPE abap_bool DEFAULT abap_false
      RETURNING
        VALUE(re_index) TYPE i
      RAISING
        cx_sy_regex
        cx_sy_regex_too_complex .

    "! <p class="shorttext synchronized" lang="en"></p>
    "!
    "! @parameter im_pattern | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter im_is_regex | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter im_ignore_case | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter re_index | <p class="shorttext synchronized" lang="en"></p>
    "! @raising cx_sy_regex | <p class="shorttext synchronized" lang="en"></p>
    "! @raising cx_sy_regex_too_complex | <p class="shorttext synchronized" lang="en"></p>
    METHODS get_last_index_of
      IMPORTING
        !im_pattern     TYPE clike
        !im_is_regex    TYPE abap_bool DEFAULT abap_false
        !im_ignore_case TYPE abap_bool DEFAULT abap_false
      RETURNING
        VALUE(re_index) TYPE i
      RAISING
        cx_sy_regex
        cx_sy_regex_too_complex .

    "! <p class="shorttext synchronized" lang="en"></p>
    "! Check if string matches Regex pattern
    "! @parameter IM_PATTERN | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter IM_IGNORE_CASE | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter RE_RESULT | <p class="shorttext synchronized" lang="en"></p>
    METHODS matches
      IMPORTING
        !im_pattern      TYPE clike
        !im_ignore_case  TYPE abap_bool DEFAULT abap_false
      RETURNING
        VALUE(re_result) TYPE abap_bool .

    "! <p class="shorttext synchronized" lang="en"></p>
    "!Replaces a pattern in section of a string
    "! @parameter IM_OFFSET | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter IM_LENGTH | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter IM_REPLACEMENT | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter RE_RESULT | <p class="shorttext synchronized" lang="en"></p>
    METHODS replace_section
      IMPORTING
        !im_offset       TYPE i
        !im_length       TYPE i
        !im_replacement  TYPE clike
      RETURNING
        VALUE(re_result) TYPE REF TO zcl_string_api_d530 .

    "! <p class="shorttext synchronized" lang="en"></p>
    "! Replaces all OCCURRENCES  a pattern in string
    "! @parameter im_pattern | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter im_is_regex | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter im_ignore_case | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter im_replacement | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter re_result | <p class="shorttext synchronized" lang="en"></p>
    "! @raising cx_sy_regex_too_complex | <p class="shorttext synchronized" lang="en"></p>
    METHODS replace_all
      IMPORTING
        !im_pattern      TYPE clike
        !im_is_regex     TYPE abap_bool DEFAULT abap_false
        !im_ignore_case  TYPE abap_bool DEFAULT abap_false
        !im_replacement  TYPE clike
      RETURNING
        VALUE(re_result) TYPE REF TO zcl_string_api_d530
      RAISING
        cx_sy_regex_too_complex .

    "! <p class="shorttext synchronized" lang="en"></p>
    "! Replace first occurrence of a pattern in string
    "! @parameter im_pattern | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter im_is_regex | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter im_ignore_case | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter im_replacement | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter re_result | <p class="shorttext synchronized" lang="en"></p>
    "! @raising cx_sy_regex_too_complex | <p class="shorttext synchronized" lang="en"></p>
    METHODS replace_first
      IMPORTING
        !im_pattern      TYPE clike
        !im_is_regex     TYPE abap_bool DEFAULT abap_false
        !im_ignore_case  TYPE abap_bool DEFAULT abap_false
        !im_replacement  TYPE clike
      RETURNING
        VALUE(re_result) TYPE REF TO zcl_string_api_d530
      RAISING
        cx_sy_regex_too_complex .

    "! <p class="shorttext synchronized" lang="en"></p>
    "! Create string instance from integer
    "! @parameter im_int_value | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter re_string | <p class="shorttext synchronized" lang="en"></p>
    CLASS-METHODS create_from_int
      IMPORTING
        !im_int_value    TYPE i
      RETURNING
        VALUE(re_string) TYPE REF TO zcl_string_api_d530 .

    "! <p class="shorttext synchronized" lang="en"></p>
    "! Create string instance from Float
    "! @parameter im_int_value | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter re_string | <p class="shorttext synchronized" lang="en"></p>
    CLASS-METHODS create_from_float
      IMPORTING
        !im_flo_value    TYPE f
      RETURNING
        VALUE(re_string) TYPE REF TO zcl_string_api_d530 .


    "! <p class="shorttext synchronized" lang="en"></p>
    "! Create string instance from packing number
    "! @parameter im_int_value | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter re_string | <p class="shorttext synchronized" lang="en"></p>
    CLASS-METHODS create_from_packed
      IMPORTING
        !im_packed_value TYPE p
      RETURNING
        VALUE(re_string) TYPE REF TO zcl_string_api_d530 .


  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: "! Internal string value
          value TYPE string.



ENDCLASS.



CLASS zcl_string_api_d530 IMPLEMENTATION.
  METHOD constructor.
    value = im_value.
  ENDMETHOD.


  METHOD equals_ignore_case.

    DATA(lv_value1) = value.
    DATA(lv_value2) = io_string->value.

    TRANSLATE:
      lv_value1 TO UPPER CASE,
      lv_value2 TO UPPER CASE.

    IF lv_value1 = lv_value2.
      re_result = abap_true.
    ELSE.
      re_result = abap_false.
    ENDIF.
  ENDMETHOD.

  METHOD trim.
*   Remove leading/trailing whitespace from the string:
    SHIFT value LEFT DELETING LEADING space.
    SHIFT value RIGHT DELETING TRAILING space.

*    CONDENSE value.
* Return a reference to this updated string instance:
    ro_string = me.

  ENDMETHOD.

  METHOD get_value.
    re_string = value.
  ENDMETHOD.

  METHOD get_length.
*  Calculate string length
    re_length = strlen( value ).
  ENDMETHOD.

  METHOD get_char_at.

    IF im_index - 1 < 0  OR im_index - 1 GT get_length( ) - 1  .

      RAISE EXCEPTION TYPE zcx_invalid_string_idx
        EXPORTING
          textid = zcx_invalid_string_idx=>zcx_invalid_string_idx.
*      previous =

    ENDIF.
    re_char = value+im_index(1).
  ENDMETHOD.

  METHOD equals.
* Check to see if the two strings are equal lexicographically:
    IF io_string IS BOUND.
      IF value = io_string->value.
        re_result = abap_true.
      ELSE.
        re_result = abap_false.
      ENDIF.

    ELSE .
      re_result = abap_false.
    ENDIF.

  ENDMETHOD.

  METHOD compare_to.

    DATA(lv_value1) = value.
    DATA(lv_value2) = io_string->value.

    IF iv_ignore_case = abap_true.
      TRANSLATE: lv_value1 TO UPPER CASE,
                lv_value2 TO UPPER CASE.
    ENDIF.

    re_result = COND #(
         WHEN lv_value1 = lv_value2 THEN 0
         WHEN lv_value1 LT lv_value2 THEN -1
         WHEN lv_value1 GT lv_value2 THEN 1

     ).

  ENDMETHOD.

  METHOD append.
    value = |{ value }{ im_string }|.
  ENDMETHOD.

  METHOD split_at.

    IF strlen(  value ) <> 0.
      SPLIT value AT im_delimiter INTO TABLE rt_string.
    ENDIF.
  ENDMETHOD.

  METHOD substring.

    ro_string = NEW #(   substring_raw( EXPORTING
                                            im_start_index = im_start_index
                                            im_end_index   =  im_end_index )
                     ).
  ENDMETHOD.

  METHOD substring_raw.

* Method-Local Data Declarations:
    DATA: lv_length    TYPE i,
          lv_offset    TYPE i,
          lv_start_idx TYPE i,
          lv_end_idx   TYPE i.

* Initialization - calculate the length of the string as well as
* some basic index/offset information:
    lv_length = strlen( me->value ).
    lv_start_idx = im_start_index - 1.


    lv_offset = COND #(
                        WHEN NOT  im_end_index  IS INITIAL THEN  im_end_index - lv_start_idx
                        WHEN im_end_index  IS INITIAL THEN  lv_length - lv_start_idx
                      ).

* Sanity check - make sure that the start/end indices are valid:
    IF lv_length EQ 0.
      RAISE EXCEPTION TYPE zcx_invalid_string_idx.
    ENDIF.

    IF ( ( im_start_index LT 1 ) OR ( im_start_index GT lv_length ) ).
      RAISE EXCEPTION TYPE zcx_invalid_string_idx.
    ENDIF.

    IF NOT im_end_index IS INITIAL.
      IF ( ( im_end_index GT lv_length ) OR
           ( im_end_index LE im_start_index ) ).
        RAISE EXCEPTION TYPE zcx_invalid_string_idx.
      ENDIF.
    ENDIF.

* Now, derive the substring:
    re_string = me->value+lv_start_idx(lv_offset).

  ENDMETHOD.

  METHOD convert_to_lower_case.
    TRANSLATE value TO LOWER CASE.
  ENDMETHOD.

  METHOD convert_to_upper_case.
    TRANSLATE value TO UPPER CASE.
  ENDMETHOD.

  METHOD as_lower_case.
    TRANSLATE value TO LOWER CASE.
    ro_string = NEW #( value ).
  ENDMETHOD.

  METHOD as_upper_case.

    TRANSLATE value TO UPPER  CASE.
    ro_string = NEW #( value ).

  ENDMETHOD.

  METHOD starts_with.
* Method-Local Data Declarations:
    DATA: lv_pattern TYPE string,
          lo_regex   TYPE REF TO cl_abap_regex,
          lo_matcher TYPE REF TO cl_abap_matcher.

* Make sure the string is not empty:
    IF strlen( me->value ) EQ 0.
      re_result = abap_false.
      RETURN.
    ENDIF.

* Check to see if the string ends with the provided sequence:
    TRY.
*   Construct the regular expression needed to determine if
*   this string object begins with the provided string value:
        CONCATENATE `^` im_pattern `.*$` INTO lv_pattern.

        CREATE OBJECT lo_regex
          EXPORTING
            pattern     = lv_pattern
            ignore_case = im_ignore_case.

*   Construct a matcher object to conduct the match operation:
        lo_matcher = lo_regex->create_matcher( text = me->value ).

*   Test the results:
        re_result = lo_matcher->match( ).
      CATCH cx_sy_regex.
        re_result = abap_false.
      CATCH cx_sy_matcher.
        re_result = abap_false.
    ENDTRY.

  ENDMETHOD.

  METHOD ends_with.

* Method-Local Data Declarations:
    DATA: lv_pattern TYPE string,
          lo_regex   TYPE REF TO cl_abap_regex,
          lo_matcher TYPE REF TO cl_abap_matcher.

* Make sure the string is not empty:
    IF strlen( me->value ) EQ 0.
      re_result = abap_false.
      RETURN.
    ENDIF.

* Check to see if the string ends with the provided sequence:
    TRY.
*   Construct the regular expression needed to determine if
*   this string object ends with the provided string value:
        CONCATENATE `^.*` im_pattern `$` INTO lv_pattern.

        CREATE OBJECT lo_regex
          EXPORTING
            pattern     = lv_pattern
            ignore_case = im_ignore_case.

*   Construct a matcher object to conduct the match operation:
        lo_matcher = lo_regex->create_matcher( text = me->value ).

*   Test the results:
        re_result = lo_matcher->match( ).
      CATCH cx_sy_regex.
        re_result = abap_false.
      CATCH cx_sy_matcher.
        re_result = abap_false.
    ENDTRY.

  ENDMETHOD.

  METHOD contains_any.

    re_result = COND #(
           WHEN strlen( value ) EQ 0 THEN abap_false
           WHEN value CA im_pattern THEN abap_true
           ELSE abap_false
    ).

  ENDMETHOD.

  METHOD contains_only.

    re_result = COND #(
           WHEN strlen( value ) EQ 0 THEN abap_false
           WHEN value CO im_pattern THEN abap_true
           ELSE abap_false
    ).

  ENDMETHOD.

  METHOD contains_not_any.

    re_result = COND #(
           WHEN strlen( value ) EQ 0 THEN abap_false
           WHEN value NA im_pattern THEN abap_true
           ELSE abap_false
    ).


  ENDMETHOD.

  METHOD contains_not_only.

    re_result = COND #(
           WHEN strlen( value ) EQ 0 THEN abap_false
           WHEN value CN im_pattern THEN abap_true
           ELSE abap_false
    ).

  ENDMETHOD.

  METHOD find_pattern.
* Method-Local Data Declarations:
    DATA: lo_regex TYPE REF TO cl_abap_regex.

* Only conduct search if there is something to look for:
    IF strlen( me->value ) EQ 0.
      RETURN.
    ENDIF.

* Search the string for the pattern:
    IF NOT im_is_regex IS INITIAL.
      CREATE OBJECT lo_regex
        EXPORTING
          pattern     = im_pattern
          ignore_case = im_ignore_case.

      FIND ALL OCCURRENCES OF REGEX lo_regex
        IN me->value RESULTS re_matches.
    ELSE.
      IF NOT im_ignore_case IS INITIAL.
        FIND ALL OCCURRENCES OF im_pattern
          IN me->value RESULTS re_matches
             IGNORING CASE.
      ELSE.
        FIND ALL OCCURRENCES OF im_pattern
          IN me->value RESULTS re_matches.
      ENDIF.
    ENDIF.



  ENDMETHOD.

  METHOD get_first_index_of.
* Method-Local Data Declarations:
    DATA: lo_regex TYPE REF TO cl_abap_regex.

* Make sure there's something to search first:
    IF strlen( me->value ) EQ 0.
      re_index = -1.
    ENDIF.

* Find the first occurrence of the pattern in the string,
* storing the offset in return parameter re_index:
    IF im_is_regex EQ abap_true.
      CREATE OBJECT lo_regex
        EXPORTING
          pattern     = im_pattern
          ignore_case = im_ignore_case.

      FIND FIRST OCCURRENCE OF REGEX lo_regex
          IN me->value
             MATCH OFFSET re_index.
    ELSE.
      IF im_ignore_case EQ abap_true.
        FIND FIRST OCCURRENCE OF im_pattern
          IN me->value
             IGNORING CASE
             MATCH OFFSET re_index.
      ELSE.
        FIND FIRST OCCURRENCE OF im_pattern
          IN me->value
             MATCH OFFSET re_index.
      ENDIF.
    ENDIF.

* Check the results:
    IF sy-subrc EQ 0.
*   The actual index is the offset value plus 1:
      ADD 1 TO re_index.
    ELSE.
      re_index = -1.
    ENDIF.
  ENDMETHOD.

  METHOD get_last_index_of.


* Method-Local Data Declarations:
    DATA: lo_regex       TYPE REF TO cl_abap_regex,
          lt_matches     TYPE match_result_tab,
          lv_match_count TYPE i.

    FIELD-SYMBOLS: <lfs_match> LIKE LINE OF lt_matches.

* Make sure there's something to search first:
    IF strlen( me->value ) EQ 0.
      re_index = -1.
    ENDIF.

* To find the last index, we must find all matches of the pattern:
    IF im_is_regex EQ abap_true.
      CREATE OBJECT lo_regex
        EXPORTING
          pattern     = im_pattern
          ignore_case = im_ignore_case.

      FIND ALL OCCURRENCES OF REGEX lo_regex IN me->value
          RESULTS lt_matches.
    ELSE.
      IF im_ignore_case EQ abap_true.
        FIND ALL OCCURRENCES OF im_pattern IN me->value
          IGNORING CASE
          RESULTS lt_matches.
      ELSE.
        FIND ALL OCCURRENCES OF im_pattern IN me->value
        RESULTS lt_matches.
      ENDIF.
    ENDIF.

* Check to see if there were any matches; calculate the index
* accordingly:
    DESCRIBE TABLE lt_matches LINES lv_match_count.
    IF lv_match_count EQ 0.
      re_index = -1.
    ELSE.
      READ TABLE lt_matches INDEX lv_match_count
       ASSIGNING <lfs_match>.

      IF <lfs_match> IS ASSIGNED.
        re_index = <lfs_match>-offset + 1.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD matches.

*   String must not be null before a match operation can be performed:
    IF strlen( me->value ) EQ 0.
      re_result = abap_false.
    ENDIF.

* Check to see if the current string matches the provided pattern:
    TRY.
        CALL METHOD cl_abap_matcher=>matches
          EXPORTING
            pattern     = im_pattern
            text        = me->value
            ignore_case = im_ignore_case
          RECEIVING
            success     = re_result.
      CATCH cx_sy_regex.
        re_result = abap_false.
    ENDTRY.


  ENDMETHOD.

  METHOD replace_section.

*   Can only perform this operation if there is a string value:
    IF strlen( me->value ) EQ 0.
      RETURN.
    ENDIF.

* Replace the given section of the string with the replacement:
    REPLACE SECTION OFFSET im_offset LENGTH im_length
         OF me->value WITH im_replacement.

* Copy a reference to the current instance to the result parameter:
    re_result = me.

  ENDMETHOD.

  METHOD replace_all.

* Make sure the string has something to replace:
    IF strlen( me->value ) EQ 0.
      RETURN.
    ENDIF.

* Process the replace operation based on the user's provided input:
    IF im_is_regex EQ abap_true.
      REPLACE ALL OCCURRENCES OF REGEX im_pattern
           IN me->value WITH im_replacement.
    ELSE.
      IF im_ignore_case EQ abap_true.
        REPLACE ALL OCCURRENCES OF im_pattern
             IN me->value WITH im_replacement
                IGNORING CASE.
      ELSE.
        REPLACE ALL OCCURRENCES OF im_pattern
             IN me->value WITH im_replacement.
      ENDIF.
    ENDIF.

* Return a reference to the resultant object:
    re_result = me.
  ENDMETHOD.

  METHOD replace_first.

*   Make sure the string has something to replace:
    IF strlen( me->value ) EQ 0.
      RETURN.
    ENDIF.

* Process the replace operation based on the user's provided input:
    IF im_is_regex EQ abap_true.
      REPLACE FIRST OCCURRENCE OF REGEX im_pattern
           IN me->value WITH im_replacement.
    ELSE.
      IF im_ignore_case EQ abap_true.
        REPLACE FIRST OCCURRENCE OF im_pattern
             IN me->value WITH im_replacement
                IGNORING CASE.
      ELSE.
        REPLACE FIRST OCCURRENCE OF im_pattern
             IN me->value WITH im_replacement.
      ENDIF.
    ENDIF.

* Return a reference to the resultant object:
    re_result = me.

  ENDMETHOD.

  METHOD create_from_int.

    re_string = NEW #( im_value = CONV string( im_int_value ) ).



  ENDMETHOD.

  METHOD create_from_float.
    re_string = NEW #( im_value = CONV string( im_flo_value ) ).
  ENDMETHOD.

  METHOD create_from_packed.
    re_string = NEW #( im_value = CONV string( im_packed_value ) ).
  ENDMETHOD.

ENDCLASS.
