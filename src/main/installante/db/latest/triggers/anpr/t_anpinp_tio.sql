--liquibase formatted sql
--changeset amonopoli:202510311220_2 runOnChange:true stripComments:false
create or replace trigger ANPINP_TIO
instead of INSERT or UPDATE or DELETE
on ANPINP
for each row

declare

w_chiave              varchar2(255) := f_GSD_chiave_registro('ANPINP');

w_nome_tabella        varchar2(255) := 'ANPINP';
w_terminalista        varchar2(255);
w_terminalista_f11    varchar2(255) := si4.utente;
w_id_tabella          varchar2(255);
w_operazione          varchar2(255);
w_note                varchar2(4000);

begin
  if INSERTING then
     w_operazione   := 'INSERT';
     w_id_tabella   := :new.parametro;

     begin
       insert into ad4_registro
              (chiave, stringa, valore, commento)
       select w_chiave
            , :new.parametro
            , :new.valore
            , :new.descrizione
         from dual
        where not exists (select 1 from ad4_registro b
                           where b.chiave  = w_chiave
                             and b.stringa = :new.parametro)
       ;
     exception
       when others then
            w_note := 'ins_ad4_registro - errore: '||sqlerrm;
            INSERISCI_GSDLOG_DB(w_nome_tabella, w_operazione, w_note, nvl(w_terminalista,w_terminalista_f11), w_id_tabella);
     end;

     begin
       insert into ANPINP_orig
              (PARAMETRO, VALORE, DESCRIZIONE, FLAG_VISIBILE)
       select :new.PARAMETRO, :new.VALORE, :new.DESCRIZIONE, :new.FLAG_VISIBILE
         from dual
        where not exists (select 1 from ANPINP_orig b
                           where parametro = :new.parametro)
       ;
     exception
       when others then
            w_note := 'ins_ANPINP - errore: '||sqlerrm;
            INSERISCI_GSDLOG_DB(w_nome_tabella, w_operazione, w_note, nvl(w_terminalista,w_terminalista_f11), w_id_tabella);
     end;

  elsif UPDATING then
     w_operazione := 'UPDATE';
     w_id_tabella := :new.parametro;

     if :old.parametro              != :new.parametro            or
        nvl(:old.valore,' ')        != nvl(:new.valore,' ')      or
        nvl(:old.descrizione,' ')   != nvl(:new.descrizione,' ')
     then
        begin
          update ad4_registro
             set stringa  = :new.parametro
               , valore   = :new.valore
               , commento = :new.descrizione
           where chiave  = w_chiave
             and stringa = :old.parametro
          ;
        exception
          when others then
               w_note := 'upd_ad4_registro - errore: '||sqlerrm;
               INSERISCI_GSDLOG_DB(w_nome_tabella, w_operazione, w_note, nvl(w_terminalista,w_terminalista_f11), w_id_tabella);
        end;
     end if;

     begin
       update ANPINP_orig
          set parametro     = :new.parametro
            , valore        = :new.valore
            , descrizione   = :new.descrizione
            , flag_visibile = :new.flag_visibile
        where parametro = :old.parametro
       ;
     exception
       when others then
            w_note := 'upd_arinp - errore: '||sqlerrm;
            INSERISCI_GSDLOG_DB(w_nome_tabella, w_operazione, w_note, nvl(w_terminalista,w_terminalista_f11), w_id_tabella);
     end;

  elsif DELETING then
     w_operazione := 'DELETE';
     w_id_tabella := :old.parametro;

     begin
       delete ad4_registro
        where chiave  = w_chiave
          and stringa = :old.parametro
       ;
     exception
       when others then
            w_note := 'del_ad4_registro - errore: '||sqlerrm;
            INSERISCI_GSDLOG_DB(w_nome_tabella, w_operazione, w_note, nvl(w_terminalista,w_terminalista_f11), w_id_tabella);
     end;

     begin
       delete ANPINP_orig
        where parametro = :old.parametro
       ;
     exception
       when others then
            w_note := 'del_arinp - errore: '||sqlerrm;
            INSERISCI_GSDLOG_DB(w_nome_tabella, w_operazione, w_note, nvl(w_terminalista,w_terminalista_f11), w_id_tabella);
     end;

  end if;
end;
/
