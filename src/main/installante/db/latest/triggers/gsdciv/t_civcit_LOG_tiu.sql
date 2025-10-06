--liquibase formatted sql
--changeset amonopoli:202306211705_3 runOnChange:true stripComments:false
create or replace trigger CIVCIT_LOG_TIU
after INSERT or UPDATE
on CIVCIT
for each row

declare
  w_nome_tabella	varchar2(255) := 'CIVCIT';
  w_terminalista        varchar2(255) := :new.terminalista;
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
                'cod_rec: '||:new.cod_rec||' - '||
                'cognome: '||:new.cognome||' - '||
                'nome: '||:new.nome||' - '||
                'sesso: '||:new.sesso||' - '||
                'data_nas: '||to_char(:new.d_data_nas,'dd/mm/yyyy')||' - '||
                'cod_comune_nas: '||lpad(:new.cod_pro_nas,3,'0')||lpad(:new.cod_com_nas,3,'0')||' - '||
                'cod_comune_res: '||lpad(:new.cod_pro_res,3,'0')||lpad(:new.cod_com_res,3,'0')||' - '||
                'data_cit: '||to_char(:new.d_data_cit,'dd/mm/yyyy');
   end if;

   if UPDATING then
      w_note := w_note||' - '||
                'OLD: '||
                'id_atto: '||:old.id_atto||' - '||
                'cod_rec: '||:old.cod_rec||' - '||
                'cognome: '||:old.cognome||' - '||
                'nome: '||:old.nome||' - '||
                'sesso: '||:old.sesso||' - '||
                'data_nas: '||to_char(:old.d_data_nas,'dd/mm/yyyy')||' - '||
                'cod_comune_nas: '||lpad(:old.cod_pro_nas,3,'0')||lpad(:old.cod_com_nas,3,'0')||' - '||
                'cod_comune_res: '||lpad(:old.cod_pro_res,3,'0')||lpad(:old.cod_com_res,3,'0')||' - '||
                'data_cit: '||to_char(:old.d_data_cit,'dd/mm/yyyy');
   end if;

   INSERISCI_GSDLOG_DB(w_nome_tabella, w_operazione, w_note, nvl(w_terminalista,w_terminalista_f11), w_id_tabella);

exception
   when others then
        INSERISCI_GSDLOG_DB('GSDLOG_DB', 'errore', w_nome_tabella||' ('||sqlerrm||')');
end;
/
