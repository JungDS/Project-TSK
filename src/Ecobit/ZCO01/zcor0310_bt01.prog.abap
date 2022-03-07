*&---------------------------------------------------------------------*
*& Include          ZCOR0310T01
*&---------------------------------------------------------------------*
TYPE-POOLS : ICON,ABAP.

TABLES : SSCRFIELDS, "선택화면의 필드(Function Key)
         CSKS,
         T001,
         TKA01,
         TKA02,
         TKA05,
         TCURC,
         CEPC.

*---------------------------------------------------------------------*
* CONSTANTS
*---------------------------------------------------------------------*
CONSTANTS : GC_LZONE TYPE LZONE    VALUE '0000000001',
            GC_A     TYPE CHAR01   VALUE 'A',
            GC_S     TYPE CHAR01   VALUE 'S',
            GC_E     TYPE CHAR01   VALUE 'E',
            GC_X     TYPE CHAR01   VALUE 'X',
            GC_N     TYPE CHAR01   VALUE 'N',
            GC_TCODE TYPE SY-TCODE VALUE 'KS01'.

*---------------------------------------------------------------------*
* TYPES
*---------------------------------------------------------------------*
* - Prefix 정의
*   1. TY_  : Global, Local Types

*---------------------------------------------------------------------*
* VARIABLE
*---------------------------------------------------------------------*
* - Prefix 정의
*   1. GV_  : Global Variable
*   2. LV_  : Local Variable

*EX) DATA: GV_EXIT   TYPE C,
*          GV_ANSWER TYPE C,
*          OK_CODE   TYPE SY-UCOMM,   "예외
*          SAVE_OK   TYPE SY-UCOMM.   "예외

DATA: GV_EXIT TYPE C,
      OK_CODE TYPE SY-UCOMM,   "예외
      SAVE_OK TYPE SY-UCOMM.   "예외

DATA: GV_TOTAL  TYPE C LENGTH 30,
      GV_SUCESS TYPE C LENGTH 30,
      GV_ERROR  TYPE C LENGTH 30.

DATA GV_ANSWER.

DATA GV_MESSAGE TYPE C LENGTH 100.

DATA: G_VALID TYPE C.
DATA: LS_TOOLBAR TYPE STB_BUTTON.

TYPES: BEGIN OF TY_LAYOUT,
         REPID    TYPE SYREPID,
         RESTRICT TYPE SALV_DE_LAYOUT_RESTRICTION,
         DEFAULT  TYPE SAP_BOOL,
         LAYOUT   TYPE DISVARIANT-VARIANT,
       END OF TY_LAYOUT.

DATA: GO_ALV        TYPE REF TO CL_SALV_TABLE,
      GO_FUNCTIONS  TYPE REF TO CL_SALV_FUNCTIONS_LIST,
      GO_LAYOUT     TYPE REF TO CL_SALV_LAYOUT,
      GO_DSPSET     TYPE REF TO CL_SALV_DISPLAY_SETTINGS,
      GS_KEY        TYPE SALV_S_LAYOUT_KEY,
      GT_COLUMN_REF TYPE SALV_T_COLUMN_REF.


DATA GS_COLOR  TYPE LVC_S_COLO.

DATA GR_COLUMN TYPE REF TO CL_SALV_COLUMN_TABLE.

DATA: GT_ROWS TYPE SALV_T_ROW,
      GS_ROW  TYPE INT4.  "ALV position 기억

DATA: GV_COLUMN_TEXT TYPE STRING,
      GV_SCRTEXT_S   TYPE SCRTEXT_S,
      GV_SCRTEXT_M   TYPE SCRTEXT_M,
      GV_SCRTEXT_L   TYPE SCRTEXT_L.

DATA: GS_SALV_LAYOUT TYPE TY_LAYOUT.
DATA  GV_REPID TYPE SYREPID.

DATA: GT_INTERN LIKE TABLE OF ALSMEX_TABLINE WITH HEADER LINE.

DATA GT_RETURN TYPE TABLE OF BAPIRET2 WITH HEADER LINE.

DATA GV_COUNT TYPE I.

DATA GV_KTOPL TYPE KTOPL VALUE '1000'.

*---------------------------------------------------------------------*
* STRUCTURE
*---------------------------------------------------------------------*
DATA : GS_FUNTXT TYPE SMP_DYNTXT. "Excel 양식 Download(펑션키)

*---------------------------------------------------------------------*
* INTERNAL TABLE
*---------------------------------------------------------------------*
DATA : BEGIN OF GS_OUTTAB ,
         STATUS(1),
         ICON         LIKE ICON-ID,
         PBUKR        LIKE T001-BUKRS,
         POSID        LIKE PRPS-POSID, "WBS
         POST1        LIKE PRPS-POST1, "WBS 내역
         RKSTAR       LIKE CSKA-KSTAR, "원가요소
         KTEXT        LIKE CSKU-KTEXT, "원가요소 내역
         RTCUR        LIKE COSP-TWAER,
         RYEAR        TYPE GJAHR,
         ROBJNR       TYPE J_OBJNR,
         HSL01        TYPE HSLXX9_CS,
         HSL02        TYPE HSLXX9_CS,
         HSL03        TYPE HSLXX9_CS,
         HSL04        TYPE HSLXX9_CS,
         HSL05        TYPE HSLXX9_CS,
         HSL06        TYPE HSLXX9_CS,
         HSL07        TYPE HSLXX9_CS,
         HSL08        TYPE HSLXX9_CS,
         HSL09        TYPE HSLXX9_CS,
         HSL10        TYPE HSLXX9_CS,
         HSL11        TYPE HSLXX9_CS,
         HSL12        TYPE HSLXX9_CS,
         SUM          TYPE HSLXX9_CS,
         MESSAGE(100),
         CELLTYPE     TYPE SALV_T_INT4_COLUMN,
       END OF GS_OUTTAB.

