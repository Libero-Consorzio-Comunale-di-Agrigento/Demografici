--liquibase formatted sql
--changeset amonopoli:202410251400 runOnChange:true stripComments:false
create or replace view cerana_filtro_dfc
       (matricola, cognome, nome, d_data_nas, sesso, filtro)
AS
-- AN  DEC Deceduti  ana_stato = 50
select ana.matricola, ana.cognome, ana.nome, ana.d_data_nas, ana.sesso, 'DEC'
  from anaana ana
 where ana.stato + 0 = 50
UNION ALL
-- AN  EIR Emigrati / Irreperibili ana_fascia = 2 and ana_stato in (select cod_eve from anadce where anagrafe = 'RES' and tipo_evento = 'C' and tipo_evento_istat in ('M','I','A'))
select ana.matricola, ana.cognome, ana.nome, ana.d_data_nas, ana.sesso, 'EIR'
  from anaana ana
 where fascia + 0 = 2
   and ana.stato + 0 in (select cod_eve from anadce where anagrafe = 'RES' and tipo_evento = 'C' and tipo_evento_istat in ('M','I','A'))
UNION ALL
-- AN  EMI Emigrati  ana_fascia = 2 and ana_stato in (select cod_eve from anadce where anagrafe = 'RES' and tipo_evento = 'C' and tipo_evento_istat in ('M'))
select ana.matricola, ana.cognome, ana.nome, ana.d_data_nas, ana.sesso, 'EMI'
  from anaana ana
 where ana.fascia + 0 = 2
   and ana.stato + 0 in (select cod_eve from anadce where anagrafe = 'RES' and tipo_evento = 'C' and tipo_evento_istat in ('M'))
UNION ALL
-- AN  IAI Iscritti A.I.R.E. ana_fascia = 3
select ana.matricola, ana.cognome, ana.nome, ana.d_data_nas, ana.sesso, 'IAI'
  from anaana ana
 where ana.fascia + 0 = 3
UNION ALL
-- AN  IRP Irreperibili Presunti (AIRE)  ana_fascia = 4 and ana_stato in (54,58,59)
select ana.matricola, ana.cognome, ana.nome, ana.d_data_nas, ana.sesso, 'IRP'
  from anaana ana
 where ana.fascia + 0 = 4
   and ana.stato + 0 in (54,58,59)
UNION ALL
-- AN  IRR Irreperibili / Cancellati d'Ufficio ana_fascia = 2 and ana_stato (select cod_eve from anadce where anagrafe = 'RES' and tipo_evento = 'C' and tipo_evento_istat in ('I','A')
select ana.matricola, ana.cognome, ana.nome, ana.d_data_nas, ana.sesso, 'IRR'
  from anaana ana
 where ana.fascia + 0 = 2
   and ana.stato + 0 in (select cod_eve from anadce where anagrafe = 'RES' and tipo_evento = 'C' and tipo_evento_istat in ('I','A'))
UNION ALL
-- AN  NRE Non Residenti ana_fascia in (5,6)
select ana.matricola, ana.cognome, ana.nome, ana.d_data_nas, ana.sesso, 'NRE'
  from anaana ana
 where ana.fascia + 0 in (5,6)
    or  (ana.fascia + 0 in (2,4) and ana.stato != 50)
UNION ALL
-- AN  RES Residenti ana_fascia + 0 = 1
select ana.matricola, ana.cognome, ana.nome, ana.d_data_nas, ana.sesso, 'RES'
  from anaana ana
 where ana.fascia + 0 = 1
UNION ALL
-- AN  'XXX' Nessun filtro
select ana.matricola, ana.cognome, ana.nome, ana.d_data_nas, ana.sesso, to_char(null) --'XXX'
  from anaana ana
/
comment on table cerana_filtro_dfc is 'Certificazione - Filtri  per Matricola (view)'
/
create or replace view cerana_filtro_dcc
       (matricola, cod_controllo)
AS
-- 1 vedovo  ana_stato_civile = 'VE'
select ana.matricola, 1
  from anaana ana
 where ana.stato_civile = 'VE'
UNION ALL
-- 2 libero da vincoli matrimoniali  ana_stato_civile not in ('CN','NC')
select ana.matricola, 2
  from anaana ana
 where ana.stato_civile not in ('CN','NC')
UNION ALL
-- 3 cittadino italiano  ana_nazionalita = 'I'
select ana.matricola, 3
  from anaana ana
 where ana.nazionalita = 'I'
UNION ALL
-- 4 coniugato o vedovo  ana_stato_civile in ('CN','VE')
select ana.matricola, 4
  from anaana ana
 where ana.stato_civile in ('CN','VE')
