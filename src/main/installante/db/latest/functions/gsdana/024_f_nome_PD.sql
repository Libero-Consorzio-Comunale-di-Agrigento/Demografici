--liquibase formatted sql
--changeset amonopoli:202606110955_2 runOnChange:true stripComments:false
create or replace function f_nome_pd 	
(a_matricola_pd		varchar2
,a_paternita		varchar2
,a_cognome_nome 	varchar2)

return varchar

is

w_cognome_nome_pd	varchar2(255);
w_nome_pd		varchar2(255);

begin
  if a_matricola_pd is not null then
     begin
       select cognome_nome 
         into w_cognome_nome_pd
         from anaana
        where matricola = a_matricola_pd
          and rownum    = 1
       ;
     exception 
       when others then
            w_cognome_nome_pd := '';
     end;
     if w_cognome_nome_pd is not null then
        w_nome_pd := f_nome(w_cognome_nome_pd);
     end if;
  end if;

  if w_nome_pd is null then
     if instr(a_paternita,'/') > 0 then
        w_nome_pd := f_nome(a_paternita);
     else
        w_nome_pd := a_paternita;
     end if;
  end if;

  return w_nome_pd;

end;
/
