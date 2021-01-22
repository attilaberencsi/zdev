CLASS lhc_Booking DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS getNextCommentNum FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Booking~getNextCommentNum.
    METHODS calculateTotalTime FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Booking~calculateTotalTime.

ENDCLASS.

CLASS lhc_Booking IMPLEMENTATION.

  METHOD getNextCommentNum.
  ENDMETHOD.

  METHOD calculateTotalTime.
    " Read parent developments of the bookings.
    " If multiple bookings of the same travel are requested, the development is returned once.
    READ ENTITIES OF ZI_Dev IN LOCAL MODE
    ENTITY Booking BY \_Development
      FIELDS ( DevUuid )
      WITH CORRESPONDING #( keys )
      RESULT DATA(developments)
      FAILED DATA(read_failed).

    " Trigger calculation of the total time
    MODIFY ENTITIES OF ZI_Dev IN LOCAL MODE
    ENTITY Development
      EXECUTE recalcTotalTime
      FROM CORRESPONDING #( developments )
    MAPPED DATA(action_mapped)
    REPORTED DATA(action_reported)
    FAILED DATA(action_failed).

    reported = CORRESPONDING #( DEEP action_reported ).
  ENDMETHOD.

ENDCLASS.
