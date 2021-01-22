CLASS lhc_Development DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Development RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Development RESULT result.
    METHODS getNextDevID FOR DETERMINE ON SAVE
      IMPORTING keys FOR Development~getNextDevID.
    METHODS addTimeSpent FOR MODIFY
      IMPORTING keys FOR ACTION Development~AddTimeSpent RESULT result.
    METHODS setDefaultValues FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Development~setDefaultValues.
    METHODS recalcTotalTime FOR MODIFY
      IMPORTING keys FOR ACTION Development~recalcTotalTime.

ENDCLASS.

CLASS lhc_Development IMPLEMENTATION.

  METHOD get_instance_features.
    "Developments
    READ ENTITIES OF zi_dev IN LOCAL MODE
      ENTITY Development
        FIELDS ( OverallStatus ) WITH CORRESPONDING #( keys )
      RESULT DATA(Developments)
      FAILED failed.

    result =
      VALUE #(
        FOR Development IN Developments
          LET AddTimeSpentEnabled = if_abap_behv=>fc-o-enabled
*          COND #( WHEN development-OverallStatus = co_travel_status-accepted
*                                      THEN if_abap_behv=>fc-o-disabled
*                                      ELSE if_abap_behv=>fc-o-enabled  )
*              is_rejected = COND #( WHEN travel-TravelStatus = co_travel_status-canceled
*                                      THEN if_abap_behv=>fc-o-disabled
*                                      ELSE if_abap_behv=>fc-o-enabled )

          IN  ( %tky                 = development-%tky
                %action-AddTimeSpent = AddTimeSpentEnabled
                "%action-rejectTravel = is_rejected
                )
      ).
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD getNextDevID.
    " Please note that this is just an example for calculating a field during _onSave_.
    " This approach does NOT ensure for gap free or unique travel IDs! It just helps to provide a readable ID.
    " The key of this business object is a UUID, calculated by the framework.
    " Number range would be required here

    " check if TravelID is already filled
    READ ENTITIES OF ZI_Dev IN LOCAL MODE
      ENTITY Development
        FIELDS ( DevId ) WITH CORRESPONDING #( keys )
      RESULT DATA(developments).

    "Get max number from buffer
    DATA(max_num_buff) = REDUCE zde_dev_id( INIT res = '00000000'  FOR line IN developments
      NEXT res = COND #( WHEN line-DevId > res THEN line-DevId ELSE res )
    ).

    "Remove lines where TravelID is already filled.
    DELETE developments WHERE DevId IS NOT INITIAL.

    "Anything left to fill?
    CHECK developments IS NOT INITIAL.

    "Select max travel ID from DB
    SELECT SINGLE
     FROM zab_dev
     FIELDS MAX( dev_id ) INTO @DATA(max_num_db).

    DATA(last_number) = COND zde_dev_id(
      WHEN max_num_buff > max_num_db THEN max_num_buff ELSE max_num_db ).

    " Set the travel ID
    MODIFY ENTITIES OF ZI_Dev IN LOCAL MODE

    ENTITY Development
      UPDATE
        FROM VALUE #( FOR Development IN Developments INDEX INTO i (
          %tky           = Development-%tky
          DevId          = last_number + i
          %control-DevId = if_abap_behv=>mk-on ) )
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD addTimeSpent.
    "This method is to add time spent on development in hours

    DATA:
      quan_booking TYPE ZAE_DevActionAddTimeInput-timespent,
      new_bookings TYPE TABLE FOR CREATE zi_dev\\Development\_Booking.


    " Fill the response table
    READ ENTITIES OF ZI_Dev IN LOCAL MODE
      ENTITY Development
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(developments).

    DATA(uom_conv) = cl_uom_conversion=>create( ).
    DATA(count) = 0.

    LOOP AT developments ASSIGNING FIELD-SYMBOL(<development>).
      "DATA(parameter_in) = keys[ DevUuid = <development>-%key-DevUuid ]-%param.
      DATA(parameter_in) = keys[ KEY entity COMPONENTS %key = <development>-%key ]-%param.

      IF parameter_in-timespent IS INITIAL OR  parameter_in-timeunit IS INITIAL.
        APPEND VALUE #( %tky = <development>-%tky ) TO failed-development.
        APPEND VALUE #(
          %tky        = <development>-%tky
          %state_area = 'ADD_TIME_SPENT'
          %msg        = NEW zcm_dev(
          severity = if_abap_behv_message=>severity-error
          textid   = zcm_dev=>time_unit_and_amount )
          "%element- = if_abap_behv=>mk-on
        ) TO reported-development.

        CONTINUE.
      ENDIF.

