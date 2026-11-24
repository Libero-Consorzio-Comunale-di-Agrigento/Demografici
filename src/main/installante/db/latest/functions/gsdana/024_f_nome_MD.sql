--liquibase formatted sql
--changeset amonopoli:202606111000_2 runOnChange:true stripComments:false
create or replace function f_nome_md 	
(a_matricola_md		varchar2
,a_maternita		varchar2)

return varchar

is

w_cognome_nome_md	varchar2(255);
w_nome_md		varchar2(255);

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
        w_nome_md := f_nome(w_cognome_nome_md);
     end if;
  end if;

  if w_nome_md is null then
     if instr(a_maternita,'/') > 0 then
        w_nome_md := f_nome(a_maternita);
     else
        w_nome_md := '';
     end if;
  end if;

  return w_nome_md;

end;
/
