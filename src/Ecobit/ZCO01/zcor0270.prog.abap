*&--------------------------------------------------------------------&*
*& PROGRAM ID  : ZCOR0270                                             &*
*& Title       : [CO] CCTR 계획 수정                                  &*
*& Created By  : BSGABAP8                                             &*
*& Created On  : 2019.08.29                                           &*
*& Description : [CO] CCTR 계획 수정                                  &*
*----------------------------------------------------------------------*
* MODIFICATION LOG
*----------------------------------------------------------------------*
* Tag  Date.       Author.     Description.
*----------------------------------------------------------------------*
* N    2019.08.29  BSGABAP8    INITIAL RELEASE
* U    20201.03.25  BSGSM_FCM   ZCOT03320  CBO 권한 체크 로직 추가
*----------------------------------------------------------------------*
REPORT zcor0270 MESSAGE-ID zco01.

INCLUDE zcor0270t01.    "Top
INCLUDE zcor0270alv.    "Alv
INCLUDE zcor0270scr.    "Screen - Condition screen
INCLUDE zcor0270o01.    "Process Befor Output
INCLUDE zcor0270i01.    "Process After Input
INCLUDE zcor0270f01.    "Form

*---------------------------------------------------------------------*
INITIALIZATION.
*---------------------------------------------------------------------*
  PERFORM initail.
  PERFORM set_init_help.

*---------------------------------------------------------------------*
AT SELECTION-SCREEN.
*---------------------------------------------------------------------*
  PERFORM scr_user_command_help.

*---------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.
*---------------------------------------------------------------------*
  PERFORM set_screen.

*---------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_ksgru.
*---------------------------------------------------------------------*
  PERFORM f4_ksgru CHANGING pa_ksgru.   "코스트센터 그룹

*---------------------------------------------------------------------*
AT SELECTION-SCREEN ON BLOCK bl1.
*---------------------------------------------------------------------*
  PERFORM check_bl1.

*----------------------------------------------------------------------*
START-OF-SELECTION.
*----------------------------------------------------------------------*
  PERFORM selected_data_rtn.
  CALL SCREEN 0100.
