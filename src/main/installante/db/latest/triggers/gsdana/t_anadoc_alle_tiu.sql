--liquibase formatted sql
--changeset amonopoli:202412051625_3 runOnChange:true stripComments:false
create or replace trigger ANADOC_ALLE_TIU
before INSERT
    or UPDATE
on ANADOC_ALLE
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
     :new.id         := F_ANADOC_ALLE_NR(:new.id);
     :new.d_data_reg := nvl(:new.d_data_reg,sysdate);
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
/* End Trigger: ANADOC_ALLE_TIU */
/
