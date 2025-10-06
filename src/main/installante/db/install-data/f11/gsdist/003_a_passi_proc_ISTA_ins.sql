--liquibase formatted sql
--changeset amonopoli:202503210950_3 runOnChange:true stripComments:false
delete a_passi_proc
 where voce_menu in ('ISTED4B','ISTED7A','ISTED7B','ISTEDAP','ISTEDD3','ISTEDD4','ISTEDDV','ISTEDP2','ISTEDP4')
/
insert into a_passi_proc (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2,  TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
select 'ISTED4B', 1, 'ISTATEL - Estrazione Modelli D.4/D.5 BIS', '', '', 'Q', 'ISTED4B', '', '', 'N'  from dual UNION
select 'ISTED4B', 2, 'ISTATEL - Estrazione Modelli D.4/D.5 BIS', '', '', 'R', 'SI4V3WAS', '', '', 'N' from dual UNION
select 'ISTED4B', 3, 'ISTATEL - Estrazione Modelli D.4/D.5 BIS', '', '', 'Q', 'ACACANAS', '', '', 'N' from dual
/
insert into a_passi_proc (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
select 'ISTED7A', 1, 'ISTATEL - Estrazione Modelli D.7.A', '', '', 'Q', 'ISTED7A', '', '', 'N'  from dual UNION
select 'ISTED7A', 2, 'ISTATEL - Estrazione Modelli D.7.A', '', '', 'R', 'SI4V3WAS', '', '', 'N' from dual UNION
select 'ISTED7A', 3, 'ISTATEL - Estrazione Modelli D.7.A', '', '', 'Q', 'ACACANAS', '', '', 'N' from dual
/
insert into a_passi_proc (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
select 'ISTED7B', 1, 'ISTATEL - Estrazione Modelli D.7.B', '', '', 'Q', 'ISTED7B', '', '', 'N'  from dual UNION
select 'ISTED7B', 2, 'ISTATEL - Estrazione Modelli D.7.B', '', '', 'R', 'SI4V3WAS', '', '', 'N' from dual UNION
select 'ISTED7B', 3, 'ISTATEL - Estrazione Modelli D.7.B', '', '', 'Q', 'ACACANAS', '', '', 'N' from dual
/
insert into a_passi_proc (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
select 'ISTEDAP', 1, 'ISTATEL - Estrazione Modelli APR/4', '', '', 'Q', 'ISTEDAP', '', '', 'N'  from dual UNION
select 'ISTEDAP', 2, 'ISTATEL - Estrazione Modelli APR/4', '', '', 'R', 'SI4V3WAS', '', '', 'N' from dual UNION
select 'ISTEDAP', 3, 'ISTATEL - Estrazione Modelli APR/4', '', '', 'Q', 'ACACANAS', '', '', 'N' from dual
/
insert into a_passi_proc (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2,  TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
select 'ISTEDD3', 1, 'ISTATEL - Estrazione Modelli D.3', '', '', 'Q', 'ISTEDD3', '', '', 'N'  from dual UNION
select 'ISTEDD3', 2, 'ISTATEL - Estrazione Modelli D.3', '', '', 'R', 'SI4V3WAS', '', '', 'N' from dual UNION
select 'ISTEDD3', 3, 'ISTATEL - Estrazione Modelli D.3', '', '', 'Q', 'ACACANAS', '', '', 'N' from dual
/
insert into a_passi_proc (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
select 'ISTEDD4', 1, 'ISTATEL - Estrazione Modelli D.4/D.5', '', '', 'Q', 'ISTEDD4', '', '', 'N'  from dual UNION
select 'ISTEDD4', 2, 'ISTATEL - Estrazione Modelli D.4/D.5', '', '', 'R', 'SI4V3WAS', '', '', 'N' from dual UNION
select 'ISTEDD4', 3, 'ISTATEL - Estrazione Modelli D.4/D.5', '', '', 'Q', 'ACACANAS', '', '', 'N' from dual
/
insert into a_passi_proc (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
select 'ISTEDDV', 1, 'ISTATEL - Estrazione Modelli SC', '', '', 'Q', 'ISTEDV1', '', '', 'N'  from dual UNION
select 'ISTEDDV', 2, 'ISTATEL - Estrazione Modelli SC', '', '', 'R', 'SI4V3WAS', '', '', 'N' from dual UNION
select 'ISTEDDV', 3, 'ISTATEL - Estrazione Modelli SC', '', '', 'Q', 'ISTEDV2', '', '', 'N'  from dual UNION
select 'ISTEDDV', 4, 'ISTATEL - Estrazione Modelli SC', '', '', 'R', 'SI4V3WAS', '', '', 'N' from dual UNION
select 'ISTEDDV', 5, 'ISTATEL - Estrazione Modelli SC', '', '', 'Q', 'ACACANAS', '', '', 'N' from dual
/
insert into a_passi_proc (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
select 'ISTEDP2', 1, 'ISTATEL - Estrazione Modelli P.2', '', '', 'Q', 'ISTEDP2', '', '', 'N'  from dual UNION
select 'ISTEDP2', 2, 'ISTATEL - Estrazione Modelli P.2', '', '', 'R', 'SI4V3WAS', '', '', 'N' from dual UNION
select 'ISTEDP2', 3, 'ISTATEL - Estrazione Modelli P.2', '', '', 'Q', 'ACACANAS', '', '', 'N' from dual
/
insert into a_passi_proc (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
select 'ISTEDP4', 1, 'ISTATEL - Estrazione Modelli P.4', '', '', 'Q', 'ISTEDP4', '', '', 'N'  from dual UNION
select 'ISTEDP4', 2, 'ISTATEL - Estrazione Modelli P.4', '', '', 'R', 'SI4V3WAS', '', '', 'N' from dual UNION
select 'ISTEDP4', 3, 'ISTATEL - Estrazione Modelli P.4', '', '', 'Q', 'ACACANAS', '', '', 'N' from dual
/

