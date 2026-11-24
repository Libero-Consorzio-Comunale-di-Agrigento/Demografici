--liquibase formatted sql
--changeset amonopoli:202512041105_2 runOnChange:true stripComments:false
create or replace trigger ANACOM_ALLE_TIU
before INSERT
    or UPDATE
on ANACOM_ALLE
for each row
declare

errore			exception;
w_errore		varchar2(4000);

w_operazione_log	varchar2(255) := 'ANACOM_alle_tiu';

begin
   if INSERTING then
      begin  
        :new.ID := F_ANACOM_ALLE_NR(:new.id);
      end;
      :new.D_DATA_REG      := sysdate;
      :new.TERMINALISTA    := si4.utente;
      :new.nome_allegato   := nvl(:new.nome_allegato,'ANACOM'||:new.id_com||'_allegato'||:new.id||'.pdf');
      :new.flag_da_firmare := f_PROT_flag_da_firmare('ANACOM');
   end if;


exception
  when errore then
       DOCAREA_PKG.ins_log(w_operazione_log, w_errore);
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       DOCAREA_PKG.ins_log(w_operazione_log, w_errore);
end;
/
