--liquibase formatted sql
--changeset amonopoli:202304181800 runOnChange:true stripComments:false
create or replace view civdrf_v_MOR
       (TIPO_ATTO, PARTE, SERIE, NATURA, 
        ID_CATEGORIA, SIGLA_CATEGORIA, COD_MINUTA,
        RICHIAMO, PROGR_DETTAGLIO, FORMULA,               
        FLAG_DEFAULT, FLAG_RICORRENTE, FLAG_TESTO_FISSO,
        FLAG_AGGIUNTA_A_CAPO, FLAG_AGGIUNTA_RICHIAMO,
        DES_RICHIAMO, DES_FORMULA, TESTO_FORMULA,
        TIPO_COMPARENTE, TIPO_FIRMATARIO, COMPRENSIONE_DIC,
        NUM_COLONNE, NUM_RIGHE, 
        TABELLA_RIF, ID_RIF, 
        id_civdrf, id_civdrf_filtri, TIPO_RICHIESTA)
AS
-- 5 - atti di morte
-- lista formula per atti 1 2A 2B
-- recuperate dal formulario
select dta.tipo_atto, 
       dta.parte, 
       dta.serie,
       dta.natura,
       dta.id_civcta,
       cta.sigla,
       to_number(null) cod_minuta,
       decode(drc.richiamo, 10, 9, 9, 10, drc.richiamo),
       drc.progr_dettaglio,
       dfa.formula,
-- flag_default
       decode(drf_f.id,'',drf.flag_default,drf_f.flag_default) flag_default,
       drf.flag_ricorrente, 
       drf.flag_testo_fisso,
       drf.flag_aggiunta_a_capo,
       drf.flag_aggiunta_richiamo,
       drc.descrizione des_richiamo,
       '('||drc.richiamo||') '||dfa.formula||' - '||initcap(dfa.descrizione) des_formula,
       f_CIV_testo_formula(tfa.testo_4000,tfa.testo_a3) testo_formula,
-- tipo_comparente
       drf_f.tipo_comparente, 
-- tipo_firmatario
       drf_f.tipo_firmatario,
-- comprensione_dic
       drf_f.comprensione_dic, 
-- num_colonne
       nvl(drc.num_colonne,decode(drc.richiamo,91,41,92,41,98,41,93,41,94,41,95,41)),
-- num_righe
       nvl(drc.num_righe,decode(drc.richiamo,91,15,92,15,98,15,93,15,94,15,95,15)),
       'CIVTFA' tabella_rif,
       tfa.formula id_rif,
-- id_civdrf
       drf.id,
-- id_civdrf_filtri
       drf_f.id,
       null tipo_richiesta
  from civdrf_filtri drf_f
     , civcta cta
     , civtfa tfa
     , civdfa dfa
     , civdrf drf
     , civdrc drc
     , civdta dta
 where nvl(drf_f.sigla_categoria,cta.sigla) = cta.sigla
   and drf_f.id_civdrf (+) = drf.id
   and (cta.flag_formule    = 'S' or drc.richiamo = 98)
   and cta.id              = dta.id_civcta
   and tfa.riga    (+)     = 1
   and tfa.formula (+)     = dfa.formula
   and dfa.formula         = drf.formula
   and drf.tipo_atto       = drc.tipo_atto
   and drf.richiamo        = drc.richiamo
   and drf.progr_dettaglio = drc.progr_dettaglio
   and drc.tipo_atto       = dta.tipo_atto
   and dta.tipo_atto       = 5
UNION
-- lista minute di default x atti 2C
-- recuperata dalla minute dichiarate in DTAT
-- (ANSC = 'N')
select dta.tipo_atto                                   tipo_atto, 
       dta.parte                                       parte, 
       dta.serie                                       serie,
       dta.natura                                      natura,
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
       dbms_lob.substr(ism.riga_clob,4000,1)           testo_formula,
       to_char(null)                                   tipo_comparente,
       to_char(null)                                   tipo_firmatario,
       to_char(null)                                   comprensione_dic,
       drc.num_colonne                                 num_colonne,
       drc.num_righe                                   num_righe,
       'CIVISM'                                        tabella_rif,
       to_char(ism.id)                                 id_rif,
       to_number(null)                                 id_civdrf,
       to_number(null)                                 id_civdrf_filtri,
       dmi.TIPO_RICHIESTA                              tipo_richiesta
  from civdrc drc
     , civism ism
     , civdmi dmi
     , civcta cta
     , civdta dta
 where drc.richiamo        = 90
   and drc.progr_dettaglio = 1
   and cta.flag_formule    is null 
   and cta.id (+)          = dta.id_civcta
   and ism.cod_riga        = 1
   and ism.cod_mi          = dta.cod_mi
   and ism.tipo_atto       = dta.tipo_atto
   and dmi.cod_mi          = dta.cod_mi
   and dmi.tipo_atto       = dta.tipo_atto
   and dta.tipo_atto       = 5
   and nvl(f_valore_inp('ANSC',1,1,'X','S'),'N') = 'N'
