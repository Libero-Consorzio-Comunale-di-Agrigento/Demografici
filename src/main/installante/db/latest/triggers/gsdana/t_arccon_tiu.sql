--liquibase formatted sql
--changeset amonopoli:202606101035_2 runOnChange:true stripComments:false
create or replace trigger ARCCON_TIU
before INSERT
    or UPDATE
on ARCCON
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   :new.id               := f_ARCCON_nr(:new.id);
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: ARCCON_TIU */
/
