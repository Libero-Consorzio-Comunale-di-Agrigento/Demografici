--liquibase formatted sql
--changeset amonopoli:202401111105_2 runOnChange:true stripComments:false
create or replace trigger CIVNAS_PLURIMO_TIU
before INSERT
    or UPDATE
on CIVNAS_PLURIMO
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           varchar2(2000);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
     :new.id      := F_CIVNAS_PLURIMO_NR(:new.id);
     :new.version := nvl(:new.version,0);
   end;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: CIVNAS_PLURIMO_TIU */
/
