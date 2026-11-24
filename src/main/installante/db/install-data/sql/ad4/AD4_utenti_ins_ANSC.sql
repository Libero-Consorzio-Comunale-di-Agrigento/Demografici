--liquibase formatted sql
--changeset amonopoli:202512041525_2 runOnChange:true stripComments:false
declare
w_esiste_utente		number := 0;

begin
  begin
    select 1 into w_esiste_utente
      from ad4_utenti
     where utente = 'ANSC'
       and rownum = 1
    ;
  exception
    when no_data_found then
         w_esiste_utente := 0;
    when others then
         w_esiste_utente := -1;
  end;

  if w_esiste_utente = 0 then
     begin
       insert into ad4_utenti (UTENTE, NOMINATIVO, TIPO_UTENTE, ID_UTENTE, STATO)
       values ('ANSC', 'WS ANSC', 'U', '', 'U')
       ;
     exception
       when others then
            null;
     end;
  end if;
end;
/
