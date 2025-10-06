--liquibase formatted sql
--changeset amonopoli:202305051645_1 runOnChange:true stripComments:false
create or replace trigger ANSUTE_TIU
before INSERT
    or UPDATE
on ANSUTE
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;

begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
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
/* End Trigger: ANSUTE_TIU */
/
