CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Travel RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS acceptTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~acceptTravel RESULT result.

    METHODS createTravelByTemplate FOR MODIFY
      IMPORTING keys FOR ACTION Travel~createTravelByTemplate RESULT result.

    METHODS rejectTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~rejectTravel RESULT result.

    METHODS validateCustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateCustomer.

    METHODS validateDates FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateDates.

    METHODS validateStatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateStatus.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD acceptTravel.
  ENDMETHOD.

  METHOD createTravelByTemplate.

    "keys[ 1 ]-travel
    "result[ 1 ]-
    "mapped-
    "failed-
    "reported-

    READ ENTITIES OF z_i_travel_2295
        ENTITY Travel
        FIELDS ( TravelId AgencyId CustomerId BookingFee TotalPrice CurrencyCode )
        WITH VALUE #( FOR row_key IN keys ( %key = row_key-%key ) )
        RESULT DATA(lt_entity_travel)
        FAILED failed
        REPORTED reported.

*    READ ENTITY z_i_travel_2295
*        FIELDS ( TravelId AgencyId CustomerId BookingFee TotalPrice CurrencyCode )
*        WITH VALUE #( FOR row_key IN keys ( %key = row_key-%key ) )
*        RESULT lt_read_entity_travel
*        FAILED failed
*        REPORTED reported.

    DATA: lt_create_travel TYPE TABLE FOR CREATE z_i_travel_2295\\Travel.
    DATA(lv_today) = cl_abap_context_info=>get_system_date( ).

    SELECT MAX( travel_id ) FROM ztb_travel_2295
    INTO @DATA(lv_travel_id).

    lt_create_travel = VALUE #(  FOR create_row IN lt_entity_travel INDEX INTO idx
                                   (  travelid      = lv_travel_id + idx
                                      agencyid      = create_row-agencyid
                                      customerid    = create_row-customerid
                                      begindate     = lv_today
                                      enddate       = lv_today + 30
                                      bookingfee    = create_row-bookingfee
                                      totalprice    = create_row-totalprice
                                      currencycode  = create_row-currencycode
                                      description    = 'Add Comments'
                                      overallstatus = 'O' ) ).

    MODIFY ENTITIES OF z_i_travel_2295
    IN LOCAL MODE ENTITY Travel
    CREATE FIELDS (  travelid
                     agencyid
                     customerid
                     begindate
                     enddate
                     bookingfee
                     totalprice
                     currencycode
                     description
                     overallstatus )
     WITH lt_create_travel
     MAPPED mapped
     FAILED failed
     REPORTED reported.

    result = VALUE #( FOR result_row IN lt_create_travel INDEX INTO idx1
                      ( %cid_ref = keys[ idx1 ]-%cid_ref
                       %key =  keys[ idx1 ]-%key
                       %param = CORRESPONDING #( result_row ) ) ).


  ENDMETHOD.

  METHOD rejectTravel.
  ENDMETHOD.

  METHOD validateCustomer.
  ENDMETHOD.

  METHOD validateDates.
  ENDMETHOD.

  METHOD validateStatus.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_Z_I_TRAVEL_2295 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_Z_I_TRAVEL_2295 IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
