*&---------------------------------------------------------------------*
*& Include          ZCOR0370ALV
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
*  Local Class Definition (Program 내부)                               *
*----------------------------------------------------------------------*


CLASS LCL_EVENT_RECEIVER DEFINITION DEFERRED.
*----------------------------------------------------------------------*
*  Reference Varialbles for Class/Interfaces                           *
*----------------------------------------------------------------------*


DATA: GR_CON1           TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      GR_SPLITTER1      TYPE REF TO CL_GUI_SPLITTER_CONTAINER,
      GR_HEAD_CONTAINER TYPE REF TO CL_GUI_CONTAINER,
      GR_DATA_CONTAINER TYPE REF TO CL_GUI_CONTAINER,
      GR_DOCK1          TYPE REF TO CL_GUI_DOCKING_CONTAINER,
      GR_GRID_HEAD      TYPE REF TO CL_GUI_ALV_GRID,
      GR_GRID_DATA      TYPE REF TO CL_GUI_ALV_GRID,
      GR_GRID1          TYPE REF TO CL_GUI_ALV_GRID,
      GR_EVENT_RECEIVER TYPE REF TO LCL_EVENT_RECEIVER,

      "Dynamic Documents: Document
      GR_TOP_DOCUMENT   TYPE REF TO CL_DD_DOCUMENT,
      "Reference to html container
      GR_HTML_CNTRL     TYPE REF TO CL_GUI_HTML_VIEWER,
      "Reference to html container
      GR_PARENT_HTML    TYPE REF TO CL_GUI_CONTAINER.

*----------------------------------------------------------------------*
*  Global Internal Table                                               *
*----------------------------------------------------------------------*

DATA: GT_FIELDCAT TYPE LVC_T_FCAT,
      GT_SORT     TYPE LVC_T_SORT,
      GT_EXCLUDE  TYPE UI_FUNCTIONS,
      GT_F4       TYPE LVC_T_F4,
      GT_ROWS     TYPE LVC_T_ROW,
      GT_STYLE    TYPE LVC_T_STYL,
      GT_COLOR    TYPE LVC_T_SCOL,
      GT_PARA     TYPE TABLE OF RFC_SPAGPA.

*----------------------------------------------------------------------*
*  Global Structure                                                    *
*----------------------------------------------------------------------*

DATA: GS_LAYOUT   TYPE LVC_S_LAYO,
      GS_FIELDCAT TYPE LVC_S_FCAT,
      GS_SORT     TYPE LVC_S_SORT,
      GS_PRINT    TYPE LVC_S_PRNT,
      GS_ROWS     TYPE LVC_S_ROW,
      GS_F4       TYPE LVC_S_F4,
      GS_STYLE    TYPE LVC_S_STYL,
      GS_COLOR    TYPE LVC_S_SCOL,
      GS_STABLE   TYPE LVC_S_STBL,
      GS_VARIANT  TYPE DISVARIANT,
      GS_COL      TYPE LVC_S_COL.

*----------------------------------------------------------------------*
*  Global Variant                                                      *
*----------------------------------------------------------------------*
*DATA: GV_CONTAINER TYPE SCRFNAME VALUE 'CT_0100',
*      GV_SAVE      TYPE C        VALUE 'U',
*      GV_POS       TYPE I,
*      GV_REPID     TYPE SY-REPID.

DATA: GV_CONTAINER TYPE SCRFNAME VALUE 'CT_0100',
      GV_SAVE      TYPE C        VALUE 'U',
      GV_POS       TYPE I,
      GV_REPID     TYPE SY-REPID.

