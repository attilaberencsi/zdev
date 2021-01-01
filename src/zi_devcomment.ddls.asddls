@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Comments on Development'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DevComment
  as select from zab_dev_comment
  association to parent ZI_Dev as _Development on $projection.DevUuid = _Development.DevUuid
{
  key comment_uuid          as CommentUuid,
      dev_uuid              as DevUuid,
      comment_count         as CommentCount,
      comment_text          as CommentText,
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
