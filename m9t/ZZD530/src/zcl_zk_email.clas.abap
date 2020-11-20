CLASS zcl_zk_email DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS  send_email_processor IMPORTING im_user     TYPE xubname
                                            iM_crequest TYPE usmd_crequest.
    METHODS  send_email_requester IMPORTING im_user     TYPE xubname
                                            iM_crequest TYPE usmd_crequest.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_zk_email IMPLEMENTATION.


  METHOD send_email_processor.

    DATA(lo_email_api) = cl_smtg_email_api=>get_instance(
                         iv_template_id    = 'ZCREQUEST_STATUS'
*                       is_email_template =
                       ).
*                     CATCH cx_smtg_email_common.
    DATA(lo_bcs) = cl_bcs=>create_persistent( ).
*               CATCH cx_send_req_bcs.
    TRY.
        lo_email_api->render_bcs(
          EXPORTING
            io_bcs      = lo_bcs
            iv_language = sy-langu
            it_data_key = VALUE #( ( name = 'crequest'  value = im_crequest )
                                   ( name = 'langu'     value = sy-langu   ) )
        ).
      CATCH cx_smtg_email_common INTO DATA(lx).
        DATA(lv_txt) = lx->get_text( ).
    ENDTRY.

    DATA(lo_sender) = cl_sapuser_bcs=>create( i_user = sy-uname ).
    lo_bcs->set_sender( i_sender =  lo_sender ).
*CATCH cx_send_req_bcs.

*    DATA(lo_recipient) = cl_sapuser_bcs=>create( im_user ).
    SELECT SINGLE FROM zi_crequest_mail_u FIELDS Email WHERE ChangeRequest = @im_crequest
                                                        INTO @DATA(lv_email).

    DATA(lo_recipient) = cl_cam_address_bcs=>create_internet_address(
                           i_address_string =    COND #(   WHEN lv_email IS NOT INITIAL THEN lv_email
                                                           ELSE 'Mahendra.Gulla@ibsolution.de'    )
                         ).
*                     CATCH cx_address_bcs.
*                  CATCH cx_address_bcs.
    lo_bcs->add_recipient(
      EXPORTING
        i_recipient  = lo_recipient
*    i_express    =
*    i_copy       =
*    i_blind_copy =
*    i_no_forward =
    ).

    lo_bcs->set_send_immediately( i_send_immediately = abap_true  ).
    DATA(did_we_send_email) = lo_bcs->send( i_with_error_screen = 'X' ).
    COMMIT WORK.

*    IF did_we_send_email EQ abap_false.
*      MESSAGE i500(sbcoms) WITH 'Mahendra:Gulla@ibsolution.de'."Document notsentto&1
*    ELSE.
*      MESSAGE s022(so)."Document sent
*      "kick offthesendjobsotheemailgoesoutimmediately
*      WAIT UP TO 2 SECONDS. "ensure themailhasbeenqueued
*      SUBMIT rsconn01
*      WITH mode = '*' "process everythingyoufind.
*      WITH output = ''
*      AND RETURN.
*    ENDIF.
*




  ENDMETHOD.


  METHOD send_email_requester.

    DATA(lo_email_api) = cl_smtg_email_api=>get_instance(
                       iv_template_id    = 'ZCREQUEST_STATUS_ACTIVE'
*                       is_email_template =
                     ).
*                     CATCH cx_smtg_email_common.
    DATA(lo_bcs) = cl_bcs=>create_persistent( ).
*               CATCH cx_send_req_bcs.
    TRY.
        lo_email_api->render_bcs(
          EXPORTING
            io_bcs      = lo_bcs
            iv_language = sy-langu
            it_data_key = VALUE #( ( name = 'crequest'  value = im_crequest ) )
        ).
      CATCH cx_smtg_email_common INTO DATA(lx).
        DATA(lv_txt) = lx->get_text( ).
    ENDTRY.

    DATA(lo_sender) = cl_sapuser_bcs=>create( i_user = sy-uname ).
    lo_bcs->set_sender( i_sender =  lo_sender ).
*CATCH cx_send_req_bcs.


*    DATA(lo_recipient) = cl_sapuser_bcs=>create( im_user ).
    SELECT SINGLE FROM zi_crequest_mail_u FIELDS Email WHERE ChangeRequest = @im_crequest
                                                        INTO @DATA(lv_email).

    DATA(lo_recipient) = cl_cam_address_bcs=>create_internet_address(
                           i_address_string =    COND #(   WHEN lv_email IS NOT INITIAL THEN lv_email
                                                           ELSE 'Mahendra.Gulla@ibsolution.de'    )
                         ).

*                     CATCH cx_address_bcs.
*                  CATCH cx_address_bcs.
    lo_bcs->add_recipient(
      EXPORTING
        i_recipient  = lo_recipient
*    i_express    =
*    i_copy       =
*    i_blind_copy =
*    i_no_forward =
    ).

    lo_bcs->set_send_immediately( i_send_immediately = abap_true  ).
    DATA(did_we_send_email) = lo_bcs->send( i_with_error_screen = 'X' ).
    COMMIT WORK.

  ENDMETHOD.
ENDCLASS.
