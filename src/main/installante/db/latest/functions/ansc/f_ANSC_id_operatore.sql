--liquibase formatted sql
--changeset amonopoli:202305051545 runOnChange:true stripComments:false
create or replace function f_ANSC_id_operatore
(a_utente	IN	varchar2)

return varchar2

IS

w_cod_fiscale	varchar2(255);

begin
  if a_utente is not null and a_utente != 'ON_LINE' then
     begin
       select cod_fiscale
         into w_cod_fiscale
         from ansute
        where cod_utente = a_utente   
          and rownum     = 1
       ; 
     exception
       when others then
            w_cod_fiscale := '';
     end;

  elsif a_utente is null or a_utente = 'ON_LINE' then
     begin
       select cod_fiscale
         into w_cod_fiscale
         from ansute
        where flag_default is not null
          and rownum       = 1
       ; 
     exception
       when others then
            w_cod_fiscale := '';
     end;
  end if;

  return w_cod_fiscale;

end;
/
