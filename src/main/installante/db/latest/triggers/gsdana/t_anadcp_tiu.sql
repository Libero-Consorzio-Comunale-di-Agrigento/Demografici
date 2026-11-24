--liquibase formatted sql
--changeset amonopoli:202511281505_2 runOnChange:true stripComments:false
create or replace trigger ANADCP_TIU
before INSERT
    or UPDATE
on ANADCP
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
     :new.id         := F_ANADCP_NR(:new.id);
   end;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
         null;
   end;

   begin  -- Set FUNCTIONAL Integrity on INSERT or UPDATE
         null;
   end;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: ANADCP_TIU */
/
