--liquibase formatted sql
--changeset amonopoli:202503270900_5 runOnChange:false stripComments:false
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
insert into a_istanze_ambiente (AMBIENTE, ENTE, GRUPPO_LING, DESCRIZIONE, USER_ORACLE, PASSWORD, LINK_ORACLE, DISLOCAZIONE, STAMPANTE, VERSIONE, DISLOCAZIONE_CLIENT, ALIAS_STA)
select 'GSD', 'GSD', '*', 'Gestione Servizi Demografici', 'GSD', 'u~E', '', 'd:\si4\de4\de4gsd\', 'GSD-WIN12', '', '', ''
  from dual
 where not exists (select 'x' from a_istanze_ambiente
                    where ambiente = 'GSD'
                      and ente     = 'GSD');
end;
  
  end if;
end;
/
