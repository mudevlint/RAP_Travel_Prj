@AbapCatalog.sqlViewName: 'ZV_BOOK_2295'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interface - Booking Supplement'
define view z_i_booksuppl_2295
  as select from ztb_bksuppl_2295 as BookingSuplement
  association        to parent z_i_booking_2295 as _Booking on  $projection.travel_id  = _Booking.TravelId
                                                            and $projection.booking_id = _Booking.BookingId
  association [1..1] to z_i_travel_2295         as _Travel  on  $projection.travel_id = _Travel.TravelId
  association [1..1] to /DMO/I_Supplement       as _Product on  $projection.supplement_id = _Product.SupplementID
  association [1..*] to /DMO/I_SupplementText as _SupplementText on $projection.supplement_id = _SupplementText.SupplementID
{

  key travel_id,
  key booking_id,
  key booking_supplement_id,
      supplement_id,
      @Semantics.amount.currencyCode: 'currency_code'
      price,
      @Semantics.currencyCode: true
      currency_code,
      @Semantics.systemDateTime.lastChangedAt: true
       last_changed_at,
      _Booking,
      _Product,
      _SupplementText,
      _Travel
}