DATA : BEGIN OF GS_EXCEL,
         PBUKR  LIKE T001-BUKRS,
         POSID  LIKE PRPS-POSID, "WBS
         POST1  LIKE PRPS-POST1,
         RKSTAR LIKE CSKA-KSTAR, "원가요소
         KTEXT  TYPE C LENGTH 30,
         RTCUR  LIKE COSP-TWAER,
         RYEAR  TYPE GJAHR,
         HSL01  TYPE C LENGTH 30,
         HSL02  TYPE C LENGTH 30,
         HSL03  TYPE C LENGTH 30,
         HSL04  TYPE C LENGTH 30,
         HSL05  TYPE C LENGTH 30,
         HSL06  TYPE C LENGTH 30,
         HSL07  TYPE C LENGTH 30,
         HSL08  TYPE C LENGTH 30,
         HSL09  TYPE C LENGTH 30,
         HSL10  TYPE C LENGTH 30,
         HSL11  TYPE C LENGTH 30,
         HSL12  TYPE C LENGTH 30.
DATA :END OF GS_EXCEL.

DATA : GT_OUTTAB LIKE TABLE OF GS_OUTTAB,
       GT_EXCEL  LIKE TABLE OF GS_EXCEL       WITH HEADER LINE.

DATA A TYPE BAPICURR_D.

*---------------------------------------------------------------------*
* RANGES
*---------------------------------------------------------------------*
* - Prefix 정의
*   1. R_  : Global, Local Ranges

* EX) RANGES: R_FKART  FOR VBRK-FKART,
*             GS_FKDAT LIKE LINE OF R_FKART.
*---------------------------------------------------------------------*
* FIELD-SYMBOLS
*---------------------------------------------------------------------*
* - Prefix 정의
*   1. <FS_  >  : Global, Local Field-symbols

* EX) FIELD-SYMBOLS <FS_SFLIGHT> TYPE SFLIGHT.


*---------------------------------------------------------------------*
* MACRO (Define)
*---------------------------------------------------------------------*
* - Prefix 정의
*   1. _ : '_' 1개로 시작; Global, Local 구분 없음.
DEFINE _INITIAL_CHK.
  IF &1 IS INITIAL.
  GS_OUTTAB-STATUS    = 'E'.
  GV_MESSAGE          = &2.
  ENDIF.
END-OF-DEFINITION.

DEFINE _CONVERSION_IN.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
  EXPORTING
  input = &1
  IMPORTING
  output = &1.
END-OF-DEFINITION.

DEFINE _CONVERSION_WBS_IN.
  CALL FUNCTION 'CONVERSION_EXIT_ABPSN_INPUT'
  EXPORTING
  input = &1
  IMPORTING
  output = &1.
END-OF-DEFINITION.

DEFINE _CONVERSION_WBS_OUT.
  CALL FUNCTION 'CONVERSION_EXIT_ABPSN_OUTPUT'
  EXPORTING
  input = &1
  IMPORTING
  output = &1.
END-OF-DEFINITION.

DEFINE _CONVERSION_OUT.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
  EXPORTING
  input = &1
  IMPORTING
  output = &1.
END-OF-DEFINITION.

DEFINE _CLEAR.
  CLEAR &1. REFRESH &1.
END-OF-DEFINITION.

DEFINE _MAKEICON.

  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      NAME                  = &1
      INFO                  = &2
    IMPORTING
      RESULT                = &3
    EXCEPTIONS
      ICON_NOT_FOUND        = 1
      OUTPUTFIELD_TOO_SHORT = 2
      OTHERS                = 3.

END-OF-DEFINITION.

DEFINE _SET_COLOR.

  GS_COLOR-COL = &1.
  GS_COLOR-INT = &2.
  GS_COLOR-INV = &3.

END-OF-DEFINITION.

DEFINE _STRING_REPLACE.

  IF &1 IS NOT INITIAL.

  CALL FUNCTION 'STRING_REPLACE'
    EXPORTING
      PATTERN    = ','
      SUBSTITUTE = ''
    CHANGING
      TEXT       = &1.

 CONDENSE  &1.

  TRY.

    MOVE &1 TO A.

    CATCH CX_SY_CONVERSION_NO_NUMBER INTO DATA(ERR).

      GS_OUTTAB-STATUS =  'E'.
      GS_OUTTAB-MESSAGE = TEXT-E04.

      CLEAR  &1.

  ENDTRY.

 ENDIF.

END-OF-DEFINITION.
DEFINE _CURR_INPUT.
  WRITE &1 CURRENCY 'KRW' TO &2.
  CONDENSE &2.
END-OF-DEFINITION.

DEFINE _CONV_KRW.
  IF &1 IS NOT INITIAL .
    &1 = &1 / 100.
  ENDIF.
END-OF-DEFINITION.

*---------------------------------------------------------------------*
* Table Controls
*---------------------------------------------------------------------*
* - Prefix 정의
*   1. TC_ : Table Controls

*---------------------------------------------------------------------*
* Custom Controls
*---------------------------------------------------------------------*
* - Prefix 정의
*   1. CC_ : Custom Controls

*---------------------------------------------------------------------*
* Tabstrip Controls
*---------------------------------------------------------------------*
* - Prefix 정의
*   1. TS_ : Tabstrip Controls
