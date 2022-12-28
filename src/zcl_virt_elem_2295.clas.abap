CLASS zcl_virt_elem_2295 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_virt_elem_2295 IMPLEMENTATION.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

    IF iv_entity = 'Z_C_TRAVEL_2295'.

      LOOP AT it_requested_calc_elements INTO DATA(LS_calc_elements).

        IF ls_calc_elements = 'DISCOUNTPRICE'.
          APPEND 'TOTALPRICE' TO et_requested_orig_elements.
        ENDIF.
      ENDLOOP.

      ENDIF.

    ENDMETHOD.

    METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: LT_ORIGINAL_DATA TYPE STANDARD TABLE OF Z_C_TRAVEL_2295 WITH DEFAULT KEY.

          LT_ORIGINAL_DATA = CORRESPONDING #( it_original_data ).

          LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<LS_ORIGINAL_DATA>).
            <LS_ORIGINAL_DATA>-DISCOUNTPRICE = <LS_ORIGINAL_DATA>-TotalPrice - ( <LS_ORIGINAL_DATA>-TotalPrice * ( 1 / 10 ) ).
          ENDLOOP.

          CT_CALCULATED_DATA = CORRESPONDING #( lt_original_data ).

    ENDMETHOD.



ENDCLASS.
