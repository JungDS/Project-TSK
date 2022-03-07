*&--------------------------------------------------------------------*
*& Report ZCOR0310
*&--------------------------------------------------------------------*
*&-------------------------------------------------------------------&*
*& PROGRAM ID  : ZCOR0310                                            &*
*& Title       : [CO] WBS 과거 실적데이터 마이그레이션                *
*& Created By  : BSGABAP4                                            &*
*& Created On  : 2019.09.03                                          &*
*& Description :                                                     &*
*---------------------------------------------------------------------*
* MODIFICATION LOG
*---------------------------------------------------------------------*
*---------------------------------------------------------------------*
REPORT ZCOR0310_B MESSAGE-ID ZCO01.

INCLUDE ZCOR0310_BT01.
*INCLUDE ZCOR0310T01.   " TOP-Decration
INCLUDE ZCOR0310_BALV.
*INCLUDE ZCOR0310ALV.   " Class ALV OR Others
INCLUDE ZCOR0310_BSCR.
*INCLUDE ZCOR0310SCR.   " Selection-Screen
INCLUDE ZCOR0310_BF01.
*INCLUDE ZCOR0310F01.   " Subroutine

*---------------------------------------------------------------------*
INITIALIZATION.
*---------------------------------------------------------------------*
  PERFORM INITAIL.
  PERFORM SCRFIELDS_FUNCTXT.

*---------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.
*---------------------------------------------------------------------*
  PERFORM SET_SCREEN.

*---------------------------------------------------------------------*
AT SELECTION-SCREEN.
*---------------------------------------------------------------------*
  PERFORM SCR_USER_COMMAND. "양식 Download

*---------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR PA_FILE.
*---------------------------------------------------------------------*
  PERFORM F4_FILE CHANGING PA_FILE.

*---------------------------------------------------------------------*
AT SELECTION-SCREEN ON BLOCK B1.
*---------------------------------------------------------------------*
  PERFORM CHECK_CONTROLLING_AREA.

*---------------------------------------------------------------------*
START-OF-SELECTION.
*---------------------------------------------------------------------*
  PERFORM EXCEL_UPLOAD_EXEC.
  CHECK GV_EXIT IS INITIAL.
  PERFORM DATA_CONVERT.

  PERFORM SALV_CALL.

*---------------------------------------------------------------------*
END-OF-SELECTION.
*---------------------------------------------------------------------*
