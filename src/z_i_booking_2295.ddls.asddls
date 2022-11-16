@AbapCatalog.sqlViewName: 'ZVBOOK_2295'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface Booking'
define view z_i_booking_2295
  as select from ztb_booking_2295 as Booking
  composition [0..*] of z_i_booksuppl_2295 as _BookingSupplement
  association to parent z_i_travel_2295    as _Travel on $projection.TravelId = _Travel.TravelId
  association [1..1] to /DMO/I_Customer    as _Customer      on $projection.customer_id = _Customer.CustomerID
  association [1..1] to /DMO/I_Carrier     as _Carrier       on $projection.CarrierId = _Carrier.AirlineID
  association [1..*] to /DMO/I_Connection  as _Connection    on $projection.ConnectionId = _Connection.ConnectionID

{

  key travel_id       as TravelId,
  key booking_id      as BookingId,
      booking_date    as BookingDate,
      customer_id     as CustomerId,
      carrier_id      as CarrierId,
      connection_id   as ConnectionId,
      flight_date     as FlightDate,
      flight_price    as FlightPrice,
      currency_code   as CurrencyCode,
      booking_status  as BookingStatus,
      last_changed_at as LastChangedAt,
      _Travel,
      _BookingSupplement,
      _Carrier,
      _Connection,
      _Customer
}