*---------------------------------------------------------------------*
*       CLASS LCL_EVENT_RECEIVER DEFINITION
*---------------------------------------------------------------------*
CLASS LCL_EVENT_RECEIVER DEFINITION.

  PUBLIC SECTION.

    METHODS:
      HANDLE_TOOLBAR FOR EVENT TOOLBAR OF CL_GUI_ALV_GRID
        IMPORTING E_OBJECT
                  E_INTERACTIVE
                  SENDER,

      HANDLE_USER_COMMAND FOR EVENT USER_COMMAND OF CL_GUI_ALV_GRID
        IMPORTING E_UCOMM
                  SENDER,

      HANDLE_DATA_CHANGED FOR EVENT DATA_CHANGED OF CL_GUI_ALV_GRID
        IMPORTING ER_DATA_CHANGED
                  E_ONF4
                  E_ONF4_BEFORE
                  E_ONF4_AFTER
                  E_UCOMM
                  SENDER,

      HANDLE_DATA_CHANGED_FINISHED FOR EVENT DATA_CHANGED_FINISHED
                  OF CL_GUI_ALV_GRID
        IMPORTING E_MODIFIED
                  ET_GOOD_CELLS
                  SENDER,

      HANDLE_HOTSPOT_CLICK FOR EVENT HOTSPOT_CLICK OF CL_GUI_ALV_GRID
        IMPORTING E_ROW_ID
                  E_COLUMN_ID
                  ES_ROW_NO
                  SENDER,

      HANDLE_DOUBLE_CLICK FOR EVENT DOUBLE_CLICK OF CL_GUI_ALV_GRID
        IMPORTING E_ROW
                  E_COLUMN
                  ES_ROW_NO
                  SENDER,

      HANDLE_ONF4 FOR EVENT ONF4 OF CL_GUI_ALV_GRID
        IMPORTING E_FIELDNAME
                  E_FIELDVALUE
                  ES_ROW_NO
                  ER_EVENT_DATA
                  ET_BAD_CELLS
                  E_DISPLAY
                  SENDER,

      HANDLE_TOP_OF_PAGE FOR EVENT TOP_OF_PAGE OF CL_GUI_ALV_GRID
        IMPORTING E_DYNDOC_ID
                  TABLE_INDEX
                  SENDER,

      HANDLE_END_OF_LIST FOR EVENT END_OF_LIST OF CL_GUI_ALV_GRID
        IMPORTING E_DYNDOC_ID
                  SENDER.

  PRIVATE SECTION.

ENDCLASS. "LCL_EVENT_RECEIVER DEFINITION
*---------------------------------------------------------------------*
* LOCAL CLASSES: Implementation                                       *
*---------------------------------------------------------------------*
CLASS LCL_EVENT_RECEIVER IMPLEMENTATION.
  METHOD HANDLE_TOOLBAR       . "Create Icon
    PERFORM EVENT_TOOLBAR USING E_OBJECT
                                E_INTERACTIVE
                                SENDER.
  ENDMETHOD.                    "HANDLE_TOOLBAR

  METHOD HANDLE_USER_COMMAND  .
    PERFORM EVENT_USER_COMMAND USING E_UCOMM
                                     SENDER.
  ENDMETHOD.                    "HANDLE_USER_COMMAND

  METHOD HANDLE_DATA_CHANGED.
    PERFORM EVENT_DATA_CHANGED USING ER_DATA_CHANGED
                                     E_ONF4
                                     E_ONF4_BEFORE
                                     E_ONF4_AFTER
                                     E_UCOMM
                                     SENDER.
  ENDMETHOD.                    "HANDLE_DATA_CHANGED

  METHOD HANDLE_DATA_CHANGED_FINISHED.
    PERFORM EVENT_DATA_CHANGED_FINISHED USING E_MODIFIED
                                     ET_GOOD_CELLS
                                     SENDER.
  ENDMETHOD.                    "HANDLE_DATA_CHANGED_FINISHED

  METHOD HANDLE_HOTSPOT_CLICK.
    PERFORM EVENT_HOTSPOT_CLICK USING E_ROW_ID
                                      E_COLUMN_ID
                                      ES_ROW_NO
                                      SENDER.
  ENDMETHOD.                    "HANDLE_HOTSPOT_CLICK

  METHOD HANDLE_DOUBLE_CLICK.
    PERFORM EVENT_DOUBLE_CLICK USING E_ROW
                                     E_COLUMN
                                     ES_ROW_NO
                                     SENDER.

  ENDMETHOD.                    "HANDLE_DOUBLE_CLICK

  METHOD HANDLE_ONF4.
    PERFORM EVENT_HELP_ON_F4 USING E_FIELDNAME
                                   E_FIELDVALUE
                                   ES_ROW_NO
                                   ER_EVENT_DATA
                                   ET_BAD_CELLS
                                   E_DISPLAY
                                   SENDER.
  ENDMETHOD.                    "HANDLE_ON_F4

  METHOD HANDLE_TOP_OF_PAGE.
    PERFORM EVENT_TOP_OF_PAGE USING E_DYNDOC_ID
                                    TABLE_INDEX
                                    SENDER.
  ENDMETHOD.                    "HANDLE_TOP_OF_PAGE

  METHOD HANDLE_END_OF_LIST.
    PERFORM EVENT_END_OF_LIST USING E_DYNDOC_ID
                                    SENDER.
  ENDMETHOD.                    "HANDLE_END_OF_LIST

ENDCLASS. "LCL_EVENT_RECEIVER IMPLEMENTATION
