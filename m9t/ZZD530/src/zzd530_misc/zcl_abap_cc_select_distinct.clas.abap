CLASS zcl_abap_cc_select_distinct DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_abap_cc_select_distinct IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA(sentence) = 'ABAP is excellent'.
    SPLIT condense( sentence ) AT | | INTO TABLE DATA(words).
    out->write( |Number of words: { lines( words ) }|  ).
    IF cl_abap_dbfeatures=>use_features(
         requested_features =  VALUE #( (  cl_abap_dbfeatures=>itabs_in_from_clause ) )  ).
      LOOP AT words REFERENCE INTO DATA(word).
        DATA(characters) = VALUE abap_sortorder_tab(  FOR char = 0 THEN char + 1 UNTIL char = strlen( word->* ) ( name = word->*+char(1) ) ).
        SELECT COUNT( DISTINCT name ) AS count, MIN( name ) AS min, MAX( name ) AS max
                          FROM @characters AS characters
                          INTO @DATA(unique_characters).
        out->write( |Number of unique characters in the word: { word->* } - { unique_characters-count } Lowest Letter { unique_characters-min } Highest Letter { unique_characters-max }| ).
      ENDLOOP.
    ELSE.
      out->write(  | Bummer: Not supoorted SELECT FROM @ITAB on this system| ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
