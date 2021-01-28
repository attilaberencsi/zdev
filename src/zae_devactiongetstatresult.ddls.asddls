@EndUserText.label: 'Action result parameter: Get Statistics'
define abstract entity ZAE_DevActionGetStatResult
{

      @EndUserText.label: 'Unit'
      @UI.identification: [ { position: 30 } ]
  key TimeUnit          : zde_unit;


      @EndUserText.label: 'Developments this year'
      @UI.identification: [ { position: 10 } ]
      @Semantics.quantity.unitOfMeasure: 'TimeUnit'
      TimeSpentThisYear :abap.dec( 12, 2 );


      @EndUserText.label: 'Developments last year'
      @UI.identification: [ { position: 20 } ]
      @Semantics.quantity.unitOfMeasure: 'TimeUnit'
      TimeSpentLastYear : abap.dec( 12, 2 );


}
