CLASS lhc_Development DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Development RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Development RESULT result.
    METHODS getNextDevID FOR DETERMINE ON SAVE
      IMPORTING keys FOR Development~getNextDevID.

ENDCLASS.

CLASS lhc_Development IMPLEMENTATION.

  METHOD get_instance_features.
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

ENDCLASS.
