--liquibase formatted sql
--changeset amonopoli:202311081250_1 runOnChange:true stripComments:false
create or replace function f_ANSC_get_cognome_sog
(a_id_soggetto_ansc		IN	number
)

return varchar2

IS

w_cognome		varchar2(255);

begin
  begin
    select v.cognome
      into w_cognome
      from anssog_v v
     where id_soggetto_ansc = a_id_soggetto_ansc
    ;
  exception
    when others then 
         w_cognome := '';
  end;

  return w_cognome;
end;
/
