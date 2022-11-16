@EndUserText.label: 'Consumption - Booking'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity z_c_booking_2295
  as projection on z_i_booking_2295
{
  key TravelId      as TravelID,
  key BookingId     as BookingID,
      BookingDate   as BookingDate,
      CustomerId    as CustomerID,
      @ObjectModel.text.element: ['CarrierName']
      CarrierId     as CarrierID,
      _Carrier.Name as CarrierName,
      ConnectionId  as ConnectionID,
      FlightDate    as FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      FlightPrice   as FlightPrice,
      @Semantics.currencyCode: true
      CurrencyCode  as CurrencyCode,
      BookingStatus as BookingStatus,
      LastChangedAt as LastChangedAt,
      /* Associations */
      _Travel :  redirected to parent z_c_travel_2295,
      _BookingSupplement : redirected to composition child z_c_booksuppl_2295,
      _Carrier,
      _Connection,
      _Customer

}
