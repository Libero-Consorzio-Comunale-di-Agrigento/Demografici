--liquibase formatted sql
--changeset amonopoli:201206011200 runOnChange:true stripComments:false
create or replace function F_FLAG_PRELIMINARE
		(a_anagrafe		IN	varchar2
		,a_tipo_evento	IN	varchar2
		,a_anno_pratica	IN	number
		,a_pratica		IN	number
		)

return varchar2

IS

w_flag		varchar2(1) := '';

w_errore		varchar2(255);
errore		exception;

begin
  if a_anagrafe = 'RES' and a_tipo_evento = 'I' then
     begin
       select 'S'
         into w_flag
         from anaeve eve
        where eve.anno_pratica	= a_anno_pratica
          and eve.pratica		= a_pratica
          and eve.cod_mov		= 1
          and eve.cod_eve		= 17
          and rownum			= 1
       ;
     exception
       when others then
            w_flag := '';
            w_errore := SQLCODE;
     end;
  end if;


  return w_flag;
exception
  when errore then
       raise_application_error(-20999, 'f_flag '||w_errore);
  when others then
       null;
end;
/
