@EndUserText.label: 'Comments on Development'
@AccessControl.authorizationCheck: #CHECK
@Search.searchable: true
@Metadata.allowExtensions: true
define view entity ZC_DevComment as projection on ZI_DevComment {
  key CommentUuid,
  DevUuid,
  CommentCount,
  @Search.defaultSearchElement: true
  CommentText,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LastChangedAt,
  LocalLastChangedAt,
  
  --Associations
  _Development: redirected to parent ZC_Dev
}
