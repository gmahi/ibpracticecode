*&---------------------------------------------------------------------*
*& Report ZZD530_GET
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zzd530_get.
TABLES sflight.
SELECT-OPTIONS: s_max FOR sflight-seatsmax,
                s_occ FOR sflight-seatsocc.
GET sflight.
cl_demo_output=>write( | { sflight-carrid }  { sflight-connid }  | ).
CHECK SELECT-OPTIONS.

cl_demo_output=>write( | { sflight-seatsmax }  { sflight-seatsocc }  | ).

END-OF-SELECTION.

  cl_demo_output=>display( ).
