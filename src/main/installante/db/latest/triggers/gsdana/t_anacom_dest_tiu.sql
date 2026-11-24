--liquibase formatted sql
--changeset amonopoli:202512041100_2 runOnChange:true stripComments:false
create or replace trigger ANACOM_DEST_TIU
before INSERT
    or UPDATE
on ANACOM_DEST
for each row
declare

errore			exception;
w_errore		varchar2(4000);

w_operazione_log	varchar2(255) := 'ANACOM_dest_tiu';

begin
   if INSERTING then
      begin  
        :new.id := F_ANACOM_DEST_NR(:new.id);
      end;
      :new.D_DATA_REG   := sysdate;
      :new.TERMINALISTA := si4.utente;
   end if;


exception
  when errore then
       DOCAREA_PKG.ins_log(w_operazione_log, w_errore);
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       DOCAREA_PKG.ins_log(w_operazione_log, w_errore);
end;
/
