CLASS lhc_Booking DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS calculateTotalFlightPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Booking~calculateTotalFlightPrice.

    METHODS validateStatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR Booking~validateStatus.

    METHODS get_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Booking RESULT result.

ENDCLASS.

CLASS lhc_Booking IMPLEMENTATION.

  METHOD calculateTotalFlightPrice.

    IF NOT keys IS INITIAL.

      zcl_aux_travel_det_2295=>calculate_price( it_travel_id = value #( for groups <booking> of booking_key in keys
                                                                        group by booking_key-travelid without members ( <booking> ) )   ).

    ENDIF.

  ENDMETHOD.

  METHOD validateStatus.

    READ ENTITY z_i_travel_2295\\Booking
         FIELDS ( bookingstatus )
         WITH VALUE #( FOR <row_key> IN keys ( %key = <row_key>-%key ) )
         RESULT DATA(lt_booking_result).

    LOOP AT lt_booking_result INTO DATA(ls_booking_result).
      CASE ls_booking_result-bookingstatus.
        WHEN 'N'. " New
        WHEN 'X'. " Cancelled
        WHEN 'B'. " Booked
        WHEN OTHERS.
          APPEND VALUE #( %key = ls_booking_result-%key ) TO failed-booking.
          APPEND VALUE #( %key = ls_booking_result-%key
                          %msg = new_message( id = 'Z_MC_TRAVEL_2295'
                          number ='007'
                          v1 = ls_booking_result-bookingid
                          severity = if_abap_behv_message=>severity-error )
                          %element-bookingstatus = if_abap_behv=>mk-on ) TO reported-booking.
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_features.

    READ ENTITIES OF z_i_travel_2295
    ENTITY Booking
    FIELDS ( bookingid bookingdate customerid bookingstatus )
    WITH VALUE #( FOR keyval IN keys ( %key = keyval-%key ) )
    RESULT DATA(lt_booking_result).

    result = VALUE #( FOR ls_travel IN lt_booking_result
                        (  %key           = ls_travel-%key
                           %assoc-_BookingSupplement = if_abap_behv=>fc-o-enabled ) ).

  ENDMETHOD.

ENDCLASS.
