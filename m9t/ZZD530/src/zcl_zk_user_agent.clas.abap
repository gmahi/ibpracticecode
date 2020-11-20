CLASS zcl_zk_user_agent DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_usmd_ssw_dynamic_agt_select .
  PROTECTED SECTION.
  PRIVATE SECTION.



ENDCLASS.



CLASS ZCL_ZK_USER_AGENT IMPLEMENTATION.


  METHOD if_usmd_ssw_dynamic_agt_select~get_dynamic_agents.

DO .
ENDDO.

    CASE iv_service_name.
      WHEN 'ZS_DYN_AGENT_ZK'.

        SELECT SINGLE FROM I_MDGovChangeRequestBasic FIELDS MDGovChgReqCreatedByUser WHERE MDGovChangeRequest = @iv_cr_number
                                                                INTO @DATA(lv_created_by).
        READ TABLE   ct_user_agent_group INDEX 1 ASSIGNING FIELD-SYMBOL(<ls_user_agent_group>).
        LOOP AT <ls_user_agent_group>-user_agent ASSIGNING FIELD-SYMBOL(<user_agent>) WHERE user_type = 'US'.
          IF  <user_agent>-user_value = 'DUMMY'.
            <user_agent>-user_value = lv_created_by.
          ENDIF.
          IF cv_new_cr_status = '02'.
            NEW zcl_zk_email(  )->send_email_processor(
              EXPORTING
                im_user     =  CONV #(  <user_agent>-user_value )
                im_crequest = iv_cr_number
            ).
          ENDIF.

        ENDLOOP.






*     Read the one and only material of the CR
*      CALL METHOD read_material
*        EXPORTING
*          iv_cr_number = iv_cr_number
*        IMPORTING
*          es_material  = ls_material.
**     Read users for the material group from customer Z table
**     If none found, exit
**>>>      SELECT * FROM zmatkl_user
**>>>        INTO CORRESPONDING FIELDS OF TABLE lt_matkl_user
**>>>        WHERE matkl = ls_material-matkl.
*      CHECK NOT lt_matkl_user IS INITIAL.
**     Move found users to result table
*      ls_user_agent_group-agent_group = 1.
*      ls_user_agent_group-step_type   = '5'. " Activate
*      LOOP AT lt_matkl_user INTO ls_matkl_user.
*        CLEAR: ls_user_agent.
*        ls_user_agent-user_type  = 'US'.
*        ls_user_agent-user_value = ls_matkl_user-agent.
*        APPEND ls_user_agent TO ls_user_agent_group-user_agent.
*      ENDLOOP.
*      APPEND ls_user_agent_group TO ct_user_agent_group.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
