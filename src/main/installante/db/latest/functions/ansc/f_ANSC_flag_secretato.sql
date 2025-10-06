--liquibase formatted sql
--changeset amonopoli:202310120930 runOnChange:true stripComments:false
create or replace function f_ANSC_flag_secretato
(a_tipo_atto    	IN	varchar2
,a_sigla_categoria	IN	varchar2
)

return number

IS

w_return		number;

begin
  w_return := 0;
  if a_tipo_atto = 2 and a_sigla_categoria = 'ADO' then
     w_return := 1;
  end if;
  
  return w_return;
end;
/
