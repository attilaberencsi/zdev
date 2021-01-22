@EndUserText.label: 'Development'
@AccessControl.authorizationCheck: #CHECK
@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity ZC_Dev
  as projection on ZI_Dev
{
  key DevUuid,
      @Search.defaultSearchElement: true
      DevId,

      @Search.defaultSearchElement: true
      UserDepartment,

      PlannedStart,
      PlannedEnd,
      TimePlanned,
      TimeSpent,
      TimeLeft,
      TimeUnit,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      ShortDescription,

      --@Search.defaultSearchElement: true
      --@Search.fuzzinessThreshold: 0.8
      LongDescription,

      @Search.defaultSearchElement: true
      OverallStatus,

      @Search.defaultSearchElement: true
      CreatedBy,

      @Search.defaultSearchElement: true
      CreatedAt,

      @Search.defaultSearchElement: true
      LastChangedBy,

      @Search.defaultSearchElement: true
      LastChangedAt,

      LocalLastChangedAt,
      
      /* Associations */
      _Comment : redirected to composition child ZC_DevComment,
      _Booking : redirected to composition child ZC_DevBooking
}
