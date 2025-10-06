--liquibase formatted sql
--changeset amonopoli:202305181140 runOnChange:true stripComments:false
create or replace function f_ANSC_inserisci_log
(a_servizio 		IN	varchar2
,a_operazione   	IN	varchar2
,a_note 		IN	varchar2
,a_campo_clob 		IN	clob	default null
)

return number

IS

w_return	number;

begin
  w_return := 0;

  if a_servizio||a_operazione||a_note||a_campo_clob is not null then
     begin 
       ANSC_PKG.ins_log(a_servizio, a_operazione, a_note, a_campo_clob);
       w_return := 1;
     exception
       when others then
            w_return := -1;
     end;
  end if;

  return w_return;

end;
/