*      uom_conv->unit_conversion_simple(
*        EXPORTING
*          input                = parameter_in-timespent
*          unit_in              = parameter_in-timeunit
*          unit_out             = zbp_i_dev=>co_time_unit-booking
*        IMPORTING
*          output               = quan_booking
*        EXCEPTIONS
*          conversion_not_found = 1
*          division_by_zero     = 2
*          input_invalid        = 3
*          output_invalid       = 4
*          overflow             = 5
*          type_invalid         = 6
*          units_missing        = 7
*          unit_in_not_found    = 8
*          unit_out_not_found   = 9
*          OTHERS               = 10
*      ).
*
*      IF sy-subrc <> 0.
*        APPEND VALUE #( %tky = <development>-%tky ) TO failed-development.
*        APPEND VALUE #(
*          %tky        = <development>-%tky
*          %state_area = 'ADD_TIME_SPENT'
*          %msg        = NEW zcm_dev(
*          severity = if_abap_behv_message=>severity-error
*          textid   = zcm_dev=>unit_conversion_failed )
*        ) TO reported-development.
*
*        CONTINUE.
*      ENDIF.

      "Validation and conversion success => Create Booking Entry
      count += 1.
      APPEND VALUE #(
         DevUuid = <development>-DevUuid
         %is_draft = <development>-%is_draft
         %target = VALUE #( (
            %cid        = count
            %is_draft = <development>-%is_draft
            DevUuid     = <development>-DevUuid
            TimeUnit    = parameter_in-timeunit
            TimeSpent   = parameter_in-timespent
*            TimeUnit    = zbp_i_dev=>co_time_unit-booking
*            TimeSpent   = quan_booking
            BookingText = parameter_in-bookingtext
         ) )
      ) TO new_bookings.

    ENDLOOP.

    MODIFY ENTITIES OF ZI_Dev IN LOCAL MODE
      ENTITY Development
      CREATE BY \_Booking
           FIELDS (
             BookingText
             DevUuid
             TimeSpent
             TimeUnit )
           WITH new_bookings

      FAILED failed
      REPORTED reported.

    MODIFY ENTITIES OF ZI_Dev IN LOCAL MODE
    ENTITY Development
      EXECUTE recalcTotalTime
      FROM CORRESPONDING #( developments )
    MAPPED DATA(action_mapped)
    REPORTED DATA(action_reported)
    FAILED DATA(action_failed).

    READ ENTITIES OF ZI_Dev IN LOCAL MODE
      ENTITY Development
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT developments.

    result = VALUE #( FOR development IN developments
      ( %tky = development-%tky %param = development ) ).

  ENDMETHOD.


  METHOD setDefaultValues.
    MODIFY ENTITIES OF ZI_Dev IN LOCAL MODE
      ENTITY Development
         UPDATE
           FIELDS ( OverallStatus TimeUnit )
           WITH VALUE #(
            FOR key IN keys
              ( %tky         = key-%tky
                OverallStatus = zbp_i_dev=>co_dev_status-under_specification
                TimeUnit = zbp_i_dev=>co_time_unit-development
              )
           )
      FAILED DATA(mod_failed)
      REPORTED DATA(mod_reported).
  ENDMETHOD.

  METHOD recalcTotalTime.
    "Recalculation of total time spent on this development
    DATA:
      dev_time_total TYPE ZAE_DevActionAddTimeInput-timespent,
      time_out       TYPE ZAE_DevActionAddTimeInput-timespent.

    LOOP AT keys INTO DATA(dev_key).

      " Read all associated bookings and add them to the total time.
      READ ENTITIES OF ZI_Dev IN LOCAL MODE
         ENTITY Development BY \_Booking
            FIELDS ( TimeSpent TimeUnit )
          WITH VALUE #( ( %tky = dev_key-%tky ) )
          RESULT DATA(bookings).

      DATA(uom_conv) = cl_uom_conversion=>create( ).

      LOOP AT bookings INTO DATA(booking) WHERE TimeUnit IS NOT INITIAL.
        IF booking-TimeUnit = zbp_i_dev=>co_time_unit-development.
          dev_time_total += booking-TimeSpent.
        ELSE.
          uom_conv->unit_conversion_simple(
             EXPORTING
               input                = booking-TimeSpent
               unit_in              = booking-TimeUnit
               unit_out             = zbp_i_dev=>co_time_unit-development
             IMPORTING
               output               = time_out
             EXCEPTIONS
               conversion_not_found = 1
               division_by_zero     = 2
               input_invalid        = 3
               output_invalid       = 4
               overflow             = 5
               type_invalid         = 6
               units_missing        = 7
               unit_in_not_found    = 8
               unit_out_not_found   = 9
               OTHERS               = 10
           ).
        ENDIF.

        IF sy-subrc = 0.
          dev_time_total += time_out.
        ELSE.
          "TO-DO: Appropriate message handling
        ENDIF.
      ENDLOOP.

      "write back the modified total time of bookings to the development header
      MODIFY ENTITIES OF ZI_Dev IN LOCAL MODE
        ENTITY Development
          UPDATE FIELDS ( TimeSpent TimeUnit )
             WITH VALUE #(
                ( %tky      = dev_key-%tky
                  TimeSpent = dev_time_total
                  TimeUnit  = zbp_i_dev=>co_time_unit-development
                )
             )
             MAPPED DATA(execute_mapped)
             FAILED DATA(execute_failed)
             REPORTED DATA(execute_reported).

      mapped = CORRESPONDING #( DEEP execute_mapped ).
      failed = CORRESPONDING #( DEEP execute_failed ).
      reported = CORRESPONDING #( DEEP execute_reported ).

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
