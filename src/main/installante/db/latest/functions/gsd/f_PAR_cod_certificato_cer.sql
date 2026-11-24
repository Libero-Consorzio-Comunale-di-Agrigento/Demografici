--liquibase formatted sql
--changeset amonopoli:202410281245_5 runOnChange:true stripComments:false
create or replace function f_PAR_cod_certificato_cer
(a_fase		IN	varchar2
,a_funzione	IN	varchar2
)

return varchar2

IS

w_cod_certificato		varchar2(255);

begin
  if a_fase||a_funzione is not null then
     if a_fase = 'CERW' then
        w_cod_certificato := substr(a_funzione,1,3);
     end if;
  end if;
 
  return w_cod_certificato;

end;
/
