--liquibase formatted sql
--changeset amonopoli:202503261115_2 runOnChange:false stripComments:false
CREATE OR REPLACE TRIGGER A_UTENTI_AD4_TIU
   BEFORE INSERT OR UPDATE
   ON A_UTENTI
   FOR EACH ROW
DECLARE
   integrity_error   EXCEPTION;
   errno             INTEGER;
   errmsg            CHAR (200);
   FOUND             BOOLEAN;
   dep_insert_or_update varchar2(1);
   dep_rinnovo_password varchar2(2);
   dep_data_psw         varchar2(10);
   dep_note             varchar2(4000);
   dep_data_accesso     varchar2(20);
   dep_traccia          VARCHAR2 (1);
   dep_old_traccia      varchar2(1);
   dep_is_accesso       number(1);
   dep_note_tab         varchar2(4000);
   d_new_utente_aggiornamento varchar2(8):='';
   
   w_nominativo varchar2(1000);
   w_utente varchar2(100);

   cursor cpk_utente (var_utente varchar, var_nominativo varchar2)
   is
      select nominativo
        from AD4_UTENTI
       where utente = var_utente and nominativo <> var_nominativo;

   cursor cpk_nominativo (var_utente varchar2, var_nominativo varchar)
   is
      select utente
        from AD4_UTENTI
       where utente <> var_utente and nominativo = var_nominativo;
BEGIN
   if nvl (:new.utente, 'x') <> nvl (:old.utente, 'x')
   then
      open cpk_utente (:new.utente, :new.nominativo);

      fetch cpk_utente
       into w_nominativo;

      found := cpk_utente%FOUND;

      close cpk_utente;

      if found
      then
         errno := -20007;
         errmsg :=
               'E'' gia prevista una registrazione con lo stesso codice attribuita a '
            || w_nominativo
            || ' nell''Amministratore Database (AD4).';
         raise integrity_error;
      end if;
   end if;

   if nvl (:new.nominativo, 'x') <> nvl (:old.nominativo, 'x')
   then
      open cpk_nominativo (:new.utente, :new.nominativo);

      fetch cpk_nominativo
       into w_utente;

      found := cpk_nominativo%FOUND;

      close cpk_nominativo;

      if found
      then
         errno := -20007;
         errmsg :=
               'E'' gia prevista una registrazione con codice '
            || w_utente
            || ' attribuita allo stesso nominativo nell''Amministratore Database (AD4).';
         raise integrity_error;
      end if;
   end if;

   if :NEW.abil_password = 'S' then
      dep_rinnovo_password := 'SI';
   elsif :NEW.abil_password = 'N' then
      dep_rinnovo_password := 'NO';
   else
      dep_rinnovo_password := 'NO';
   end if;
   dep_data_psw := to_char(:NEW.DATA_PASSWORD,'dd/mm/yyyy');
   dep_data_accesso := to_char(:NEW.DATA_accesso,'dd/mm/yyyy hh24:mi:ss');
   if :NEW.STAT_ACCESSI = 'N' then
      dep_traccia := 'M';
   elsif :NEW.STAT_ACCESSI = 'S' then
      dep_traccia := 'F';
   else
      dep_traccia := 'M';
   end if;
   if :OLD.STAT_ACCESSI = 'N' then
      dep_old_traccia := 'M';
   elsif :OLD.STAT_ACCESSI = 'S' then
      dep_old_traccia := 'F';
   else
      dep_old_traccia := 'M';
   end if;
   IF INSERTING THEN
      dep_insert_or_update := 'I';
      dep_note := 'terminale='
               || :NEW.TERMINALE
               || ' stampante='
               || :NEW.stampante;
   END IF;
   IF UPDATING THEN
      dep_insert_or_update := 'U';
      dep_note_tab := AD4_UTENTE.GET_NOTE(:new.utente, 'Y');
      dep_note := LTRIM
                      (REPLACE
                          (REPLACE (LOWER (dep_note_tab)
                                  ,    'terminale='
                                    || LOWER
                                           (AFC.GET_STRINGPARM (dep_note_tab
                                                              , 'terminale'
                                                               )
                                           )
                                  , ''
                                   )
                         ,    'stampante='
                           || LOWER (AFC.GET_STRINGPARM (dep_note_tab, 'stampante'))
                         , ''
                          )
                      )
               || 'terminale='
               || :NEW.terminale
               || ' '
               || 'stampante='
               || :NEW.stampante;
      d_new_utente_aggiornamento := :NEW.utente;
   END IF;
   IF nvl(:NEW.accessi, 0) != nvl(:OLD.accessi, 0) THEN
      dep_is_accesso := 1;
   ELSE
      dep_is_accesso := 0;
   END IF;
   ad4_utente.gestisci_si_si3 (
   p_si_si3  => 'SI3',
   p_insert_or_update => dep_insert_or_update,
   p_new_utente => :NEW.utente,
   p_new_nominativo  => :NEW.nominativo,
   p_new_password  => :NEW.password,
   p_new_data_password => dep_data_psw,
   p_new_note => dep_note,
   p_new_lingua  => :NEW.gruppo_ling,
   p_new_gruppo_lavoro  => :NEW.gruppo,
   p_new_importanza  => :NEW.importanza,
   p_new_data_accesso => dep_data_accesso,
   p_new_tentativi  => :NEW.tentativi,
   p_new_giorni_password  => :NEW.giorni_password,
   p_new_traccia => dep_traccia,
   p_new_tentativi_password  => :NEW.tentativi_max,
   p_new_accesso  => :NEW.accesso,
   p_new_rinnovo_password => dep_rinnovo_password,
   p_new_utente_aggiornamento => d_new_utente_aggiornamento,
   p_old_utente => :OLD.utente,
   p_old_nominativo => :OLD.nominativo,
   p_old_giorni_password  => :OLD.giorni_password,
   p_old_traccia => dep_old_traccia,
   p_old_tentativi_password => :OLD.tentativi_max,
   p_old_accesso => :OLD.accesso,
   p_is_accesso => dep_is_accesso
);
EXCEPTION
   WHEN integrity_error THEN
      IntegrityPackage.InitNestLevel;
      RAISE_APPLICATION_ERROR (errno, errmsg);
   WHEN OTHERS THEN
      IntegrityPackage.InitNestLevel;
      RAISE;
END;
/* End Trigger: A_UTENTI_AD4_TIU*/
/
