--liquibase formatted sql
--changeset amonopoli:202606111000_1 runOnChange:true stripComments:false
create or replace function f_cognome_md 	
(a_matricola_md		varchar2
,a_maternita		varchar2)

return varchar

is

w_cognome_nome_md	varchar2(255);
w_cognome_md		varchar2(255);

begin
  if a_matricola_md is not null then
     begin
       select cognome_nome 
         into w_cognome_nome_md
         from anaana
        where matricola = a_matricola_md
          and rownum    = 1
       ;
     exception 
       when others then
            w_cognome_nome_md := '';
     end;
     if w_cognome_nome_md is not null then
        w_cognome_md := f_cognome(w_cognome_nome_md);
     end if;
  end if;

  if w_cognome_md is null then
     if instr(a_maternita,'/') > 0 then
        w_cognome_md := f_cognome(a_maternita);
     else
        w_cognome_md := a_maternita;
     end if;
  end if;

  return w_cognome_md;

end;
/
