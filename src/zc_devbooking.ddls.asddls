@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Time Spent on Development'
@Metadata.allowExtensions: true
define view entity ZC_DevBooking
  as projection on ZI_DevBooking
{
  key BookingUuid,
      DevUuid,
      BookCount,
      ActivityDate,
      TimeSpent,
      TimeUnit,
      BookingText,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,

      /* Associations */
      _Development : redirected to parent ZC_Dev

}
