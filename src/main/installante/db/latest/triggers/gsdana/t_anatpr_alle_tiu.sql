--liquibase formatted sql
--changeset amonopoli:202510271405_2 runOnChange:true stripComments:false
create or replace trigger ANATPR_ALLE_TIU
before INSERT
    or UPDATE
on ANATPR_ALLE
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
     :new.id         := F_ANATPR_ALLE_NR(:new.id);
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
/* End Trigger: ANATPR_ALLE_TIU */
/
