--liquibase formatted sql
--changeset amonopoli:202305251615_5 runOnChange:true stripComments:false
create or replace view civdrf_v_UCI
       (TIPO_ATTO, PARTE, SERIE, NATURA, 
        ID_CATEGORIA, SIGLA_CATEGORIA, COD_MINUTA,
        RICHIAMO, PROGR_DETTAGLIO, FORMULA,               
        FLAG_DEFAULT, FLAG_RICORRENTE, FLAG_TESTO_FISSO,
        FLAG_AGGIUNTA_A_CAPO, FLAG_AGGIUNTA_RICHIAMO,
        DES_RICHIAMO, DES_FORMULA, TESTO_FORMULA,
        DOCUMENTI_PRESENTATI_MAT, DOCUMENTI_PRESENTATI_UCI, 
        CONVENZIONI_PATRIMONIALI, SCELTA_COGNOME, SCELTA_COGNOME_1, SCELTA_COGNOME_2,
        PRESENZA_AVVOCATI,
        NUM_COLONNE, NUM_RIGHE,
        TABELLA_RIF, ID_RIF, TIPO_RICHIESTA)
AS
-- 4 - atti di matrimonio
-- lista formula per atti 1 2 (originali e trascritti)
-- recuperate dal formulario
select dta.tipo_atto, 
       dta.parte, 
       dta.serie,
--       decode(dta.natura,'O','O','1','O','T','T','D'),
       dta.natura_decode natura,
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
-- documenti_presentati_mat
       f_CIV_documenti_presentati_pub(dta.tipo_atto,dta.parte,dta.serie,drc.richiamo,drc.progr_dettaglio,dfa.formula,dfa.tipo_annotazione,cta.sigla),
-- documenti_presentati_uci
       f_CIV_documenti_presentati_uci(dta.tipo_atto,dta.parte,dta.serie,drc.richiamo,drc.progr_dettaglio,dfa.formula,dfa.tipo_annotazione,cta.sigla),
-- convenzioni_patrimoniali
       f_CIV_convenzioni_patrimoniali(dta.tipo_atto,dta.parte,dta.serie,drc.richiamo,drc.progr_dettaglio,dfa.formula,dfa.tipo_annotazione,cta.sigla),
-- scelta_cognome
       f_CIV_scelta_cognome(dta.tipo_atto,dta.parte,dta.serie,drc.richiamo,drc.progr_dettaglio,dfa.formula,dfa.tipo_annotazione,cta.sigla),
-- scelta_cognome_1
       f_CIV_scelta_cognome(dta.tipo_atto,dta.parte,dta.serie,drc.richiamo,drc.progr_dettaglio,dfa.formula,dfa.tipo_annotazione,cta.sigla,1),
-- scelta_cognome_2
       f_CIV_scelta_cognome(dta.tipo_atto,dta.parte,dta.serie,drc.richiamo,drc.progr_dettaglio,dfa.formula,dfa.tipo_annotazione,cta.sigla,2),
-- presenza_avvocati
       f_CIV_presenza_avvocati(dta.tipo_atto,dta.parte,dta.serie,drc.richiamo,drc.progr_dettaglio,dfa.formula,dfa.tipo_annotazione,cta.sigla),
-- num_colonne
       nvl(drc.num_colonne,decode(drc.richiamo,91,41,92,41,93,41,94,41,95,41)),
-- num_righe
       nvl(drc.num_righe,decode(drc.richiamo,91,15,92,15,93,15,94,15,95,15)),
       'CIVTFA' tabella_rif,
       tfa.formula id_rif,
       null tipo_richiesta
  from civcta cta
     , civtfa tfa
     , civdfa dfa
     , civdrf drf
     , civdrc drc
     , civdta_v dta
 where cta.flag_formule    = 'S'
   and cta.flag_verbale||cta.flag_divorzio is null
   and cta.id              = dta.id_civcta
   and tfa.riga    (+)     = 1
   and tfa.formula (+)     = dfa.formula
   and (dfa.formula not like '0-%-PV%')
   and dfa.formula         = drf.formula
   and drf.tipo_atto       = drc.tipo_atto
   and drf.richiamo        = drc.richiamo
   and drf.progr_dettaglio = drc.progr_dettaglio
   and drc.tipo_atto       = dta.tipo_atto
   and dta.tipo_atto       = -4
UNION
-- lista minute di default x atti parte 2
-- recuperata dalla minute dichiarate in DTAT
-- (ANSC = 'N')
select dta.tipo_atto                                   tipo_atto, 
       dta.parte                                       parte, 
       dta.serie                                       serie,
--       decode(dta.natura,'1','O',dta.natura)           natura,
       dta.natura_decode			       natura,
       dta.id_civcta                                   id_categoria,
       cta.sigla                                       sigla_categoria,
       dta.cod_mi                                      cod_minuta,
       90                                              richiamo, 
       1                                               prog_dettaglio,
       to_char(dmi.cod_mi)                             formula,
       'S'                                             flag_default,
       to_char(null)                                   flag_ricorrente,
       to_char(null)                                   flag_testo_fisso,
       to_char(null)                                   flag_aggiunta_a_capo,
       to_char(null)                                   flag_aggiunta_richiamo,
       'Minuta'                                        des_richiamo,
       '('||dmi.cod_mi||') '||nvl(dmi.descrizione_estesa,dmi.descrizione)   des_formula,
       dbms_lob.substr(ism.riga_clob,4000,1)          testo_formula,
       to_char(null)                                   documenti_presentati_mat,
       to_char(null)                                   documenti_presentati_uci,
       to_char(null)                                   convenzioni_patrimoniali,
       to_char(null)                                   scelta_cognome,
       to_char(null)                                   scelta_cognome_1,
       to_char(null)                                   scelta_cognome_2,
       to_char(null)                                   presenza_avvocati,
       drc.num_colonne                                 num_colonne,
       drc.num_righe                                   num_righe,
       'CIVISM'                                        tabella_rif,
       to_char(ism.id)                                 id_rif,
       dmi.TIPO_RICHIESTA                              tipo_richiesta
  from civdrc drc
     , civism ism
     , civdmi dmi
     , civcta cta
     , civdta_v dta
 where drc.richiamo        = 90
   and drc.progr_dettaglio = 1
   and cta.flag_formule    is null 
   and cta.id (+)          = dta.id_civcta
   and ism.cod_riga        = 1
   and ism.cod_mi          = dta.cod_mi
   and ism.tipo_atto       = dta.tipo_atto
   and dmi.cod_mi          = dta.cod_mi
   and dmi.tipo_atto       = dta.tipo_atto
   and dta.tipo_atto       = -4
   and nvl(f_valore_inp('ANSC',1,1,'X','S'),'N') = 'N'
