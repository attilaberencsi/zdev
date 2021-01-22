@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Time Spent on Development'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DevBooking
  as select from zab_dev_booking
  association to parent ZI_Dev as _Development on $projection.DevUuid = _Development.DevUuid
{
  key zab_dev_booking.booking_uuid          as BookingUuid,
      zab_dev_booking.dev_uuid              as DevUuid,
      zab_dev_booking.book_count            as BookCount,
      zab_dev_booking.time_spent            as TimeSpent,
      zab_dev_booking.time_unit             as TimeUnit,
      zab_dev_booking.booking_text          as BookingText,
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
      _Development      
}
