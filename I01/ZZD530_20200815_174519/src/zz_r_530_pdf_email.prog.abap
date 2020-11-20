*&---------------------------------------------------------------------*
*& Report zz_r_530_pdf_email
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zz_r_530_pdf_email.

TYPES: BEGIN OF ty_smtp,
         smtpadr  TYPE ad_smtpadr,
         mail_to  TYPE char1,
         mail_cc  TYPE char1,
         mail_bcc TYPE char1,
       END OF ty_smtp.

TYPES: BEGIN OF ty_text,
         line TYPE char1024,
       END OF ty_text.

TYPES: tt_smtp_tab TYPE STANDARD TABLE OF ty_smtp,
       tt_text_tab TYPE STANDARD TABLE OF ty_text.



CLASS lcl_pdf_email DEFINITION.

  PUBLIC SECTION.




    CLASS-METHODS send_pdf_file IMPORTING  im_file_header_text   TYPE string
                                           im_email_subject_line TYPE so_obj_des

                                           im_email_body_text    TYPE    bcsy_text
                                           im_email_address      TYPE    tt_smtp_tab
                                           im_email_dist_name    TYPE   so_obj_nam
                                           im_email_dist_id      TYPE    so_obj_id
                                           im_attachment_name    TYPE    sood-objdes
                                           im_file_delimeter     TYPE    c
                                           im_itab_1             TYPE    tt_text_tab
                                           im_itab_2             TYPE    soli_tab
                                           im_email_do_not       TYPE    char1
                                           im_layout             TYPE    sypaart OPTIONAL

                                EXPORTING  ex_send_to_all        TYPE    os_boolean
                                           ex_pdf_table          TYPE    rcl_bag_tline
                                EXCEPTIONS error_transferring .

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



START-OF-SELECTION.
  PARAMETERS : p_email TYPE char100 DEFAULT 'mahendra.gulla@ibsolution.de'."Email ID in the format test@xxxx.com

  TYPES: BEGIN OF ty_outfield,
           outdata TYPE soli,
         END OF ty_outfield,
         BEGIN OF ty_data,
           outdata TYPE ty_text,
         END OF ty_data.

  DATA:lt_headings TYPE soli_tab,
       ls_headings TYPE ty_outfield,
       ls_data     TYPE ty_data,
       lt_data     TYPE tt_text_tab,
       ls_email    TYPE ty_smtp,
       li_email    TYPE tt_smtp_tab,
       l_return    TYPE os_boolean,
       li_body     TYPE bcsy_text,
       lst_body    TYPE soli.


*----Populate Column names in the PDF file--------*

  ls_headings-outdata = 'PERNR'.  APPEND ls_headings TO lt_headings.
  ls_headings-outdata = 'LNAME'.  APPEND ls_headings TO lt_headings.
  ls_headings-outdata = 'FNAME'.  APPEND ls_headings TO lt_headings.

*----Populate Actual data names in the PDF file(Use Internal Table content here)--------*
  ls_data-outdata = '10000001|Romo|Tony'.  APPEND ls_data TO lt_data.
  ls_data-outdata = '10000002|Favre|Brett'.  APPEND ls_data TO lt_data.

*----Populate Email IDs here(To ,CC , Bcc etc.)--------*

  ls_email-smtpadr = p_email.
  ls_email-mail_to = 'X'.
  APPEND ls_email TO li_email.
  CLEAR : ls_email.

*ls_email-smtpadr = 'souvik.bhattacharya@test.com'.
*ls_email-mail_to = ' '.
*ls_email-mail_cc = 'X'.
*APPEND ls_email TO li_email.    "


