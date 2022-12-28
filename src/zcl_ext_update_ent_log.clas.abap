CLASS zcl_ext_update_ent_log DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ext_update_ent_log IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    MODIFY ENTITIES OF z_i_travel_2295
    ENTITY Travel
    UPDATE FIELDS ( AgencyId Description )
    WITH VALUE #( ( Travelid = '000000001'
                    Agencyid = '070017'
                    description = 'Vacation' ) )
    FAILED DATA(failed)
    REPORTED DATA(reported).

    READ ENTITIES OF z_i_travel_2295
    ENTITY Travel
    FIELDS ( AgencyId Description )
    WITH VALUE #( ( Travelid = '000000001'  ) )
    RESULT DATA(lt_travel_data)
    FAILED failed
    REPORTED reported.

    COMMIT ENTITIES.

    IF failed IS INITIAL.
      out->write( 'Commit Successfull' ).
    ELSE.
      out->write( 'Commit Failed' ).
    ENDIF.


  ENDMETHOD.

ENDCLASS.
