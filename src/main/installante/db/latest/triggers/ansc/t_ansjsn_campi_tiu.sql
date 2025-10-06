--liquibase formatted sql
--changeset amonopoli:202304281530_1 runOnChange:true stripComments:false
create or replace trigger ANSJSN_CAMPI_TIU
before INSERT
    or UPDATE
on ANSJSN_CAMPI
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;

begin
   :new.id := F_ANSJSN_CAMPI_NR(:new.id);

exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: ANSJSN_CAMPI_TIU */
/
