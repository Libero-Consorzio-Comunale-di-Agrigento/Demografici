--liquibase formatted sql
--changeset amonopoli:202411191600_1 runOnChange:true stripComments:false
create or replace view anavxx_denominazione_via
	(codice, descrizione, ordinamento)
AS
-- DENOMINAZIONE_VIA
select denom_uff, denom_uff, cod_via
  from arcvie
 order by 1
/
comment on table anavxx_denominazione_via is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/ 
create or replace view anavxx_sesso
	(codice, descrizione, ordinamento)
AS
-- SESSO
select v.codice, v.descrizione, v.sequenza
  from (select 'F' codice, 'FEMMINILE' descrizione, 1 sequenza from dual UNION
        select 'M' codice, 'MASCHILE'  descrizione, 1 sequenza from dual) v
 order by 1
/
comment on table anavxx_sesso is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/ 
-- STATO_CIVILE
create or replace view anavxx_stato_civile
(codice, descrizione, ordinamento)
as
select drp_m.cod_sc codice, drp_m.cod_sc||' - '||drp_m.descrizione||decode(drp_m.descrizione,drp_f.descrizione,'',' / '||drp_f.descrizione) descrizione, 1
  from anadsc drp_m
     , anadsc drp_f
 where drp_m.sesso = 'M'
   and drp_f.sesso = 'F'
   and drp_m.cod_sc = drp_f.cod_sc
UNION
select drp_m.cod_sc codice, drp_m.cod_sc||' - '||drp_m.descrizione, 1
  from anadsc drp_m
 where drp_m.sesso = 'M'
   and not exists (select 'x' from anadsc drp_f
                    where drp_f.sesso = 'F'
                      and drp_f.cod_sc = drp_m.cod_sc)
UNION
select drp_f.cod_sc codice, drp_f.cod_sc||' - '||drp_f.descrizione descrizione, 1
  from anadsc drp_f
 where drp_f.sesso = 'F'
   and not exists (select 'x' from anadsc drp_m
                    where drp_m.sesso = 'M'
                      and drp_m.cod_sc = drp_f.cod_sc)
order by 1
/
comment on table anavxx_stato_civile is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/ 
create or replace view anavxx_nazionalita
	(codice, descrizione, ordinamento)
AS
-- NAZIONALITA
select v.codice, v.descrizione, v.sequenza
 from (select cod_ci codice, descrizione                 descrizione, nvl(ist_ci,999) sequenza from anadci) v
 order by decode(v.sequenza,100,'AAA001',997,'AAA002','998','AAA003','999','AAA004',v.descrizione)
/
comment on table anavxx_nazionalita is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/ 
create or replace view anavxx_gruppo_nazionalita
	(codice, descrizione, ordinamento)
AS
-- GRUPPO_NAZIONALITA
select v.codice, v.descrizione, v.sequenza
 from (select 51 codice, 'America del Nord'    descrizione, 51 sequenza from dual UNION
       select 41 codice, 'Asia'                descrizione, 41 sequenza from dual UNION
       select 12 codice, 'Unione Europea'      descrizione, 12 sequenza from dual UNION
       select 31 codice, 'Oceania'             descrizione, 31 sequenza from dual UNION
       select 21 codice, 'Africa'              descrizione, 21 sequenza from dual UNION
       select 11 codice, 'Italia'              descrizione, 11 sequenza from dual UNION
       select 52 codice, 'America del Sud'     descrizione, 52 sequenza from dual UNION
       select 13 codice, 'Altri paesi europei' descrizione, 13 sequenza from dual UNION
       select 99 codice, 'Non codificato'      descrizione, 99 sequenza from dual) v
 order by 3
/
comment on table anavxx_gruppo_nazionalita is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/ 
create or replace view anavxx_flag_s
	(codice, descrizione, ordinamento)
AS
-- FLAG_S
select 'S' codice, 'FLAG ATTIVO' descrizione, 1 
  from dual 
 order by 1
/
comment on table anavxx_flag_s is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
create or replace view anavxx_flag_si
	(codice, descrizione, ordinamento)
AS
-- FLAG_SI
select 'SI' codice, 'FLAG ATTIVO' descrizione, 1 
  from dual 
 order by 1
/
comment on table anavxx_flag_si is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/ 
create or replace view anavxx_titolo_studio
	(codice, descrizione, ordinamento)
