--liquibase formatted sql
--changeset amonopoli:202503210950_1 runOnChange:true stripComments:false
insert into A_voci_MENU (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
select 'MENUIST', 'GSD', 'IST', '', '', 'ISTATEL', '', '', 'N', 'M', '', '', null, '', ''
  from dual
 where not exists (select 1 from a_voci_menu b
                    where b.voce_menu = 'MENUIST'
                      and b.ambiente  = 'GSD')
/
insert into A_voci_MENU (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
select 'ISTAFIS', 'GSD', 'AFIS', '', '', 'Anteprima File ISTATEL', '', '', 'F', 'F', 'ISTAFIS', '', null, '', ''
  from dual
 where not exists (select 1 from a_voci_menu b
                    where b.voce_menu = 'ISTAFIS'
                      and b.ambiente  = 'GSD')
/
insert into A_voci_MENU (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
select 'ISTAM4B', 'GSD', 'AM4B', '', '', 'ISTAT D.4 BIS (morti nel 1o anno)', '', '', 'F', 'F', 'ISTAM4B', '', null, '', ''
  from dual
 where not exists (select 1 from a_voci_menu b
                    where b.voce_menu = 'ISTAM4B'
                      and b.ambiente  = 'GSD')
/
insert into A_voci_MENU (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
select 'ISTAMAP', 'GSD', 'AMAP', '', '', 'Modelli APR/4', '', '', 'F', 'F', 'ISTAMAP', '', null, '', ''
  from dual
 where not exists (select 1 from a_voci_menu b
                    where b.voce_menu = 'ISTAMAP'
                      and b.ambiente  = 'GSD')
/
insert into A_voci_MENU (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
select 'ISTAMD3', 'GSD', 'AMD3', '', '', 'ISTAT D.3 (matrimoni)', '', '', 'F', 'F', 'ISTAMD3', '', null, '', ''
  from dual
 where not exists (select 1 from a_voci_menu b
                    where b.voce_menu = 'ISTAMD3'
                      and b.ambiente  = 'GSD')
/
insert into A_voci_MENU (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
select 'ISTAMD4', 'GSD', 'AMD4', '', '', 'ISTAT D.4 (morti oltre il 1o anno)', '', '', 'F', 'F', 'ISTAMD4', '', null, '', ''
  from dual
 where not exists (select 1 from a_voci_menu b
                    where b.voce_menu = 'ISTAMD4'
                      and b.ambiente  = 'GSD')
/
insert into A_voci_MENU (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
select 'ISTAMIS', 'GSD', 'AMIS', '', '', 'Aggiornamento Modelli ISTAT', '', '', 'N', 'M', 'ISTAMIS', '', null, '', ''
  from dual
 where not exists (select 1 from a_voci_menu b
                    where b.voce_menu = 'ISTAMIS'
                      and b.ambiente  = 'GSD')
/
insert into A_voci_MENU (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
select 'ISTAMP4', 'GSD', 'AMP4', '', '', 'ISTAT P.4 (nascite)', '', '', 'F', 'F', 'ISTAMP4', '', null, '', ''
  from dual
 where not exists (select 1 from a_voci_menu b
                    where b.voce_menu = 'ISTAMP4'
                      and b.ambiente  = 'GSD')
/
insert into A_voci_MENU (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
select 'ISTED4B', 'GSD', 'ED4B', '', '', 'ISTAT D.4 / D.5 BIS (morti nel 1o anno)', '', '', 'F', 'F', 'ISTED4B', '', null, '', ''
  from dual
 where not exists (select 1 from a_voci_menu b
                    where b.voce_menu = 'ISTED4B'
                      and b.ambiente  = 'GSD')
/
insert into A_voci_MENU (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
select 'ISTED7A', 'GSD', 'ED7A', '', '', 'ISTAT D.7.A', '', '', 'F', 'F', 'ISTED7A', '', null, '', ''
  from dual
 where not exists (select 1 from a_voci_menu b
                    where b.voce_menu = 'ISTED7A'
                      and b.ambiente  = 'GSD')
/
insert into A_voci_MENU (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
select 'ISTED7B', 'GSD', 'ED7B', '', '', 'ISTAT D.7.B', '', '', 'F', 'F', 'ISTED7B', '', null, '', ''
  from dual
 where not exists (select 1 from a_voci_menu b
                    where b.voce_menu = 'ISTED7B'
                      and b.ambiente  = 'GSD')
/
insert into A_voci_MENU (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
select 'ISTEDAP', 'GSD', 'EDAP', '', '', 'ISTAT APR/4', '', '', 'F', 'F', 'ISTEDAP', '', null, '', ''
  from dual
 where not exists (select 1 from a_voci_menu b
                    where b.voce_menu = 'ISTEDAP'
                      and b.ambiente  = 'GSD')
/
insert into A_voci_MENU (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
select 'ISTEDD3', 'GSD', 'EDD3', '', '', 'ISTAT D.3 (matrimoni)', '', '', 'F', 'F', 'ISTEDD3', '', null, '', ''
  from dual
 where not exists (select 1 from a_voci_menu b
                    where b.voce_menu = 'ISTEDD3'
                      and b.ambiente  = 'GSD')
/
insert into A_voci_MENU (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
select 'ISTEDD4', 'GSD', 'EDD4', '', '', 'ISTAT D.4 / D.5 (morti oltre il 1o anno)', '', '', 'F', 'F', 'ISTEDD4', '', null, '', ''
  from dual
 where not exists (select 1 from a_voci_menu b
                    where b.voce_menu = 'ISTEDD4'
                      and b.ambiente  = 'GSD')
/
insert into A_voci_MENU (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
select 'ISTEDIS', 'GSD', 'EDIS', '', '', 'Estrazione Dati per ISTATEL', '', '', 'N', 'M', 'ISTEDIS', '', null, '', ''
  from dual
 where not exists (select 1 from a_voci_menu b
                    where b.voce_menu = 'ISTEDIS'
                      and b.ambiente  = 'GSD')
/
insert into A_voci_MENU (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
select 'ISTEDP2', 'GSD', 'EDP2', '', '', 'ISTAT P.2', '', '', 'F', 'F', 'ISTEDP2', '', null, '', ''
  from dual
 where not exists (select 1 from a_voci_menu b
                    where b.voce_menu = 'ISTEDP2'
                      and b.ambiente  = 'GSD')
/
insert into A_voci_MENU (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
select 'ISTEDP4', 'GSD', 'EDP4', '', '', 'ISTAT P.4 (nascite)', '', '', 'F', 'F', 'ISTEDP4', '', null, '', ''
  from dual
 where not exists (select 1 from a_voci_menu b
                    where b.voce_menu = 'ISTEDP4'
                      and b.ambiente  = 'GSD')
/
insert into a_voci_menu (voce_menu, ambiente, acronimo, titolo, tipo_voce, tipo, modulo) 
select 'ISTAMDV', 'GSD', 'AMDV', 'Modelli SC.6sd / SC.12sd (divorzi)', 'F', 'F', 'ISTAMDV'
  from dual
 where not exists (select 1 from a_voci_menu b
                    where b.voce_menu = 'ISTAMDV'
                      and b.ambiente  = 'GSD')
/
insert into a_voci_menu (voce_menu, ambiente, acronimo, titolo, tipo_voce, tipo, modulo) 
select 'ISTEDDV', 'GSD', 'EDDV', 'ISTAT SC.6sd / SC.12sd (divorzi)', 'F', 'F', 'ISTEDDV'
  from dual
 where not exists (select 1 from a_voci_menu b
                    where b.voce_menu = 'ISTEDDV'
                      and b.ambiente  = 'GSD')
/
