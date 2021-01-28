@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZI_DevWorktime
  with parameters
    to_unit :abap.unit( 3 )
  as select from ZI_DevBooking
{

  key BookingUuid,
      DevUuid,
      _Development.DevId,      
      ActivityDate,
      TimeSpent,
      TimeUnit,
      BookingText,
      CreatedBy,
      CreatedAt,

      @Semantics.quantity.unitOfMeasure: 'TimeUnitConverted'
      unit_conversion(
        quantity => TimeSpent,
        source_unit => TimeUnit,
        target_unit => $parameters.to_unit,
       error_handling => 'SET_TO_NULL' ) as TimeSpentConverted,

      $parameters.to_unit                as TimeUnitConverted
}
