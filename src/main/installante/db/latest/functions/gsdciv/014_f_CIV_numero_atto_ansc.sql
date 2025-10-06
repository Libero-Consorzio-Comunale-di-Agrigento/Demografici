--liquibase formatted sql
--changeset amonopoli:202310250925 runOnChange:true stripComments:false
create or replace function f_CIV_numero_atto_ansc
(a_id_atto_ansc		IN	varchar2 
,a_numero_unico		IN	number	default null
)

return varchar2

IS

w_flag_ansc		varchar2(255) := f_flag_ANSC();

w_numero_atto_ansc	varchar2(255);

begin
  if nvl(w_flag_ansc,'N') = 'S' and a_id_atto_ansc||a_numero_unico is not null then
     if a_id_atto_ansc is null then
        w_numero_atto_ansc := a_numero_unico||' di questo Comune';
     else 
        w_numero_atto_ansc := a_id_atto_ansc;
     end if;
  end if;

  return w_numero_atto_ansc;
end;
/
