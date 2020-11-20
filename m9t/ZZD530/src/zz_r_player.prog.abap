*&---------------------------------------------------------------------*
*& Report zz_r_player
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zz_r_player.

CLASS player DEFINITION.
  PUBLIC SECTION.
    METHODS constructor IMPORTING name TYPE string
    weight TYPE p height TYPE i.
    METHODS display_player_details.
  PROTECTED SECTION.
    DATA : name TYPE string.
    DATA : height TYPE i.
    DATA : weight TYPE p DECIMALS 2.
ENDCLASS.
CLASS player IMPLEMENTATION.
  METHOD constructor .
    me->name = name.
    me->height = height.
    me->weight = weight.
  ENDMETHOD.
  METHOD display_player_details.
    WRITE :/ 'Player Name: ',15 me->name ,
    / 'Height : ',15 me->height LEFT-JUSTIFIED ,
    / 'Weight :',15 me->weight LEFT-JUSTIFIED.
  ENDMETHOD.
ENDCLASS.

CLASS football_player DEFINITION INHERITING
FROM player.
  PUBLIC SECTION.
    METHODS constructor IMPORTING
                          name          TYPE string
                          weight        TYPE p
                          height        TYPE i
                          football_club TYPE string.
    METHODS display_player_details REDEFINITION.
    EVENTS : player_created .
  PRIVATE SECTION.
    DATA : football_club TYPE string.
ENDCLASS.
CLASS football_player IMPLEMENTATION.
  METHOD constructor.
    CALL METHOD super->constructor
      EXPORTING
        name   = name
        weight = weight
        height = height.
    me->football_club = football_club.
    RAISE EVENT player_created.
  ENDMETHOD .
  METHOD display_player_details.
    CALL METHOD super->display_player_details.
    WRITE:/ 'Club Name : ',15 me->football_club.
  ENDMETHOD .
ENDCLASS.
CLASS myhandlerclass DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS myhandler FOR EVENT player_created
    OF football_player IMPORTING sender.
ENDCLASS.
CLASS myhandlerclass IMPLEMENTATION.
  METHOD myhandler.
    WRITE : 'Event Handler Executed'.
    CALL METHOD sender->display_player_details.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DATA : myfootball_player TYPE REF TO football_player.
  SET HANDLER myhandlerclass=>myhandler FOR ALL INSTANCES.
  CREATE OBJECT myfootball_player
    EXPORTING
      name          = 'Oliver Kahn'
      weight        = '95'
      height        = '188'
      football_club = 'Bayern Munich'.
