--liquibase formatted sql
--changeset snocca:202303281200_3 runOnChange:true stripComments:false
create or replace trigger CIVSOG_TIU
before INSERT
    or UPDATE
on CIVSOG
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;

begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
     :new.id := F_CIVSOG_NR(:new.id);

     if INSERTING then
        :new.id_atto := nvl(:new.id_atto,f_CIV_get_id_atto(:new.tipo_atto,:new.ufficio,:new.anno,:new.parte,:new.serie,:new.atto));
     elsif UPDATING then
        if :new.tipo_atto||:new.ufficio||:new.anno||:new.parte||:new.serie||:new.atto != :old.tipo_atto||:old.ufficio||:old.anno||:old.parte||:old.serie||:old.atto then
           :new.id_atto := f_CIV_get_id_atto(:new.tipo_atto,:new.ufficio,:new.anno,:new.parte,:new.serie,:new.atto);
        end if;
     end if;

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
/* End Trigger: CIVSOG_TIU */
/
