--liquibase formatted sql
--changeset amonopoli:202310231140_1 runOnChange:true stripComments:false
create or replace function f_ANSC_cognome_officiante
(a_cognome_nome		IN	varchar2
,a_solo_cognome		IN	varchar2
)

return varchar2

IS

w_cognome	varchar2(255);

begin
  if a_solo_cognome is not null then
     w_cognome := a_solo_cognome;

  elsif a_cognome_nome is not null then
     if instr(a_cognome_nome, '  ') > 0 then
        w_cognome := substr(a_cognome_nome, 1, instr(a_cognome_nome,'  ') - 1);
     elsif instr(a_cognome_nome, ' ') > 0 then
        w_cognome := substr(a_cognome_nome, 1, instr(a_cognome_nome,' ') - 1);
     else
        w_cognome := '';
     end if;
  end if;

  return w_cognome;

end;
/
