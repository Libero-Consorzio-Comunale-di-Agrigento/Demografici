--liquibase formatted sql
--changeset amonopoli:202503261016_2 runOnChange:false stripComments:false
CREATE OR REPLACE PACKAGE BODY object_data IS
 procedure open_obj_cv( obj_cv in out objcurtyp) is
 begin
 		  open obj_cv for SELECT USER_OBJECTS.OBJECT_NAME, USER_OBJECTS.OBJECT_TYPE, USER_OBJECTS.STATUS, USER_TRIGGERS.TABLE_NAME, USER_TRIGGERS.STATUS
    FROM USER_OBJECTS,
         USER_TRIGGERS
   WHERE ( user_objects.object_name = user_triggers.trigger_name (+)) and
         ( ( USER_TRIGGERS.STATUS = 'DISABLED'  ) OR
         ( USER_OBJECTS.STATUS = 'INVALID' ) )
UNION
  SELECT USER_CONSTRAINTS.CONSTRAINT_NAME,
         'CONSTRAINT',
         '',
         USER_CONSTRAINTS.TABLE_NAME,
         USER_CONSTRAINTS.STATUS
    FROM USER_CONSTRAINTS
   WHERE USER_CONSTRAINTS.STATUS = 'DISABLED'
ORDER BY 4,2,1;
 end open_obj_cv;
END;
/
