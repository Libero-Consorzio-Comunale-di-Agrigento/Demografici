--liquibase formatted sql
--changeset amonopoli:202310070915_2 runOnChange:true stripComments:false
create or replace trigger CERINC_ZK_TIU
before INSERT
    or UPDATE
on CERINC_ZK
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
     :new.id := :new.anno_emissione||lpad(:new.progr_emissione,6,'0');
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
