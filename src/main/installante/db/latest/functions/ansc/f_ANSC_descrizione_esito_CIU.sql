--liquibase formatted sql
--changeset amonopoli:202305081515 runOnChange:true stripComments:false
create or replace function f_ANSC_descrizione_esito_ciu
(a_esito_ansc		IN	varchar2)

return varchar2

IS

w_descrizione		varchar2(255);

begin
  if a_esito_ansc is not null then
     if a_esito_ansc = '0' then
        w_descrizione :=  'Servizio inviato con successo';
     elsif a_esito_ansc = '1' then
        w_descrizione := 'Errore';
     elsif a_esito_ansc = '999' then
        w_descrizione := 'Errore (999)';
     else
       w_descrizione := 'Esito non codificato';
    end if;
  end if;

  return w_descrizione;
end;
/