AS
-- TITOLO_STUDIO
select cod_ts codice, cod_ts||' - '||descrizione descrizione, 1 
  from anadts 
 order by 1
/
comment on table anavxx_titolo_studio is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/ 
create or replace view anavxx_des_titolo_studio
	(codice, descrizione, ordinamento)
AS
-- DES_TITOLO_STUDIO
select descrizione codice, descrizione descrizione, 1 
  from anadts 
 order by 1
/
comment on table anavxx_des_titolo_studio is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/ 
create or replace view anavxx_gruppo_di_studio
	(codice, descrizione, ordinamento)
AS
-- GRUPPO_DI_STUDIO
select v.codice, v.codice||' - '||v.descrizione, v.sequenza
  from (select 'AN' codice, 'ANALFABETA'         descrizione, 1 sequenza from dual UNION
        select 'TE' codice, 'TERZA ELEMENTARE'   descrizione, 2 sequenza from dual UNION
        select 'LE' codice, 'LICENZA ELEMENTARE' descrizione, 3 sequenza from dual UNION
        select 'LM' codice, 'LICENZA MEDIA'      descrizione, 4 sequenza from dual UNION
        select 'DP' codice, 'DIPLOMA'            descrizione, 5 sequenza from dual UNION
        select 'LR' codice, 'LAUREA'             descrizione, 6 sequenza from dual) v
 order by 3
/
comment on table anavxx_gruppo_di_studio is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/ 
create or replace view anavxx_des_professione
	(codice, descrizione, ordinamento)
AS
-- DES_PROFESSIONE
select distinct descrizione codice,descrizione descrizione, 1
  from anadpr 
 order by 1
/
comment on table anavxx_des_professione is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/ 
create or replace view anavxx_rapporto_par
	(codice, descrizione, ordinamento)
AS
-- RAPPORTO_PAR
select drp_m.cod_rp codice, drp_m.cod_rp||' - '||drp_m.descrizione||decode(drp_m.descrizione,drp_f.descrizione,'',' / '||drp_f.descrizione) descrizione, 1
  from anadrp drp_m
     , anadrp drp_f
 where drp_m.sesso = 'M'
   and drp_f.sesso = 'F'
   and drp_m.cod_rp = drp_f.cod_rp
UNION
select drp_m.cod_rp codice, drp_m.cod_rp||' - '||drp_m.descrizione, 1
  from anadrp drp_m
 where drp_m.sesso = 'M'
   and not exists (select 'x' from anadrp drp_f
                    where drp_f.sesso = 'F'
                      and drp_f.cod_rp = drp_m.cod_rp)
UNION
select drp_f.cod_rp codice, drp_f.cod_rp||' - '||drp_f.descrizione descrizione, 1 
  from anadrp drp_f
 where drp_f.sesso = 'F'
   and not exists (select 'x' from anadrp drp_m
                    where drp_m.sesso = 'M'
                      and drp_m.cod_rp = drp_f.cod_rp) order by 1
/
comment on table anavxx_rapporto_par is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/ 
create or replace view anavxx_des_rapporto_par
	(codice, descrizione, ordinamento)
AS
-- DES_RAPPORTO_PAR
select distinct descrizione codice, descrizione descrizione, 1 
  from anadrp 
 order by 1
/
comment on table anavxx_des_rapporto_par is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/ 
create or replace view anavxx_des_esito_leva
	(codice, descrizione, ordinamento)
AS
-- DES_ESITO_LEVA
select descrizione codice, descrizione descrizione, 1 
  from levdes 
 order by 1
/
comment on table anavxx_des_esito_leva is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/ 
create or replace view anavxx_des_arma
	(codice, descrizione, ordinamento)
AS
-- DES_ARMA
select descrizione codice, descrizione descrizione, 1 
  from levdar 
 order by 1
/
comment on table anavxx_des_arma is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/ 
create or replace view anavxx_des_corpo
	(codice, descrizione, ordinamento)
AS
-- DES_CORPO
select descrizione codice, descrizione descrizione, 1 
  from levdco 
 order by 1
/
comment on table anavxx_des_corpo is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/ 
create or replace view anavxx_des_grado
	(codice, descrizione, ordinamento)
AS
-- DES_GRADO
select descrizione codice, descrizione descrizione, 1 
  from levdgr 
 order by 1
