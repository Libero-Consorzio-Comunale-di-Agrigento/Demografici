--liquibase formatted sql
--changeset amonopoli:202304181555 runOnChange:true
create or replace trigger CIVDRF_TD
before DELETE
on CIVDRF
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
     null;
   end;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
     begin
       delete civdrf_filtri
        where id_civdrf = :old.id
       ;
     exception
       when others then 
            null;
     end;
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
/* End Trigger: CIVDRF_TD */
/