*----Populate Body of the email here--------*

  lst_body = 'Hello User,'.
  APPEND lst_body TO li_body.  "Body of the email
  CLEAR : lst_body.
  lst_body = 'Please find attached the PDF file.'.
  APPEND lst_body TO li_body.  "Body of the email

  CALL METHOD lcl_pdf_email=>send_pdf_file
    EXPORTING
      im_file_header_text   = 'Employee Name Details'
      im_email_subject_line = 'Employee Details in attached PDF file '
      im_email_body_text    = li_body
      im_email_address      = li_email
      im_email_dist_name    = 'DISTRIBU_LIS'
      im_email_dist_id      = 'DISTRIBU_LIS'
      im_attachment_name    = 'Employee_data.pdf'
      im_file_delimeter     = '|'
      im_itab_1             = lt_data
      im_itab_2             = lt_headings
      im_email_do_not       = space
    IMPORTING
      ex_send_to_all        = l_return
    EXCEPTIONS
      error_transferring    = 1.

  IF l_return <> 0.

  ELSE.
    SET LOCALE LANGUAGE 'E'.
    COMMIT WORK.
    SUBMIT rsconn01 WITH mode = 'INT'
                WITH output = 'X'
                AND RETURN.

    WRITE : 'Email successfully Sent'.
  ENDIF.






CLASS lcl_pdf_email IMPLEMENTATION.

  METHOD send_pdf_file.

*  CONSTANTS----------------------------------------------------------------*
    CONSTANTS:
      gc_crlf TYPE c VALUE cl_bcs_convert=>gc_crlf.

* TYPES----------------------------------------------------------------*
    TYPES: BEGIN OF ty_itab,
             line TYPE ty_text,
           END OF ty_itab,
           BEGIN OF ty_itab2,
             line TYPE soli,
           END OF ty_itab2,
           BEGIN OF ty_header,
             field TYPE char80,
           END OF ty_header,
           BEGIN OF ty_field,
             field TYPE char40,
           END OF ty_field,
           BEGIN OF ty_maxlen,
             maxlen TYPE i,
           END OF ty_maxlen.

* INTERNAL TABLES------------------------------------------------------*
    DATA:
      lt_dlientries TYPE STANDARD TABLE OF sodlienti1,
      lt_main_text  TYPE bcsy_text,
      lt_recipient  TYPE tt_smtp_tab,
      lt_header     TYPE STANDARD TABLE OF ty_header,
      lt_maxlen     TYPE STANDARD TABLE OF ty_maxlen,
      lt_final      TYPE tt_text_tab,
      lt_field      TYPE STANDARD TABLE OF ty_field.

* STRUCTURES-----------------------------------------------------------*
    DATA:
      ls_email_addr TYPE ty_smtp,
      ls_dlientry   TYPE sodlienti1,
      ls_body       TYPE soli.

* FIELD-SYMBOLS----------------------------------------------------*
    FIELD-SYMBOLS: <ls_xline>    TYPE x,
                   <lt_dyntable> TYPE STANDARD TABLE ,  "Dynamic internal table name
                   <ls_dyntable> TYPE any,
                   <lv_any>      TYPE any.

* VARIABLES------------------------------------------------------------*
    DATA:
      ls_field_header  TYPE ty_header,
      lo_send_request  TYPE REF TO cl_bcs,
      lo_document      TYPE REF TO cl_document_bcs,
      lo_recipient     TYPE REF TO if_recipient_bcs,
      lx_bcs_exception TYPE REF TO cx_bcs,
      lv_sent_to_all   TYPE os_boolean,
      ls_sodlidata     TYPE sodlidati1,
      lv_mailcc        TYPE c,
      lv_mailbcc       TYPE c,
      lv_recipient     TYPE ad_smtpadr,
      lr_newtable      TYPE REF TO data,
      lr_newline       TYPE REF TO data,
      lt_fldcat        TYPE lvc_t_fcat,
      ls_fldcat        TYPE lvc_s_fcat,
      ls_flname        TYPE string,
      lt_pdf_content   TYPE solix_tab,
      lv_lp_pdf_size   TYPE so_obj_len,
      lv_string        TYPE string,
      lv_pdf_xstring   TYPE xstring,
      lt_pdf_table     TYPE  rcl_bag_tline,
      ls_pdfline       TYPE tline,
      lv_spoolid       TYPE tsp01-rqident,
      ls_params        TYPE pri_params,
      lv_valid         TYPE char1,
      lv_pdf_bytecount TYPE i,
      ls_text_1        TYPE ty_text,
      lv_output        TYPE char40,
      lv_col_cnt       TYPE i,
      lv_maxcnt        TYPE i,
      ls_field         TYPE ty_field,
      ls_maxlen        TYPE ty_maxlen,
      lv_index         TYPE char2,
      ls_final         TYPE ty_text,
      lv_field         TYPE string,
      lv_rec           TYPE i,
      ls_soli          TYPE soli,
      lv_field_conv    TYPE string,
      lv_comp          TYPE string,
      lv_pos           TYPE i VALUE 1,
      lv_sp_id         TYPE tsp01_sp0r-rqid_char.



    lv_field = ' '.

    CONCATENATE im_file_header_text
                gc_crlf gc_crlf
                INTO lv_string.

    SET LOCALE LANGUAGE 'E'."added
    CALL FUNCTION 'GET_PRINT_PARAMETERS'
      EXPORTING
        destination    = 'LOCL'
