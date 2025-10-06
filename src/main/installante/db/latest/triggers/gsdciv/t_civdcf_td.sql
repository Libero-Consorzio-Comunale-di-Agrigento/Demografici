--liquibase formatted sql
--changeset amonopoli:202307031335_2 runOnChange:true stripComments:false
create or replace trigger CIVDCF_TD
before DELETE 
on CIVDCF
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;

   w_errore         varchar2(4000);

begin
   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
     w_errore := f_CIV_esiste_comunicazione(:old.codice_co,'',:old.formula);
     if w_errore is not null then
        raise_application_error(-20999,w_errore);
     end if;
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
