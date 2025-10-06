--liquibase formatted sql
--changeset amonopoli:202304281530_4 runOnChange:true stripComments:false
create or replace trigger ANSC_LOG_TIU
before INSERT
    or UPDATE
on ANSC_LOG
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
     :new.id       := F_ANSC_LOG_NR(:new.id);
     :new.data_ora := nvl(:new.data_ora,sysdate);
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
/* End Trigger: ANSC_LOG_TIU */
/
