--liquibase formatted sql
--changeset amonopoli:202501311415_2 runOnChange:true stripComments:false
create or replace trigger ANAANA_TIU
before INSERT
    or UPDATE
on ANAANA
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;

w_errore		varchar2(4000);
errore			exception;

begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
      :new.cod_fam_unique   := f_ANA_get_cod_fam_unique(:new.fascia,:new.cod_fam);
  
      if UPDATING then
         if nvl(:old.cognome_nome,' ') != nvl(:new.cognome_nome,' ') and nvl(:old.cognome||:old.nome,' ') = nvl(:new.cognome||:new.nome,' ') then
            :new.cognome         := f_cognome(:new.cognome_nome);
            :new.nome            := f_nome(:new.cognome_nome);
         end if;
      end if;

      if INSERTING then
         if rtrim(:new.cognome_nome) is not null and rtrim(:new.cognome||:new.nome) is null then
            :new.cognome          := f_cognome(:new.cognome_nome);
            :new.nome             := f_nome(:new.cognome_nome);
         elsif rtrim(:new.cognome||:new.nome) is not null and rtrim(:new.cognome_nome) is null then
            :new.cognome_nome := :new.cognome||'/'||:new.nome;
         end if;
         if rtrim(:new.paternita) is not null and rtrim(:new.cognome_pd||:new.nome_pd) is null then
            :new.cognome_pd          := f_cognome_pd('',:new.paternita,:new.cognome_nome);
            :new.nome_pd             := f_nome_pd('',:new.paternita,:new.cognome_nome);
         elsif rtrim(:new.cognome_pd||:new.nome_pd) is not null and rtrim(:new.paternita) is null then
            :new.paternita := :new.cognome_pd||'/'||:new.nome_pd;
         end if;
         if rtrim(:new.maternita) is not null and rtrim(:new.cognome_md||:new.nome_md) is null then
            :new.cognome_md          := f_cognome(:new.maternita);
            :new.nome_md             := f_nome(:new.maternita);
         elsif rtrim(:new.cognome_md||:new.nome_md) is not null and rtrim(:new.maternita) is null then
            :new.maternita := :new.cognome_md||'/'||:new.nome_md;
         end if;
         if rtrim(:new.cognome_nome_cn) is not null and rtrim(:new.cognome_cn||:new.nome_cn) is null then
            :new.cognome_cn          := f_cognome(:new.cognome_nome_cn);
            :new.nome_cn             := f_nome(:new.cognome_nome_cn);
         elsif rtrim(:new.cognome_cn||:new.nome_cn) is not null and rtrim(:new.cognome_nome_cn) is null then
            :new.cognome_nome_cn := :new.cognome_cn||'/'||:new.nome_cn;
         end if;
      end if;

      if UPDATING then
         if nvl(rtrim(:old.cognome_nome),' ') != nvl(rtrim(:new.cognome_nome),' ') then
            :new.cognome         := f_cognome(:new.cognome_nome);
            :new.nome            := f_nome(:new.cognome_nome);
         elsif nvl(rtrim(:old.cognome||:old.nome),' ') != nvl(rtrim(:new.cognome||:new.nome),' ') then
            :new.cognome_nome := :new.cognome||'/'||:new.nome;
         end if;
         if nvl(rtrim(:old.paternita),' ') != nvl(rtrim(:new.paternita),' ') then
            :new.cognome_pd         := f_cognome_pd('',:new.paternita,:new.cognome_nome);
            :new.nome_pd            := f_nome_pd('',:new.paternita,:new.cognome_nome);
         elsif nvl(rtrim(:old.cognome_pd||:old.nome_pd),' ') != nvl(rtrim(:new.cognome_pd||:new.nome_pd),' ') then
            :new.paternita := :new.cognome_pd||'/'||:new.nome_pd;
         end if;
         if nvl(rtrim(:old.maternita),' ') != nvl(rtrim(:new.maternita),' ') then
            :new.cognome_md         := f_cognome(:new.maternita);
            :new.nome_md            := f_nome(:new.maternita);
         elsif nvl(rtrim(:old.cognome_md||:old.nome_md),' ') != nvl(rtrim(:new.cognome_md||:new.nome_md),' ') then
            :new.maternita := :new.cognome_md||'/'||:new.nome_md;
         end if;
         if nvl(rtrim(:old.cognome_nome_cn),' ') != nvl(rtrim(:new.cognome_nome_cn),' ') then
            :new.cognome_cn         := f_cognome(:new.cognome_nome_cn);
            :new.nome_cn            := f_nome(:new.cognome_nome_cn);
         elsif nvl(rtrim(:old.cognome_cn||:old.nome_cn),' ') != nvl(rtrim(:new.cognome_cn||:new.nome_cn),' ') then
            :new.cognome_nome_cn := :new.cognome_cn||'/'||:new.nome_cn;
         end if;
      end if;
   
      :new.cognome_nome_ric := upper(:new.cognome_nome);
      :new.cognome_ric      := upper(:new.cognome);
      :new.nome_ric         := upper(:new.nome);

      if INSERTING then
         if :new.data_reg is null and :new.d_data_reg is null then
            :new.data_reg := to_char(sysdate,'j');
            :new.d_data_reg := sysdate;
         elsif :new.data_reg is not null and :new.d_data_reg is null then
            :new.d_data_reg := to_date(:new.data_reg,'j');
         elsif :new.d_data_reg is not null and :new.data_reg is null then
            :new.data_reg := to_char(:new.d_data_reg,'j');
         end if;
         if :new.data_nas is not null and :new.d_data_nas is null then
            :new.d_data_nas := to_date(:new.data_nas,'j');
         elsif :new.d_data_nas is not null and :new.data_nas is null then
            :new.data_nas := to_char(:new.d_data_nas,'j');
         end if;
         if :new.data_ult_eve is not null and :new.d_data_ult_eve is null then
            :new.d_data_ult_eve := to_date(:new.data_ult_eve,'j');
         elsif :new.d_data_ult_eve is not null and :new.data_ult_eve is null then
            :new.data_ult_eve := to_char(:new.d_data_ult_eve,'j');
         end if;
         if :new.data_inizio_fam is not null and :new.d_data_inizio_fam is null then
            :new.d_data_inizio_fam := to_date(:new.data_inizio_fam,'j');
         elsif :new.d_data_inizio_fam is not null and :new.data_inizio_fam is null then
            :new.data_inizio_fam := to_char(:new.d_data_inizio_fam,'j');
         end if;
         if :new.data_inizio_res is not null and :new.d_data_inizio_res is null then
            :new.d_data_inizio_res := to_date(:new.data_inizio_res,'j');
         elsif :new.d_data_inizio_res is not null and :new.data_inizio_res is null then
            :new.data_inizio_res := to_char(:new.d_data_inizio_res,'j');
         end if;
         if :new.data_mat is not null and :new.d_data_mat is null then
            :new.d_data_mat := to_date(:new.data_mat,'j');
         elsif :new.d_data_mat is not null and :new.data_mat is null then
            :new.data_mat := to_char(:new.d_data_mat,'j');
         end if;
         if :new.data_mor is not null and :new.d_data_mor is null then
            :new.d_data_mor := to_date(:new.data_mor,'j');
         elsif :new.d_data_mor is not null and :new.data_mor is null then
            :new.data_mor := to_char(:new.d_data_mor,'j');
         end if;
         if :new.data_ved is not null and :new.d_data_ved is null then
            :new.d_data_ved := to_date(:new.data_ved,'j');
         elsif :new.d_data_ved is not null and :new.data_ved is null then
            :new.data_ved := to_char(:new.d_data_ved,'j');
         end if;
         if :new.data_div is not null and :new.d_data_div is null then
            :new.d_data_div := to_date(:new.data_div,'j');
         elsif :new.d_data_div is not null and :new.data_div is null then
            :new.data_div := to_char(:new.d_data_div,'j');
         end if;
         if :new.data_div_giu is not null and :new.d_data_div_giu is null then
            :new.d_data_div_giu := to_date(:new.data_div_giu,'j');
         elsif :new.d_data_div_giu is not null and :new.data_div_giu is null then
            :new.data_div_giu := to_char(:new.d_data_div_giu,'j');
         end if;
         if :new.data_div_ann is not null and :new.d_data_div_ann is null then
            :new.d_data_div_ann := to_date(:new.data_div_ann,'j');
         elsif :new.d_data_div_ann is not null and :new.data_div_ann is null then
            :new.data_div_ann := to_char(:new.d_data_div_ann,'j');
         end if;
         if :new.data_val_espatrio is not null and :new.d_data_val_espatrio is null then
            :new.d_data_val_espatrio := to_date(:new.data_val_espatrio,'j');
         elsif :new.d_data_val_espatrio is not null and :new.data_val_espatrio is null then
            :new.data_val_espatrio := to_char(:new.d_data_val_espatrio,'j');
         end if;
         if :new.data_inizio_naz is not null and :new.d_data_inizio_naz is null then
            :new.d_data_inizio_naz := to_date(:new.data_inizio_naz,'j');
         elsif :new.d_data_inizio_naz is not null and :new.data_inizio_naz is null then
            :new.data_inizio_naz := to_char(:new.d_data_inizio_naz,'j');
         end if;
      end if;

      if UPDATING then
         if nvl(:old.data_reg,0) != nvl(:new.data_reg,0) then
            :new.d_data_reg := to_date(:new.data_reg,'j');
         elsif nvl(:old.d_data_reg,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_reg,to_date('01/01/1800','dd/mm/yyyy')) then
            :new.data_reg := to_char(:new.d_data_reg,'j');
         elsif :old.fascia != :new.fascia or :old.stato != :new.stato or :old.data_inizio_fam != :new.data_inizio_fam or :old.data_inizio_res != :new.data_inizio_res then
            :new.data_reg := to_char(sysdate,'j');
            :new.d_data_reg := sysdate;
         end if;
         if nvl(:old.data_nas,0) != nvl(:new.data_nas,0) then
            :new.d_data_nas := to_date(:new.data_nas,'j');
         elsif nvl(:old.d_data_nas,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_nas,to_date('01/01/1800','dd/mm/yyyy')) then
            :new.data_nas := to_char(:new.d_data_nas,'j');
         end if;
         if nvl(:old.data_ult_eve,0) != nvl(:new.data_ult_eve,0) then
            :new.d_data_ult_eve := to_date(:new.data_ult_eve,'j');
         elsif nvl(:old.d_data_ult_eve,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_ult_eve,to_date('01/01/1800','dd/mm/yyyy')) then
            :new.data_ult_eve := to_char(:new.d_data_ult_eve,'j');
         end if;
         if nvl(:old.data_inizio_res,0) != nvl(:new.data_inizio_res,0) then
            :new.d_data_inizio_res := to_date(:new.data_inizio_res,'j');
         elsif nvl(:old.d_data_inizio_res,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_inizio_res,to_date('01/01/1800','dd/mm/yyyy')) then
            :new.data_inizio_res := to_char(:new.d_data_inizio_res,'j');
         end if;
         if nvl(:old.data_inizio_fam,0) != nvl(:new.data_inizio_fam,0) then
            :new.d_data_inizio_fam := to_date(:new.data_inizio_fam,'j');
         elsif nvl(:old.d_data_inizio_fam,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_inizio_fam,to_date('01/01/1800','dd/mm/yyyy')) then
            :new.data_inizio_fam := to_char(:new.d_data_inizio_fam,'j');
         end if;
         if nvl(:old.data_mat,0) != nvl(:new.data_mat,0) then
            :new.d_data_mat := to_date(:new.data_mat,'j');
         elsif nvl(:old.d_data_mat,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_mat,to_date('01/01/1800','dd/mm/yyyy')) then
            :new.data_mat := to_char(:new.d_data_mat,'j');
         end if;
         if nvl(:old.data_mor,0) != nvl(:new.data_mor,0) then
            :new.d_data_mor := to_date(:new.data_mor,'j');
         elsif nvl(:old.d_data_mor,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_mor,to_date('01/01/1800','dd/mm/yyyy')) then
            :new.data_mor := to_char(:new.d_data_mor,'j');
         end if;
         if nvl(:old.data_ved,0) != nvl(:new.data_ved,0) then
            :new.d_data_ved := to_date(:new.data_ved,'j');
         elsif nvl(:old.d_data_ved,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_ved,to_date('01/01/1800','dd/mm/yyyy')) then
            :new.data_ved := to_char(:new.d_data_ved,'j');
         end if;
         if nvl(:old.data_div,0) != nvl(:new.data_div,0) then
            :new.d_data_div := to_date(:new.data_div,'j');
         elsif nvl(:old.d_data_div,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_div,to_date('01/01/1800','dd/mm/yyyy')) then
            :new.data_div := to_char(:new.d_data_div,'j');
         end if;
         if nvl(:old.data_div_giu,0) != nvl(:new.data_div_giu,0) then
            :new.d_data_div_giu := to_date(:new.data_div_giu,'j');
         elsif nvl(:old.d_data_div_giu,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_div_giu,to_date('01/01/1800','dd/mm/yyyy')) then
            :new.data_div_giu := to_char(:new.d_data_div_giu,'j');
         end if;
         if nvl(:old.data_div_ann,0) != nvl(:new.data_div_ann,0) then
            :new.d_data_div_ann := to_date(:new.data_div_ann,'j');
         elsif nvl(:old.d_data_div_ann,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_div_ann,to_date('01/01/1800','dd/mm/yyyy')) then
            :new.data_div_ann := to_char(:new.d_data_div_ann,'j');
         end if;
         if nvl(:old.data_val_espatrio,0) != nvl(:new.data_val_espatrio,0) then
            :new.d_data_val_espatrio := to_date(:new.data_val_espatrio,'j');
         elsif nvl(:old.d_data_val_espatrio,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_val_espatrio,to_date('01/01/1800','dd/mm/yyyy')) then
            :new.data_val_espatrio := to_char(:new.d_data_val_espatrio,'j');
         end if;
         if nvl(:old.data_inizio_naz,0) != nvl(:new.data_inizio_naz,0) then
            :new.d_data_inizio_naz := to_date(:new.data_inizio_naz,'j');
         elsif nvl(:old.d_data_inizio_naz,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_inizio_naz,to_date('01/01/1800','dd/mm/yyyy')) then
            :new.data_inizio_naz := to_char(:new.d_data_inizio_naz,'j');
         end if;
      end if;

      if :new.atto_nas_digitale is not null then
         w_errore := f_GSD_ctr_id_atto_ansc(:new.atto_nas_digitale);
         if w_errore is not null then
            w_errore := 'Atto di Nascita: '||w_errore;
            raise errore;
         end if;
      end if;
      if :new.atto_nas_tr_digitale is not null then
         w_errore := f_GSD_ctr_id_atto_ansc(:new.atto_nas_tr_digitale);
         if w_errore is not null then
            w_errore := 'Atto di Nascita Trascritto: '||w_errore;
            raise errore;
         end if;
      end if;
      if :new.atto_mat_digitale is not null then
         w_errore := f_GSD_ctr_id_atto_ansc(:new.atto_mat_digitale);
         if w_errore is not null then
            w_errore := 'Atto di Matrimonio: '||w_errore;
            raise errore;
         end if;
      end if;
      if :new.atto_mat_tr_digitale is not null then
         w_errore := f_GSD_ctr_id_atto_ansc(:new.atto_mat_tr_digitale);
         if w_errore is not null then
            w_errore := 'Atto di Matrimonio Trascritto: '||w_errore;
            raise errore;
         end if;
      end if;
      if :new.atto_mor_digitale is not null then
         w_errore := f_GSD_ctr_id_atto_ansc(:new.atto_mor_digitale);
         if w_errore is not null then
            w_errore := 'Atto di Morte: '||w_errore;
            raise errore;
         end if;
      end if;
      if :new.atto_mor_tr_digitale is not null then
         w_errore := f_GSD_ctr_id_atto_ansc(:new.atto_mor_tr_digitale);
         if w_errore is not null then
            w_errore := 'Atto di Morte Trascritto: '||w_errore;
            raise errore;
         end if;
      end if;
      if :new.atto_ved_digitale is not null then
         w_errore := f_GSD_ctr_id_atto_ansc(:new.atto_ved_digitale);
         if w_errore is not null then
            w_errore := 'Atto di Vedovanza: '||w_errore;
            raise errore;
         end if;
      end if;
      if :new.atto_div_digitale is not null then
         w_errore := f_GSD_ctr_id_atto_ansc(:new.atto_div_digitale);
         if w_errore is not null then
            w_errore := 'Atto di Divorzio: '||w_errore;
            raise errore;
         end if;
      end if;
   end;

   if UPDATING then
      if :old.fascia != 1 and :new.fascia = 1 and :new.stato = 17 then
         :new.sospensione := f_valore_inp('IAPR_SIND',1,2,'9','');
      end if;
      if :old.fascia = 1 and :old.stato = 17 and :new.stato != 17 then
         if :new.sospensione = f_valore_inp('IAPR_SIND',1,2,'9','') then
            :new.sospensione := '';
         end if;
      end if;
   end if;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      if UPDATING then
         ANAANA_PU(:OLD.MATRICOLA,
                         :NEW.MATRICOLA);
         null;
      end if;
      if INSERTING then
         if IntegrityPackage.GetNestLevel = 0 then
            declare  --  Check UNIQUE PK Integrity per la tabella "ANAANA"
            cursor cpk_anaana(var_MATRICOLA number) is
               select 1
                 from   ANAANA
                where  MATRICOLA = var_MATRICOLA;
            mutating         exception;
            PRAGMA exception_init(mutating, -4091);
            begin  -- Check UNIQUE Integrity on PK of "ANAANA"
               if :new.MATRICOLA is not null then
                  open  cpk_anaana(:new.MATRICOLA);
                  fetch cpk_anaana into dummy;
                  found := cpk_anaana%FOUND;
                  close cpk_anaana;
                  if found then
                     errno  := -20007;
                     errmsg := 'Identificazione "'||
                               :new.MATRICOLA||
                               '" gia'' presente in ANAANA. La registrazione  non puo'' essere inserita.';
                     raise integrity_error;
                  end if;
               end if;
            exception
               when MUTATING then null;  -- Ignora Check su UNIQUE PK Integrity
            end;
         end if;
      end if;
   end;

   begin  -- Set REFERENTIAL Integrity on UPDATE
      if UPDATING then
         IntegrityPackage.NextNestLevel;
         IntegrityPackage.PreviousNestLevel;
      end if;
   end;

   begin  -- Set FUNCTIONAL Integrity on INSERT or UPDATE
      if IntegrityPackage.GetNestLevel = 0 then
         IntegrityPackage.NextNestLevel;
         begin  -- Global FUNCTIONAL Integrity at Level 0
            ANAANA_FI(:new.matricola,:new.fascia,:old.fascia,:new.stato,:new.cognome_nome,
		      :new.sesso,:new.data_nas,:new.cod_pro_nas,:new.cod_com_nas,
		      :old.sospensione,:old.val_espatrio,:old.data_val_espatrio,:old.note,
		      :new.sospensione,:new.val_espatrio,:new.data_val_espatrio,:new.note);
         end;
         if IntegrityPackage.Functional then
            begin  -- Switched FUNCTIONAL Integrity at Level 0
               /* NONE */ null;
            end;
         end if;
         IntegrityPackage.PreviousNestLevel;
      end if;
      IntegrityPackage.NextNestLevel;
      begin  -- Full FUNCTIONAL Integrity at Any Level
         /* NONE */ null;
      end;
      IntegrityPackage.PreviousNestLevel;
   end;
exception
   when errore then
        raise_application_error(-20999, w_errore);
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/
