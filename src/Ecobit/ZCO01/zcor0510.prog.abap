*&--------------------------------------------------------------------&*
*& PROGRAM ID  : ZCOR0510                                             &*
*& Title       : [CO] CO 오브젝트 부서코드 매칭 관리                  &*
*& Created By  : BSGSM_FCM                                            &*
*& Created On  : 2021.08.25                                           &*
*& Description : [CO] 예산기준 정보 관리_코스트센터, WBS               &*
*----------------------------------------------------------------------*
* MODIFICATION LOG
*----------------------------------------------------------------------*
* Tag  Date.       Author.     Description.
*----------------------------------------------------------------------*
* N    2021.08.25  BSGSM_FCM   INITIAL RELEASE
*----------------------------------------------------------------------*
REPORT ZCOR0510 MESSAGE-ID ZCO01.

*----------------------------------------------------------------------*
* INCLUDE
*----------------------------------------------------------------------*
INCLUDE ZCOR0510T01.
INCLUDE ZCOR0510ALV.
INCLUDE ZCOR0510SCR.
INCLUDE ZCOR0510O01.
INCLUDE ZCOR0510I01.
INCLUDE ZCOR0510F01.


*----------------------------------------------------------------------*
INITIALIZATION.
*----------------------------------------------------------------------*
  PERFORM INITIAL_SET.
  PERFORM SCRFIELDS_FUNCTXT.

*---------------------------------------------------------------------*
AT SELECTION-SCREEN.
*---------------------------------------------------------------------*
  PERFORM SCR_USER_COMMAND.

*---------------------------------------------------------------------*
AT SELECTION-SCREEN ON BLOCK BL1.
*---------------------------------------------------------------------*
  PERFORM CHECK_CONTROLLING_AREA.

*----------------------------------------------------------------------*
START-OF-SELECTION.
*----------------------------------------------------------------------*
  PERFORM SELECTED_DATA_RTN.
  CALL SCREEN 0100.

*----------------------------------------------------------------------*
END-OF-SELECTION.
*----------------------------------------------------------------------*