/
comment on table anavxx_des_grado is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/ 
create or replace view anavxx_stato_albo_ele
	(codice, descrizione, ordinamento)
AS
-- STATO_ALBO_ELE
select v.codice, v.codice||' - '||v.descrizione, v.sequenza
  from (select 'I' codice, 'ISCRITTO'   descrizione, 1 sequenza from dual UNION
        select 'C' codice, 'CANCELLATO' descrizione, 2 sequenza from dual UNION
        select 'R' codice, 'RINUNCIATARIO' descrizione, 3 sequenza from dual) v
 order by 1
/
comment on table anavxx_stato_albo_ele is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
create or replace view anavxx_stato_ele
	(codice, descrizione, ordinamento)
AS
-- STATO_ELE
select v.codice, v.codice||' - '||v.descrizione, v.sequenza
  from (select 'E' codice, 'ELETTORE'   descrizione, 1 sequenza from dual UNION
        select 'S' codice, 'SOSPESO'    descrizione, 3 sequenza from dual UNION
        select 'C' codice, 'CANCELLATO' descrizione, 2 sequenza from dual) v
 order by 1
/
comment on table anavxx_stato_ele is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
create or replace view anavxx_cod_provincia
	(codice, descrizione, ordinamento)
AS
-- COD_PROVINCIA
select v.codice, v.codice||' - '||v.descrizione, v.sequenza
  from (select lpad(cod_provincia,3,'0') codice, descrizione, cod_provincia sequenza from arcpro UNION
        select lpad(cod_provincia,3,'0') codice, descrizione, cod_provincia sequenza from arccom where cod_provincia > 200 and cod_comune = 0) v
 order by 1
/
comment on table anavxx_cod_provincia is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
create or replace view anavxx_cod_comune
	(codice, descrizione, ordinamento)
AS
-- COD_COMUNE
select lpad(cod_comune,3,'0') codice, lpad(cod_provincia,3,'0')||'-'||lpad(cod_comune,3,'0')||' '||descrizione||' ('||sigla_provincia||')' descrizione, 1
  from arccom
 order by 1
/
comment on table anavxx_cod_comune is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
create or replace view anavxx_comune
	(codice, descrizione, ordinamento)
AS
-- COMUNE
select descrizione||' ('||sigla_provincia||')' descrizione, descrizione||' ('||sigla_provincia||')' descrizione, 1
  from arccom
 order by 1
/
comment on table anavxx_comune is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
create or replace view anavxx_cod_regione
	(codice, descrizione, ordinamento)
AS
-- COD_REGIONE
select v.codice, v.codice||' - '||descrizione, v.sequenza
  from (select '01' codice,'PIEMONTE'              descrizione, 12 sequenza from dual UNION
        select '02' codice,'VALLE D''AOSTA'        descrizione, 19 sequenza from dual UNION
        select '03' codice,'LOMBARDIA'             descrizione, 9  sequenza from dual UNION
        select '04' codice,'TRENTINO-ALTO ADIGE'   descrizione, 17 sequenza from dual UNION
        select '05' codice,'VENETO'                descrizione, 20 sequenza from dual UNION
        select '06' codice,'FRIULI-VENEZIA GIULIA' descrizione, 6  sequenza from dual UNION
        select '07' codice,'LIGURIA'               descrizione, 8  sequenza from dual UNION
        select '08' codice,'EMILIA ROMAGNA'        descrizione, 5  sequenza from dual UNION
        select '09' codice,'TOSCANA'               descrizione, 16 sequenza from dual UNION
        select '10' codice,'UMBRIA'                descrizione, 18 sequenza from dual UNION
        select '11' codice,'MARCHE'                descrizione, 10 sequenza from dual UNION
        select '12' codice,'LAZIO'                 descrizione, 7  sequenza from dual UNION
        select '13' codice,'ABRUZZO'               descrizione, 1  sequenza from dual UNION
        select '14' codice,'MOLISE'                descrizione, 11 sequenza from dual UNION
        select '15' codice,'CAMPANIA'              descrizione, 4  sequenza from dual UNION
        select '16' codice,'PUGLIA'                descrizione, 13 sequenza from dual UNION
        select '17' codice,'BASILICATA'            descrizione, 2  sequenza from dual UNION
        select '18' codice,'CALABRIA'              descrizione, 3  sequenza from dual UNION
        select '19' codice,'SICILIA'               descrizione, 15 sequenza from dual UNION
        select '20' codice,'SARDEGNA'              descrizione, 14 sequenza from dual) v
 order by 1
