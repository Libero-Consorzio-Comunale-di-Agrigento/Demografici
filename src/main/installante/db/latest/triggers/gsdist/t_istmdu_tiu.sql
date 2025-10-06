--liquibase formatted sql
--changeset amonopoli:202503211145_1 runOnChange:true stripComments:false
create or replace trigger ISTMDU_TIU
before INSERT
    or UPDATE
on ISTMDU
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
     :new.id       := F_ISTMDU_NR(:new.id);
     :new.version  := nvl(:new.version,0);

     if INSERTING then 
        :new.id_atto_mat    := f_CIV_get_id_atto(-4,:new.ufficio_mat,:new.anno_mat,:new.parte_mat,:new.serie_mat,:new.atto_mat);
        :new.id_atto_pub    := f_CIV_get_id_atto(-4,:new.ufficio_pub,:new.anno_pub,:new.parte_pub,:new.serie_pub,:new.atto_pub);
     elsif UPDATING then
        if nvl(:new.ufficio_mat||:new.anno_mat||:new.parte_mat||:new.serie_mat||:new.atto_mat,' ') != nvl(:old.ufficio_mat||:old.anno_mat||:old.parte_mat||:old.serie_mat||:old.atto_mat,' ') then
           :new.id_atto_mat := f_CIV_get_id_atto(-4,:new.ufficio_mat,:new.anno_mat,:new.parte_mat,:new.serie_mat,:new.atto_mat);
        elsif nvl(:new.ufficio_pub||:new.anno_pub||:new.parte_pub||:new.serie_pub||:new.atto_pub,' ') != nvl(:old.ufficio_pub||:old.anno_pub||:old.parte_pub||:old.serie_pub||:old.atto_pub,' ') then
           :new.id_atto_pub := f_CIV_get_id_atto(-4,:new.ufficio_pub,:new.anno_pub,:new.parte_pub,:new.serie_pub,:new.atto_pub);
        end if;
     end if;

     if INSERTING then
        if :new.data_fine_mat_m is not null and :new.d_data_fine_mat_m is null then
           :new.d_data_fine_mat_m := to_date(:new.data_fine_mat_m,'j');
        elsif :new.d_data_fine_mat_m is not null and :new.data_fine_mat_m is null then 
           :new.data_fine_mat_m := to_char(:new.d_data_fine_mat_m,'j');
        end if;
        if :new.data_fine_mat_f is not null and :new.d_data_fine_mat_f is null then
           :new.d_data_fine_mat_f := to_date(:new.data_fine_mat_f,'j');
        elsif :new.d_data_fine_mat_f is not null and :new.data_fine_mat_f is null then 
           :new.data_fine_mat_f := to_char(:new.d_data_fine_mat_f,'j');
        end if;
        if :new.data_nazionalita_m is not null and :new.d_data_nazionalita_m is null then
           :new.d_data_nazionalita_m := to_date(:new.data_nazionalita_m,'j');
        elsif :new.d_data_nazionalita_m is not null and :new.data_nazionalita_m is null then 
           :new.data_nazionalita_m := to_char(:new.d_data_nazionalita_m,'j');
        end if;
        if :new.data_nazionalita_f is not null and :new.d_data_nazionalita_f is null then
           :new.d_data_nazionalita_f := to_date(:new.data_nazionalita_f,'j');
        elsif :new.d_data_nazionalita_f is not null and :new.data_nazionalita_f is null then 
           :new.data_nazionalita_f := to_char(:new.d_data_nazionalita_f,'j');
        end if;
     end if;

     if UPDATING then
        if nvl(:old.data_fine_mat_m,1111111) != nvl(:new.data_fine_mat_m,1111111) then
           :new.d_data_fine_mat_m := to_date(:new.data_fine_mat_m,'j');
        elsif nvl(:old.d_data_fine_mat_m,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_fine_mat_m,to_date('01/01/1800','dd/mm/yyyy')) then
           :new.data_fine_mat_m := to_char(:new.d_data_fine_mat_m,'j');
        end if;
        if nvl(:old.data_fine_mat_f,1111111) != nvl(:new.data_fine_mat_f,1111111) then
           :new.d_data_fine_mat_f := to_date(:new.data_fine_mat_f,'j');
        elsif nvl(:old.d_data_fine_mat_f,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_fine_mat_f,to_date('01/01/1800','dd/mm/yyyy')) then
           :new.data_fine_mat_f := to_char(:new.d_data_fine_mat_f,'j');
        end if;
        if nvl(:old.data_nazionalita_m,1111111) != nvl(:new.data_nazionalita_m,1111111) then
           :new.d_data_nazionalita_m := to_date(:new.data_nazionalita_m,'j');
        elsif nvl(:old.d_data_nazionalita_m,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_nazionalita_m,to_date('01/01/1800','dd/mm/yyyy')) then
           :new.data_nazionalita_m := to_char(:new.d_data_nazionalita_m,'j');
        end if;
        if nvl(:old.data_nazionalita_f,1111111) != nvl(:new.data_nazionalita_f,1111111) then
           :new.d_data_nazionalita_f := to_date(:new.data_nazionalita_f,'j');
        elsif nvl(:old.d_data_nazionalita_f,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_nazionalita_f,to_date('01/01/1800','dd/mm/yyyy')) then
           :new.data_nazionalita_f := to_char(:new.d_data_nazionalita_f,'j');
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
/* End Trigger: ISTMDU_TIU */
/
