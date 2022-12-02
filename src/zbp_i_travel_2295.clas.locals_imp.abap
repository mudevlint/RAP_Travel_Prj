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

    READ ENTITIES OF z_i_travel_2295
    ENTITY travel
    FIELDS (  TravelId OverallStatus )
    WITH VALUE #( FOR key_row IN keys ( %key = key_row-%key ) )
    RESULT DATA(lt_travel_result).

    result = VALUE #( FOR ls_travel IN lt_travel_result ( %key = ls_travel-%key
                                                          %field-TravelId = if_abap_behv=>fc-f-read_only
                                                          %field-OverallStatus = if_abap_behv=>fc-f-read_only
                                                          %action-acceptTravel = COND #(  WHEN ls_travel-OverallStatus = 'A'
                                                                                          THEN if_abap_behv=>fc-o-disabled
                                                                                          ELSE if_abap_behv=>fc-o-enabled )
                                                          %action-rejectTravel = COND #(  WHEN ls_travel-OverallStatus = 'X'
                                                                                          THEN if_abap_behv=>fc-o-disabled
                                                                                          ELSE if_abap_behv=>fc-o-enabled ) ) ).
  ENDMETHOD.

  METHOD get_instance_authorizations.


    "CB9980002295

    DATA(lv_auth) = COND #(  WHEN cl_abap_context_info=>get_user_technical_name(  ) EQ 'CB9980002295'
                              THEN if_abap_behv=>auth-allowed
                              ELSE if_abap_behv=>auth-unauthorized ).

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_keys>).
      APPEND INITIAL LINE TO result ASSIGNING FIELD-SYMBOL(<ls_result>).

      <ls_result> = VALUE #( %key        = <ls_keys>-%key
                             %op-%update                    = lv_auth "if_abap_behv=>auth-allowed
                             %delete                        = lv_auth
                             %action-acceptTravel           = lv_auth "if_abap_behv=>auth-allowed
                             %action-rejectTravel           = lv_auth "if_abap_behv=>auth-allowed
                             %action-createTravelByTemplate = lv_auth "if_abap_behv=>auth-allowed
                             %assoc-_Booking                = lv_auth ).

    ENDLOOP.

  ENDMETHOD.

  METHOD acceptTravel.



    " Modify in Local Mode - Bo - related updates there are not relevant for authorization objects

    MODIFY ENTITIES OF z_i_travel_2295 IN LOCAL MODE
    ENTITY travel
    UPDATE FIELDS ( OverallStatus )
      WITH VALUE #( FOR key_row IN keys ( TravelId = key_row-TravelId
                                          OverallStatus = 'A' ) ) "Accepted

      FAILED failed
      REPORTED reported.

    READ ENTITIES OF z_i_travel_2295 IN LOCAL MODE
    ENTITY travel
    FIELDS ( agencyid
    customerid
    begindate
    enddate
    bookingfee
    totalprice
    currencycode
    overallstatus
    description
    createdby
    createdat
    lastchangedby
    lastchangedat )
    WITH VALUE #(  FOR key_row1 IN keys ( travelid = key_row1-travelid ) )
    RESULT DATA(lt_travel).

    result = VALUE #( FOR ls_travel IN lt_travel (  travelid = ls_travel-travelid
                                                     %param = ls_travel ) ).

    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).
      DATA(lv_travel_msg) = <ls_travel>-TravelId.

      SHIFT lv_travel_msg LEFT DELETING LEADING '0'.

      APPEND VALUE #( travelid = <ls_travel>-TravelId
                      %msg        = new_message( id = 'Z_MC_TRAVEL_2295'
                                                 number = '005'
                                                 v1 = lv_travel_msg
                                                 severity = if_abap_behv_message=>severity-success )
                                                 %element-customerid = if_abap_behv=>mk-on
                                                 ) TO reported-travel.
    ENDLOOP.

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

    " Modify in Local Mode - Bo - related updates there are not relevant for authorization objects

    MODIFY ENTITIES OF z_i_travel_2295 IN LOCAL MODE
    ENTITY travel
    UPDATE FIELDS ( OverallStatus )
      WITH VALUE #( FOR key_row IN keys ( TravelId = key_row-TravelId
                                          OverallStatus = 'X' ) ) "Rejected

      FAILED failed
      REPORTED reported.

    READ ENTITIES OF z_i_travel_2295 IN LOCAL MODE
    ENTITY travel
    FIELDS ( agencyid
    customerid
    begindate
    enddate
    bookingfee
    totalprice
    currencycode
    overallstatus
    description
    createdby
    createdat
    lastchangedby
    lastchangedat )
    WITH VALUE #(  FOR key_row1 IN keys ( travelid = key_row1-travelid ) )
    RESULT DATA(lt_travel).

    result = VALUE #( FOR ls_travel IN lt_travel (  travelid = ls_travel-travelid
                                                     %param = ls_travel ) ).

    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).

      DATA(lv_travel_msg) = <ls_travel>-TravelId.

      SHIFT lv_travel_msg LEFT DELETING LEADING '0'.

      APPEND VALUE #( travelid = <ls_travel>-TravelId
                      %msg        = new_message( id = 'Z_MC_TRAVEL_2295'
                                                 number = '006'
                                                 v1 = lv_travel_msg
                                                 severity = if_abap_behv_message=>severity-success )
                                                 %element-customerid = if_abap_behv=>mk-on
                                                 ) TO reported-travel.
    ENDLOOP.


  ENDMETHOD.

  METHOD validateCustomer.
    READ ENTITIES OF z_i_travel_2295
    ENTITY travel
    FIELDS ( customerid )
    WITH CORRESPONDING #( keys )
     RESULT DATA(lt_travel).

    DATA lt_customer TYPE SORTED TABLE OF /dmo/customer WITH UNIQUE KEY customer_id.

    lt_customer = CORRESPONDING #( lt_travel DISCARDING DUPLICATES MAPPING customer_id = CustomerId EXCEPT * ).

    DELETE lt_customer WHERE customer_id IS INITIAL.

    SELECT FROM /dmo/customer FIELDS customer_id
    FOR ALL ENTRIES IN @lt_customer
    WHERE customer_id EQ @lt_customer-customer_id
    INTO TABLE @DATA(lt_customer_db).

    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).

      IF <ls_travel>-CustomerId IS INITIAL
       OR NOT line_exists( lt_customer_db[ customer_id = <ls_travel>-customerid ] ).
        APPEND VALUE #( TRAVelid = <ls_travel>-TravelId ) TO failed-travel.

        APPEND VALUE #( travelid = <ls_travel>-TravelId
                        %msg        = new_message( id = 'Z_MC_TRAVEL_2295'
                                                   number = '001'
                                                   v1 = <ls_travel>-travelid
                                                   severity = if_abap_behv_message=>severity-error )
                                                   %element-customerid = if_abap_behv=>mk-on
                      ) TO reported-travel.

      ENDIF.

    ENDLOOP.

    "failed-travel
  ENDMETHOD.

  METHOD validateDates.

    READ ENTITY z_i_travel_2295\\Travel
     FIELDS ( begindate enddate )
     WITH VALUE #( FOR <row_key> IN keys ( %key = <row_key>-%key ) )
     RESULT DATA(lt_travel_result).

    LOOP AT lt_travel_result INTO DATA(ls_travel_result).
      IF ls_travel_result-enddate LT ls_travel_result-begindate. "end_date before begin_date
        APPEND VALUE #( %key = ls_travel_result-%key
        travelid = ls_travel_result-travelid ) TO failed-travel.
        APPEND VALUE #( %key = ls_travel_result-%key
                        %msg = new_message( id = 'Z_MC_TRAVEL_2295'  number = '003'
                                            v1 = ls_travel_result-begindate
                                            v2 = ls_travel_result-enddate
                                            v3 = ls_travel_result-travelid
                                            severity = if_abap_behv_message=>severity-error )
                                            %element-begindate = if_abap_behv=>mk-on
                                            %element-enddate = if_abap_behv=>mk-on ) TO reported-travel.
      ELSEIF ls_travel_result-begindate < cl_abap_context_info=>get_system_date( ). "begin_date must be in the future
        APPEND VALUE #( %key = ls_travel_result-%key
        travelid = ls_travel_result-travelid ) TO failed-travel.
        APPEND VALUE #( %key = ls_travel_result-%key
                        %msg = new_message( id = 'Z_MC_TRAVEL_2295'
                                            number = '002'
                                            severity = if_abap_behv_message=>severity-error )
                                            %element-begindate = if_abap_behv=>mk-on
                                            %element-enddate   = if_abap_behv=>mk-on ) TO reported-travel.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateStatus.

    READ ENTITY z_i_travel_2295\\Travel
        FIELDS ( overallstatus )
        WITH VALUE #( FOR <row_key> IN keys ( %key = <row_key>-%key ) )
        RESULT DATA(lt_travel_result).

    LOOP AT lt_travel_result INTO DATA(ls_travel_result).

      CASE ls_travel_result-overallstatus.

        WHEN 'O'. " Open

        WHEN 'X'. " Cancelled

        WHEN 'A'. " Accepted

        WHEN OTHERS.
          APPEND VALUE #( %key = ls_travel_result-%key ) TO failed-travel.
          APPEND VALUE #( %key = ls_travel_result-%key
          %msg = new_message( id = 'Z_MC_TRAVEL_2295'
                              number = '004'
                              v1 = ls_travel_result-overallstatus
                              severity = if_abap_behv_message=>severity-error )
                              %element-overallstatus = if_abap_behv=>mk-on ) TO reported-travel.
      ENDCASE.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_Z_I_TRAVEL_2295 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PUBLIC SECTION.

    CONSTANTS: create TYPE string VALUE 'CREATE',
               update TYPE string VALUE 'UPDATE',
               delete TYPE string VALUE 'DELETE'.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_Z_I_TRAVEL_2295 IMPLEMENTATION.

  METHOD save_modified.

    DATA: lt_travel_2295 TYPE STANDARD TABLE OF ztb_log_2295.
    DATA: lt_travel_2295_u TYPE STANDARD TABLE OF ztb_log_2295.

    DATA(lv_user) = cl_abap_context_info=>get_user_technical_name( ).

    IF  NOT create-travel IS INITIAL.

      lt_travel_2295 = CORRESPONDING #( create-travel ).

      LOOP AT lt_travel_2295 ASSIGNING FIELD-SYMBOL(<ls_travel_2295>).

        GET TIME STAMP FIELD <ls_travel_2295>-created_at.
        <ls_travel_2295>-changing_operation = lsc_Z_I_TRAVEL_2295=>create.

        READ TABLE create-travel WITH TABLE KEY entity COMPONENTS travelid = <ls_travel_2295>-travel_id
        INTO DATA(ls_travel).

        IF sy-subrc EQ 0.

          IF ls_travel-%control-BookingFee EQ cl_abap_behv=>flag_changed.

            <ls_travel_2295>-changed_field_name = 'Booking_Fee'.
            <ls_travel_2295>-changed_value = ls_travel-BookingFee.
            <ls_travel_2295>-user_mod = lv_user.
            TRY.

                <ls_travel_2295>-change_id = cl_system_uuid=>create_uuid_x16_static( ).

              CATCH cx_uuid_error.

            ENDTRY.

            APPEND <ls_travel_2295> TO lt_travel_2295_u.


          ENDIF.


        ENDIF.



      ENDLOOP.

    ENDIF.

    IF NOT update-travel IS INITIAL.

      lt_travel_2295 = CORRESPONDING #( update-travel ).

      LOOP AT update-travel INTO DATA(ls_update_travel).

        ASSIGN lt_travel_2295[ travel_id =  ls_update_travel-TravelId ] TO FIELD-SYMBOL(<ls_travel_2295_bd>).

        GET TIME STAMP FIELD <ls_travel_2295_bd>-created_at.
        <ls_travel_2295_bd>-changing_operation = lsc_z_i_travel_2295=>update.

        IF ls_update_travel-%control-CustomerId EQ cl_abap_behv=>flag_changed.

          <ls_travel_2295_bd>-changed_field_name = 'customer_id'.
          <ls_travel_2295_bd>-changed_value = ls_update_travel-CustomerId.
          <ls_travel_2295_bd>-user_mod = lv_user.

          TRY.
              <ls_travel_2295_bd>-change_id = cl_system_uuid=>create_uuid_x16_static(  ).
            CATCH cx_uuid_error.

          ENDTRY.


        ENDIF.

      ENDLOOP.

    ENDIF.

    IF NOT delete-travel IS INITIAL.

      lt_travel_2295 = CORRESPONDING #( delete-travel ).

      LOOP AT lt_travel_2295 ASSIGNING FIELD-SYMBOL(<ls_travel_2295_del>).

        GET TIME STAMP FIELD <ls_travel_2295_del>-created_at.
        <ls_travel_2295_del>-changing_operation = lsc_z_i_travel_2295=>delete.
        <ls_travel_2295_del>-user_mod           = lv_user.

        TRY.

            <ls_travel_2295_del>-change_id = cl_system_uuid=>create_uuid_x16_static(  ).

          CATCH cx_uuid_error.

        ENDTRY.
        APPEND <ls_travel_2295_del> TO lt_travel_2295_u.
      ENDLOOP.

    ENDIF.

    IF NOT lt_travel_2295_u IS INITIAL.
      INSERT ztb_log_2295 FROM TABLE @lt_travel_2295_u.
    ENDIF.



  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
