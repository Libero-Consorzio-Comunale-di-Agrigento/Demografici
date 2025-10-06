--liquibase formatted sql
--changeset amonopoli:202410241455 runOnChange:true stripComments:false
create or replace trigger CERCEM_LOG_TIU
before INSERT
    or UPDATE
    or DELETE 
on CERCEM
for each row
declare
  w_nome_tabella	varchar2(255) := 'CERCEM';
  w_operazione		varchar2(255);
  w_note		varchar2(4000);

  w_terminalista        varchar2(255) := '';
  w_terminalista_f11    varchar2(255) := si4.utente;
  w_id_tabella          varchar2(255);

begin
   if w_terminalista_f11 is not null then
      w_terminalista_f11 := w_terminalista_f11||' (f11)';
   end if;

   if INSERTING then
      w_terminalista := nvl(w_terminalista,:new.terminalista);
      w_operazione := 'INSERT';
   elsif UPDATING then
      w_operazione := 'UPDATE';
   else
      w_operazione := 'DELETE';
   end if;

   if INSERTING or UPDATING then
      w_id_tabella := :new.anno_emissione||lpad(:new.progr_emissione,6,'0');
      w_note := 'NEW anno_emissione: '||:new.anno_emissione||' - '||
                'progr_emissione: '||:new.progr_emissione||' - '||
                'data_emissione: '||to_char(:new.d_data_emissione,'dd/mm/yyyy')||' - '||
                'cod_certificato: '||:new.cod_certificato||' - '||
                'cognome_nome: '||:new.cognome_nome||' - '||
                'segreteria: '||:new.segreteria||' - '||
                'stato_civile: '||:new.stato_civile||' - '||
                'rimborso_st: '||:new.rimborso_st||' - '||
                'bollo: '||:new.bollo||' - '||
                'terminalista: '||:new.terminalista||' - '||
                'id_documento_gdm: '||:new.id_documento_gdm||' - '||
                'id_oggetto_file_gdm: '||:new.id_oggetto_file_gdm;

      if :new.annullamento is not null then
         w_note := w_note||' - '||
                   'annullamento: '||:new.annullamento||' - '||
                   'utente_annullamento: '||:new.utente_annullamento||' - '||
                   'data_annullamento: '||to_char(:new.d_data_annullamento,'dd/mm/yyyy');
      end if;

      if :new.utente_ripristino is not null then
         w_note := w_note||' - '||
                   'utente_ripristino: '||:new.utente_ripristino||' - '||
                   'data_ripristino: '||to_char(:new.d_data_ripristino,'dd/mm/yyyy');
      end if;

   end if;

   if UPDATING or DELETING then
      w_id_tabella := :old.anno_emissione||lpad(:old.progr_emissione,6,'0');
      w_note := w_note||' - '||
                'OLD anno_emissione: '||:old.anno_emissione||' - '||
                'progr_emissione: '||:old.progr_emissione||' - '||
                'data_emissione: '||to_char(:old.d_data_emissione,'dd/mm/yyyy')||' - '||
                'cod_certificato: '||:old.cod_certificato||' - '||
                'cognome_nome: '||:old.cognome_nome||' - '||
                'segreteria: '||:old.segreteria||' - '||
                'stato_civile: '||:old.stato_civile||' - '||
                'rimborso_st: '||:old.rimborso_st||' - '||
                'bollo: '||:old.bollo||' - '||
                'terminalista: '||:old.terminalista||' - '||
                'id_documento_gdm: '||:old.id_documento_gdm||' - '||
                'id_oggetto_file_gdm: '||:old.id_oggetto_file_gdm;

       if :old.annullamento is not null then
          w_note := w_note||' - '||
                    'annullamento: '||:old.annullamento||' - '||
                    'utente_annullamento: '||:old.utente_annullamento||' - '||
                    'data_annullamento: '||to_char(:old.d_data_annullamento,'dd/mm/yyyy');
       end if;

       if :old.utente_ripristino is not null then
          w_note := w_note||' - '||
                    'utente_ripristino: '||:old.utente_ripristino||' - '||
                    'data_ripristino: '||to_char(:old.d_data_ripristino,'dd/mm/yyyy');
       end if;
   end if;

   w_note := ltrim(ltrim(ltrim(w_note),'-'));

   INSERISCI_GSDLOG_DB(w_nome_tabella, w_operazione, w_note, nvl(w_terminalista,w_terminalista_f11), w_id_tabella);

exception
   when others then
        INSERISCI_GSDLOG_DB('GSDLOG_DB', 'errore', w_nome_tabella||' ('||sqlerrm||')');
end;
/
