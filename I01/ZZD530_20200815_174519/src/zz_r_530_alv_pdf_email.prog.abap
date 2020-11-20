*&---------------------------------------------------------------------*
*& Report zz_r_530_alv_pdf_email
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zz_r_530_alv_pdf_email.

TYPE-POOLS:slis.
TYPES: BEGIN OF ty_t001,
         bukrs TYPE t001-bukrs,
         butxt TYPE t001-butxt,
         ort01 TYPE t001-ort01,
         land1 TYPE t001-land1,
         waers TYPE t001-waers,
       END  OF ty_t001.
DATA: it_t001     TYPE TABLE OF ty_t001,
      it_pdf      LIKE tline OCCURS 0,
      it_fieldcat TYPE slis_t_fieldcat_alv.
DATA: g_spool   TYPE tsp01-rqident,
      g_program TYPE sy-repid VALUE sy-repid.
DATA: w_print      TYPE slis_print_alv,
      w_print_ctrl TYPE alv_s_pctl,
      w_pri_params TYPE pri_params,
      pdf_xstring  TYPE xstring.
DATA rq       TYPE tsp01.
DATA dummy    TYPE TABLE OF rspoattr.
DATA: bin_size TYPE i,
      mailto   TYPE ad_smtpadr VALUE 'mahendra.gulla@ibsolution.de'.

** Selection screen
PARAMETERS: p_file TYPE string.
** Initialization
INITIALIZATION.
  p_file = 'C:\Users\D530\OneDrive - IBsolution GmbH\Desktop\CHECK.pdf'.
** Start of Selection
START-OF-SELECTION.
  SELECT bukrs
         butxt
         ort01
         land1
         waers
    FROM t001
    INTO TABLE it_t001 UP TO 100 ROWS.
*  w_print-print = 'X'.
* Function Call to get print parameters
  CALL FUNCTION 'GET_PRINT_PARAMETERS'
    EXPORTING
      mode                   = 'CURRENT'
      no_dialog              = 'X'
      user                   = sy-uname
    IMPORTING
      out_parameters         = w_pri_params
    EXCEPTIONS
      archive_info_not_found = 1
      invalid_print_params   = 2
      invalid_archive_params = 3
      OTHERS                 = 4.
* To capture the Spool Request
  NEW-PAGE PRINT ON PARAMETERS w_pri_params NO DIALOG.
  PERFORM fill_catalog_alv1 USING:
     'BUKRS'     'T001'    'BUKRS',
     'BUTXT'     'T001'    'BUTXT',
     'ORT01'     'T001'    'ORT01',
     'LAND1'     'T001'    'LAND1',
     'WAERS'     'T001'    'WAERS'.

  TRY.
      cl_salv_table=>factory(
        IMPORTING
          r_salv_table = DATA(o_alv)
        CHANGING
          t_table      = it_t001 ).
    CATCH cx_salv_msg INTO DATA(lx_msg).
  ENDTRY.

*  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
*    EXPORTING
*      i_callback_program = g_program
*      it_fieldcat        = it_fieldcat
*    TABLES
*      t_outtab           = it_t001.
  o_alv->display( ).
  IF sy-subrc EQ 0.
    NEW-PAGE PRINT OFF.
    g_spool = sy-spono.


    FIELD-SYMBOLS:  <ls_xline>  TYPE x  .
    DATA lv_pdf_xstring  TYPE xstring  .

    CALL FUNCTION 'CONVERT_ABAPSPOOLJOB_2_PDF'
      EXPORTING
        src_spoolid = g_spool
        dst_device  = 'LOCL'
      TABLES
        pdf         = it_pdf.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ELSE.

      LOOP AT it_pdf INTO DATA(ls_pdf).
        ASSIGN ls_pdf TO <ls_xline> CASTING.
        CONCATENATE lv_pdf_xstring <ls_xline> INTO lv_pdf_xstring IN BYTE MODE.
      ENDLOOP.