*LINE_SIZE = 100
        immediately    = ' '
        no_dialog      = 'X'
        layout         = im_layout
*LINE_COUNT = 500000
        line_size      = 200
      IMPORTING
        out_parameters = ls_params
        valid          = lv_valid.


    SPLIT im_file_header_text AT '#' INTO TABLE lt_header.
    SET LOCALE LANGUAGE 'E'.

    NEW-PAGE PRINT ON PARAMETERS ls_params NO DIALOG NO-TITLE NO-HEADING.
    LOOP AT lt_header INTO ls_field_header.
      WRITE : ls_field_header-field.
    ENDLOOP.


    LOOP AT im_itab_2 INTO ls_soli.
      IF sy-tabix = 1.
        lv_field = ls_soli.
      ELSE.
        CONCATENATE lv_field  ls_soli INTO lv_field SEPARATED BY '|'.
      ENDIF.
    ENDLOOP.
    APPEND lv_field TO lt_final.

    LOOP AT  im_itab_1 INTO ls_text_1.
      APPEND ls_text_1 TO lt_final.
    ENDLOOP.


    READ TABLE lt_final INTO ls_final INDEX 1.  "reading the columns name
    IF sy-subrc = 0.
      SPLIT ls_final AT '|' INTO TABLE lt_field.
    ENDIF.

    DESCRIBE TABLE lt_field LINES lv_rec.

    LOOP AT lt_field INTO ls_field.
      lv_index = sy-tabix.
      CONCATENATE 'COL' lv_index INTO ls_flname.
      ls_fldcat-fieldname = ls_flname.
      ls_fldcat-outputlen = 40.
      ls_fldcat-datatype = 'CHAR'.
      APPEND ls_fldcat TO lt_fldcat.

      CLEAR ls_fldcat.

    ENDLOOP.

* Create dynamic internal table and assign to FS

    CALL METHOD cl_alv_table_create=>create_dynamic_table
      EXPORTING
        it_fieldcatalog = lt_fldcat
      IMPORTING
        ep_table        = lr_newtable.

    ASSIGN lr_newtable->* TO <lt_dyntable>.

    REFRESH <lt_dyntable>.

* Create dynamic work area and assign to FS
    CREATE DATA lr_newline LIKE LINE OF <lt_dyntable>.
    ASSIGN lr_newline->* TO <ls_dyntable>.
    CLEAR <ls_dyntable>.

*****************reading the data value********************************************
    REFRESH lt_field.
    LOOP AT lt_final  INTO ls_final.
      SPLIT ls_final AT '|' INTO TABLE lt_field.
      SET LOCALE LANGUAGE 'E'.
      LOOP AT lt_field INTO ls_field.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = ls_field-field
          IMPORTING
            output = lv_output.

        CONCATENATE lv_field_conv lv_output INTO lv_field_conv RESPECTING BLANKS.

      ENDLOOP.
      <ls_dyntable> = lv_field_conv.
      APPEND  <ls_dyntable> TO <lt_dyntable>.
      CLEAR:lv_field_conv.
    ENDLOOP.

    DO lv_rec TIMES.
      REFRESH: lt_field.
      lv_col_cnt = lv_col_cnt + 1.
      LOOP AT <lt_dyntable> INTO <ls_dyntable>.
        IF <lv_any> IS ASSIGNED.
          UNASSIGN <lv_any>.
        ENDIF.
        DO.
          ASSIGN COMPONENT lv_col_cnt OF STRUCTURE <ls_dyntable> TO <lv_any>.
          IF sy-subrc <> 0.
            EXIT.
          ENDIF.
          ls_field-field = <lv_any>.
