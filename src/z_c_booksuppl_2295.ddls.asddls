@EndUserText.label: 'Consumption - Booking Supplement'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity z_c_booksuppl_2295
  as projection on z_i_booksuppl_2295
{

  key travel_id                   as TravelID,
  key booking_id                  as BookingID,
  key booking_supplement_id       as BookingSupplementID,
      supplement_id               as SupplementID,
      @ObjectModel.text.element:['SupplementDescription']
      _SupplementText.Description as SupplementDescription : localized,
      @Semantics.amount.currencyCode : 'CurrencyCode'
      price                       as Price,
      @Semantics.currencyCode: true
      currency_code               as CurrencyCode,
      /* Associations */
      _Travel  : redirected to z_c_travel_2295,
      _Booking : redirected to parent z_c_booking_2295,
      _Product,
      _SupplementText
}
