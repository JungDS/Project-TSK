*&---------------------------------------------------------------------*
*& Include          ZCOR0160SCR
*&---------------------------------------------------------------------*

SELECTION-SCREEN FUNCTION KEY 1.

SELECTION-SCREEN: BEGIN OF BLOCK BL1 WITH FRAME TITLE TEXT-T01.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(12) TEXT-001 FOR FIELD PA_KOKRS.
SELECTION-SCREEN POSITION 33.
PARAMETERS: PA_KOKRS TYPE KOKRS MEMORY ID CAC OBLIGATORY
                                MATCHCODE OBJECT CSH_TKA01
                                MODIF ID MG1 DEFAULT '1000'.
SELECTION-SCREEN COMMENT 45(20) PA_KTXT MODIF ID MG1.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(12) TEXT-002 FOR FIELD PA_VERSN.
SELECTION-SCREEN POSITION 33.
PARAMETERS  PA_VERSN TYPE VERSN OBLIGATORY MATCHCODE
                                 OBJECT ZH_TKA09
                                 DEFAULT 'P0'.
SELECTION-SCREEN COMMENT 45(20) PA_VTXT .
SELECTION-SCREEN END OF LINE.

PARAMETERS: PA_PVER TYPE VERSN OBLIGATORY DEFAULT 'V01'
                         MATCHCODE OBJECT ZSH_PVER.
SELECTION-SCREEN COMMENT 45(20) PA_PVERT  .
SELECTION-SCREEN SKIP 1.

*-- 당기
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(12) TEXT-003 FOR FIELD PA_GJAHR.
SELECTION-SCREEN POSITION 33.
PARAMETERS  PA_GJAHR TYPE GJAHR DEFAULT SY-DATUM(4) OBLIGATORY
                                MODIF ID G1.
*
SELECTION-SCREEN COMMENT 40(6) TEXT-004 FOR FIELD PA_SPERL.
SELECTION-SCREEN POSITION 47.
PARAMETERS : PA_SPERL TYPE PERBL DEFAULT '001' OBLIGATORY.

SELECTION-SCREEN COMMENT 53(6) TEXT-005 FOR FIELD PA_EPERL.
SELECTION-SCREEN POSITION 60.
PARAMETERS : PA_EPERL TYPE PERBL DEFAULT '012' OBLIGATORY.
SELECTION-SCREEN END OF LINE.


SELECTION-SCREEN SKIP 1.

SELECT-OPTIONS SO_BUKRS FOR T001-BUKRS MATCHCODE OBJECT ZSH_BUKRS.
SELECT-OPTIONS SO_PRCTR FOR PRPS-PRCTR.
SELECT-OPTIONS SO_PSPID FOR PROJ-PSPID MATCHCODE OBJECT PRS.
SELECT-OPTIONS SO_POSID FOR PRPS-POSID MATCHCODE OBJECT PRP.
PARAMETERS PA_PDGR TYPE POSIDGR.


SELECTION-SCREEN: END OF BLOCK BL1.


*--------------------------------------------------------------------*
* [ESG_CO] DEV_ESG 기존PGM 고도화 #4, 2021.12.06 08:55:57, MDP_06
*--------------------------------------------------------------------*
SELECTION-SCREEN: BEGIN OF BLOCK BL2 WITH FRAME TITLE TEXT-T11.

PARAMETERS PA_EQWBS AS CHECKBOX.

SELECTION-SCREEN: END OF BLOCK BL2.
