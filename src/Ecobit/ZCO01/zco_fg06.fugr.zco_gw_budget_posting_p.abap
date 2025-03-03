FUNCTION ZCO_GW_BUDGET_POSTING_P .
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(I_GWKEY) TYPE  ZEGWKEY
*"  EXPORTING
*"     REFERENCE(E_RESULT) TYPE  CHAR1
*"     REFERENCE(E_MSG) TYPE  CHAR255
*"     REFERENCE(E_BELNR) TYPE  BELNR_D
*"----------------------------------------------------------------------

  DATA: LV_MESSAGE TYPE STRING.

  DATA LV_MONTH TYPE N LENGTH 2.

  FIELD-SYMBOLS: <FS1>    TYPE ANY,
                 <FS_HSL> TYPE ANY.

  DATA LS_HEADERINFO  LIKE  BAPIPLNHDR.
  DATA LS_RETURN TYPE BAPIRET2.

  DATA LV_FNAME TYPE FIELDNAME.

  DATA : LT_INDEXSTRUCTURE LIKE BAPIACPSTRU OCCURS 0 WITH HEADER LINE,
         LT_COOBJECT       LIKE BAPIPCPOBJ  OCCURS 0 WITH HEADER LINE,
         LT_PERVALUE       LIKE BAPIPCPVAL  OCCURS 0 WITH HEADER LINE.

  DATA LT_ZCOT0040 TYPE TABLE OF ZCOT0040 WITH HEADER LINE.
  DATA LT_RETURN TYPE TABLE OF BAPIRET2 WITH HEADER LINE.

  DATA LV_BELNR TYPE BELNR_D.
  DATA LV_SEQ   TYPE ZERSEQ.

  CLEAR: LS_HEADERINFO, LT_INDEXSTRUCTURE,
                        LT_INDEXSTRUCTURE[],
                        LT_COOBJECT,
                        LT_COOBJECT[],
                        LT_PERVALUE,
                        LT_PERVALUE[].

  SELECT A~GWKEY,  A~GWTYP,   B~RSEQ,      B~RLDNR,
         B~RRCTY,  B~RVERS,   B~RYEAR,     B~ROBJNR,
         B~RKOKRS, B~RKSTAR,  B~PROCESS_9, B~BUDTYPE_9,
         B~RTCUR,  B~FAMOUNT, B~HSLVT,     B~HSL01, B~HSL02,
         B~HSL03,  B~HSL04,   B~HSL05,     B~HSL06, B~HSL07,
         B~HSL08,  B~HSL09,   B~HSL10,     B~HSL11, B~HSL12
    INTO TABLE @DATA(LT_ZCOT1200)
    FROM ZCOT1190 AS A
    INNER JOIN ZCOT1200 AS B
      ON A~GWKEY = B~GWKEY
   WHERE A~GWKEY = @I_GWKEY
     AND A~GWSTS = 'A0'.

  IF SY-SUBRC <> 0.
    E_RESULT = 'E'.
    MESSAGE S004(ZCO01) INTO E_MSG.
    EXIT.
  ENDIF.

  READ TABLE LT_ZCOT1200 INTO DATA(LS_ZCOT1200) INDEX 1.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      NR_RANGE_NR             = '01'
      OBJECT                  = 'ZCO_DOCNR'
      TOYEAR                  = LS_ZCOT1200-RYEAR
    IMPORTING
      NUMBER                  = LV_BELNR
    EXCEPTIONS
      INTERVAL_NOT_FOUND      = 1
      NUMBER_RANGE_NOT_INTERN = 2
      OBJECT_NOT_FOUND        = 3
      QUANTITY_IS_0           = 4
      QUANTITY_IS_NOT_1       = 5
      INTERVAL_OVERFLOW       = 6
      BUFFER_OVERFLOW         = 7
      OTHERS                  = 8.

  IF SY-SUBRC <> 0.
    E_RESULT = 'E'.
    MESSAGE S001 WITH TEXT-E03 INTO E_MSG.
    EXIT.
  ENDIF.

  _CONVERSION_IN LV_BELNR.

*-- Header Data
  LS_HEADERINFO-CO_AREA     = LS_ZCOT1200-RKOKRS.   "관리 회계영역
  LS_HEADERINFO-FISC_YEAR   = LS_ZCOT1200-RYEAR.    "회계연도
  LS_HEADERINFO-PERIOD_FROM = '001'.                "기간 시작
  LS_HEADERINFO-PERIOD_TO   = '012'.                "기간 종료
  LS_HEADERINFO-VERSION     = LS_ZCOT1200-RVERS.    "버전

*-- 전표 헤더 텍스트
  LS_HEADERINFO-PLAN_CURRTYPE = 'C'. "통화

