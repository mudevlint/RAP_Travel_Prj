@AbapCatalog.sqlViewName: 'ZV_TRAV__2295'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface Travel 2295'
define root view z_i_travel_2295
  as select from ztb_travel_2295 as Travel
  composition [0..*] of z_i_booking_2295 as _Booking 
  association[0..1] to /DMO/I_Agency as _Agency on $projection.AgencyId= _Agency.AgencyID
  association[0..1] to /DMO/I_Customer as _Customer on $projection.CustomerId = _Customer.CustomerID
  association [0..1] to I_Currency as _Currency on $projection.CurrencyCode = _Currency.Currency 
  
  
{
  key travel_id       as TravelId,
      agency_id       as AgencyId,
      customer_id     as CustomerId,
      begin_date      as BeginDate,
      end_date        as EndDate,
      @Semantics.amount.currencyCode: 'currencycode'
      booking_fee     as BookingFee,
      @Semantics.amount.currencyCode: 'currencycode'
      total_price     as TotalPrice,
      @Semantics.currencyCode: true
      currency_code   as CurrencyCode,
      description     as Description,
      overall_status  as OverallStatus,
      @Semantics.user.createdBy: true
      created_by      as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at      as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at as LastChangedAt,
      _Booking,
      _Agency,
      _Customer,
      _Currency
}
