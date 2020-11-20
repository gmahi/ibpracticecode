*&---------------------------------------------------------------------*
*& Report ztable_desriptions
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztable_desriptions.

*DATA lt_data type STANDARD TABLE OF /mdgmm/_s_mm_pp_classasgn.
*
*DATA(components) =
*  CAST cl_abap_structdescr(
*       cl_abap_typedescr=>describe_by_name( '/mdgmm/_s_mm_pp_classasgn' )
*       )->components.
*
*      cl_demo_output=>display(
*        EXPORTING
*          data = components
**          name =
*      ).

SELECT SINGLE * FROM I_BusinessPartnerSupplier INTO @DATA(ls_bps) .

WRITE: ls_bps-BusinessPartner.
