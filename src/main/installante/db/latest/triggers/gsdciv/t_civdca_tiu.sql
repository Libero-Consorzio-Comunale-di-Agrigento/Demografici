--liquibase formatted sql
--changeset amonopoli:202307031330_1 runOnChange:true stripComments:false
create or replace trigger CIVDCA_TIU
before INSERT
    or UPDATE
on CIVDCA
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;

   w_tipo_atto		varchar2(1);
   w_errore		varchar2(4000);

begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
     :new.id := nvl(:new.id,f_CIVDCA_NR(w_tipo_atto,:new.codice_co));
   end;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
     if UPDATING then
        if :new.tipo_atto||:new.codice_co != :old.tipo_atto||:old.codice_co then
           w_errore := f_CIV_esiste_comunicazione(:old.codice_co,:old.tipo_atto,'');
           if w_errore is not null then
              raise_application_error(-20999,w_errore);
           end if;
        end if;
     end if;
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
/
