--liquibase formatted sql
--changeset amonopoli:202306211635 runOnChange:true stripComments:false
create or replace procedure INSERISCI_GSDLOG_DB
(a_nome_tabella		IN	varchar2
,a_operazione		IN	varchar2
,a_note			IN	varchar2
,a_terminalista		IN	varchar2 	default null
,a_id_tabella		IN	varchar2	default null
)

IS

w_inserisci_log	varchar2(255);

w_log_id		number;
w_nome_tabella		varchar2(255)	:= a_nome_tabella;
w_operazione		varchar2(255)	:= a_operazione;
w_note			varchar2(4000)	:= a_note;
w_terminalista		varchar2(255) 	:= a_terminalista;
w_id_tabella		varchar2(255)	:= a_id_tabella;

w_data_ora		date		:= sysdate;

w_errore		varchar2(2000);
errore			exception;

begin
  begin
    select nvl(max(log_id),0) + 1
      into w_log_id
      from gsdlog_db
    ;
  exception
    when others then 
         w_log_id := 1;
  end;


  begin
    insert into gsdlog_db	
           (log_id, data_ora, nome_tabella, operazione, note, terminalista, id_tabella)
    values (w_log_id, w_data_ora, w_nome_tabella, w_operazione, w_note, w_terminalista, w_id_tabella)
    ;
  exception
    when others then
         null;
  end;

exception
  when errore then
       null;
--       raise_application_error(-20999, w_errore);
--       rollback;
  when others then
       null;
--       raise_application_error(-20999, 'Errore ('||SQLERRM||')');
--       rollback;
end;
/
