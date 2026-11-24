--liquibase formatted sql
--changeset amonopoli:202604011425_0 runOnChange:true stripComments:false
create or replace function f_ANPR_des_esito_ciu
(a_esito_anpr		IN	varchar2)

return varchar2

IS

w_esito_anpr		varchar2(255) := upper(a_esito_anpr);

w_descrizione		varchar2(255);

begin
  if w_esito_anpr is not null then
     if w_esito_anpr in ('0000','00AA') then
        w_descrizione :=  'Servizio inviato con successo';

     elsif w_esito_anpr = 'XXXX' then
        w_descrizione := 'Errore';

     else
       w_descrizione := 'Esito non codificato ('||a_esito_anpr||')';
    end if;
  end if;

  return w_descrizione;
end;
/
