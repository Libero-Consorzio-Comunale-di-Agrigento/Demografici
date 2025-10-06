--liquibase formatted sql
--changeset amonopoli:202503210950_2 runOnChange:true stripComments:false
declare
w_padre number;

begin
-- MENUIST 
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', '0', (select (nvl(max(figlio),0) + 1) from a_menu), 'MENUIST', 10, '' 
  from dual
 where not exists (select 1 from a_menu b
                    where b.applicazione = 'GSD'
                      and b.voce_menu    = 'MENUIST'
                      and b.ruolo        = 'RGSD')
;
w_padre := f_a00_padre('MENUIST','GSD','RGSD');
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre, (select (nvl(max(figlio),0) + 1) from a_menu), 'ISTAMIS', 10, ''
  from dual
 where not exists (select 1 from a_menu b
                    where b.applicazione = 'GSD'
                      and b.voce_menu    = 'ISTAMIS'
                      and b.ruolo        = 'RGSD')
;
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre, (select (nvl(max(figlio),0) + 1) from a_menu), 'ISTEDIS', 20, ''
  from dual
 where not exists (select 1 from a_menu b
                    where b.applicazione = 'GSD'
                      and b.voce_menu    = 'ISTEDIS'
                      and b.ruolo        = 'RGSD')
;
-- MENUAMIS
w_padre := f_a00_padre('ISTAMIS','GSD','RGSD');
insert into A_MENU (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre, (select (nvl(max(figlio),0) + 1) from a_menu), 'ISTAMP4', 10, ''
  from dual
 where not exists (select 1 from a_menu b
                    where b.applicazione = 'GSD'
                      and b.voce_menu    = 'ISTAMP4'
                      and b.ruolo        = 'RGSD')
;
insert into A_MENU (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre, (select (nvl(max(figlio),0) + 1) from a_menu), 'ISTAMD3', 20, ''
  from dual
 where not exists (select 1 from a_menu b
                    where b.applicazione = 'GSD'
                      and b.voce_menu    = 'ISTAMD3'
                      and b.ruolo        = 'RGSD')
;
insert into A_MENU (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre, (select (nvl(max(figlio),0) + 1) from a_menu), 'ISTAMD4', 30, ''
  from dual
 where not exists (select 1 from a_menu b
                    where b.applicazione = 'GSD'
                      and b.voce_menu    = 'ISTAMD4'
                      and b.ruolo        = 'RGSD')
;
insert into A_MENU (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre, (select (nvl(max(figlio),0) + 1) from a_menu), 'ISTAM4B', 40, ''
  from dual
 where not exists (select 1 from a_menu b
                    where b.applicazione = 'GSD'
                      and b.voce_menu    = 'ISTAM4B'
                      and b.ruolo        = 'RGSD')
;
insert into A_MENU (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre, (select (nvl(max(figlio),0) + 1) from a_menu), 'ISTAMAP', 50, ''
  from dual
 where not exists (select 1 from a_menu b
                    where b.applicazione = 'GSD'
                      and b.voce_menu    = 'ISTAMAP'
                      and b.ruolo        = 'RGSD')
;
insert into A_MENU (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre, (select (nvl(max(figlio),0) + 1) from a_menu), 'ISTAMDV', 60, ''
  from dual
 where not exists (select 1 from a_menu b
                    where b.applicazione = 'GSD'
                      and b.voce_menu    = 'ISTAMDV'
                      and b.ruolo        = 'RGSD')
;
-- MENUEDIS
w_padre := f_a00_padre('ISTEDIS','GSD','RGSD');
insert into A_MENU (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre, (select (nvl(max(figlio),0) + 1) from a_menu), 'ISTEDP4', 10, ''
  from dual
 where not exists (select 1 from a_menu b
                    where b.applicazione = 'GSD'
                      and b.voce_menu    = 'ISTEDP4'
                      and b.ruolo        = 'RGSD')
;
insert into A_MENU (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre, (select (nvl(max(figlio),0) + 1) from a_menu), 'ISTEDD3', 20, ''
  from dual
 where not exists (select 1 from a_menu b
                    where b.applicazione = 'GSD'
                      and b.voce_menu    = 'ISTEDD3'
                      and b.ruolo        = 'RGSD')
;
insert into A_MENU (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre, (select (nvl(max(figlio),0) + 1) from a_menu), 'ISTEDD4', 30, ''
  from dual
 where not exists (select 1 from a_menu b
                    where b.applicazione = 'GSD'
                      and b.voce_menu    = 'ISTEDD4'
                      and b.ruolo        = 'RGSD')
;
insert into A_MENU (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre, (select (nvl(max(figlio),0) + 1) from a_menu), 'ISTED4B', 40, ''
  from dual
 where not exists (select 1 from a_menu b
                    where b.applicazione = 'GSD'
                      and b.voce_menu    = 'ISTED4B'
                      and b.ruolo        = 'RGSD')
;
insert into A_MENU (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre, (select (nvl(max(figlio),0) + 1) from a_menu), 'ISTED7A', 50, ''
  from dual
 where not exists (select 1 from a_menu b
                    where b.applicazione = 'GSD'
                      and b.voce_menu    = 'ISTED7A'
                      and b.ruolo        = 'RGSD')
;
insert into A_MENU (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre, (select (nvl(max(figlio),0) + 1) from a_menu), 'ISTED7B', 60, ''
  from dual
 where not exists (select 1 from a_menu b
                    where b.applicazione = 'GSD'
                      and b.voce_menu    = 'ISTED7B'
                      and b.ruolo        = 'RGSD')
;
insert into A_MENU (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre, (select (nvl(max(figlio),0) + 1) from a_menu), 'ISTEDP2', 70, ''
  from dual
 where not exists (select 1 from a_menu b
                    where b.applicazione = 'GSD'
                      and b.voce_menu    = 'ISTEDP2'
                      and b.ruolo        = 'RGSD')
;
insert into A_MENU (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre, (select (nvl(max(figlio),0) + 1) from a_menu), 'ISTEDAP', 80, ''
  from dual
 where not exists (select 1 from a_menu b
                    where b.applicazione = 'GSD'
                      and b.voce_menu    = 'ISTEDAP'
                      and b.ruolo        = 'RGSD')
;
insert into A_MENU (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre, (select (nvl(max(figlio),0) + 1) from a_menu), 'ISTEDDV', 90, ''
  from dual
 where not exists (select 1 from a_menu b
                    where b.applicazione = 'GSD'
                      and b.voce_menu    = 'ISTEDDV'
                      and b.ruolo        = 'RGSD')
;
insert into A_MENU (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select 'GSD', 'RGSD', w_padre, (select (nvl(max(figlio),0) + 1) from a_menu), 'ISTAFIS', 300, ''
  from dual
 where not exists (select 1 from a_menu b
                    where b.applicazione = 'GSD'
                      and b.voce_menu    = 'ISTAFIS'
                      and b.ruolo        = 'RGSD')
;
end;
/
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select APPLICAZIONE, '*', PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE
  from a_menu a
 where applicazione = 'GSD'
   and ruolo        = 'RGSD'
   and (voce_menu like 'IST%' or voce_menu = 'MENUIST')
   and not exists (select 1 from a_menu b
                    where b.applicazione = a.applicazione
                      and b.voce_menu    = a.voce_menu
                      and b.ruolo        = '*')
;
insert into a_menu (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE)
select APPLICAZIONE, 'GSD', PADRE, FIGLIO, VOCE_MENU, SEQUENZA, STAMPANTE
  from a_menu a
 where applicazione = 'GSD'
   and ruolo        = 'RGSD'
   and (voce_menu like 'IST%' or voce_menu = 'MENUIST')
   and not exists (select 1 from a_menu b
                    where b.applicazione = a.applicazione
                      and b.voce_menu    = a.voce_menu
                      and b.ruolo        = 'GSD')
;
