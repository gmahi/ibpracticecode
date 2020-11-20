*&---------------------------------------------------------------------*
*& Report zr_excel_import_export
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr_excel_import_export.

 Include zr_excle_import_export_inc.

SELECTION-SCREEN BEGIN OF BLOCK b04 WITH FRAME TITLE TEXT-b04.
  PARAMETERS  p_exp RADIOBUTTON GROUP radi USER-COMMAND action DEFAULT 'X'.
  PARAMETERS  p_imp RADIOBUTTON GROUP radi.
SELECTION-SCREEN END OF BLOCK b04.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01.
  PARAMETERS p_table TYPE dd02l-tabname MODIF ID gp1 OBLIGATORY MEMORY ID ht.
  PARAMETERS p_file TYPE localfile MODIF ID gp2 OBLIGATORY MEMORY ID hf.
  PARAMETERS p_sql TYPE string MODIF ID gp3.
  SELECTION-SCREEN COMMENT /1(75) comm.
SELECTION-SCREEN END OF BLOCK b01.

INITIALIZATION.
  comm = `e.g. RLDNR = 'Y1' AND RRCTY = 'U'`.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
*  call function 'F4_FILENAME'
*    exporting
*      field_name = 'P_FILE'
*    importing
*      file_name  = p_file.

  DATA(title) = |Select Excel File, e.g. *.xlsx|.
  DATA(defaultextension) = |.xlsx|.
  DATA(filefilter) = `Excel Files (*.xlsx)|*.xlsx`.
  DATA it_tab TYPE filetable.
  DATA returncode TYPE i.

  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      window_title      = title
      default_extension = defaultextension
*     default_filename  =
*     file_filter       = filefilter
*     with_encoding     =
*     initial_directory =
*     multiselection    =
    CHANGING
      file_table        = it_tab
      rc                = returncode
*     user_action       =
*     file_encoding     =
*    exceptions
*     file_open_dialog_failed = 1
*     cntl_error        = 2
*     error_no_gui      = 3
*     not_supported_by_gui    = 4
*     others            = 5
    .
  IF sy-subrc <> 0.
*   Implement suitable error handling here
  ENDIF.

  READ TABLE it_tab ASSIGNING FIELD-SYMBOL(<selectedfilename>) INDEX 1.
  IF sy-subrc = 0.
    p_file = <selectedfilename>-filename.
  ENDIF.

  start-of-selection.
  try.
      data(configurationhandler) =  new lcl_configuration( filefullpath = conv #( p_file )
                                                           tablename = conv #( p_table )
                                                           sqlscript = p_sql  ).
      if p_exp = abap_true.
        configurationhandler->export( ).
      else.
        configurationhandler->import( ).
      endif.
    catch lcx_configuration into data(configurationexception).
      write: / configurationexception->local_text.
  endtry.
