@EndUserText.label: 'Consumption - Travel'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity z_c_travel_2295
  as projection on z_i_travel_2295
{
  key TravelId           as TravelID,
      @ObjectModel.text.element: ['AgencyName']
      AgencyId           as AgencyID,
      _Agency.Name       as AgencyName,
      @ObjectModel.text.element: ['CustomerName']
      CustomerId         as CustomerID,
      _Customer.LastName as CustomerName,
      BeginDate          as BeginDate,
      EndDate            as EndDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      BookingFee         as BookingFee,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      TotalPrice         as TotalPrice,
      @Semantics.currencyCode: true
      CurrencyCode       as CurrencyCode,
      Description        as Description,
      OverallStatus      as TravelStatus,
      LastChangedAt      as LastChangedAt,
      /* Associations */
      _Agency,
      _Booking : redirected to composition child z_c_booking_2295,
      _Currency,
      _Customer
}