/
comment on table anavxx_cod_regione is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
create or replace view anavxx_regione
	(codice, descrizione, ordinamento)
AS
-- REGIONE
select v.descrizione, v.descrizione, v.sequenza
  from (select '01' codice,'PIEMONTE'              descrizione, 12 sequenza from dual UNION
        select '02' codice,'VALLE D''AOSTA'        descrizione, 19 sequenza from dual UNION
        select '03' codice,'LOMBARDIA'             descrizione, 9  sequenza from dual UNION
        select '04' codice,'TRENTINO-ALTO ADIGE'   descrizione, 17 sequenza from dual UNION
        select '05' codice,'VENETO'                descrizione, 20 sequenza from dual UNION
        select '06' codice,'FRIULI-VENEZIA GIULIA' descrizione, 6  sequenza from dual UNION
        select '07' codice,'LIGURIA'               descrizione, 8  sequenza from dual UNION
        select '08' codice,'EMILIA ROMAGNA'        descrizione, 5  sequenza from dual UNION
        select '09' codice,'TOSCANA'               descrizione, 16 sequenza from dual UNION
        select '10' codice,'UMBRIA'                descrizione, 18 sequenza from dual UNION
        select '11' codice,'MARCHE'                descrizione, 10 sequenza from dual UNION
        select '12' codice,'LAZIO'                 descrizione, 7  sequenza from dual UNION
        select '13' codice,'ABRUZZO'               descrizione, 1  sequenza from dual UNION
        select '14' codice,'MOLISE'                descrizione, 11 sequenza from dual UNION
        select '15' codice,'CAMPANIA'              descrizione, 4  sequenza from dual UNION
        select '16' codice,'PUGLIA'                descrizione, 13 sequenza from dual UNION
        select '17' codice,'BASILICATA'            descrizione, 2  sequenza from dual UNION
        select '18' codice,'CALABRIA'              descrizione, 3  sequenza from dual UNION
        select '19' codice,'SICILIA'               descrizione, 15 sequenza from dual UNION
        select '20' codice,'SARDEGNA'              descrizione, 14 sequenza from dual) v
 order by 3
/
comment on table anavxx_regione is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
create or replace view anavxx_tipo_ds
	(codice, descrizione, ordinamento)
AS
-- TIPO_DS
select cod_do codice, cod_do||' - '||descrizione, 1
  from anaddo
 where flag_stranieri = 'S'
 order by 1
/
comment on table anavxx_tipo_ds is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
create or replace view anavxx_des_tipo_ds
	(codice, descrizione, ordinamento)
AS
-- DES_TIPO_DS
select descrizione codice, descrizione, 1
  from anaddo
 where flag_stranieri = 'S'
 order by 1
/
comment on table anavxx_des_tipo_ds is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
create or replace view anavxx_tipo_di
	(codice, descrizione, ordinamento)
AS
-- TIPO_DI
select cod_do codice, cod_do||' - '||descrizione, 1
  from anaddo
 where flag_identita = 'S'
 order by 1
/
comment on table anavxx_tipo_di is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
create or replace view anavxx_des_tipo_di
	(codice, descrizione, ordinamento)
AS
-- DES_TIPO_DI
select descrizione codice, descrizione, 1
  from anaddo
 where flag_identita = 'S'
 order by 1
/
comment on table anavxx_des_tipo_di is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
create or replace view anavxx_des_unita_01
	(codice, descrizione, ordinamento)
AS
-- DES_unita_0TERRITORIALE_1
select descrizione codice, descrizione, 1
  from anadut
 where cod_ut = 1
 order by 1
/
comment on table anavxx_des_unita_01 is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
create or replace view anavxx_des_unita_02
	(codice, descrizione, ordinamento)
AS
-- DES_unita_0TERRITORIALE_2
select descrizione codice, descrizione, 1
  from anadut
 where cod_ut = 2
 order by 1
/
comment on table anavxx_des_unita_02 is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
create or replace view anavxx_des_unita_03
	(codice, descrizione, ordinamento)
