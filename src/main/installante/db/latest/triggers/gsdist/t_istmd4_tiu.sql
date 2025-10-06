--liquibase formatted sql
--changeset amonopoli:202503211145_5 runOnChange:true stripComments:false
create or replace trigger ISTMD4_TIU
before INSERT
    or UPDATE
on ISTMD4
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
     :new.id       := F_ISTMD4_NR(:new.id);
     :new.version  := nvl(:new.version,0);

     if INSERTING then 
        :new.id_atto    := f_CIV_get_id_atto(5,:new.ufficio,:new.anno,:new.parte,:new.serie,:new.atto);
     elsif UPDATING then
        if :new.ufficio||:new.anno||:new.parte||:new.serie||:new.atto != :old.ufficio||:old.anno||:old.parte||:old.serie||:old.atto then
           :new.id_atto := f_CIV_get_id_atto(5,:new.ufficio,:new.anno,:new.parte,:new.serie,:new.atto);
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
/* End Trigger: ISTMD4_TIU */
/
