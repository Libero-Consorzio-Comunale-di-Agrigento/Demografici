--liquibase formatted sql
--changeset amonopoli:202407301500 runOnChange:true stripComments:false
create or replace function f_GTE_inserisci_log
(a_operazione   IN	varchar2
,a_note 	IN	varchar2
,a_campo_clob 	IN	clob	
,a_modulo_rif	IN	varchar2
,a_id_rif	IN	varchar2
)

return number

IS

w_id			number;

w_operazione_log	varchar2(255) := 'ins_log';

w_errore		varchar2(4000);
errore			exception;

w_return		number;

begin
  w_return := 0;

  begin
    select GTE_LOG_SQ.nextval
      into w_id
      from dual
    ;
  end;

  begin
    insert into gte_log (id, data_ora, operazione, note, campo_clob, modulo_rif, id_rif)
    values (w_id, sysdate, a_operazione, a_note, a_campo_clob, a_modulo_rif, a_id_rif)
    ;
    if sql%found then
       w_return := 1;
    end if;
--COMMIT;
  exception
    when others then
         raise errore;
  end;

<< fine >>
  return w_return;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       begin
         insert into gte_log (id, data_ora, operazione, note, campo_clob, modulo_rif, id_rif)
         values (w_id, sysdate, w_operazione_log, a_note, a_campo_clob, a_modulo_rif, a_id_rif)
         ;
       end;
       w_return := -1;
       return w_return;
end;
/