--liquibase formatted sql
--changeset amonopoli:202606161205 runOnChange:true stripComments:false
create or replace function F_GSD_INSERISCI_LOG
(a_fase			IN	varchar2
,a_parametri		IN	varchar2
,a_note			IN	varchar2
,a_terminalista		IN	varchar2
,a_operazione		IN	varchar2
)

return number

IS

w_inserisci_log	varchar2(255);

w_log_id	number;
w_fase		varchar2(255)	:= upper(a_fase);
w_parametri	varchar2(2000)	:= a_parametri;
w_note		varchar2(2000)	:= a_note;
w_terminalista	varchar2(255)	:= a_terminalista;
w_operazione	varchar2(255)	:= a_operazione;

w_data_reg	number		:= to_char(sysdate,'j');
w_ora_reg	number		:= to_char(sysdate,'hh24');
w_minuti_reg	number		:= to_char(sysdate,'mi');
w_d_data_reg	date		:= sysdate;

w_return	number;

w_errore	varchar2(2000);
errore		exception;

begin
  w_return := 0;

  begin
    select nvl(max(log_id),0) + 1
      into w_log_id
      from gsdlog
    ;
  exception
    when others then 
--         w_errore	:= 'sel_arcinp ('||SQLERRM||')';
--         raise_errore;
         w_log_id := 1;
  end;

  if w_fase = 'ZK' and w_operazione is not null then
     w_fase          := '';
     w_inserisci_log := 'S';
  else
     begin
       select nvl(upper(substr(valore,1,1)),'N')
         into w_inserisci_log
         from arcinp
        where parametro = 'LOG_'||w_fase
       ;
     exception
       when others then
--            w_errore	:= 'sel_arcinp ('||SQLERRM||')';
--            raise_errore;
            w_inserisci_log := 'S';
     end;
  end if;

  if w_inserisci_log = 'S' then
     begin
       insert into gsdlog	
		  (log_id, fase, parametri, note, data_reg, ora_reg, minuti_reg, d_data_reg, terminalista, operazione )
       values (w_log_id, w_fase, w_parametri, w_note, w_data_reg, w_ora_reg, w_minuti_reg, w_d_data_reg, w_terminalista, w_operazione)
       ;
       if sql%found then
          w_return := 1;
       else
          w_return := 0;
       end if;
     exception
       when others then
--         w_errore	:= 'ins_gsdlog ('||SQLERRM||')';
--         raise_errore;
            w_return := -1;
     end;
  else
--   w_errore	:= 'w_inserisci_log: '||w_inserisci_log;
--   raise errore;
     null;
  end if;

  return w_return;

exception
  when errore then
       null;
  when others then
       null;
end;
/
