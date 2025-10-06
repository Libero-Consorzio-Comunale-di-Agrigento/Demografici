--liquibase formatted sql
--changeset amonopoli:202503270900_1 runOnChange:false stripComments:false
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
insert into a_gruppi_lavoro (GRUPPO, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2)
select 'GS', 'Gruppo GS', '', ''
  from dual
 where not exists (select 'x' from a_gruppi_lavoro b
                    where b.gruppo = 'GS');
end;

  end if;
end;
/
