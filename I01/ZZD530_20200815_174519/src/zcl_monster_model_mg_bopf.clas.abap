CLASS zcl_monster_model_mg_bopf DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor RAISING zcx_monster_exceptions.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: mo_transaction_manager TYPE REF TO /bobf/if_tra_transaction_mgr,
          mo_service_manager     TYPE REF TO /bobf/if_tra_service_manager,
          mo_object_configration TYPE REF TO /bobf/if_frw_configuration,
          mo_bobf_pl_helper      TYPE REF TO zcl_bc_bopf_pl_helper.
ENDCLASS.



CLASS zcl_monster_model_mg_bopf IMPLEMENTATION.

  METHOD constructor.
    TRY.
        mo_transaction_manager = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).

        mo_service_manager    = /bobf/cl_tra_serv_mgr_factory=>get_service_manager(
                                  iv_bo_key                     = zif_bo_monster_c=>sc_bo_key ).

        mo_object_configration  = /bobf/cl_frw_factory=>get_configuration( iv_bo_key = zif_bo_monster_c=>sc_bo_key ).



        mo_bobf_pl_helper = NEW #( io_object_configuration = mo_object_configration
                                   io_service_manager     = mo_service_manager
                                   io_transaction_manager = mo_transaction_manager
                                                                                       ).


      CATCH /bobf/cx_frw INTO DATA(bobf_exception).

        RAISE EXCEPTION TYPE zcx_monster_exceptions
          EXPORTING
            textid = bobf_exception->if_t100_message~t100key.

    ENDTRY.


  ENDMETHOD.

ENDCLASS.
