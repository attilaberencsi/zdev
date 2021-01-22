@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Development'
define root view entity ZI_Dev
  as select from zab_dev
  composition [0..*] of ZI_DevComment as _Comment
  composition [0..*] of ZI_DevBooking as _Booking

{
  key dev_uuid              as DevUuid,
      dev_id                as DevId,
      user_department       as UserDepartment,
      planned_start         as PlannedStart,
      planned_end           as PlannedEnd,
      time_planned          as TimePlanned,
      time_spent            as TimeSpent,
      time_left             as TimeLeft,
      time_unit             as TimeUnit,
      short_description     as ShortDescription,
      long_description      as LongDescription,
      overall_status        as OverallStatus,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      --Associations
      _Comment,
      _Booking
}
