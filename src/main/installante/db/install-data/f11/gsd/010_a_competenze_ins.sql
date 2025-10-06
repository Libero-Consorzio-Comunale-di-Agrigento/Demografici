--liquibase formatted sql
--changeset amonopoli:202503270900_10 runOnChange:false stripComments:false
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
insert into a_competenze (UTENTE, OGGETTO, AMBIENTE, ENTE, COMPETENZA, GRUPPO)
select 'GSD', 'ACCESSO', 'GSD', 'GSD', 'ASEN', ''
  from dual
 where not exists (select 'x' from a_competenze
                    where utente = 'GSD');
end;

  end if;
end;
/