UNION
-- lista minute di popUP x atti 2C
-- recuperata dalla minute presentei in DFSC
-- (purche' non gia' censite in DTAT)
-- (ANSC = 'N')
select 5                                               tipo_atto, 
       2                                               parte, 
       'C'                                             serie,
       to_char(null)                                   natura,
       dmi.id_civcta                                   id_categoria,
       cta.sigla                                       sigla_categoria, 
       dmi.cod_mi                                      cod_minuta,
       decode(drc.richiamo, 10, 9, 9, 10, drc.richiamo)    richiamo,
       drc.progr_dettaglio                             progr_richiamo,
       to_char(dmi.cod_mi)                             formula,
       to_char(null)                                   flag_default,
       to_char(null)                                   flag_ricorrente,
       to_char(null)                                   flag_testo_fisso,
       to_char(null)                                   flag_aggiunta_a_capo,
       to_char(null)                                   flag_aggiunta_richiamo,
       'Minuta'                                        des_richiamo,
       '('||dmi.cod_mi||') '||nvl(dmi.descrizione_estesa,dmi.descrizione)   des_formula,
       dbms_lob.substr(ism.riga_clob,4000,1)           testo_formula,
       to_char(null)                                   tipo_comparente,
       to_char(null)                                   tipo_firmatario,
       to_char(null)                                   comprensione_dic,
       drc.num_colonne                                 num_colonne,
       drc.num_righe                                   num_righe,
       'CIVISM'                                        tabella_rif,
       to_char(ism.id)                                 id_rif,
       to_number(null)                                 id_civdrf,
       to_number(null)                                 id_civdrf_filtri,
       dmi.TIPO_RICHIESTA                              tipo_richiesta
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
   and dmi.tipo_atto       = 5
   and not exists (select 'x' from civdta dta
                    where dta.tipo_atto = dmi.tipo_atto
                      and dta.cod_mi    = dmi.cod_mi)
   and nvl(f_valore_inp('ANSC',1,1,'X','S'),'N') = 'N'
UNION
-- lista minute di popUP x atti 2C
-- (ANSC = 'S')
select 5                                               tipo_atto, 
       2                                               parte, 
       'C'                                             serie,
       to_char(null)                                   natura,
       dmi.id_civcta                                   id_categoria,
       cta.sigla                                       sigla_categoria, 
       dmi.cod_mi                                      cod_minuta,
       decode(drc.richiamo, 10, 9, 9, 10, drc.richiamo)    richiamo,
       drc.progr_dettaglio                             progr_richiamo,
       to_char(dmi.cod_mi)                             formula,
       to_char(null)                                   flag_default,
       to_char(null)                                   flag_ricorrente,
       to_char(null)                                   flag_testo_fisso,
       to_char(null)                                   flag_aggiunta_a_capo,
       to_char(null)                                   flag_aggiunta_richiamo,
       'Minuta'                                        des_richiamo,
       '('||dmi.cod_mi||') '||nvl(dmi.descrizione_estesa,dmi.descrizione)   des_formula,
       dbms_lob.substr(ism.riga_clob,4000,1)           testo_formula,
       to_char(null)                                   tipo_comparente,
       to_char(null)                                   tipo_firmatario,
       to_char(null)                                   comprensione_dic,
       drc.num_colonne                                 num_colonne,
       drc.num_righe                                   num_righe,
       'CIVISM'                                        tabella_rif,
       to_char(ism.id)                                 id_rif,
       to_number(null)                                 id_civdrf,
       to_number(null)                                 id_civdrf_filtri,
       dmi.TIPO_RICHIESTA                              tipo_richiesta
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
   and dmi.tipo_atto       = 5
   and nvl(f_valore_inp('ANSC',1,1,'X','S'),'N') = 'S'
/
comment on table CIVDRF_V_MOR is 'Stato Civile - Formule per Atti di Morte (view)'
/
