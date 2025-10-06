--liquibase formatted sql
--changeset amonopoli:202503270900_14 runOnChange:false stripComments:false
declare
w_menu		number;

w_padre		number;

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

-- ruolo RGSD
begin
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', '0', (select (nvl(max(figlio),0) + 1) from a_menu), 'MENUARC', 1, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', '0', (select (nvl(max(figlio),0) + 1) from a_menu), 'MENUANA', 2, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', '0', (select (nvl(max(figlio),0) + 1) from a_menu), 'MENUCIV', 3, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', '0', (select (nvl(max(figlio),0) + 1) from a_menu), 'MENUELE', 4, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', '0', (select (nvl(max(figlio),0) + 1) from a_menu), 'MENULEV', 5, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', '0', (select (nvl(max(figlio),0) + 1) from a_menu), 'MENUCER', 6, '' from dual;

w_padre := f_a00_padre('MENUARC','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre, (select (nvl(max(figlio),0) + 1) from a_menu), 'ARCSARC', 70, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre, (select (nvl(max(figlio),0) + 1) from a_menu), 'ARCPARC', 100, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre, (select (nvl(max(figlio),0) + 1) from a_menu), 'ARCGPRO', 5, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre, (select (nvl(max(figlio),0) + 1) from a_menu), 'ARCVCOM', 9, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre, (select (nvl(max(figlio),0) + 1) from a_menu), 'ARCGCOM', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre, (select (nvl(max(figlio),0) + 1) from a_menu), 'ARCVVIE', 19, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre, (select (nvl(max(figlio),0) + 1) from a_menu), 'ARCGVIE', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre, (select (nvl(max(figlio),0) + 1) from a_menu), 'ARCGCON', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre, (select (nvl(max(figlio),0) + 1) from a_menu), 'ARCGDCO', 35, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre, (select (nvl(max(figlio),0) + 1) from a_menu), 'ARCGTES', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre, (select (nvl(max(figlio),0) + 1) from a_menu), 'ARCGINP', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre, (select (nvl(max(figlio),0) + 1) from a_menu), 'ARCADNC', 30, '' from dual;

w_padre := f_a00_padre('ARCSARC','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ARCSPCO', 5, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ARCSCCO', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ARCSCIA', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ARCSCEA', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ARCSVIA', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ARCSVIC', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ARCSCON', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ARCSTES', 70, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ARCSCCE', 80, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ARCSDIC', 200, '' from dual;

w_padre := f_a00_padre('MENUANA','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANADANA', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAGARC', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAARES', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAAIRE', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAECIV', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVIAN', 70, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASTAN', 80, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAPANA', 100, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAGCEN', 110, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAELEV', 45, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAGDOC', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAAGEV', 95, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANARMIN', 96, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANANOTE', 97, '' from dual;

w_padre := f_a00_padre('ANADANA','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'DANASDAN', 130, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANADSEN', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANADANG', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANADTER', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANADDOC', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAAVST', 15, '' from dual;

w_padre := f_a00_padre('DANASDAN','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASDUT', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASDST', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASDTS', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASDPR', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASDCI', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASDCA', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASDUP', 61, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASAST', 70, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASSAG', 80, '' from dual;

w_padre := f_a00_padre('ANAGARC','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANACANA', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANACAIR', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASCAM', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASCAA', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANACANR', 23, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAFAIR', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANA2FAM', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANARSTO', 100, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANARSTA', 110, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAFSTO', 90, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANACSPT', 26, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAAALB', 28, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAESTC', 125, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAFSTA', 95, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAESTO', 120, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASSPT', 27, '' from dual;

w_padre := f_a00_padre('ANAARES','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ARESGEVR', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANARANR', 20, '' from dual;

w_padre := f_a00_padre('ARESGEVR','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'GEVRGAP4', 5, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAIAPR', 1, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANACAPR', 2, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANACABI', 3, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANARICO', 65, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAMORP', 90, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANACAMO', 100, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAAINI', 90, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'GEVRGEPT', 10, '' from dual;

w_padre := f_a00_padre('GEVRGAP4','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANACAP4', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANARAP4', 15, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASAP4', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASREN', 22, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASMPC', 25, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVAP4', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVAPM', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAAAP4', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASCAP', 70, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAEAP4', 80, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANACCP4', 110, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASCP4', 120, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVCPM', 45, '' from dual;

w_padre := f_a00_padre('ANAAIRE','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'AIREGEVA', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANARANA', 20, '' from dual;

w_padre := f_a00_padre('AIREGEVA','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'GEVAGA01', 5, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAISAI', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANACVAI', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASCAI', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANACREA', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAMRPA', 50, '' from dual;

w_padre := f_a00_padre('GEVAGA01','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANACA01', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANARA01', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASA01', 25, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVA0M', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVA0I', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANACC01', 50, '' from dual;

w_padre := f_a00_padre('ANAECIV','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASCNA', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASCMA', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASCMO', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASCDV', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAAGES', 50, '' from dual;

w_padre := f_a00_padre('ANAVIAN','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'VIANVRPR', 90, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVANA', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVEVE', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVDOC', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVDOG', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVANM', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVNCO', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVMOV', 70, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVSEN', 72, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVCEN', 80, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVTPR', 100, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVFAM', 55, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAMTPR', 105, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVNCD', 65, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVR01', 103, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVDAL', 66, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASAIA', 110, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVANG', 11, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVIGI', 120, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'GSDVLOG', 900, '' from dual;

w_padre := f_a00_padre('VIANVRPR','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVRIR', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVRCR', 20, '' from dual;

w_padre := f_a00_padre('ANASTAN','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'STANSPAN', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'STANSSTA', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'STANSSAA', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'STANSVAN', 160, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASRPR', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASCAW', 35, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASR01', 45, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASAPW', 36, '' from dual;

w_padre := f_a00_padre('STANSPAN','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'SPANSPSI', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'SPANSPFF', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'SPANSPVA', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASRGP', 35, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASRMP', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASRAP', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASMP2', 52, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAIST3', 55, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASMAG', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANACSTR', 56, '' from dual;

w_padre := f_a00_padre('SPANSPSI','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASI01', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASI02', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASI03', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASI04', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASI05', 50, '' from dual;

w_padre := f_a00_padre('SPANSPFF','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAFF01', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAFF02', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAFF03', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAFF04', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAFF05', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAFF06', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAFF07', 70, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAFF08', 80, '' from dual;

w_padre := f_a00_padre('SPANSPVA','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVA01', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVA02', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVA03', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVA04', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVA05', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVA06', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVA07', 70, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVA08', 80, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVAI8', 85, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVAE8', 86, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVA09', 90, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVA11', 110, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVA12', 120, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVA13', 130, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVA14', 140, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVA16', 160, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVA10', 100, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVA15', 150, '' from dual;

w_padre := f_a00_padre('STANSSTA','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'SSTAEPSM', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASEIN', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASTIN', 15, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASETI', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASETP', 25, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASPCN', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASTPR', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAASTA', 100, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASETW', 28, '' from dual;

w_padre := f_a00_padre('SSTAEPSM','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAIST2', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASST2', 12, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANATPAT', 15, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANATMCT', 16, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASPAT', 17, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASMCT', 18, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANATFSM', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAESQU', 110, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAEVNC', 400, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAAI01', 5, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASTNA', 14, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASTSA', 13, '' from dual;

w_padre := f_a00_padre('STANSSAA','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASSCI', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASFFA', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASEAF', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASSCH', 40, '' from dual;

w_padre := f_a00_padre('STANSVAN','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASIAI', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASIAG', 11, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASSTR', 15, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASECO', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASDOC', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAETIC', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASEMC', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASMOC', 70, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASCID', 80, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASEMI', 90, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASMOR', 100, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASIRR', 110, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASINI', 120, '' from dual;

w_padre := f_a00_padre('ANAPANA','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANACCFI', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANACOFI', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASLCF', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAACCE', 35, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASAP6', 220, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASAP5', 210, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAGSTR', 5, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVSTR', 6, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'PANAGAMF', 300, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASECL', 37, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'PANACNSD', 310, '' from dual;

w_padre := f_a00_padre('PANAPCCI','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANACREF', 10, '' from dual;

w_padre := f_a00_padre('PANAPCAR','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASSTP', 30, '' from dual;

w_padre := f_a00_padre('PANACSDM','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAAACI', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVACI', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASACI', 50, '' from dual;

w_padre := f_a00_padre('ANAGCEN','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANACENS', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAAINR', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANACNIM', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAANOC', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASANO', 70, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASNIM', 80, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASINC', 90, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASCP9', 100, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANACP10', 110, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAELAC', 5, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAECP5', 5, '' from dual;

w_padre := f_a00_padre('MENUCIV','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVDCIV', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVGEAR', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVIATT', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVRATT', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVVATT', 45, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVSPSC', 80, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVRANN', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVVANN', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVSCSW', 72, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVSCPW', 75, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVVANU', 61, '' from dual;

w_padre := f_a00_padre('CIVDCIV','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'DCIVSDSC', 80, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVDCSC', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVDDGE', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVDFSC', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVDTAT', 5, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVCFMI', 6, '' from dual;

w_padre := f_a00_padre('DCIVSDSC','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVSDMM', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVSDFA', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVSDTA', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVSDFC', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVSDTC', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVSDCS', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVSDMI', 70, '' from dual;

w_padre := f_a00_padre('CIVGEAR','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVCNAS', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVCCIT', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVCPUB', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVCMAT', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVCMOR', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVCATA', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVTASC', 70, '' from dual;

w_padre := f_a00_padre('CIVIATT','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVANAS', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVACIT', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVAVPB', 35, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVAMAT', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVAMOR', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVADIV', 55, '' from dual;

w_padre := f_a00_padre('CIVRATT','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVRCIT', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVRNAS', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVRPUB', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVRMAT', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVRMOR', 50, '' from dual;

w_padre := f_a00_padre('CIVVATT','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVVNAS', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVVCIT', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVVPUB', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVVVPB', 35, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVVMAT', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVVMOR', 50, '' from dual;

w_padre := f_a00_padre('CIVSPSC','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVSIAN', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVSIDE', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVSPCI', 25, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVSPNA', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVSPMA', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVSPMO', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVSPRA', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVSFCR', 100, '' from dual;

w_padre := f_a00_padre('MENUELE','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEDELE', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEAREL', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELERLEL', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELELELE', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEELEZ', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEGSCR', 70, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEGPSE', 80, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEGGPO', 90, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESVEL', 100, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEGLAG', 110, '' from dual;

w_padre := f_a00_padre('ELEDELE','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'DELESDEL', 90, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEDELG', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEDMEL', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEDELZ', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEDNUM', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEDREL', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEDSEZ', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEADVS', 15, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESDLR', 10, '' from dual;

w_padre := f_a00_padre('DELESDEL','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESDMO', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESDSE', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESDSR', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESDCC', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESSCO', 60, '' from dual;

w_padre := f_a00_padre('ELEAREL','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ARELGTEL', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEGAEL', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEVELE', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEASEL', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEGAEF', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ARELGOVI', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEVTEL', 35, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEVTEA', 36, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEAPSE', 37, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEASVE', 38, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEENOT', 33, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEVELG', 21, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESAEL', 70, '' from dual;

w_padre := f_a00_padre('ARELGTEL','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEANTE', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELETELE', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEETEM', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEDRTP', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEDRTE', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEATEE', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEVTEE', 70, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEEATE', 80, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEEVLR', 100, '' from dual;

w_padre := f_a00_padre('ELERLEL','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'RLELRDI1', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'RLELRDI2', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'RLELCIND', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'RLELRSEM', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'RLELBLIS', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'RLELGMFR', 70, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELERSEI', 80, '' from dual;

w_padre := f_a00_padre('RLELRDI1','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEEME1', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESCO1', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEAME1', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESME1', 35, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESEC1', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESTE1', 45, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELES34D', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELES34B', 51, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESEC3', 55, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESV01', 59, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESPR1', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEAAE1', 70, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESCL1', 25, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEVME1', 31, '' from dual;

w_padre := f_a00_padre('RLELRDI2','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'RDI2SRD2', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEEME2', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESCO2', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEAME2', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESME2', 35, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEAPR2', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESV02', 59, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESPR2', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEAAE2', 70, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESCL2', 25, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEVME2', 31, '' from dual;

w_padre := f_a00_padre('RDI2SRD2','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESEC2', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESCC2', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESEI2', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESIC2', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESCR2', 45, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESTE2', 47, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESFP2', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESM5D', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESM5B', 70, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESEC5', 75, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESSI2', 80, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESCS2', 90, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESCG2', 100, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEEAT2', 110, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELECSA2', 95, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELECGA2', 105, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESM6B', 71, '' from dual;

w_padre := f_a00_padre('RLELCIND','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEEMEC', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESCOC', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEAMEC', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEAPRC', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESECC', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESEIC', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESSIC', 70, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESCSC', 80, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELECSAC', 81, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEEATC', 85, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESVEC', 89, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESPRC', 90, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEAAEC', 100, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEVMEC', 31, '' from dual;

w_padre := f_a00_padre('RLELRSEM','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'RSEMAD1S', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'RSEMSCOL', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'RSEMAD2S', 70, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'RSEMAD3S', 80, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEEMES', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESCOS', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEAMES', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESCRS', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESPRS', 90, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEAAES', 100, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESCLS', 25, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEVMES', 31, '' from dual;

w_padre := f_a00_padre('RSEMAD1S','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEAFSS', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESFPS', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESEPR', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESRDO', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESRDB', 41, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESECR', 42, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESSIF', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESV03', 60, '' from dual;

w_padre := f_a00_padre('RSEMSCOL','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEEELR', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEEELE', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEESCO', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEEATS', 40, '' from dual;

w_padre := f_a00_padre('RSEMAD2S','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESPEL', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESSEL', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESEVI', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESEVR', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESV06', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESV14', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESNCS', 70, '' from dual;

w_padre := f_a00_padre('RSEMAD3S','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEAPRS', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESSIS', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESCSS', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESCGS', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESV10', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESV15', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELECSAS', 35, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELECGAS', 45, '' from dual;

w_padre := f_a00_padre('RLELBLIS','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEEMEB', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESCOB', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEAMEB', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESECB', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESVEB', 49, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESPRB', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEAAEB', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESMEB', 35, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEVMEB', 31, '' from dual;

w_padre := f_a00_padre('RLELGMFR','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEEMEF', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESCOF', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEAMEF', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESMEF', 35, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEAFSF', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESFPF', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEAAEF', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEVMEF', 31, '' from dual;

w_padre := f_a00_padre('ELELELE','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELERPSE', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELERPGE', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELERFAS', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESLGE', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESLSE', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESSIG', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESFPE', 70, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELELESM', 80, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELELSA3', 55, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELELGA3', 45, '' from dual;

w_padre := f_a00_padre('ELEELEZ','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESCEL', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESCED', 15, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESPEV', 18, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESENV', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESECA', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESEVP', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEAISL', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESISL', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEALPR', 87, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESLPR', 90, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESPEA', 19, '' from dual;

w_padre := f_a00_padre('ELEGSCR','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'GSCRAALS', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'GSCRELSC', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'GSCRSVSC', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEGASC', 10, '' from dual;

w_padre := f_a00_padre('GSCRAALS','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEEMSC', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESCTS', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEAMSC', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESRPS', 32, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESNIE', 35, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESNIS', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESEIS', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESECS', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEAASC', 70, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESVAS', 65, '' from dual;

w_padre := f_a00_padre('GSCRELSC','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEESSE', 5, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEASSE', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESNSE', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESNSI', 25, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESESE', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESESS', 35, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESENS', 40, '' from dual;

w_padre := f_a00_padre('GSCRSVSC','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESASC', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESALS', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESETS', 30, '' from dual;

w_padre := f_a00_padre('ELEGPSE','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'GPSEAALP', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'GPSESVPS', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEGAPS', 10, '' from dual;

w_padre := f_a00_padre('GPSEAALP','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEEMPS', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESCTP', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEAMPS', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESRPP', 35, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESEIP', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESECP', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEAAPS', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESVAP', 55, '' from dual;

w_padre := f_a00_padre('GPSESVPS','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESALP', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEPSMI', 20, '' from dual;

w_padre := f_a00_padre('ELEGGPO','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'GGPOAALG', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'GGPOSVGP', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEGAGP', 10, '' from dual;

w_padre := f_a00_padre('GGPOAALG','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'AALGSTGP', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEEMGP', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESCTG', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEAMGP', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEAAGP', 100, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESVAG', 90, '' from dual;

w_padre := f_a00_padre('AALGSTGP','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESRCP', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESACP', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESEIG', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESECG', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESEGG', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESETG', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESCCR', 70, '' from dual;

w_padre := f_a00_padre('GGPOSVGP','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESALG', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESEGP', 20, '' from dual;

w_padre := f_a00_padre('ELESVEL','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESVSS', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESSTE', 15, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESELE', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESETE', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESELS', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESCAR', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESTEC', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESCSV', 70, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESTEV', 80, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESEVS', 90, '' from dual;

w_padre := f_a00_padre('MENULEV','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'LEVLMIL', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'LEVGRMA', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'LEVDLEV', 10, '' from dual;

w_padre := f_a00_padre('DLEVSDLE','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'LEVSDES', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'LEVSDCO', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'LEVSDGR', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'LEVSDAR', 40, '' from dual;

w_padre := f_a00_padre('LEVLMIL','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'LMILSCAC', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'LMILSTLM', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'LEVELMI', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'LEVALMI', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'LEVSEPL', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'LEVANLI', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'LEVAGNE', 55, '' from dual;

w_padre := f_a00_padre('LMILSCAC','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'LEVSTCN', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'LEVSRCN', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'LEVSAIS', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'LEVSRCA', 40, '' from dual;

w_padre := f_a00_padre('LMILSTLM','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'LEVSETL', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'LEVSELI', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'LEVSLLE', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'LEVSGIS', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'LEVSGNE', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'LEVSGND', 60, '' from dual;

w_padre := f_a00_padre('MENUCER','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CERDCER', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CERCERW', 15, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CERCETI', 25, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CERSIND', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CERIVES', 35, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CERECEM', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CERVDIR', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CERSDIR', 65, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CEREISO', 70, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CERANCE', 80, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CERECID', 90, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CERSSCE', 100, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CERCMAW', 16, '' from dual;

w_padre := f_a00_padre('CERDCER','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'DCERSDCR', 70, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CERAFCI', 67, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'GSDEURO', 900, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CERADCE', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CERDCEG', 20, '' from dual;

w_padre := f_a00_padre('DCERSDCR','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CERSDCE', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CERSDRI', 20, '' from dual;

w_padre := f_a00_padre('ARELGOVI','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEAOVI', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEVOVI', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEAAOV', 30, '' from dual;

w_padre := f_a00_padre('EPSMEDLL','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'LEVLLMD', 10, '' from dual;

w_padre := f_a00_padre('GEVRGEPT','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAIMMI', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAIMAI', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAISUF', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAEMIG', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAEMAI', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANACIRR', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASCIS', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANACRES', 70, '' from dual;

w_padre := f_a00_padre('PANAGAMF','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANARCFR', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAADMF', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVDMF', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASAMF', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANASCTC', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAACFR', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAFSDE', 70, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANARSCA', 80, '' from dual;

w_padre := f_a00_padre('CIVGRNA','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVVRNA', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'CIVSRNA', 30, '' from dual;

w_padre := f_a00_padre('PANACNSD','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAAFRA', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAAFRI', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAPINA', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ANAVFRI', 40, '' from dual;

w_padre := f_a00_padre('LEVGRMA','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'LEVAPRU', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'LEVARUO', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'LEVSEDC', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'LEVSEMA', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'LEVSRUO', 50, '' from dual;

w_padre := f_a00_padre('LEVDLEV','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'DLEVSDLE', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'LEVDLEG', 10, '' from dual;

w_padre := f_a00_padre('ELEGLAG','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEADTL', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEGAEA', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESCLA', 23, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'GLAGALAG', 100, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'GLAGLELA', 110, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'GLAGGTEA', 120, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEDLAG', 11, '' from dual;

w_padre := f_a00_padre('GLAGALAG','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEEMLA', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESCML', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEAMLA', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESRDA', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEAPRA', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESPLA', 130, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEAALA', 140, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ALAGSALA', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESVLI', 90, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESVLV', 100, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESVLR', 110, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESVLB', 120, '' from dual;

w_padre := f_a00_padre('GLAGLELA','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELERPLA', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESLGA', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEGAA3', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESLSA', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESAA3', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESFPA', 60, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESELA', 80, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELELASM', 70, '' from dual;

w_padre := f_a00_padre('GLAGGTEA','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEANTA', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELETELA', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEATEA', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEEATA', 40, '' from dual;

w_padre := f_a00_padre('PARCGVIR','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ARCEVIR', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ARCSVIR', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ARCAVIR', 30, '' from dual;

w_padre := f_a00_padre('ALAGSALA','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESNIA', 10, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESNCA', 20, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELESEVA', 30, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELECSAA', 40, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELECGAA', 50, '' from dual;

insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre ,(select (nvl(max(figlio),0) + 1) from a_menu), 'ELEEATV', 60, '' from dual;
end;

-- ruolo *
begin
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select APPLICAZIONE, '*', PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE
  from a_menu
 where applicazione = 'GSD'
   and ruolo        = 'RGSD';
end;

-- ruolo GSD
begin
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select APPLICAZIONE, 'GSD', PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE
  from a_menu
 where applicazione = 'GSD'
   and ruolo        = 'RGSD'
   and voce_menu	  not in ('ARCADNC','ARCGCOM','GSDVLOG');
end;

begin
update a_menu
   set padre = 0
 where applicazione      = 'GSD'
   and voce_menu         like 'MENU%'
   and length(voce_menu) = 7;

update a_menu
   set padre = figlio
 where voce_menu    = 'GSDMENU'
   and applicazione = 'GSD';

update a_voci_menu
   set titolo = 'Archivi'
 where titolo = 'A R C H I V I'
   and voce_menu = 'MENUARC'
   and ambiente  = 'GSD';

update a_voci_menu
   set titolo = 'Anagrafe'
 where titolo = 'A N A G R A F E'
   and voce_menu = 'MENUANA'
   and ambiente  = 'GSD';

update a_voci_menu
   set titolo = 'Stato Civile'
 where titolo = 'S T A T O  C I V I L E'
   and voce_menu = 'MENUCIV'
   and ambiente  = 'GSD';

update a_voci_menu
   set titolo = 'Elettorale'
 where titolo = 'E L E T T O R A L E'
   and voce_menu = 'MENUELE'
   and ambiente  = 'GSD';

update a_voci_menu
   set titolo = 'Leve'
 where titolo = 'L E V E'
   and voce_menu = 'MENULEV'
   and ambiente  = 'GSD';

update a_voci_menu
   set titolo = 'ISTAT'
 where titolo = 'I S T A T E L'
   and voce_menu = 'MENUIST'
   and ambiente  = 'GSD';
end;

  end if;
end;
/
