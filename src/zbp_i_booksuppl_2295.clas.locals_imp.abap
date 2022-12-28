CLASS lcl_save DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PUBLIC SECTION.
    CONSTANTS: create TYPE string VALUE 'C',
               update TYPE string VALUE 'U',
               delete TYPE string VALUE 'D'.
  PROTECTED SECTION.
    METHODS save_modified REDEFINITION.
ENDCLASS.

CLASS lcl_save IMPLEMENTATION.
  METHOD save_modified.
    DATA: lt_supplements TYPE STANDARD TABLE OF ztb_bksuppl_2295,
          lv_op_type     TYPE zde_flag,
          lv_updated     TYPE zde_flag.

    IF NOT create-supplement IS INITIAL.
      lt_supplements = CORRESPONDING #( create-supplement ).
      lv_op_type = lcl_save=>create.
    ENDIF.

    IF NOT update-supplement IS INITIAL.
      lt_supplements = CORRESPONDING #( update-supplement ).
      lv_op_type = lcl_save=>update.
    ENDIF.

    IF NOT delete-supplement IS INITIAL.
      lt_supplements = CORRESPONDING #( delete-supplement ).
      lv_op_type = lcl_save=>delete.
    ENDIF.

    IF NOT lt_supplements IS INITIAL.
      CALL FUNCTION 'ZFM_UNMANAGED_2295'
        EXPORTING
          values     = lt_supplements
          operation  = lv_op_type
        IMPORTING
          ev_updated = lv_updated.
      IF lv_updated EQ abap_true.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

CLASS lhc_Supplement DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS calculateTotalSupplPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Supplement~calculateTotalSupplPrice.

ENDCLASS.

CLASS lhc_Supplement IMPLEMENTATION.

  METHOD calculateTotalSupplPrice.

    IF NOT keys IS INITIAL.

      zcl_aux_travel_det_2295=>calculate_price( it_travel_id = VALUE #( FOR GROUPS <booking_suppl> OF booking_key IN keys
                                                                        GROUP BY booking_key-travel_id WITHOUT MEMBERS ( <booking_suppl> ) )   ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
