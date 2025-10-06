--liquibase formatted sql
--changeset amonopoli:202312181250 runOnChange:true stripComments:false
create or replace trigger ISTMSC_TIU
before INSERT
    or UPDATE
on ISTMSC
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
     :new.id       := F_ISTMSC_NR(:new.id);
     :new.version  := nvl(:new.version,0);

     if :new.cod_modello = '6SD' then
        :new.tipo_procedura := 2;
     elsif :new.cod_modello = '12SD' then
        :new.tipo_procedura := 1;
     elsif :new.cod_modello = 'PROVV' then
        :new.tipo_procedura := nvl(:new.tipo_procedura,3);
     end if;

     if INSERTING then 
        :new.id_atto    := f_CIV_get_id_atto(4,:new.ufficio,:new.anno,:new.parte,:new.serie,:new.atto);
     elsif UPDATING then
        if :new.ufficio||:new.anno||:new.parte||:new.serie||:new.atto != :old.ufficio||:old.anno||:old.parte||:old.serie||:old.atto then
           :new.id_atto := f_CIV_get_id_atto(4,:new.ufficio,:new.anno,:new.parte,:new.serie,:new.atto);
        end if;
     end if;

     if INSERTING then
        if :new.data_sentenza is not null and :new.d_data_sentenza is null then
           :new.d_data_sentenza := to_date(:new.data_sentenza,'j');
        elsif :new.d_data_sentenza is not null and :new.data_sentenza is null then 
           :new.data_sentenza := to_char(:new.d_data_sentenza,'j');
        end if;
        if :new.data_stipula_sep is not null and :new.d_data_stipula_sep is null then
           :new.d_data_stipula_sep := to_date(:new.data_stipula_sep,'j');
        elsif :new.d_data_stipula_sep is not null and :new.data_stipula_sep is null then 
           :new.data_stipula_sep := to_char(:new.d_data_stipula_sep,'j');
        end if;
        if :new.data_reg_sep is not null and :new.d_data_reg_sep is null then
           :new.d_data_reg_sep := to_date(:new.data_reg_sep,'j');
        elsif :new.d_data_reg_sep is not null and :new.data_reg_sep is null then 
           :new.data_reg_sep := to_char(:new.d_data_reg_sep,'j');
        end if;
        if :new.data_mat is not null and :new.d_data_mat is null then
           :new.d_data_mat := to_date(:new.data_mat,'j');
        elsif :new.d_data_mat is not null and :new.data_mat is null then 
           :new.data_mat := to_char(:new.d_data_mat,'j');
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
        if :new.data_nas_fg_1 is not null and :new.d_data_nas_fg_1 is null then
           :new.d_data_nas_fg_1 := to_date(:new.data_nas_fg_1,'j');
        elsif :new.d_data_nas_fg_1 is not null and :new.data_nas_fg_1 is null then 
           :new.data_nas_fg_1 := to_char(:new.d_data_nas_fg_1,'j');
        end if;
        if :new.data_nas_fg_2 is not null and :new.d_data_nas_fg_2 is null then
           :new.d_data_nas_fg_2 := to_date(:new.data_nas_fg_2,'j');
        elsif :new.d_data_nas_fg_2 is not null and :new.data_nas_fg_2 is null then 
           :new.data_nas_fg_2 := to_char(:new.d_data_nas_fg_2,'j');
        end if;
        if :new.data_nas_fg_3 is not null and :new.d_data_nas_fg_3 is null then
           :new.d_data_nas_fg_3 := to_date(:new.data_nas_fg_3,'j');
        elsif :new.d_data_nas_fg_3 is not null and :new.data_nas_fg_3 is null then 
           :new.data_nas_fg_3 := to_char(:new.d_data_nas_fg_3,'j');
        end if;
        if :new.data_nas_fg_4 is not null and :new.d_data_nas_fg_4 is null then
           :new.d_data_nas_fg_4 := to_date(:new.data_nas_fg_4,'j');
        elsif :new.d_data_nas_fg_4 is not null and :new.data_nas_fg_4 is null then 
           :new.data_nas_fg_4 := to_char(:new.d_data_nas_fg_4,'j');
        end if;
        if :new.data_nas_fg_5 is not null and :new.d_data_nas_fg_5 is null then
           :new.d_data_nas_fg_5 := to_date(:new.data_nas_fg_5,'j');
        elsif :new.d_data_nas_fg_5 is not null and :new.data_nas_fg_5 is null then 
           :new.data_nas_fg_5 := to_char(:new.d_data_nas_fg_5,'j');
        end if;
