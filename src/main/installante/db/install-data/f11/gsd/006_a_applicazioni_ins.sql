--liquibase formatted sql
--changeset amonopoli:202503270900_6 runOnChange:false stripComments:false
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
insert into a_applicazioni (APPLICAZIONE, TITOLO, TITOLO_AL1, TITOLO_AL2, VOCE_MENU, AMBIENTE, VOCE_MENU_FINE)
select 'GSD', 'Gestione Servizi Demografici', '', '', 'GSDSTART', 'GSD', ''
  from dual
 where not exists (select 'x'
                     from a_applicazioni
                    where applicazione = 'GSD');
end;
  end if;
end;
/
