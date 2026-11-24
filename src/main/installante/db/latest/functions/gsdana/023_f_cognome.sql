--liquibase formatted sql
--changeset amonopoli:202606110950_1 runOnChange:true stripComments:false
create or replace function f_cognome 
(a_cognome_nome varchar2)

return varchar

is

w_cognome	varchar2(255);

begin
  if instr(a_cognome_nome,'/') > 0 then
     w_cognome := substr(a_cognome_nome,1,instr(a_cognome_nome,'/')-1);
  else
     w_cognome := a_cognome_nome;
  end if;

  return w_cognome;

end;
/
