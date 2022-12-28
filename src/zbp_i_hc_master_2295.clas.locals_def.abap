*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section
CLASS lcl_buffer DEFINITION.
 PUBLIC SECTION.
 CONSTANTS: created TYPE c LENGTH 1 VALUE 'C',
 updated TYPE c LENGTH 1 VALUE 'U',
 deleted TYPE c LENGTH 1 VALUE 'D'.
 TYPES: BEGIN OF ty_buffer_master.
        INCLUDE TYPE zhc_master_2295 AS data.
 TYPES: flag TYPE c LENGTH 1,
 END OF ty_buffer_master.
 TYPES: tt_master TYPE SORTED TABLE OF ty_buffer_master WITH  UNIQUE KEY e_name.
 CLASS-DATA mt_buffer_master TYPE tt_master.
ENDCLASS.
