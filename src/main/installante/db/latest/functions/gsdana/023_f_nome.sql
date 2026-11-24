--liquibase formatted sql
--changeset amonopoli:202606110950_2 runOnChange:true stripComments:false
create or replace function f_nome 
(a_cognome_nome varchar2)

return varchar

is

w_nome	varchar2(255);

begin
  if instr(a_cognome_nome,'/') > 0 then
     w_nome := substr(a_cognome_nome,instr(a_cognome_nome,'/')+1);
  else
     w_nome := '';
  end if;

  return w_nome;

end;
/
