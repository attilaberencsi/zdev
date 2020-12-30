@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Development'
define root view entity ZI_Dev
  as select from zab_dev
  composition [0..*] of ZI_DevComment as _Comment
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
      created_by            as CreatedBy,
      created_at            as CreatedAt,
      last_changed_by       as LastChangedBy,
      last_changed_at       as LastChangedAt,
      local_last_changed_at as LocalLastChangedAt,

      --Associations
      _Comment
}