UNION ALL
-- 5 elettore  ele_stato = 'E'
select ana.matricola, 5
  from eleana ele, anaana ana
 where ele.stato = 'E'
   and ele.matricola = ana.matricola
UNION ALL
-- 6 coniugato ana_stato_civile = 'CN'
select ana.matricola, 6
  from anaana ana
 where ana.stato_civile = 'CN'
UNION ALL
-- 7 eta' maggiore di 15 anni  add_months(ana_d_data_nas,180) <= trunc(sysdate)
select ana.matricola, 7
  from anaana ana
 where add_months(ana.d_data_nas,180) <= trunc(sysdate)
UNION ALL
-- 8 eta' maggiore di 18 anni  add_months(ana_d_data_nas,216) <= trunc(sysdate)
select ana.matricola, 8
  from anaana ana
 where add_months(ana.d_data_nas,216) <= trunc(sysdate)
UNION ALL
-- 9 eta' maggiore di 14 anni  add_months(ana_d_data_nas,168) <= trunc(sysdate)
select ana.matricola, 9
  from anaana ana
 where add_months(ana.d_data_nas,168) <= trunc(sysdate)
UNION ALL
-- 10  cittadino straniero UE  ana_nazionalita != 'I' and dci_cee = 'S'
select ana.matricola, 10
  from anadci dci, anaana ana
 where dci.cee         = 'S'
   and dci.cod_ci      = ana.nazionalita
   and ana.nazionalita != 'I'
UNION ALL
-- 11  elettore liste aggiunte ela_stato = 'E'
select distinct ana.matricola, 11
  from eleela ela, anaana ana
 where ela.stato = 'E'
   and ela.matricola = ana.matricola
UNION ALL
-- 12  cittadino italiano / libero da vincoli matrimoniali ana_nazionalita = 'I' and ana_stato_civile not in ('CN','NC')
select ana.matricola, 12
  from anaana ana
 where ana.nazionalita = 'I'
   and ana.stato_civile not in ('CN','NC')
UNION ALL
-- 13  cittadino straniero ana_nazionalita != 'I'
select ana.matricola, 13
  from anaana ana
 where ana.nazionalita != 'I'
UNION ALL
-- 14  cittadino italiano / eta' minore 15 anni  ana_nazionalita = 'I' and add_months(ana_d_data_nas,180) > trunc(sysdate)
select ana.matricola, 14
  from anaana ana
 where ana.nazionalita = 'I'
   and add_months(ana.d_data_nas,180) > trunc(sysdate)
UNION ALL
-- 15  eta' minore 15 anni add_months(ana_d_data_nas,180) > trunc(sysdate)
select ana.matricola, 15
  from anaana ana
 where add_months(ana.d_data_nas,180) > trunc(sysdate)
UNION ALL
-- 16  atto nascita presente atto_nascita is not null
select ana.matricola, 16
  from anaana ana
 where ana.atto_nas||ana.atto_nas_digitale is not null
UNION ALL
-- 17  convivenza di fatto f_flag_CDF(matricola) = 'S'
select ana.matricola, 17
  from anaana ana
 where f_flag_CDF(ana.matricola) = 'S'
UNION ALL
-- 18  unito civilmente  ana_stato_civile = 'UC'
select ana.matricola, 18
  from anaana ana
 where ana.stato_civile = 'UC'
UNION ALL
-- 19  in famiglia ana_rapporto_par not in ('CC','IC')
select ana.matricola, 19
  from anaana ana
 where ana.rapporto_par not in ('CC','IC')
UNION ALL
-- 20  in convivenza ana_rapporto_par in ('CC','IC')
select ana.matricola, 20
  from anaana ana
 where ana.rapporto_par in ('CC','IC')
UNION ALL
-- 21  presente in archivio elettorale
select ana.matricola, 21
  from anaana ana
 where exists (select 1 from eleana where matricola = ana.matricola
               UNION
               select 1 from eleela where matricola = ana.matricola)
UNION ALL
-- 22  presente il liste di leva
select ana.matricola, 22
  from anaana ana
 where exists (select 1 from levruo where matricola = ana.matricola)
UNION ALL
-- 0  nessun codice controllo
select ana.matricola, to_number(null) --0
  from anaana ana
/
comment on table cerana_filtro_dcc is 'Certificazione - Codici Controllo per Matricola (view)'
/
create or replace view cerana_filtro_civ
       (matricola, tipo_archivio, cognome, nome, d_data_nas, sesso, filtro)
AS
select ana.matricola, 1, cit_f.cognome, cit_f.nome, cit_f.d_data_nas, cit_f.sesso, cit_f.filtro
  from cercit_filtro cit_f, anaana ana
 where cit_f.cognome_nome = ana.cognome_nome (+)
   and cit_f.sesso        = ana.sesso (+)
   and cit_f.data_nas     = ana.data_nas (+)
