--liquibase formatted sql
--changeset amonopoli:202303291405_1 runOnChange:true stripComments:false
create or replace view civdrf_v_NAS_v1
       (TIPO_ATTO, PARTE, SERIE, NATURA, 
        ID_CATEGORIA, SIGLA_CATEGORIA, COD_MINUTA,
        RICHIAMO, PROGR_DETTAGLIO, FORMULA,               
        FLAG_DEFAULT, FLAG_RICORRENTE, FLAG_TESTO_FISSO,
        FLAG_AGGIUNTA_A_CAPO, FLAG_AGGIUNTA_RICHIAMO,
        DES_RICHIAMO, DES_FORMULA, TESTO_FORMULA,
        TIPO_FILIAZIONE, TIPO_DICHIARANTE, NATO_MORTO, 
        PARTO_PLURIMO, 
        PARTO_PLURIMO_FLAG_PRIMO, PARTO_PLURIMO_FLAG_ULTIMO, PARTO_PLURIMO_FLAG_BIGEMINO,
        TIPO_ADDETTO_DICHIARAZIONE_CNA,
        NUM_COLONNE, NUM_RIGHE,
        id_civdrf)
AS
-- 2 - atti di nascita
-- lista formula per atti 1A 1B 2A
-- recuperate dal formulario
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
       '('||drc.richiamo||') '||dfa.formula||' - '||initcap(dfa.descrizione_1||' '||dfa.descrizione_2||' '||dfa.descrizione_3) des_formula,
       f_CIV_testo_formula(tfa.testo_4000,tfa.testo_a3) testo_formula,
-- tipo_filiazione
       f_CIV_tipo_filiazione(dta.tipo_atto,dta.parte,dta.serie,drc.richiamo,drc.progr_dettaglio,dfa.formula,dfa.tipo_annotazione,cta.sigla) tipo_filiazione,
-- tipo_dichiarante
       f_CIV_tipo_dichiarante(dta.tipo_atto,dta.parte,dta.serie,drc.richiamo,drc.progr_dettaglio,dfa.formula,dfa.tipo_annotazione,cta.sigla) tipo_dichiarante,
-- nato_morto       
       case
         when drc.richiamo = 9 and drc.progr_dettaglio = 2 and dfa.formula = '40' then
              'NO'
         when drc.richiamo = 9 and drc.progr_dettaglio = 2 and dfa.formula = '41' then
              'SI'
       end case,
-- parto_plurimo
       case
         when drc.richiamo = 9 and drc.progr_dettaglio = 1 then
              'SI'
       end case,
-- parto_plurimo_flag_primo
       case
         when drc.richiamo = 9 and drc.progr_dettaglio = 1 and dfa.formula in ('35','37') then
              'S'
         else
              'N'
       end case,
-- parto_plurimo_flag_ultimo
       case
         when drc.richiamo = 9 and drc.progr_dettaglio = 1 and dfa.formula in ('36','39') then
              'S'
         else
              'N'
       end case,
-- parto_plurimo_flag_bigemino
       case
         when drc.richiamo = 9 and drc.progr_dettaglio = 1 and dfa.formula in ('35','36') then
              'S'
         else
              'N'
       end case,
-- tipo_addetto_dichiarazione_cna
       f_CIV_tipo_addetto_cna(dta.tipo_atto,dta.parte,dta.serie,drc.richiamo,drc.progr_dettaglio,dfa.formula,dfa.tipo_annotazione,cta.sigla) tipo_dichiarante,
-- num_colonne
       nvl(drc.num_colonne,decode(drc.richiamo,91,41,92,41,98,41,93,41,94,41,95,41)),
-- num_righe
       nvl(drc.num_righe,decode(drc.richiamo,91,15,92,15,98,15,93,15,94,15,95,15)),
