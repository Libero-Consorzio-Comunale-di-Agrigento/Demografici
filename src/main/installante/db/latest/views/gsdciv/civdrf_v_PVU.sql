--liquibase formatted sql
--changeset amonopoli:202305251615_6 runOnChange:true stripComments:false
create or replace view civdrf_v_pvu
       (TIPO_ATTO, PARTE, SERIE, NATURA, 
        ID_CATEGORIA, SIGLA_CATEGORIA, COD_MINUTA,
        RICHIAMO, PROGR_DETTAGLIO, FORMULA,               
        FLAG_DEFAULT, FLAG_RICORRENTE, FLAG_TESTO_FISSO,
        FLAG_AGGIUNTA_A_CAPO, FLAG_AGGIUNTA_RICHIAMO,
        DES_RICHIAMO, DES_FORMULA, TESTO_FORMULA,
        DOCUMENTI_PRESENTATI_PUB,
        NUM_COLONNE, NUM_RIGHE, 
        TABELLA_RIF, ID_RIF,
        FLAG_DB, TIPO_RICHIESTA)
as
select dta.tipo_atto,
       dta.parte,
       dta.serie,
       dta.natura,
       dta.id_civcta,
       cta.sigla,
       to_number(null) cod_minuta,
       drc.richiamo,
       drc.progr_dettaglio,
       dfa.formula,
-- flag_default
       f_CIV_flag_default(dta.tipo_atto,dta.parte,dta.serie,drc.richiamo,drc.progr_dettaglio,dfa.formula,dfa.tipo_annotazione,cta.sigla,drf.flag_default) flag_default,
       drf.flag_ricorrente,
       drf.flag_testo_fisso,
       drf.flag_aggiunta_a_capo,
       drf.flag_aggiunta_richiamo,
       drc.descrizione des_richiamo,
       '('||drc.richiamo||') '||dfa.formula||' - '||initcap(dfa.descrizione) des_formula,
       f_CIV_testo_formula(tfa.testo_4000,tfa.testo_a3) testo_formula,
       f_CIV_documenti_presentati_pub(dta.tipo_atto,dta.parte,dta.serie,drc.richiamo,drc.progr_dettaglio,dfa.formula,dfa.tipo_annotazione,cta.sigla),
-- num_colonne
       nvl(drc.num_colonne,decode(drc.richiamo,91,41,92,41,93,41,94,41,95,41)),
-- num_righe
       nvl(drc.num_righe,decode(drc.richiamo,91,15,92,15,93,15,94,15,95,15)),
       'CIVTFA' tabella_rif,
       tfa.formula id_rif,
       'S' flag_db,
       null tipo_richiesta
  from civcta cta
     , civtfa tfa
     , civdfa dfa
     , civdrf drf
     , civdrc drc
     , civdta dta
 where cta.flag_formule    = 'S'
   and cta.flag_verbale    = 'S'
   and cta.id              = dta.id_civcta
   and tfa.riga    (+)     = 1
   and tfa.formula (+)     = dfa.formula
   and (dfa.formula like '0-%-PV%')
   and dfa.formula         = drf.formula
   and drf.tipo_atto       = drc.tipo_atto
   and drf.richiamo        = drc.richiamo
   and drf.progr_dettaglio = drc.progr_dettaglio
   and drc.tipo_atto       = dta.tipo_atto
--   and dta.natura          = 'V'
   and dta.tipo_atto       = -4
/
comment on table CIVDRF_V_PVU is 'Stato Civile - Formule per Atti di Processi Verbali (view)'
/
