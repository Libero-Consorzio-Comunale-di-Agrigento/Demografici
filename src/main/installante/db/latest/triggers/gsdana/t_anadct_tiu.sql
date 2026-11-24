--liquibase formatted sql
--changeset amonopoli:202606111545_2 runOnChange:true stripComments:false
create or replace trigger ANADCT_TIU
before INSERT
    or UPDATE
on ANADCT
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
     :new.id             := F_ANADCT_NR(:new.anagrafe,:new.tipo_evento,:new.codice_co);
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
/