-- id_civdrf
       drf.id
  from civcta cta
     , civtfa tfa
     , civdfa dfa
     , civdrf drf
     , civdrc drc
     , civdta dta
 where (cta.flag_formule    = 'S' or drc.richiamo = 98)
   and cta.id              = dta.id_civcta
   and tfa.riga    (+)     = 1
   and tfa.formula (+)     = dfa.formula
   and dfa.formula         = drf.formula
   and drf.tipo_atto       = drc.tipo_atto
   and drf.richiamo        = drc.richiamo
   and drf.progr_dettaglio = drc.progr_dettaglio
   and drc.tipo_atto       = dta.tipo_atto
   and dta.tipo_atto       = 2
UNION
-- lista minute di default x atti 2B
-- recuperata dalla minute dichiarate in DTAT
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
       dbms_lob.substr(ism.riga_clob,4000,1)          testo_formula,
       to_char(null)                                   tipo_filiazione,
       to_char(null)                                   tipo_dichiarante,
       to_char(null)                                   nato_morto,
       to_char(null)                                   parto_plurimo,
       to_char(null)                                   parto_plurimo_flag_primo,
       to_char(null)                                   parto_plurimo_flag_ultimo,
       to_char(null)                                   parto_plurimo_flag_bigemino,
       to_char(null)                                   tipo_addetto_dichiarazione_cna,
       drc.num_colonne                                 num_colonne,
       drc.num_righe                                   num_righe,
       to_number(null)                                 id_civdrf
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
   and dta.tipo_atto       = 2
UNION
-- lista minute di popUP x atti 2B
-- recuperata dalla minute presentei in DFSC
-- (purche' non gia' censite in DTAT)
select 2                                               tipo_atto, 
       2                                               parte, 
       'B'                                             serie,
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
       to_char(null)                                   tipo_filiazione,
       to_char(null)                                   tipo_dichiarante,
       to_char(null)                                   nato_morto,
       to_char(null)                                   parto_plurimo,
       to_char(null)                                   parto_plurimo_flag_primo,
       to_char(null)                                   parto_plurimo_flag_ultimo,
       to_char(null)                                   parto_plurimo_flag_bigemino,
       to_char(null)                                   tipo_addetto_dichiarazione_cna,
       drc.num_colonne                                 num_colonne,
       drc.num_righe                                   num_righe,
       to_number(null)                                 id_civdrf
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
   and dmi.tipo_atto       = 2
   and not exists (select 'x' from civdta dta
                    where dta.tipo_atto = dmi.tipo_atto
                      and dta.cod_mi    = dmi.cod_mi)
UNION
-- minute convenzionale (vuota) di default x atti in parte 1 senza serie
select dta.tipo_atto                                   tipo_atto, 
       dta.parte                                       parte, 
       dta.serie                                       serie,
       dta.natura                                      natura,
       dta.id_civcta                                   id_categoria,
       cta.sigla                                       sigla_categoria,
       dta.cod_mi                                      cod_minuta,
       90                                              richiamo, 
       1                                               prog_dettaglio,
       '0'                                             formula,
       'S'                                             flag_default,
       to_char(null)                                   flag_ricorrente,
       to_char(null)                                   flag_testo_fisso,
       to_char(null)                                   flag_aggiunta_a_capo,
       to_char(null)                                   flag_aggiunta_richiamo,
       'Minuta'                                        des_richiamo,
       '(0)'                                           des_formula,
       to_char(null)                                   testo_formula,
       to_char(null)                                   tipo_filiazione,
       to_char(null)                                   tipo_dichiarante,
       to_char(null)                                   nato_morto,
       to_char(null)                                   parto_plurimo,
       to_char(null)                                   parto_plurimo_flag_primo,
       to_char(null)                                   parto_plurimo_flag_ultimo,
       to_char(null)                                   parto_plurimo_flag_bigemino,
       to_char(null)                                   tipo_addetto_dichiarazione_cna,
       to_number(null)                                 num_colonne,
       to_number(null)                                 num_righe,
       to_number(null)                                 id_civdrf
  from civcta cta
     , civdta dta
 where cta.flag_formule    is null 
   and cta.id (+)          = dta.id_civcta
   and dta.tipo_atto       = 2
   and dta.parte           = 1
   and dta.serie           is null
/
