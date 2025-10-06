--liquibase formatted sql
--changeset amonopoli:202307241200_2 runOnChange:true stripComments:false
create or replace trigger CIVDTA_TD
before DELETE 
on CIVDTA
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
     if :old.tipo_atto is not null and :old.id is not null then
        w_errore := f_CIV_esiste_atto_x_tipo_atto(:old.tipo_atto, :old.id);
        if w_errore is not null then
           errno  := -20999;
           errmsg := w_errore;
           raise integrity_error;
        end if;
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
