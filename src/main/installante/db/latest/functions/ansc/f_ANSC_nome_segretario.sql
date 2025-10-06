--liquibase formatted sql
--changeset amonopoli:202504061220_2 runOnChange:true stripComments:false
create or replace function f_ANSC_nome_segretario
(a_cognome_nome		IN	varchar2
,a_solo_nome		IN	varchar2
)

return varchar2

IS

w_nome	varchar2(255);

begin
  if a_solo_nome is not null then
     w_nome := a_solo_nome;

  elsif a_cognome_nome is not null then
     if instr(a_cognome_nome, '  ') > 0 then
        w_nome := substr(a_cognome_nome, instr(a_cognome_nome,'  ') + 2);
     elsif instr(a_cognome_nome, ' ') > 0 then
        w_nome := substr(a_cognome_nome, instr(a_cognome_nome,' ') + 1);
     else
        w_nome := a_cognome_nome;
     end if;
  end if;

  return w_nome;

end;
/