*condense wa_field-field.
          APPEND ls_field TO lt_field.
          CLEAR: ls_field.
          EXIT.
        ENDDO.

      ENDLOOP.
*****************calculating tha maximum length of domain values********************************************
      LOOP AT lt_field INTO ls_field.
        lv_maxcnt = strlen( ls_field-field ).
        IF ls_maxlen-maxlen <  lv_maxcnt .
          ls_maxlen-maxlen = lv_maxcnt.
        ENDIF.
        CLEAR:lv_maxcnt.
      ENDLOOP.
      APPEND ls_maxlen TO lt_maxlen .
      CLEAR: ls_maxlen,lv_maxcnt.
    ENDDO.

    SKIP 2.
*****************writing the column names and data value********************************************
    LOOP AT <lt_dyntable> INTO <ls_dyntable>.
      IF <lv_any> IS ASSIGNED.
        UNASSIGN <lv_any>.
      ENDIF.
      DO.
        ASSIGN COMPONENT sy-index OF STRUCTURE <ls_dyntable> TO <lv_any>.
        IF sy-subrc <> 0.
          EXIT.
        ENDIF.
        lv_comp = <lv_any>.
        IF sy-index = 1.
          WRITE:/ lv_comp.
        ELSE.
          lv_rec = sy-index - 1.
          READ TABLE lt_maxlen INTO ls_maxlen  INDEX lv_rec.
          IF sy-subrc = 0.
            lv_pos = lv_pos + ls_maxlen-maxlen + 1.
            WRITE AT lv_pos lv_comp.
          ENDIF.
        ENDIF.
        CLEAR:lv_rec,lv_comp.
      ENDDO.
      lv_pos = 1.
    ENDLOOP.

    NEW-PAGE PRINT OFF.
    lv_spoolid = sy-spono.
    SET LOCALE LANGUAGE 'E'.
    CALL FUNCTION 'CONVERT_ABAPSPOOLJOB_2_PDF'
      EXPORTING
        src_spoolid              = lv_spoolid                  "'30221'
*       NO_DIALOG                = 'X'
        dst_device               = 'LOCL'
*       PDF_DESTINATION          =
*       NO_BACKGROUND            =
*       GET_SIZE_FROM_FORMAT     =
      IMPORTING
        pdf_bytecount            = lv_pdf_bytecount
*       PDF_SPOOLID              =
*       LIST_PAGECOUNT           =
*       BTC_JOBNAME              =
*       BTC_JOBCOUNT             =
*       BIN_FILE                 =
      TABLES
        pdf                      = lt_pdf_table
      EXCEPTIONS
        err_no_abap_spooljob     = 1
        err_no_spooljob          = 2
        err_no_permission        = 3
        err_conv_not_possible    = 4
        err_bad_destdevice       = 5
        user_cancelled           = 6
        err_spoolerror           = 7
        err_temseerror           = 8
        err_btcjob_open_failed   = 9
        err_btcjob_submit_failed = 10
        err_btcjob_close_failed  = 11
        OTHERS                   = 12.


    MOVE lv_spoolid TO lv_sp_id.

    CALL FUNCTION 'RSPO_R_RDELETE_SPOOLREQ'
      EXPORTING
        spoolid = lv_sp_id.


* Map PDF table into 'flat' table acording to Unicode flag
    ex_pdf_table = lt_pdf_table .





    IF im_email_do_not IS INITIAL.
      LOOP AT lt_pdf_table INTO ls_pdfline.
        ASSIGN ls_pdfline TO <ls_xline> CASTING.
        CONCATENATE lv_pdf_xstring <ls_xline> INTO lv_pdf_xstring IN BYTE MODE.
      ENDLOOP.

*   get PDF xstring and convert it to BCS format
      lv_lp_pdf_size = xstrlen( lv_pdf_xstring ).
      lt_pdf_content = cl_document_bcs=>xstring_to_solix(
          ip_xstring = lv_pdf_xstring ).
      TRY.

*-------- create persistent send request ------------------------
          lo_send_request = cl_bcs=>create_persistent( ).

*-------- create and set document with attachment ---------------
*create document object from internal table with text
          LOOP AT im_email_body_text INTO ls_body.
            APPEND ls_body TO lt_main_text.
          ENDLOOP.
          lo_document = cl_document_bcs=>create_document(
            i_type    = 'RAW'
            i_text    = lt_main_text
            i_subject = im_email_subject_line ).

