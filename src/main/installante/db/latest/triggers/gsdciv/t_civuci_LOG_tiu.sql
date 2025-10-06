--liquibase formatted sql
--changeset amonopoli:202306211705_5 runOnChange:true stripComments:false
create or replace trigger CIVUCI_LOG_TIU
after INSERT or UPDATE
on CIVUCI
for each row

declare
  w_nome_tabella	varchar2(255) := 'CIVUCI';
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
                'cognome_1: '||:new.cognome_m||' - '||
                'nome_1: '||:new.nome_m||' - '||
                'sesso_1: '||:new.sesso_m||' - '||
                'data_nas_1: '||to_char(:new.d_data_nas_m,'dd/mm/yyyy')||' - '||
                'cod_comune_nas_1: '||lpad(:new.cod_pro_nas_m,3,'0')||lpad(:new.cod_com_nas_m,3,'0')||' - '||
                'cod_comune_res_1: '||lpad(:new.cod_pro_res_m,3,'0')||lpad(:new.cod_com_res_m,3,'0')||' - '||
                'cognome_2: '||:new.cognome_f||' - '||
                'nome_2: '||:new.nome_f||' - '||
                'sesso_2: '||:new.sesso_f||' - '||
                'data_nas_2: '||to_char(:new.d_data_nas_m,'dd/mm/yyyy')||' - '||
                'cod_comune_nas_2: '||lpad(:new.cod_pro_nas_m,3,'0')||lpad(:new.cod_com_nas_m,3,'0')||' - '||
                'cod_comune_res_2: '||lpad(:new.cod_pro_res_m,3,'0')||lpad(:new.cod_com_res_m,3,'0')||' - '||
                'data_mat: '||to_char(:new.d_data_mat,'dd/mm/yyyy')||' - '||
                'cod_comune_mat: '||lpad(:new.cod_pro_mat,3,'0')||lpad(:new.cod_com_mat,3,'0');
   end if;

   if UPDATING then
      w_note := w_note||' - '||
                'OLD: '||
                'id_atto: '||:old.id_atto||' - '||
                'cod_rec: '||:old.cod_rec||' - '||
                'cognome_1: '||:old.cognome_m||' - '||
                'nome_1: '||:old.nome_m||' - '||
                'sesso_1: '||:old.sesso_m||' - '||
                'data_nas_1: '||to_char(:old.d_data_nas_m,'dd/mm/yyyy')||' - '||
                'cod_comune_nas_1: '||lpad(:old.cod_pro_nas_m,3,'0')||lpad(:old.cod_com_nas_m,3,'0')||' - '||
                'cod_comune_res_1: '||lpad(:old.cod_pro_res_m,3,'0')||lpad(:old.cod_com_res_m,3,'0')||' - '||
                'cognome_2: '||:old.cognome_f||' - '||
                'nome_2: '||:old.nome_f||' - '||
                'sesso_2: '||:old.sesso_f||' - '||
                'data_nas_2: '||to_char(:old.d_data_nas_f,'dd/mm/yyyy')||' - '||
                'cod_comune_nas_2: '||lpad(:old.cod_pro_nas_f,3,'0')||lpad(:old.cod_com_nas_f,3,'0')||' - '||
                'cod_comune_res_2: '||lpad(:old.cod_pro_res_f,3,'0')||lpad(:old.cod_com_res_f,3,'0')||' - '||
                'data_mat: '||to_char(:old.d_data_mat,'dd/mm/yyyy')||' - '||
                'cod_comune_mat: '||lpad(:old.cod_pro_mat,3,'0')||lpad(:old.cod_com_mat,3,'0');
   end if;

   INSERISCI_GSDLOG_DB(w_nome_tabella, w_operazione, w_note, nvl(w_terminalista,w_terminalista_f11), w_id_tabella);

exception
   when others then
        INSERISCI_GSDLOG_DB('GSDLOG_DB', 'errore', w_nome_tabella||' ('||sqlerrm||')');
end;
/
