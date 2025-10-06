--liquibase formatted sql
--changeset amonopoli:202503270900_4 runOnChange:false stripComments:false
declare
w_menu		number;

begin
  begin
    select 1 into w_menu
      from a_menu
     where applicazione = 'GSD'
       and rownum = 1
    ;
  exception
    when no_data_found then
         w_menu := 0;
    when others then
         w_menu := -1;
  end;

  if w_menu = 0 then

begin
insert into a_utenti (UTENTE, NOMINATIVO, PASSWORD, GRUPPO_LING, GRUPPO, DATA_PASSWORD, GIORNI_PASSWORD, ABIL_PASSWORD, STAT_ACCESSI, ACCESSO) 
select 'GSD', 'GSD', 'u~E', '*', 'GS', trunc(sysdate), null, 'S', 'S', 'L'
  from dual
 where not exists (select 'x' from a_utenti b
                    where b.utente = 'GSD');
end;

  end if;
end;
/
