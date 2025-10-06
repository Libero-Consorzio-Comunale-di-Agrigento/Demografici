--liquibase formatted sql
--changeset amonopoli:202310251155 runOnChange:true stripComments:false
create or replace function f_CIV_numero_unico_comunale
(a_numero_unico		IN	number
)

return number

IS

w_flag_ansc		varchar2(255) := f_flag_ANSC();

w_numero_unico		number;

begin
  if nvl(w_flag_ansc,'N') = 'S' and a_numero_unico is not null then
     w_numero_unico := a_numero_unico;
  end if;

  return w_numero_unico;
end;
/