UNION
select ana.matricola, 2, nas_f.cognome, nas_f.nome, nas_f.d_data_nas, nas_f.sesso, nas_f.filtro
  from cernas_filtro nas_f, anaana ana
 where nas_f.cognome_nome = ana.cognome_nome (+)
   and nas_f.sesso        = ana.sesso (+)
   and nas_f.data_nas     = ana.data_nas (+)
UNION
select ana.matricola, 4, mat_f.cognome, mat_f.nome, mat_f.d_data_nas, mat_f.sesso,  mat_f.filtro
  from (select cognome_nome_m cognome_nome, cognome_m cognome, nome_m nome, data_nas_m data_nas, d_data_nas_m d_data_nas, 'M' sesso, filtro from cermat_filtro
        UNION
        select cognome_nome_f cognome_nome, cognome_f cognome, nome_f nome, data_nas_f data_nas, d_data_nas_f d_data_nas, 'F' sesso, filtro from cermat_filtro) mat_f,
       anaana ana
 where mat_f.cognome_nome = ana.cognome_nome (+)
   and mat_f.data_nas     = ana.data_nas (+)
   and mat_f.sesso        = ana.sesso (+)
UNION
select ana.matricola, -4, uci_f.cognome, uci_f.nome, uci_f.d_data_nas, uci_f.sesso,  uci_f.filtro
  from (select cognome_nome_m cognome_nome, cognome_m cognome, nome_m nome, data_nas_m data_nas, d_data_nas_m d_data_nas, sesso_m sesso, filtro from ceruci_filtro
        UNION
        select cognome_nome_f cognome_nome, cognome_f cognome, nome_f nome, data_nas_f data_nas, d_data_nas_f d_data_nas, sesso_f sesso, filtro from ceruci_filtro) uci_f,
       anaana ana
 where uci_f.cognome_nome = ana.cognome_nome (+)
   and uci_f.data_nas     = ana.data_nas (+)
   and uci_f.sesso        = ana.sesso (+)
UNION
select ana.matricola, 5, mor_f.cognome, mor_f.nome, mor_f.d_data_nas, mor_f.sesso,  mor_f.filtro
  from cermor_filtro mor_f, anaana ana
 where mor_f.cognome_nome = ana.cognome_nome (+)
   and mor_f.sesso        = ana.sesso (+)
   and mor_f.data_nas     = ana.data_nas (+)
/
comment on table cerana_filtro_civ is 'Certificazione - Filtri CIV per Matricola (view)'
/
create or replace view cerana_filtro
       (id, matricola, cognome, nome, d_data_nas, sesso, id_cerctc, tipo_archivio, filtro, cod_controllo)
AS
-- cerctc
-- 1 ANA ANAGRAFE  10  0
-- 2 CIV STATO CIVILE  20  0
-- 3 ELE ELETTORALE  30  0
-- 4 LEV LEVA E RUOLI MATRICOLARI  40  0
-- 5 DIC DICHIARAZIONI SOSTITUTIVE 50  0
-- 6 VARIE-ANA DOCUMENTI VARI ANAGRAFE 60  0
-- 7 VARIE-CIV DOCUMENTI VARI STATO CIVILE 70  0
--
--select 1000000 + rownum id,
select 'DFC_'||dcc_v.matricola||'-'||ctc.id||'-'||dfc_v.filtro||'-'||dcc_v.cod_controllo id,
       dcc_v.matricola, dfc_v.cognome, dfc_v.nome, dfc_v.d_data_nas, dfc_v.sesso, ctc.id, 0, dfc_v.filtro, dcc_v.cod_controllo
  from cerana_filtro_dcc dcc_v, cerana_filtro_dfc dfc_v, cerctc ctc
 where dcc_v.matricola = dfc_v.matricola
   and ctc.competenza  !=  'SC'
UNION ALL
--select 2000000 + rownum id,
select 'CIV_'||civ_v.matricola||'-'||civ_v.cognome||'-'||civ_v.nome||'-'||to_char(civ_v.d_data_nas,'ddmmyyyy')||'-'||civ_v.sesso||'-'||ctc.id||'-'||civ_v.tipo_archivio||'-'||civ_v.filtro id,
       civ_v.matricola, civ_v.cognome, civ_v.nome, civ_v.d_data_nas, civ_v.sesso, ctc.id, civ_v.tipo_archivio, civ_v.filtro, to_number(null)
  from cerana_filtro_civ civ_v, cerctc ctc 
 where ctc.competenza   =  'SC'
/ 
comment on table cerana_filtro is 'Certificazione - Filtri di Certificazione (view)'
/
