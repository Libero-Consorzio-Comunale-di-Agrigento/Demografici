--liquibase formatted sql
--changeset amonopoli:202510071545_2 runOnChange:true stripComments:false
create or replace trigger GSDANA_UNICODE_TIU
before INSERT
    or UPDATE
on GSDANA_UNICODE
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
     :new.id           := F_GSDANA_UNICODE_NR(:new.id);
     :new.version      := nvl(:new.version,0);
     :new.d_data_reg   := nvl(:new.d_data_reg,sysdate);
   end;

exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: GSDANA_UNICODE_TIU */
/
