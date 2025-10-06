--liquibase formatted sql
--changeset amonopoli:202306301000_2 runOnChange:true stripComments:false
create or replace trigger CIVCOM_LOG_TD
after DELETE
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

   if DELETING then
      w_id_tabella := :old.id_atto;
      w_operazione := 'DELETE';
   end if;

   if DELETING then
      w_note := 'OLD: '||
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
