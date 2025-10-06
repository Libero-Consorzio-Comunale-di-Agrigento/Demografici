--liquibase formatted sql
--changeset amonopoli:202312181255 runOnChange:true stripComments:false
create or replace trigger ISTMSU_TIU
before INSERT
    or UPDATE
on ISTMSU
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
     :new.id       := F_ISTMSU_NR(:new.id);
     :new.version  := nvl(:new.version,0);

     if :new.cod_modello = '6SU' then
        :new.tipo_procedura := 2;
     elsif :new.cod_modello = '12SU' then
        :new.tipo_procedura := 1;
     elsif :new.cod_modello = 'PROVV' then
        :new.tipo_procedura := nvl(:new.tipo_procedura,3);
     end if;

     if INSERTING then 
        :new.id_atto    := f_CIV_get_id_atto(-4,:new.ufficio,:new.anno,:new.parte,:new.serie,:new.atto);
     elsif UPDATING then
        if :new.ufficio||:new.anno||:new.parte||:new.serie||:new.atto != :old.ufficio||:old.anno||:old.parte||:old.serie||:old.atto then
           :new.id_atto := f_CIV_get_id_atto(-4,:new.ufficio,:new.anno,:new.parte,:new.serie,:new.atto);
        end if;
     end if;

     if INSERTING then
        if :new.data_sentenza is not null and :new.d_data_sentenza is null then
           :new.d_data_sentenza := to_date(:new.data_sentenza,'j');
        elsif :new.d_data_sentenza is not null and :new.data_sentenza is null then 
           :new.data_sentenza := to_char(:new.d_data_sentenza,'j');
        end if;
        if :new.data_uci is not null and :new.d_data_uci is null then
           :new.d_data_uci := to_date(:new.data_uci,'j');
        elsif :new.d_data_uci is not null and :new.data_uci is null then 
           :new.data_uci := to_char(:new.d_data_uci,'j');
        end if;
        if :new.data_nazionalita_1 is not null and :new.d_data_nazionalita_1 is null then
           :new.d_data_nazionalita_1 := to_date(:new.data_nazionalita_1,'j');
        elsif :new.d_data_nazionalita_1 is not null and :new.data_nazionalita_1 is null then 
           :new.data_nazionalita_1 := to_char(:new.d_data_nazionalita_1,'j');
        end if;
        if :new.data_nazionalita_2 is not null and :new.d_data_nazionalita_2 is null then
           :new.d_data_nazionalita_2 := to_date(:new.data_nazionalita_2,'j');
        elsif :new.d_data_nazionalita_2 is not null and :new.data_nazionalita_2 is null then 
           :new.data_nazionalita_2 := to_char(:new.d_data_nazionalita_2,'j');
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
        if nvl(:old.data_uci,1111111) != nvl(:new.data_uci,1111111) then
           :new.d_data_uci := to_date(:new.data_uci,'j');
        elsif nvl(:old.d_data_uci,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_uci,to_date('01/01/1800','dd/mm/yyyy')) then
           :new.data_uci := to_char(:new.d_data_uci,'j');
        end if;
        if nvl(:old.data_nazionalita_1,1111111) != nvl(:new.data_nazionalita_1,1111111) then
           :new.d_data_nazionalita_1 := to_date(:new.data_nazionalita_1,'j');
        elsif nvl(:old.d_data_nazionalita_1,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_nazionalita_1,to_date('01/01/1800','dd/mm/yyyy')) then
           :new.data_nazionalita_1 := to_char(:new.d_data_nazionalita_1,'j');
        end if;
        if nvl(:old.data_nazionalita_2,1111111) != nvl(:new.data_nazionalita_2,1111111) then
           :new.d_data_nazionalita_2 := to_date(:new.data_nazionalita_2,'j');
        elsif nvl(:old.d_data_nazionalita_2,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_nazionalita_2,to_date('01/01/1800','dd/mm/yyyy')) then
           :new.data_nazionalita_2 := to_char(:new.d_data_nazionalita_2,'j');
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
/* End Trigger: ISTMSU_TIU */
/
