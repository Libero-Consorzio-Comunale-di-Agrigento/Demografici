--liquibase formatted sql
--changeset amonopoli:202501311415 runOnChange:true stripComments:false
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

      :new.cognome          := nvl(:new.cognome,f_cognome(:new.cognome_nome));
      :new.nome             := nvl(:new.nome,f_nome(:new.cognome_nome));
      :new.cognome_nome_ric := upper(:new.cognome_nome);
      :new.cognome_ric      := upper(:new.cognome);
      :new.nome_ric         := upper(:new.nome);

      :new.cognome_pd       := f_cognome_pd('',:new.paternita,:new.cognome_nome);
      :new.nome_pd          := f_nome_pd('',:new.paternita,:new.cognome_nome);
      :new.cognome_md       := f_cognome(:new.maternita);
      :new.nome_md          := f_nome(:new.maternita);
      :new.cognome_cn       := f_cognome(:new.cognome_nome_cn);
      :new.nome_cn          := f_nome(:new.cognome_nome_cn);

      :new.d_data_nas          := nvl(:new.d_data_nas,to_date(:new.data_nas,'j'));
      :new.d_data_ult_eve      := nvl(:new.d_data_ult_eve,to_date(:new.data_ult_eve,'j'));
      :new.d_data_inizio_fam   := nvl(:new.d_data_inizio_fam,to_date(:new.data_inizio_fam,'j'));
      :new.d_data_inizio_res   := nvl(:new.d_data_inizio_res,to_date(:new.data_inizio_res,'j'));
      :new.d_data_mat          := nvl(:new.d_data_mat,to_date(:new.data_mat,'j'));
      :new.d_data_mor          := nvl(:new.d_data_mor,to_date(:new.data_mor,'j'));
      :new.d_data_ved          := nvl(:new.d_data_ved,to_date(:new.data_ved,'j'));
      :new.d_data_div          := nvl(:new.d_data_div,to_date(:new.data_div,'j'));
      :new.d_data_div_giu      := nvl(:new.d_data_div_giu,to_date(:new.data_div_giu,'j'));
      :new.d_data_div_ann      := nvl(:new.d_data_div_ann,to_date(:new.data_div_ann,'j'));
      :new.d_data_val_espatrio := nvl(:new.d_data_val_espatrio,to_date(:new.data_val_espatrio,'j'));
      :new.d_data_inizio_naz   := nvl(:new.d_data_inizio_naz,to_date(:new.data_inizio_naz,'j'));
      :new.d_data_reg          := nvl(:new.d_data_reg,to_date(:new.data_reg,'j'));

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
