--liquibase formatted sql
--changeset amonopoli:202503211145_3 runOnChange:true stripComments:false
create or replace trigger ISTM4B_TIU
before INSERT
    or UPDATE
on ISTM4B
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
     :new.id       := F_ISTM4B_NR(:new.id);
     :new.version  := nvl(:new.version,0);

     if INSERTING then 
        :new.id_atto    := f_CIV_get_id_atto(5,:new.ufficio,:new.anno,:new.parte,:new.serie,:new.atto);
     elsif UPDATING then
        if :new.ufficio||:new.anno||:new.parte||:new.serie||:new.atto != :old.ufficio||:old.anno||:old.parte||:old.serie||:old.atto then
           :new.id_atto := f_CIV_get_id_atto(5,:new.ufficio,:new.anno,:new.parte,:new.serie,:new.atto);
        end if;
     end if;

     if INSERTING then
        if :new.data_nas_nato_prec is not null and :new.d_data_nas_nato_prec is null then
           :new.d_data_nas_nato_prec := to_date(:new.data_nas_nato_prec,'j');
        elsif :new.d_data_nas_nato_prec is not null and :new.data_nas_nato_prec is null then 
           :new.data_nas_nato_prec := to_char(:new.d_data_nas_nato_prec,'j');
        end if;
        if :new.data_nas_mat is not null and :new.d_data_nas_mat is null then
           :new.d_data_nas_mat := to_date(:new.data_nas_mat,'j');
        elsif :new.d_data_nas_mat is not null and :new.data_nas_mat is null then 
           :new.data_nas_mat := to_char(:new.d_data_nas_mat,'j');
        end if;
     end if;

     if UPDATING then
        if nvl(:old.data_nas_nato_prec,1111111) != nvl(:new.data_nas_nato_prec,1111111) then
           :new.d_data_nas_nato_prec := to_date(:new.data_nas_nato_prec,'j');
        elsif nvl(:old.d_data_nas_nato_prec,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_nas_nato_prec,to_date('01/01/1800','dd/mm/yyyy')) then
           :new.data_nas_nato_prec := to_char(:new.d_data_nas_nato_prec,'j');
        end if;
        if nvl(:old.data_nas_mat,1111111) != nvl(:new.data_nas_mat,1111111) then
           :new.d_data_nas_mat := to_date(:new.data_nas_mat,'j');
        elsif nvl(:old.d_data_nas_mat,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_nas_mat,to_date('01/01/1800','dd/mm/yyyy')) then
           :new.data_nas_mat := to_char(:new.d_data_nas_mat,'j');
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
/* End Trigger: ISTM4B_TIU */
/