--
        if :new.data_iscr_ruolo_trib is not null and :new.d_data_iscr_ruolo_trib is null then
           :new.d_data_iscr_ruolo_trib := to_date(:new.data_iscr_ruolo_trib,'j');
        elsif :new.d_data_iscr_ruolo_trib is not null and :new.data_iscr_ruolo_trib is null then 
           :new.data_iscr_ruolo_trib := to_char(:new.d_data_iscr_ruolo_trib,'j');
        end if;
        if :new.data_provvedimento_trib is not null and :new.d_data_provvedimento_trib is null then
           :new.d_data_provvedimento_trib := to_date(:new.data_provvedimento_trib,'j');
        elsif :new.d_data_provvedimento_trib is not null and :new.data_provvedimento_trib is null then 
           :new.data_provvedimento_trib := to_char(:new.d_data_provvedimento_trib,'j');
        end if;
        if :new.data_trascr_provv_trib is not null and :new.d_data_trascr_provv_trib is null then
           :new.d_data_trascr_provv_trib := to_date(:new.data_trascr_provv_trib,'j');
        elsif :new.d_data_trascr_provv_trib is not null and :new.data_trascr_provv_trib is null then 
           :new.data_trascr_provv_trib := to_char(:new.d_data_trascr_provv_trib,'j');
        end if;
     end if;

     if UPDATING then
        if nvl(:old.data_sentenza,1111111) != nvl(:new.data_sentenza,1111111) then
           :new.d_data_sentenza := to_date(:new.data_sentenza,'j');
        elsif nvl(:old.d_data_sentenza,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_sentenza,to_date('01/01/1800','dd/mm/yyyy')) then
           :new.data_sentenza := to_char(:new.d_data_sentenza,'j');
        end if;
        if nvl(:old.data_stipula_sep,1111111) != nvl(:new.data_stipula_sep,1111111) then
           :new.d_data_stipula_sep := to_date(:new.data_stipula_sep,'j');
        elsif nvl(:old.d_data_stipula_sep,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_stipula_sep,to_date('01/01/1800','dd/mm/yyyy')) then
           :new.data_stipula_sep := to_char(:new.d_data_stipula_sep,'j');
        end if;
        if nvl(:old.data_reg_sep,1111111) != nvl(:new.data_reg_sep,1111111) then
           :new.d_data_reg_sep := to_date(:new.data_reg_sep,'j');
        elsif nvl(:old.d_data_reg_sep,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_reg_sep,to_date('01/01/1800','dd/mm/yyyy')) then
           :new.data_reg_sep := to_char(:new.d_data_reg_sep,'j');
        end if;
        if nvl(:old.data_mat,1111111) != nvl(:new.data_mat,1111111) then
           :new.d_data_mat := to_date(:new.data_mat,'j');
        elsif nvl(:old.d_data_mat,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_mat,to_date('01/01/1800','dd/mm/yyyy')) then
           :new.data_mat := to_char(:new.d_data_mat,'j');
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
        if nvl(:old.data_nas_fg_1,1111111) != nvl(:new.data_nas_fg_1,1111111) then
           :new.d_data_nas_fg_1 := to_date(:new.data_nas_fg_1,'j');
        elsif nvl(:old.d_data_nas_fg_1,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_nas_fg_1,to_date('01/01/1800','dd/mm/yyyy')) then
           :new.data_nas_fg_1 := to_char(:new.d_data_nas_fg_1,'j');
        end if;
        if nvl(:old.data_nas_fg_2,1111111) != nvl(:new.data_nas_fg_2,1111111) then
           :new.d_data_nas_fg_2 := to_date(:new.data_nas_fg_2,'j');
        elsif nvl(:old.d_data_nas_fg_2,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_nas_fg_2,to_date('01/01/1800','dd/mm/yyyy')) then
           :new.data_nas_fg_2 := to_char(:new.d_data_nas_fg_2,'j');
        end if;
        if nvl(:old.data_nas_fg_3,1111111) != nvl(:new.data_nas_fg_3,1111111) then
           :new.d_data_nas_fg_3 := to_date(:new.data_nas_fg_3,'j');
        elsif nvl(:old.d_data_nas_fg_3,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_nas_fg_3,to_date('01/01/1800','dd/mm/yyyy')) then
           :new.data_nas_fg_3 := to_char(:new.d_data_nas_fg_3,'j');
        end if;
        if nvl(:old.data_nas_fg_4,1111111) != nvl(:new.data_nas_fg_4,1111111) then
           :new.d_data_nas_fg_4 := to_date(:new.data_nas_fg_4,'j');
        elsif nvl(:old.d_data_nas_fg_4,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_nas_fg_4,to_date('01/01/1800','dd/mm/yyyy')) then
           :new.data_nas_fg_4 := to_char(:new.d_data_nas_fg_4,'j');
        end if;
        if nvl(:old.data_nas_fg_5,1111111) != nvl(:new.data_nas_fg_5,1111111) then
           :new.d_data_nas_fg_5 := to_date(:new.data_nas_fg_5,'j');
        elsif nvl(:old.d_data_nas_fg_5,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_nas_fg_5,to_date('01/01/1800','dd/mm/yyyy')) then
           :new.data_nas_fg_5 := to_char(:new.d_data_nas_fg_5,'j');
        end if;
--
        if nvl(:old.data_iscr_ruolo_trib,1111111) != nvl(:new.data_iscr_ruolo_trib,1111111) then
           :new.d_data_iscr_ruolo_trib := to_date(:new.data_iscr_ruolo_trib,'j');
        elsif nvl(:old.d_data_iscr_ruolo_trib,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_iscr_ruolo_trib,to_date('01/01/1800','dd/mm/yyyy')) then
           :new.data_iscr_ruolo_trib := to_char(:new.d_data_iscr_ruolo_trib,'j');
        end if;
        if nvl(:old.data_provvedimento_trib,1111111) != nvl(:new.data_provvedimento_trib,1111111) then
           :new.d_data_provvedimento_trib := to_date(:new.data_provvedimento_trib,'j');
        elsif nvl(:old.d_data_provvedimento_trib,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_provvedimento_trib,to_date('01/01/1800','dd/mm/yyyy')) then
           :new.data_provvedimento_trib := to_char(:new.d_data_provvedimento_trib,'j');
        end if;
        if nvl(:old.data_trascr_provv_trib,1111111) != nvl(:new.data_trascr_provv_trib,1111111) then
           :new.d_data_trascr_provv_trib := to_date(:new.data_trascr_provv_trib,'j');
        elsif nvl(:old.d_data_trascr_provv_trib,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_trascr_provv_trib,to_date('01/01/1800','dd/mm/yyyy')) then
           :new.data_trascr_provv_trib := to_char(:new.d_data_trascr_provv_trib,'j');
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
/* End Trigger: ISTMSC_TIU */
/
