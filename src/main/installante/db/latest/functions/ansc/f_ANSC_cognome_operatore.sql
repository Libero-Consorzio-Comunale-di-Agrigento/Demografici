--liquibase formatted sql
--changeset amonopoli:202305111245_2 runOnChange:true stripComments:false
create or replace function f_ANSC_cognome_operatore
(a_utente	IN	varchar2)

return varchar2

IS

w_cognome	varchar2(255);

begin
  if a_utente is not null and a_utente != 'ON_LINE' then
     begin
       select cognome
         into w_cognome
         from ansute
        where cod_utente = a_utente   
          and rownum     = 1
       ; 
     exception
       when others then
            w_cognome := '';
     end;

  elsif a_utente is null or a_utente = 'ON_LINE' then
     begin
       select cognome
         into w_cognome
         from ansute
        where flag_default is not null
          and rownum       = 1
       ; 
     exception
       when others then
            w_cognome := '';
     end;
  end if;

  return w_cognome;

end;
/