AS
-- DES_unita_0TERRITORIALE_2
select descrizione codice, descrizione, 1
  from anadut
 where cod_ut = 3
 order by 1
/
comment on table anavxx_des_unita_03 is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
create or replace view anavxx_des_unita_04
	(codice, descrizione, ordinamento)
AS
-- DES_unita_0TERRITORIALE_4
select descrizione codice, descrizione, 1
  from anadut
 where cod_ut = 4
 order by 1
/
comment on table anavxx_des_unita_04 is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
create or replace view anavxx_des_unita_05
	(codice, descrizione, ordinamento)
AS
-- DES_unita_0TERRITORIALE_5
select descrizione codice, descrizione, 1
  from anadut
 where cod_ut = 5
 order by 1
/
comment on table anavxx_des_unita_05 is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
create or replace view anavxx_des_unita_06
	(codice, descrizione, ordinamento)
AS
-- DES_unita_0TERRITORIALE_6
select descrizione codice, descrizione, 1
  from anadut
 where cod_ut = 6
 order by 1
/
comment on table anavxx_des_unita_06 is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
create or replace view anavxx_des_unita_07
	(codice, descrizione, ordinamento)
AS
-- DES_unita_0TERRITORIALE_7
select descrizione codice, descrizione, 1
  from anadut
 where cod_ut = 7
 order by 1
/
comment on table anavxx_des_unita_07 is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
create or replace view anavxx_des_unita_08
	(codice, descrizione, ordinamento)
AS
-- DES_unita_0TERRITORIALE_8
select descrizione codice, descrizione, 1
  from anadut
 where cod_ut = 8
 order by 1
/
comment on table anavxx_des_unita_08 is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
create or replace view anavxx_des_unita_09
	(codice, descrizione, ordinamento)
AS
-- DES_unita_0TERRITORIALE_9
select descrizione codice, descrizione, 1
  from anadut
 where cod_ut = 9
 order by 1
/
comment on table anavxx_des_unita_09 is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
create or replace view anavxx_des_unita_10
	(codice, descrizione, ordinamento)
AS
-- DES_UNITA_TERRITORIALE_10
select descrizione codice, descrizione, 1
  from anadut
 where cod_ut = 10
 order by 1
/
comment on table anavxx_des_unita_10 is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
create or replace view anavxx_des_unita_cap
	(codice, descrizione, ordinamento)
AS
-- DES_UNITA_TERRITORIALE_CAP
select descrizione codice, descrizione, 1
  from anadut
 where cod_ut = 99
 order by 1
/
comment on table anavxx_des_unita_cap is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
create or replace view anavxx_des_suddivisione_01
	(codice, descrizione, ordinamento)
AS
-- DES_suddivisione_01
select descrizione codice, descrizione, cod_st
  from anadst
 where cod_ut = 1
 order by 1
/
comment on table anavxx_des_suddivisione_01 is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
create or replace view anavxx_des_suddivisione_02
	(codice, descrizione, ordinamento)
AS
-- DES_suddivisione_02
select descrizione codice, descrizione, cod_st
  from anadst
 where cod_ut = 2
 order by 1
/
comment on table anavxx_des_suddivisione_02 is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
create or replace view anavxx_des_suddivisione_03
	(codice, descrizione, ordinamento)
AS
-- DES_suddivisione_02
select descrizione codice, descrizione, cod_st
  from anadst
 where cod_ut = 3
 order by 1
/
comment on table anavxx_des_suddivisione_03 is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
create or replace view anavxx_des_suddivisione_04
	(codice, descrizione, ordinamento)
AS
-- DES_suddivisione_04
select descrizione codice, descrizione, cod_st
  from anadst
 where cod_ut = 4
 order by 1
/
comment on table anavxx_des_suddivisione_04 is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
create or replace view anavxx_des_suddivisione_05
	(codice, descrizione, ordinamento)
AS
-- DES_suddivisione_05
select descrizione codice, descrizione, cod_st
  from anadst
 where cod_ut = 5
 order by 1
/
comment on table anavxx_des_suddivisione_05 is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
create or replace view anavxx_des_suddivisione_06
	(codice, descrizione, ordinamento)
AS
-- DES_suddivisione_06
select descrizione codice, descrizione, cod_st
  from anadst
 where cod_ut = 6
 order by 1
/
comment on table anavxx_des_suddivisione_06 is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
create or replace view anavxx_des_suddivisione_07
	(codice, descrizione, ordinamento)
