CLASS zcl_aux_travel_det_2295 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: tt_travel_reported      TYPE TABLE FOR REPORTED z_i_travel_2295,
           tt_booking_reported     TYPE TABLE FOR REPORTED z_i_booking_2295,
           tt_supplements_reported TYPE TABLE FOR REPORTED z_i_booksuppl_2295.

    TYPES: tt_travel_id TYPE TABLE OF /dmo/travel_id.

    CLASS-METHODS calculate_price IMPORTING it_travel_id TYPE tt_travel_id.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_aux_travel_det_2295 IMPLEMENTATION.

  METHOD calculate_price.

    DATA: lv_total_booking_price TYPE /dmo/total_price,
          lv_total_suppl_price   TYPE /dmo/total_price.

    IF it_travel_id IS INITIAL.
      RETURN.
    ENDIF.

    READ ENTITIES OF z_i_travel_2295
    ENTITY travel
    FROM VALUE #( FOR lv_travel_id IN it_travel_id (
                      TravelId = lv_travel_id ) )
    RESULT DATA(lt_read_travel).

    READ ENTITIES OF z_i_travel_2295
    ENTITY travel BY \_Booking
    FROM VALUE #( FOR lv_travel_id IN it_travel_id (
                        TravelId = lv_travel_id
                        %control-FlightPrice = if_abap_behv=>mk-on
                        %control-CurrencyCode = if_abap_behv=>mk-on ) )
    RESULT DATA(lt_read_booking).



    LOOP AT lt_read_booking INTO DATA(ls_booking)
        GROUP BY ls_booking-TravelId INTO DATA(lV_travel_key).

      ASSIGN lt_read_travel[  KEY entity COMPONENTS TravelId = lV_travel_key ]
      TO FIELD-SYMBOL(<ls_travel>).

      LOOP AT GROUP lv_travel_key INTO DATA(ls_booking_RESULT)
      GROUP BY ls_booking_result-CurrencyCode INTO DATA(lv_curr).

        lv_total_booking_price = 0.


        LOOP AT GROUP lv_curr INTO DATA(ls_booking_LINE).
          lv_total_booking_price += ls_booking_line-flightprice.
        ENDLOOP.

        IF lv_curr EQ <ls_travel>-CurrencyCode.

          <ls_travel>-TotalPrice = <ls_travel>-TotalPrice + lv_total_booking_price.

        ELSE.

          /dmo/cl_flight_amdp=>convert_currency(
            EXPORTING
              iv_amount               =  lv_total_booking_price
              iv_currency_code_source = lv_curr
              iv_currency_code_target = <ls_travel>-CurrencyCode
              iv_exchange_rate_date   = cl_abap_context_info=>get_system_date( )
            IMPORTING
              ev_amount               = DATA(lv_amount_converted)
          ).

          <ls_travel>-TotalPrice += lv_amount_converted.

        ENDIF.

      ENDLOOP.

    ENDLOOP.

    READ ENTITIES OF z_i_travel_2295
        ENTITY Booking BY \_BookingSupplement
        FROM VALUE #( FOR ls_travel IN lt_read_booking (
                            TravelId = ls_travel-TravelId
                            %control-price = if_abap_behv=>mk-on
                            %control-currency_code = if_abap_behv=>mk-on ) )
        RESULT DATA(lt_read_supplements).

    LOOP AT lt_read_supplements INTO DATA(ls_booking_suppl)
      GROUP BY ls_booking_suppl-travel_id INTO lv_travel_key.

      ASSIGN lt_read_travel[  KEY entity COMPONENTS TravelId = lv_travel_key ] TO <ls_travel>.

      LOOP AT GROUP lv_travel_key INTO DATA(ls_supplements_result)
          GROUP BY  ls_supplements_result-currency_code INTO lv_curr.

        lv_total_suppl_price = 0.

        LOOP AT GROUP lv_curr INTO DATA(ls_supplements_line).

          lv_total_suppl_price += ls_supplements_line-price.

          IF lv_curr EQ <ls_travel>-CurrencyCode.

            <ls_travel>-TotalPrice += lv_total_suppl_price.

          ELSE.

            /dmo/cl_flight_amdp=>convert_currency(
              EXPORTING
                iv_amount               =  lv_total_booking_price
                iv_currency_code_source = lv_curr
                iv_currency_code_target = <ls_travel>-CurrencyCode
                iv_exchange_rate_date   = cl_abap_context_info=>get_system_date( )
              IMPORTING
                ev_amount               = lv_amount_converted
            ).

            <ls_travel>-TotalPrice += lv_amount_converted.

          ENDIF.



        ENDLOOP.

      ENDLOOP.

    ENDLOOP.

    MODIFY ENTITIES OF z_i_travel_2295
    ENTITY travel
    UPDATE FROM VALUE #( FOR ls_travel_bo IN lt_read_travel ( TravelId = ls_travel_bo-TravelId
                                                              TotalPrice = ls_travel_bo-TotalPrice
                                                              %control-TotalPrice = if_abap_behv=>mk-on ) ).


  ENDMETHOD.

ENDCLASS.
