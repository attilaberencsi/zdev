CLASS zcm_dev DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_t100_dyn_msg .
    INTERFACES if_t100_message .
    INTERFACES if_abap_behv_message.

    CONSTANTS:
      BEGIN OF time_unit_and_amount,
        msgid TYPE symsgid VALUE 'ZDEVMAN',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF time_unit_and_amount.
    CONSTANTS:
      BEGIN OF unit_conversion_failed,
        msgid TYPE symsgid VALUE 'ZDEVMAN',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF unit_conversion_failed .


*    DATA begindate TYPE /dmo/begin_date READ-ONLY.
*    DATA enddate TYPE /dmo/end_date READ-ONLY.
*    DATA travelid TYPE string READ-ONLY.
*    DATA customerid TYPE string READ-ONLY.
*    DATA agencyid TYPE string READ-ONLY.

    METHODS constructor
      IMPORTING
        severity   TYPE if_abap_behv_message=>t_severity DEFAULT if_abap_behv_message=>severity-error
        textid     LIKE if_t100_message=>t100key OPTIONAL
        previous   TYPE REF TO cx_root OPTIONAL
        begindate  TYPE /dmo/begin_date OPTIONAL
        enddate    TYPE /dmo/end_date OPTIONAL
        travelid   TYPE /dmo/travel_id OPTIONAL
        customerid TYPE /dmo/customer_id OPTIONAL
        agencyid   TYPE /dmo/agency_id  OPTIONAL.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCM_DEV IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( EXPORTING previous = previous ).

    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.

    me->if_abap_behv_message~m_severity = severity.
*    me->begindate = begindate.
*    me->enddate = enddate.
*    me->travelid = |{ travelid ALPHA = OUT }|.
*    me->customerid = |{ customerid ALPHA = OUT }|.
*    me->agencyid = |{ agencyid ALPHA = OUT }|.
  ENDMETHOD.
ENDCLASS.