UNION
-- lista minute di popUP x atti parte 2
-- recuperata dalla minute presentei in DFSC
-- (purche' non gia' censite in DTAT)
-- (ANSC = 'N')=
select -4                                              tipo_atto, 
       2                                               parte, 
       to_char(null)                                   serie,
       to_char(null)                                   natura,
       dmi.id_civcta                                   id_categoria,
       cta.sigla                                       sigla_categoria, 
       dmi.cod_mi                                      cod_minuta,
       drc.richiamo                                    richiamo, 
       drc.progr_dettaglio                             progr_richiamo,
       to_char(dmi.cod_mi)                             formula,
       to_char(null)                                   flag_default,
       to_char(null)                                   flag_ricorrente,
       to_char(null)                                   flag_testo_fisso,
       to_char(null)                                   flag_aggiunta_a_capo,
       to_char(null)                                   flag_aggiunta_richiamo,
       'Minuta'                                        des_richiamo,
       '('||dmi.cod_mi||') '||nvl(dmi.descrizione_estesa,dmi.descrizione)   des_formula,
       dbms_lob.substr(ism.riga_clob,4000,1)          testo_formula,
       to_char(null)                                   documenti_presentati_mat,
       to_char(null)                                   documenti_presentati_uci,
       to_char(null)                                   convenzioni_patrimoniali,
       to_char(null)                                   scelta_cognome,
       to_char(null)                                   scelta_cognome_1,
       to_char(null)                                   scelta_cognome_2,
       to_char(null)                                   presenza_avvocati,
       drc.num_colonne                                 num_colonne,
       drc.num_righe                                   num_righe,
       'CIVISM'                                        tabella_rif,
       to_char(ism.id)                                 id_rif,
       null                                            tipo_richiesta
  from civdrc drc
     , civcta cta
     , civism ism
     , civdmi dmi
 where drc.richiamo        = 90
   and drc.progr_dettaglio = 1
   and cta.id (+)          = dmi.id_civcta
   and ism.cod_riga        = 1
   and ism.cod_mi          = dmi.cod_mi
   and ism.tipo_atto       = dmi.tipo_atto
   and dmi.tipo_atto       = -4
   and not exists (select 'x' from civdta dta
                    where dta.tipo_atto = dmi.tipo_atto
                      and dta.cod_mi    = dmi.cod_mi)
   and nvl(f_valore_inp('ANSC',1,1,'X','S'),'N') = 'N'
UNION
-- lista minute di popUP x atti parte 2
-- (ANSC = 'S')=
select -4                                              tipo_atto, 
       2                                               parte, 
       to_char(null)                                   serie,
       to_char(null)                                   natura,
       dmi.id_civcta                                   id_categoria,
       cta.sigla                                       sigla_categoria, 
       dmi.cod_mi                                      cod_minuta,
       drc.richiamo                                    richiamo, 
       drc.progr_dettaglio                             progr_richiamo,
       to_char(dmi.cod_mi)                             formula,
       to_char(null)                                   flag_default,
       to_char(null)                                   flag_ricorrente,
       to_char(null)                                   flag_testo_fisso,
       to_char(null)                                   flag_aggiunta_a_capo,
       to_char(null)                                   flag_aggiunta_richiamo,
       'Minuta'                                        des_richiamo,
       '('||dmi.cod_mi||') '||nvl(dmi.descrizione_estesa,dmi.descrizione)   des_formula,
       dbms_lob.substr(ism.riga_clob,4000,1)          testo_formula,
       to_char(null)                                   documenti_presentati_mat,
       to_char(null)                                   documenti_presentati_uci,
       to_char(null)                                   convenzioni_patrimoniali,
       to_char(null)                                   scelta_cognome,
       to_char(null)                                   scelta_cognome_1,
       to_char(null)                                   scelta_cognome_2,
       to_char(null)                                   presenza_avvocati,
       drc.num_colonne                                 num_colonne,
       drc.num_righe                                   num_righe,
       'CIVISM'                                        tabella_rif,
       to_char(ism.id)                                 id_rif,
       null                                            tipo_richiesta
  from civdrc drc
     , civcta cta
     , civism ism
     , civdmi dmi
 where drc.richiamo        = 90
   and drc.progr_dettaglio = 1
   and cta.id              = dmi.id_civcta
   and ism.cod_riga        = 1
   and ism.cod_mi          = dmi.cod_mi
   and ism.tipo_atto       = dmi.tipo_atto
   and dmi.tipo_atto       = -4
   and nvl(f_valore_inp('ANSC',1,1,'X','S'),'N') = 'S'
/
comment on table CIVDRF_V_UCI is 'Stato Civile - Formule per Atti di Unione Civile (view)'
/
