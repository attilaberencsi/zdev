@EndUserText.label: 'Development'
@AccessControl.authorizationCheck: #CHECK
@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity ZC_Dev as projection on ZI_Dev {
  key DevUuid,
  @Search.defaultSearchElement: true
  DevId,
  UserDepartment,
  PlannedStart,
  PlannedEnd,
  TimePlanned,
  TimeSpent,
  TimeLeft,
  TimeUnit,
  @Search.defaultSearchElement: true
  ShortDescription,
  LongDescription,
  OverallStatus,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LastChangedAt,
  LocalLastChangedAt,
  /* Associations */
  _Comment: redirected to composition child ZC_DevComment
}
