--liquibase formatted sql
--changeset amonopoli:202306301000_1 runOnChange:true stripComments:false
create or replace trigger CIVCOM_LOG_TIU
after INSERT or UPDATE
on CIVCOM
for each row

declare
  w_nome_tabella	varchar2(255) := 'CIVCOM';
  w_terminalista        varchar2(255);
  w_terminalista_f11    varchar2(255) := si4.utente;
  w_id_tabella          varchar2(255);
  w_operazione		varchar2(255);
  w_note		varchar2(4000);

begin
   if w_terminalista_f11 is not null then
      w_terminalista_f11 := w_terminalista_f11||' (f11)';
   end if;

   if UPDATING then
      if :old.id_atto != :new.id_atto then
         begin
           update gsdlog_db
              set id_tabella = :new.id_atto
            where nome_tabella = w_nome_tabella
              and id_tabella   = :old.id_atto
           ;
         exception
           when others then 
                null;
         end;
      end if;
   end if;

   if INSERTING then
      w_id_tabella := :new.id_atto;
      w_operazione := 'INSERT';
   elsif UPDATING then
      w_id_tabella := :new.id_atto;
      w_operazione := 'UPDATE';
   end if;

   if INSERTING or UPDATING then
      w_note := 'NEW: '||
                'id_atto: '||:new.id_atto||' - '||
                'codice_co: '||:new.codice_co||' - '||
                'formula: '||:new.formula||' - '||
                'data_reg: '||to_char(:new.d_data_reg,'dd/mm/yyyy')||' - '||
                'id_atto_rif: '||:new.id_atto_rif||' - '||
                'stampa_eseguita: '||:new.stampa_eseguita||' - '||
                'id: '||:new.id;
   end if;

   if UPDATING then
      w_note := w_note||' - '||
                'OLD: '||
                'id_atto: '||:old.id_atto||' - '||
                'codice_co: '||:old.codice_co||' - '||
                'formula: '||:old.formula||' - '||
                'data_reg: '||to_char(:old.d_data_reg,'dd/mm/yyyy')||' - '||
                'id_atto_rif: '||:old.id_atto_rif||' - '||
                'stampa_eseguita: '||:old.stampa_eseguita||' - '||
                'id: '||:old.id;
   end if;

   INSERISCI_GSDLOG_DB(w_nome_tabella, w_operazione, w_note, nvl(w_terminalista,w_terminalista_f11), w_id_tabella);

exception
   when others then
        INSERISCI_GSDLOG_DB('GSDLOG_DB', 'errore', w_nome_tabella||' ('||sqlerrm||')');
end;
/
