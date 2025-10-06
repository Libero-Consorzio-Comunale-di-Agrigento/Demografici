--liquibase formatted sql
--changeset snocca:202212051037 runOnChange:true
create or replace trigger civcom_tiu
before INSERT
    or UPDATE
on CIVCOM
for each row
declare

w_tipo_atto             varchar2(255);

w_ctr_protocollo        number;
w_funzione_prot         varchar2(255);

w_flag_atto_allegato	varchar2(255);
w_id_atto           	number;

errore			exception;
w_errore		varchar2(4000);

w_operazione_log	varchar2(255) := 'civcom_tiu';

begin
   if INSERTING then
      :new.id              := F_CIVCOM_NR(:new.id);
      :new.id_atto         := nvl(:new.id_atto,f_CIV_get_id_atto(:new.tipo_atto,:new.ufficio,:new.anno,:new.parte,:new.serie,:new.atto));

      :new.data_reg        := nvl(:new.data_reg,to_char(sysdate,'j'));
      :new.stampa_eseguita := nvl(:new.stampa_eseguita,'NO');
      :new.d_data_reg      := nvl(:new.d_data_reg,to_date(:new.data_reg,'j'));

   elsif UPDATING then
      if :new.tipo_atto||:new.ufficio||:new.anno||:new.parte||:new.serie||:new.atto != :old.tipo_atto||:old.ufficio||:old.anno||:old.parte||:old.serie||:old.atto then
         :new.id_atto := f_CIV_get_id_atto(:new.tipo_atto,:new.ufficio,:new.anno,:new.parte,:new.serie,:new.atto);
      end if;

      if nvl(:old.data_reg,1111111) != nvl(:new.data_reg,1111111) then
         :new.d_data_reg := to_date(:new.data_reg,'j');
      elsif nvl(:old.d_data_reg,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_reg,to_date('01/01/1800','dd/mm/yyyy')) then
         :new.data_reg := to_char(:new.d_data_reg,'j');
      end if;
   end if;

   if :new.formula is not null then
      w_funzione_prot := 'W0'||lpad(:new.codice_co,2,'0');
   else
      if nvl(:new.tipo_atto,0) = -4 then
         w_tipo_atto := 'U';
      else
         w_tipo_atto := nvl(:new.tipo_atto,0);
      end if;
      w_funzione_prot := 'W'||w_tipo_atto||lpad(:new.codice_co,2,'0');
   end if;

   begin 
     select 1
       into w_ctr_protocollo
       from parametri_protocollo
      where fase = 'SCPW'
        and funzione = w_funzione_prot
     ;
     DOCAREA_PKG.ins_log(w_operazione_log, 'trovato parametri_protocollo');
   exception
     when others then
          DOCAREA_PKG.ins_log(w_operazione_log, 'NON trovato parametri_protocollo');
          w_ctr_protocollo := 0;
   end;

   if w_ctr_protocollo = 0 then
      goto fine;
   end if;

   if INSERTING then
      begin
        insert into civcom_prot
               (TIPO_ATTO, UFFICIO, ANNO, ATTO, PARTE, SERIE, FORMULA, DATA_REG,
                VERSIONE, CODICE_CO, NUMERO_COPIE, STAMPA_ESEGUITA, SEQUENZA, ID, D_DATA_REG)
        values (:new.TIPO_ATTO, :new.UFFICIO, :new.ANNO, :new.ATTO, :new.PARTE,
                :new.SERIE, :new.FORMULA, :new.DATA_REG, :new.VERSIONE, :new.CODICE_CO,
                :new.NUMERO_COPIE, :new.STAMPA_ESEGUITA, :new.SEQUENZA, :new.ID, :new.D_DATA_REG)
        ;
      exception
        when others then
             w_errore := 'Errore in inserimento CIVCOM_PROT ('||sqlerrm||')';
             raise errore;
      end;

      begin 
        select flag_atto_allegato
          into w_flag_atto_allegato
          from civdco
         where codice_co = :new.codice_co
           and rownum = 1
        ;
      exception
        when others then
             w_flag_atto_allegato := '';
      end;
    
      if w_flag_atto_allegato is not null then
         begin
           select id into w_id_atto
             from civcom_prot
            where codice_co      = 0 
              and tipo_atto      = :new.tipo_atto
              and ufficio        = :new.ufficio
              and anno           = :new.anno
              and atto           = :new.atto
              and nvl(parte,0)   = nvl(:new.parte,0)
              and nvl(serie,' ') = nvl(:new.serie,' ')
              and flag_ws_prot   is null
           ;
         exception
           when others then
                w_id_atto := '';
         end;
      end if;
   
      if w_id_atto is not null then
         begin
           update civcom_alle
              set id_com = :new.id
            where id_com = w_id_atto
           ;
           if sql%found then
              begin
                delete civcom_prot
                 where id = w_id_atto
                ;
              end;
           end if;
         end;
      end if;


   elsif UPDATING then
      begin
        update civcom_prot
           set TIPO_ATTO       = :new.TIPO_ATTO
             , UFFICIO         = :new.UFFICIO
             , ANNO            = :new.ANNO
             , ATTO            = :new.ATTO
             , PARTE           = :new.PARTE               
             , SERIE           = :new.SERIE
             , FORMULA         = :new.FORMULA
             , DATA_REG        = :new.DATA_REG
             , VERSIONE        = :new.VERSIONE
             , CODICE_CO       = :new.CODICE_CO
             , NUMERO_COPIE    = :new.NUMERO_COPIE
             , STAMPA_ESEGUITA = :new.STAMPA_ESEGUITA
             , SEQUENZA        = :new.SEQUENZA
             , ID              = :new.ID
             , D_DATA_REG      = :new.D_DATA_REG
         where id = :old.id
        ;
      exception
        when others then
             w_errore := 'Errore in aggiornamento CIVCOM_PROT ('||sqlerrm||')';
             raise errore;
      end;

   end if;

<< fine >>
null;

exception
  when errore then
       DOCAREA_PKG.ins_log(w_operazione_log, w_errore);
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       DOCAREA_PKG.ins_log(w_operazione_log, w_errore);
end;
/