*add the spread sheet as attachment to document object
          lo_document->add_attachment(
           i_attachment_type    = 'PDF'                     "#EC NOTEXT
           i_attachment_subject = im_attachment_name        "#EC NOTEXT
           i_attachment_size    = lv_lp_pdf_size                    "Size
           i_att_content_hex    = lt_pdf_content ).
*add document object to send request
          lo_send_request->set_document( lo_document ).

*get email addresses from table
          LOOP AT im_email_address INTO ls_email_addr.
            APPEND ls_email_addr TO lt_recipient.
          ENDLOOP.

*Get email addresses from Distribution list
          CALL FUNCTION 'SO_DLI_READ_API1'
            EXPORTING
              shared_dli                 = 'X'
              dli_id                     = space
              dli_name                   = im_email_dist_name
            IMPORTING
              dli_data                   = ls_sodlidata
            TABLES
              dli_entries                = lt_dlientries
            EXCEPTIONS
              dli_not_exist              = 9001
              operation_no_authorization = 9002
              parameter_error            = 9003
              x_error                    = 9004
              OTHERS                     = 01.

          CLEAR ls_email_addr.
          LOOP AT lt_dlientries INTO ls_dlientry.
            ls_email_addr-smtpadr = ls_dlientry-member_adr.
            ls_email_addr-mail_to = 'X'.
            APPEND ls_email_addr TO lt_recipient.
          ENDLOOP.

*Get email addresses from Distribution Id
          CALL FUNCTION 'SO_DLI_READ_API1'
            EXPORTING
              shared_dli                 = 'X'
              dli_id                     = im_email_dist_id
              dli_name                   = space
            IMPORTING
              dli_data                   = ls_sodlidata
            TABLES
              dli_entries                = lt_dlientries
            EXCEPTIONS
              dli_not_exist              = 9001
              operation_no_authorization = 9002
              parameter_error            = 9003
              x_error                    = 9004
              OTHERS                     = 01.

          LOOP AT lt_dlientries INTO ls_dlientry.
            ls_email_addr-smtpadr = ls_dlientry-member_adr.
            ls_email_addr-mail_to = 'X'.
            APPEND ls_email_addr TO lt_recipient.
          ENDLOOP.


*--------- add recipient (e-mail address)-----------------------
          LOOP AT lt_recipient INTO ls_email_addr.
            lv_recipient = ls_email_addr-smtpadr.
            lo_recipient = cl_cam_address_bcs=>create_internet_address( lv_recipient ).
            IF ls_email_addr-mail_to = 'X'.
              CLEAR lv_mailcc.
              CLEAR lv_mailbcc.
            ELSE.
              IF ls_email_addr-mail_cc = 'X'.
                lv_mailcc = 'X'.
                CLEAR lv_mailbcc.
              ELSE.
                IF ls_email_addr-mail_bcc = 'X'.
                  lv_mailbcc = 'X'.
                  CLEAR lv_mailcc.
                ENDIF.
              ENDIF.
            ENDIF.
            TRY.
                CALL METHOD lo_send_request->add_recipient
                  EXPORTING
                    i_recipient  = lo_recipient
                    i_express    = 'X'
                    i_copy       = lv_mailcc
                    i_blind_copy = lv_mailbcc.
            ENDTRY .

          ENDLOOP.

*add recipient object to send request
*send_request->add_recipient( recipient ).

*---------- send document ---------------------------------------
          lo_send_request->send_request->set_link_to_outbox( 'X' ).

          lv_sent_to_all = lo_send_request->send( i_with_error_screen = 'X' ).

          COMMIT WORK.

          IF lv_sent_to_all IS INITIAL.
            ex_send_to_all = '1'.
          ELSE.
            ex_send_to_all = '0'.
          ENDIF.

          SUBMIT rsconn01 WITH mode = 'INT'
                      WITH output = 'X'
                      AND RETURN.

*   ------------ exception handling ----------------------------------
        CATCH cx_bcs INTO lx_bcs_exception.
*      message i865(so) with bcs_exception->error_type.
      ENDTRY.

    ENDIF.



  ENDMETHOD.

ENDCLASS.
