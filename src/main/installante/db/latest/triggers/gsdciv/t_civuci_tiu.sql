--liquibase formatted sql
--changeset amonopoli:202302281050_6 runOnChange:true stripComments:false
create or replace trigger CIVUCI_TIU
before INSERT
    or UPDATE
on CIVUCI
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           varchar2(2000);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
     :new.id       := F_CIVUCI_NR(:new.id);
     :new.version  := nvl(:new.version,0);
     :new.versione := nvl(:new.versione,1);

     if INSERTING then
        :new.id_atto      := nvl(:new.id_atto,f_CIV_get_id_atto(-4,:new.ufficio,:new.anno,:new.parte,:new.serie,:new.atto));
     elsif UPDATING then
        if :new.ufficio||:new.anno||:new.parte||:new.serie||:new.atto != :old.ufficio||:old.anno||:old.parte||:old.serie||:old.atto then
           :new.id_atto   := f_CIV_get_id_atto(-4,:new.ufficio,:new.anno,:new.parte,:new.serie,:new.atto);
        end if;
     end if;

--
-- 21/12/2023 (AM)
-- in presenza di id_atto con suffisso '.v[n]' (perche' nato con cod_rec "not in (0,3)")
-- viene SEMPRE tolto il suffisso e poi ri-aggiunto SOLO se l'atto risulta ancora con cod_rec "not in (0,3)"
-- prima veniva tolto e ri-aggiunto solo se il cod_rec corrente risultava "not in (0,3)"
-- (a Belluno si e' verificato il passaggio da un cod_rec '9' a cod_rec '0' e l'id_atto ha mantenuto il suffisso '.v[n]')
--
     if instr(:new.id_atto,'.v') > 0 then
        :new.id_atto := substr(:new.id_atto,1,instr(:new.id_atto,'.v')-1);
     end if;
     if :new.cod_rec not in (0,3) then
        :new.id_atto := :new.id_atto||'.v'||:new.versione;
     end if;

-- 08/04/2025 (AM)
-- controllo mirato a gestire l'eventualita' di modifica del cognome_nome che arriva dal forms11 e che non allinea automaticamente i campi separati cognome e nome
     if UPDATING then
        if nvl(:old.cognome_nome_m,' ') != nvl(:new.cognome_nome_m,' ') and nvl(:old.cognome_m||:old.nome_m,' ') = nvl(:new.cognome_m||:new.nome_m,' ') then
           :new.cognome_m         := f_cognome(:new.cognome_nome_m);
           :new.nome_m            := f_nome(:new.cognome_nome_m);
        end if;
        if nvl(:old.cognome_nome_f,' ') != nvl(:new.cognome_nome_f,' ') and nvl(:old.cognome_f||:old.nome_f,' ') = nvl(:new.cognome_f||:new.nome_f,' ') then
           :new.cognome_f         := f_cognome(:new.cognome_nome_f);
           :new.nome_f            := f_nome(:new.cognome_nome_f);
        end if;
     end if;

     :new.cognome_m       := nvl(:new.cognome_m,f_cognome(:new.cognome_nome_m));
     :new.nome_m          := nvl(:new.nome_m,f_nome(:new.cognome_nome_m));
     :new.cognome_f       := nvl(:new.cognome_f,f_cognome(:new.cognome_nome_f));
     :new.nome_f          := nvl(:new.nome_f,f_nome(:new.cognome_nome_f));

     :new.cognome_nome_m_ric := upper(:new.cognome_nome_m);
     :new.cognome_m_ric      := upper(:new.cognome_m);
     :new.nome_m_ric         := upper(:new.nome_m);
     :new.cognome_nome_f_ric := upper(:new.cognome_nome_f);
     :new.cognome_f_ric      := upper(:new.cognome_f);
     :new.nome_f_ric         := upper(:new.nome_f);

     if INSERTING then
        :new.cod_rec         := nvl(:new.cod_rec,3);
        :new.natura_uci := :new.natura;

        if :new.data_mat is not null and :new.d_data_mat is null then
           :new.d_data_mat := to_date(:new.data_mat,'j');
        elsif :new.d_data_mat is not null and :new.data_mat is null then
           :new.data_mat := to_char(:new.d_data_mat,'j');
        end if;

        if :new.data_nas_m is not null and :new.d_data_nas_m is null then
           :new.d_data_nas_m := to_date(:new.data_nas_m,'j');
        elsif :new.d_data_nas_m is not null and :new.data_nas_m is null then
           :new.data_nas_m := to_char(:new.d_data_nas_m,'j');
        end if;

        if :new.data_nas_f is not null and :new.d_data_nas_f is null then
           :new.d_data_nas_f := to_date(:new.data_nas_f,'j');
        elsif :new.d_data_nas_f is not null and :new.data_nas_f is null then
           :new.data_nas_f := to_char(:new.d_data_nas_f,'j');
        end if;

        if :new.data_convenzioni is not null and :new.d_data_convenzioni is null then
           :new.d_data_convenzioni := to_date(:new.data_convenzioni,'j');
        elsif :new.d_data_convenzioni is not null and :new.data_convenzioni is null then
           :new.data_convenzioni := to_char(:new.d_data_convenzioni,'j');
        end if;

        if :new.data_versione is not null and :new.d_data_versione is null then
           :new.d_data_versione := to_date(:new.data_versione,'j');
        elsif :new.d_data_versione is not null and :new.data_versione is null then
           :new.data_versione   := to_char(:new.d_data_versione,'j');
        elsif :new.d_data_versione is null and :new.data_versione is null then
           :new.data_versione   := to_char(sysdate,'j');
           :new.d_data_versione := sysdate;
        end if;

        if :new.data_reg is not null and :new.d_data_reg is null then
           :new.d_data_reg := to_date(:new.data_reg,'j');
        elsif :new.d_data_reg is not null and :new.data_reg is null then
           :new.data_reg   := to_char(:new.d_data_reg,'j');
        elsif :new.data_reg is null and :new.d_data_reg is null then
           :new.data_reg   := to_char(sysdate,'j');
           :new.d_data_reg := sysdate;
        end if;
     end if;

     if UPDATING then
        if nvl(:old.data_mat,1111111) != nvl(:new.data_mat,1111111) then
           :new.d_data_mat := to_date(:new.data_mat,'j');
        elsif nvl(:old.d_data_mat,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_mat,to_date('01/01/1800','dd/mm/yyyy')) then
           :new.data_mat := to_char(:new.d_data_mat,'j');
        end if;

        if nvl(:old.data_nas_m,1111111) != nvl(:new.data_nas_m,1111111) then
           :new.d_data_nas_m := to_date(:new.data_nas_m,'j');
        elsif nvl(:old.d_data_nas_m,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_nas_m,to_date('01/01/1800','dd/mm/yyyy')) then
           :new.data_nas_m := to_char(:new.d_data_nas_m,'j');
        end if;

        if nvl(:old.data_nas_f,1111111) != nvl(:new.data_nas_f,1111111) then
           :new.d_data_nas_f := to_date(:new.data_nas_f,'j');
        elsif nvl(:old.d_data_nas_f,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_nas_f,to_date('01/01/1800','dd/mm/yyyy')) then
           :new.data_nas_f := to_char(:new.d_data_nas_f,'j');
        end if;

        if nvl(:old.data_convenzioni,1111111) != nvl(:new.data_convenzioni,1111111) then
           :new.d_data_convenzioni := to_date(:new.data_convenzioni,'j');
        elsif nvl(:old.d_data_convenzioni,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_convenzioni,to_date('01/01/1800','dd/mm/yyyy')) then
           :new.data_convenzioni := to_char(:new.d_data_convenzioni,'j');
        end if;

        if nvl(:old.data_versione,1111111) != nvl(:new.data_versione,1111111) then
           :new.d_data_versione := to_date(:new.data_versione,'j');
        elsif nvl(:old.d_data_versione,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_versione,to_date('01/01/1800','dd/mm/yyyy')) then
           :new.data_versione := to_char(:new.d_data_versione,'j');
        end if;

        if nvl(:old.data_reg,1111111) != nvl(:new.data_reg,1111111) then
           :new.d_data_reg := to_date(:new.data_reg,'j');
        elsif nvl(:old.d_data_reg,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_reg,to_date('01/01/1800','dd/mm/yyyy')) then
           :new.data_reg := to_char(:new.d_data_reg,'j');
        end if;

        if :old.cod_rec = 3 and :new.cod_rec = 0 then
           :new.flag_bloccato := nvl(:new.flag_bloccato,rtrim(f_valore_inp('IATT_BLOC',1,1,'X','S'),'N'));
        end if;
     end if;
   end;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      if UPDATING then
         null;
      end if;
      if INSERTING then
         if IntegrityPackage.GetNestLevel = 0 then
            -- f_CIV_esiste_atto(A_TIPO_ATTO,A_NATURA,A_COD_REC,A_UFFICIO,A_ANNO,A_ATTO,A_PARTE,A_SERIE,A_VERSIONE)
            errmsg := f_CIV_esiste_atto(-4, :new.natura, :new.cod_rec, :new.ufficio, :new.anno, :new.atto, :new.parte, :new.serie, :new.versione);
            if errmsg is not null then
               errno  := -20007;
               errmsg := errmsg||'. La registrazione non puo'' essere inserita.';
               raise integrity_error;
            end if;
         end if;
      end if;
   end;

   begin  -- Set FUNCTIONAL Integrity on INSERT or UPDATE
      if IntegrityPackage.GetNestLevel = 0 then
         IntegrityPackage.NextNestLevel;
         begin  -- Global FUNCTIONAL Integrity at Level 0
            /* NONE */ null;
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
         CIVUCI_FI(:new.ufficio, :new.anno, :new.atto, :new.parte, :new.serie,
                   :new.cognome_nome_m, :new.cognome_nome_f,
                   :old.cognome_nome_m, :old.cognome_nome_f,
                   :old.ufficio, :old.anno, :old.atto, :old.parte, :old.serie);
NULL;
      end;
      IntegrityPackage.PreviousNestLevel;
   end;

   if nvl(:old.natura,' ') != 'N' and :new.natura = 'N' then
      begin
        delete civcom c
         where tipo_atto                 = -4
           and ufficio                   = :new.ufficio
           and anno                      = :new.anno
           and nvl(parte,0)              = nvl(:new.parte,0)
           and nvl(serie,' ')            = nvl(:new.serie,' ')
           and atto                      = :new.atto
           and nvl(stampa_eseguita,'NO') = 'NO'
           and not exists (select 1 from civcom_prot p
                            where p.id         = c.id
                              and flag_ws_prot is not null)
        ;
        delete civcom c
         where id_atto_rif               = :new.id_atto
           and nvl(stampa_eseguita,'NO') = 'NO'
           and not exists (select 1 from civcom_prot p
                            where p.id         = c.id
                              and flag_ws_prot is not null)
        ;
      exception
        when others then
             raise_application_error(-20999,'errore in eliminazione comunicazioni');
      end;
   end if;

exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: CIVUCI_TIU */
/
