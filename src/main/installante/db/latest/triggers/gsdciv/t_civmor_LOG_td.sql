--liquibase formatted sql
--changeset amonopoli:202306221145_2 runOnChange:true stripComments:false
create or replace trigger CIVMOR_LOG_TD
after DELETE
on CIVMOR
for each row

declare
  w_nome_tabella	varchar2(255) := 'CIVMOR';
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
                'cod_rec: '||:old.cod_rec||' - '||
                'cognome: '||:old.cognome||' - '||
                'nome: '||:old.nome||' - '||
                'sesso: '||:old.sesso||' - '||
                'data_nas: '||to_char(:old.d_data_nas,'dd/mm/yyyy')||' - '||
                'cod_comune_nas: '||lpad(:old.cod_pro_nas,3,'0')||lpad(:old.cod_com_nas,3,'0')||' - '||
                'cod_comune_res: '||lpad(:old.cod_pro_res,3,'0')||lpad(:old.cod_com_res,3,'0')||' - '||
                'data_mor: '||to_char(:old.d_data_mor,'dd/mm/yyyy')||' - '||
                'cod_comune_mor: '||lpad(:old.cod_pro_mor,3,'0')||lpad(:old.cod_com_mor,3,'0');
   end if;

   INSERISCI_GSDLOG_DB(w_nome_tabella, w_operazione, w_note, nvl(w_terminalista,w_terminalista_f11), w_id_tabella);

exception
   when others then
        INSERISCI_GSDLOG_DB('GSDLOG_DB', 'errore', w_nome_tabella||' ('||sqlerrm||')');
end;
/