AS
-- DES_suddivisione_07
select descrizione codice, descrizione, cod_st
  from anadst
 where cod_ut = 7
 order by 1
/
comment on table anavxx_des_suddivisione_07 is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
create or replace view anavxx_des_suddivisione_08
	(codice, descrizione, ordinamento)
AS
-- DES_suddivisione_08
select descrizione codice, descrizione, cod_st
  from anadst
 where cod_ut = 8
 order by 1
/
comment on table anavxx_des_suddivisione_08 is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
create or replace view anavxx_des_suddivisione_09
	(codice, descrizione, ordinamento)
AS
-- DES_suddivisione_09
select descrizione codice, descrizione, cod_st
  from anadst
 where cod_ut = 9
 order by 1
/
comment on table anavxx_des_suddivisione_09 is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
create or replace view anavxx_des_suddivisione_10
	(codice, descrizione, ordinamento)
AS
-- DES_SUDDIVISIONE_10
select descrizione codice, descrizione, cod_st
  from anadst
 where cod_ut = 10
 order by 1
/
comment on table anavxx_des_suddivisione_10 is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
create or replace view anavxx_des_suddivisione_cap
	(codice, descrizione, ordinamento)
AS
-- DES_SUDDIVISIONE_CAP
select descrizione codice, descrizione, cod_st
  from anadst
 where cod_ut = 99
 order by 1
/
comment on table anavxx_des_suddivisione_cap is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
create or replace view anavxx_data_storico
	(codice, descrizione, ordinamento)
AS
-- DATA_STORICO
select distinct to_char(to_date(sta.data,'j'),'dd/mm/yyyy') codice, to_char(to_date(sta.data,'j'),'dd/mm/yyyy') descrizione, data
  from anasta sta
 order by 3
/
comment on table anavxx_data_storico is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
create or replace view anavxx_des_cod_mov
	(codice, descrizione, ordinamento)
AS
-- DES_CODICE_MOVIMENTO
select 'ISCRIZIONE IN APR',            'ISCRIZIONE IN APR',             1 from dual UNION
select 'CANCELLAZIONE DA APR',         'CANCELLAZIONE DA APR',          2 from dual UNION
select 'ISCRIZIONE IN AIRE',           'ISCRIZIONE IN AIRE',            3 from dual UNION
select 'CANCELLAZIONE DA AIRE',        'CANCELLAZIONE DA AIRE',         4 from dual UNION
select 'CAMBIO DI ABITAZIONE IN APR',  'CAMBIO DI ABITAZIONE IN APR',  10 from dual UNION
select 'CAMBIO DI ABITAZIONE IN APR',  'CAMBIO DI ABITAZIONE IN APR',  11 from dual UNION
select 'CAMBIO DI ABITAZIONE IN AIRE', 'CAMBIO DI ABITAZIONE IN AIRE', 12 from dual UNION
select 'CAMBIO DI ABITAZIONE IN AIRE', 'CAMBIO DI ABITAZIONE IN AIRE', 13 from dual UNION
select 'RETTIFICA APR',                'RETTIFICA APR',                97 from dual UNION
select 'RETTIFICA AIRE',               'RETTIFICA AIRE',               98 from dual
 order by 2
/
comment on table anavxx_des_cod_mov is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
create or replace view anavxx_des_cod_eve
	(codice, descrizione, ordinamento)
AS
-- DES_CODICE_EVENTO
select distinct dev.descrizione, dev.descrizione, dev.cod_ev
  from anadev dev, anadce dce
 where dev.cod_ev = dce.cod_eve
   and dce.cod_mov in (1,2,3,4)
UNION
 select 'IRREPERIBILITA'' AL CENSIMENTO', 'IRREPERIBILITA'' AL CENSIMENTO', 53
   from dual
UNION
select 'GENERALITA', 'GENERALITA (RETTIFICA)', 99
  from dual
UNION
select 'CITTADINANZA', 'CITTADINANZA (RETTIFICA)', 99
  from dual
UNION
select 'STATO CIVILE', 'STATO CIVILE (RETTIFICA)', 99
  from dual
order by 1
/
comment on table anavxx_des_cod_eve is 'Statistiche Anagrafe - Filtri "alfabetici" per elaborazione elenchi (view)'
/
