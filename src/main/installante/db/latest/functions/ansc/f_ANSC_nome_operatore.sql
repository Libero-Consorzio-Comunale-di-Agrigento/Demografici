--liquibase formatted sql
--changeset amonopoli:202305111245_1 runOnChange:true stripComments:false
create or replace function f_ANSC_nome_operatore
(a_utente	IN	varchar2)

return varchar2

IS

w_nome	varchar2(255);

begin
  if a_utente is not null and a_utente != 'ON_LINE' then
     begin
       select nome
         into w_nome
         from ansute
        where cod_utente = a_utente   
          and rownum     = 1
       ; 
     exception
       when others then
            w_nome := '';
     end;

  elsif a_utente is null or a_utente = 'ON_LINE' then
     begin
       select nome
         into w_nome
         from ansute
        where flag_default is not null
          and rownum       = 1
       ; 
     exception
       when others then
            w_nome := '';
     end;
  end if;

  return w_nome;

end;
/