*-- CO-계획: 액티비티투입 & 주요지표 계획 BAPIs
  LT_INDEXSTRUCTURE-OBJECT_INDEX = 1.
  LT_INDEXSTRUCTURE-VALUE_INDEX  = 1.
  APPEND LT_INDEXSTRUCTURE.

*-- CO 계획: 1차 원가 BAPI에 대한 오브젝트
  LT_COOBJECT-OBJECT_INDEX  = 1.

  CASE LS_ZCOT1200-ROBJNR(2).

    WHEN 'KS'.
      LT_COOBJECT-COSTCENTER    = LS_ZCOT1200-ROBJNR+6.

    WHEN 'PR'.
      SELECT SINGLE POSID INTO LT_COOBJECT-WBS_ELEMENT
        FROM PRPS
       WHERE OBJNR = LS_ZCOT1200-ROBJNR.

  ENDCASE.

  APPEND LT_COOBJECT.

*-- CO 계획: 1차 원가 BAPI에 대한 값
  LT_PERVALUE-VALUE_INDEX  = 1.
  LT_PERVALUE-COST_ELEM    = LS_ZCOT1200-RKSTAR.   "원가요소
  LT_PERVALUE-TRANS_CURR   = 'KRW'.

  LOOP AT LT_ZCOT1200 INTO LS_ZCOT1200.

    LT_PERVALUE-VALUE_INDEX  = 1.
    LT_PERVALUE-COST_ELEM    = LS_ZCOT1200-RKSTAR.   "원가요소
    LT_PERVALUE-TRANS_CURR   = 'KRW'.

*-- CBO 저장 데이터
    MOVE-CORRESPONDING LS_ZCOT1200 TO LT_ZCOT0040.

    MOVE: '00'                  TO LT_ZCOT0040-RLDNR,
          '1'                   TO LT_ZCOT0040-RRCTY,
          LV_BELNR              TO LT_ZCOT0040-RDOCNR,
          'BT01'                TO LT_ZCOT0040-BUDTYPE_9,
          SY-UZEIT              TO LT_ZCOT0040-CPUTM,
          SY-DATUM              TO LT_ZCOT0040-CPUDT,
          SY-UNAME              TO LT_ZCOT0040-USNAM.

    APPEND  LT_ZCOT0040.
    CLEAR   LT_ZCOT0040.

    CLEAR LV_MONTH.

    DO 12 TIMES.

      ADD 1 TO LV_MONTH.

      LV_FNAME = 'LS_ZCOT1200-HSL' && LV_MONTH.
      ASSIGN (LV_FNAME) TO <FS_HSL>.

      LV_FNAME = 'FIX_VAL_PER' && LV_MONTH.
      ASSIGN COMPONENT LV_FNAME OF STRUCTURE LT_PERVALUE
         TO FIELD-SYMBOL(<FS_PER>).

      <FS_PER> = <FS_HSL>.
      <FS_PER> = <FS_PER> * '100'.

    ENDDO.

    COLLECT LT_PERVALUE.
    CLEAR   LT_PERVALUE.

  ENDLOOP.

  LOOP AT LT_ZCOT0040.
    ADD 1 TO LV_SEQ.
    MOVE LV_SEQ TO LT_ZCOT0040-RSEQ.
    MODIFY LT_ZCOT0040.
  ENDLOOP.

  CALL FUNCTION 'BAPI_COSTACTPLN_POSTPRIMCOST'
    EXPORTING
      HEADERINFO     = LS_HEADERINFO
      DELTA          = ABAP_TRUE
    TABLES
      INDEXSTRUCTURE = LT_INDEXSTRUCTURE
      COOBJECT       = LT_COOBJECT
      PERVALUE       = LT_PERVALUE
      RETURN         = LT_RETURN.

  READ TABLE LT_RETURN WITH KEY TYPE = 'E'.

  IF SY-SUBRC EQ 0 .

    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    PERFORM BUILD_MESSAGE USING    LT_RETURN
                          CHANGING E_MSG.

    E_RESULT = 'E'.

  ELSE.

    TRY .

        INSERT  ZCOT0040 FROM TABLE LT_ZCOT0040.

        COMMIT WORK.

        MESSAGE S007 INTO E_MSG.

        E_RESULT = 'S'.
        E_BELNR  = LV_BELNR.

      CATCH CX_SY_SQL_ERROR INTO DATA(LR_ERROR).

        ROLLBACK WORK.

        E_RESULT = 'E'.
        LV_MESSAGE = LR_ERROR->GET_TEXT( ).
        MESSAGE S001 WITH LV_MESSAGE INTO E_MSG.

    ENDTRY.

  ENDIF.

ENDFUNCTION.
