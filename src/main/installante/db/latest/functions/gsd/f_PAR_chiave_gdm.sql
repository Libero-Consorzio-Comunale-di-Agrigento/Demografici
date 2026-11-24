--liquibase formatted sql
--changeset amonopoli:202410281245_7 runOnChange:true stripComments:false
create or replace function f_PAR_chiave_gdm
(a_fase		IN	varchar2
,a_destinatario	IN	varchar2
)

return varchar2

IS

w_chiave_gdm		varchar2(255);

begin
  if a_fase||a_destinatario is not null then
     if a_destinatario like 'AODI%' then
        w_chiave_gdm := 'NUMERO_'||upper(substr(a_destinatario,6));
     end if;
  end if;
 
  return w_chiave_gdm;

end;
/
