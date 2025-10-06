--liquibase formatted sql
--changeset amonopoli:202304281530_2 runOnChange:true stripComments:false
create or replace trigger ANSJSN_SEZIONI_TIU
before INSERT
    or UPDATE
on ANSJSN_SEZIONI
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;

begin
   :new.id := F_ANSJSN_SEZIONI_NR(:new.id);

exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: ANSJSN_SEZIONI_TIU */
/
