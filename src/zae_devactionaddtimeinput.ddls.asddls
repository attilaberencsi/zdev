@EndUserText.label: 'Action input parameter: Add Worktime'
define abstract entity ZAE_DevActionAddTimeInput
{

      @UI          :{
        lineItem   :    [ { position: 5 } ],
        identification: [ { position: 5 } ],
        selectionField: [ { position: 5 } ] }
  key ActivityDate : zde_dev_activity_date;
      @Semantics.quantity.unitOfMeasure: 'TimeUnit'
      @EndUserText.label: 'Amount'
      @UI          :{
        lineItem   :    [ { position: 10 } ],
        identification: [ { position: 10 } ],
        selectionField: [ { position: 10 } ] }
  key TimeSpent    : abap.quan(6,2);

      @Consumption.valueHelpDefinition: [{entity: {name: 'I_UnitOfMeasureStdVH', element: 'UnitOfMeasure' }}]
      @UI          : {
        lineItem   :    [ { position: 20 } ],
        identification: [ { position: 20 } ],
        selectionField: [ { position: 20 } ] }
  key TimeUnit     : zde_unit;


      @EndUserText.label: 'Description'
      @UI          :{
        lineItem   :    [ { position: 30 } ],
        identification: [ { position: 30 } ],
        selectionField: [ { position: 30 } ] }
      BookingText  : zde_comment;

}
