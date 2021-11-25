*&---------------------------------------------------------------------*
*& Include          ZCOR0460SCR
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* SCREEN 1000
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK BL1 WITH FRAME TITLE TEXT-T01.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(12) TEXT-001 FOR FIELD PA_KOKRS.
SELECTION-SCREEN POSITION 33.
PARAMETERS: PA_KOKRS TYPE KOKRS OBLIGATORY
                                MATCHCODE OBJECT CSH_TKA01
                                DEFAULT '1000'.
SELECTION-SCREEN COMMENT 45(20) PA_KTXT.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(12) TEXT-002 FOR FIELD PA_BUKRS.
SELECTION-SCREEN POSITION 33.
PARAMETERS  PA_BUKRS TYPE BUKRS  DEFAULT '1900' OBLIGATORY MEMORY ID BUK.
SELECTION-SCREEN COMMENT 45(20) PA_BUTXT.
SELECTION-SCREEN END OF LINE.


PARAMETERS  PA_MONTH TYPE SPMON DEFAULT SY-DATUM(6) OBLIGATORY.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(12) TEXT-003 FOR FIELD PA_WERKS.
SELECTION-SCREEN POSITION 33.
PARAMETERS : PA_WERKS TYPE WERKS_D OBLIGATORY MATCHCODE OBJECT  ZCO_1900PLANT_SH.

SELECTION-SCREEN COMMENT 45(20) PA_WENM .
SELECTION-SCREEN END OF LINE.

*
*SELECTION-SCREEN BEGIN OF LINE.
*SELECTION-SCREEN COMMENT 1(12) TEXT-011 FOR FIELD SO_FMAT.
*SELECTION-SCREEN POSITION 30.
*SELECT-OPTIONS : SO_FMAT FOR mara-matnr .

*SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK BL1.

**SELECTION-SCREEN BEGIN OF BLOCK BL2 WITH FRAME TITLE TEXT-T02.
**
**SELECTION-SCREEN BEGIN OF LINE.
**SELECTION-SCREEN COMMENT (03) TEXT-009.
**PARAMETER : P_RA1 RADIOBUTTON GROUP RB1  DEFAULT 'X'
**                    USER-COMMAND RDO.
**SELECTION-SCREEN COMMENT (35) TEXT-R01 FOR FIELD P_RA1.
**PARAMETER : P_RA2 RADIOBUTTON GROUP RB1 .
**SELECTION-SCREEN COMMENT (35) TEXT-R02 FOR FIELD P_RA2.
**SELECTION-SCREEN END OF LINE.
***SELECTION-SCREEN SKIP.
**SELECTION-SCREEN END OF BLOCK BL2.

PARAMETERS : P_MODE TYPE RFPDO-ALLGAZMD DEFAULT 'N'.
**
**SELECTION-SCREEN SKIP 1 .
**
**PARAMETERS : P_CHK  AS CHECKBOX DEFAULT 'X'.


SELECTION-SCREEN FUNCTION KEY 1.
SELECTION-SCREEN FUNCTION KEY 2.
