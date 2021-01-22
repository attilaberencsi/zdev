@EndUserText.label: 'Action input parameter: Add Time'
define abstract entity ZAE_DevActionAddTimeInput
{
      @Consumption.valueHelpDefinition: [{entity: {name: 'I_UnitOfMeasureStdVH', element: 'UnitOfMeasure' }}]
  key TimeUnit     : zde_unit;

      @Semantics.quantity.unitOfMeasure: 'TimeUnit'
      @EndUserText.label: 'Amount'
  key TimeSpent    : abap.quan(6,2);
      
      @EndUserText.label: 'Description'
      BookingText : zde_comment;

}