*       get PDF xstring and convert it to BCS format
      DATA  lv_lp_pdf_size  TYPE so_obj_len.
      lv_lp_pdf_size = xstrlen( lv_pdf_xstring ).
      DATA(lt_pdf_content) = cl_document_bcs=>xstring_to_solix(
          ip_xstring = lv_pdf_xstring ).



      TRY.
*
**     -------- create persistent send request ------------------------
          DATA(send_request) = cl_bcs=>create_persistent( ).

**     -------- create and set document -------------------------------
          DATA(pdf_content) = cl_document_bcs=>xstring_to_solix( pdf_xstring ).


          DATA body_text TYPE  bcsy_text .
          APPEND 'TEST body' TO     body_text.

*       lo_document = cl_document_bcs=>create_document(
*          i_type    = 'RAW'
*          i_text    = lt_main_text
*          i_subject = im_email_subject_line ).

          DATA(document) = cl_document_bcs=>create_document(
                i_type    = 'RAW'
                i_text     = body_text
                i_subject = 'test created by BCS_EXAMPLE_8' ). "#EC NOTEXT

          document->add_attachment(
            EXPORTING
              i_attachment_type     =  'PDF'   " Document Class for Attachment
              i_attachment_subject  =  'Test Data'    " Attachment Title
              i_attachment_size     =  lv_lp_pdf_size   " Size of Document Content
*                i_attachment_language = SPACE    " Language in Which Attachment Is Created
*                i_att_content_text    =     " Content (Text-Like)
              i_att_content_hex     =  lt_pdf_content   " Content (Binary)
*                i_attachment_header   =     " Attachment Header Data
*                iv_vsi_profile        =     " Virus Scan Profile
          ).
*              CATCH cx_document_bcs.    "

**     add document object to send request
          send_request->set_document( document ).

**     --------- add recipient (e-mail address) -----------------------
**     create recipient object
          DATA(recipient) = cl_cam_address_bcs=>create_internet_address( mailto ).

**     add recipient object to send request
          send_request->add_recipient( recipient ).

**     ---------- send document ---------------------------------------
         send_request->send_request->set_link_to_outbox( 'X' ).

          DATA(sent_to_all) = send_request->send( i_with_error_screen = 'X' ).

          COMMIT WORK.

          IF sent_to_all IS INITIAL.
            MESSAGE i500(sbcoms) WITH mailto.
          ELSE.
        message s022(so).
      endif.

**   ------------ exception handling ----------------------------------
**   replace this rudimentary exception handling with your own one !!!
    catch cx_bcs into DATA(bcs_exception).
      message i865(so) with bcs_exception->error_type.
  endtry.









            CALL FUNCTION 'GUI_DOWNLOAD'
              EXPORTING
                filename = p_file
                filetype = 'BIN'
              TABLES
                data_tab = it_pdf.
            IF sy-subrc <> 0.
              MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2.
            ELSE.
              WRITE: / 'Downloaded document successfully'.
            ENDIF.
          ENDIF.
        ENDIF.
*&---------------------------------------------------------------------*
*&      Form  fill_catalog_alv1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_FIELD_NAME   text
*      -->P_REFTAB_NAME  text
*      -->P_REF_FIELD    text
*----------------------------------------------------------------------*
FORM fill_catalog_alv1 USING p_field_name  TYPE slis_fieldname
                             p_reftab_name TYPE slis_tabname
                             p_ref_field   TYPE slis_fieldname.
  DATA: ls_field_alv TYPE slis_fieldcat_alv.
* Filling the field catalog values.
  ls_field_alv-fieldname     = p_field_name.
  ls_field_alv-ref_tabname   = p_reftab_name.
  ls_field_alv-ref_fieldname = p_ref_field.
  APPEND ls_field_alv TO it_fieldcat.
ENDFORM.                    " FILL_CATALOG_ALV1
