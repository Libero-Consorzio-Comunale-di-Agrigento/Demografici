--liquibase formatted sql
--changeset amonopoli:202304041355_3 runOnChange:true stripComments:false
create or replace trigger CIVDRF_FILTRI_TIU
before INSERT
    or UPDATE
on CIVDRF_FILTRI
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;

begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
     :new.id      := F_CIVDRF_FILTRI_NR(:new.id);
     :new.version := nvl(:new.version,0);
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
/* End Trigger: CIVDRF_FILTRI_TIU */
/
