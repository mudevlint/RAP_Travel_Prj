FUNCTION zfm_unmanaged_2295.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(VALUES) TYPE  ZTT_SUPPL_2295
*"     REFERENCE(OPERATION) TYPE  ZDE_FLAG
*"  EXPORTING
*"     REFERENCE(EV_UPDATED) TYPE  ZDE_FLAG
*"----------------------------------------------------------------------
  CHECK NOT values IS INITIAL.
  CASE operation.
    WHEN 'C'.
      INSERT ztb_bksuppl_2295 FROM TABLE @values.
    WHEN 'U'.
      UPDATE ztb_bksuppl_2295 FROM TABLE @values.
    WHEN 'D'.
       DELETE ztb_bksuppl_2295 FROM TABLE @values.
  ENDCASE.

  IF sy-subrc EQ 0.
    ev_updated = abap_true.
  ENDIF.

ENDFUNCTION.
