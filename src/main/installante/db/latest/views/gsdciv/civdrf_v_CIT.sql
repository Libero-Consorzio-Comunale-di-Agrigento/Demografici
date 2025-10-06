--liquibase formatted sql
--changeset amonopoli:202305251615_1 runOnChange:true stripComments:false
create or replace view civdrf_v_CIT
       (TIPO_ATTO, PARTE, SERIE, NATURA, 
        ID_CATEGORIA, SIGLA_CATEGORIA, COD_MINUTA,
        RICHIAMO, PROGR_DETTAGLIO, FORMULA,               
        FLAG_DEFAULT, FLAG_RICORRENTE, FLAG_TESTO_FISSO,
        FLAG_AGGIUNTA_A_CAPO, FLAG_AGGIUNTA_RICHIAMO,
        DES_RICHIAMO, DES_FORMULA, TESTO_FORMULA,
        NUM_COLONNE, NUM_RIGHE,
        TABELLA_RIF, ID_RIF, TIPO_RICHIESTA)
AS
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
       dbms_lob.substr(ism.riga_clob,4000,1)          testo_formula,
       drc.num_colonne                                 num_colonne,
       drc.num_righe                                   num_righe,
       'CIVISM'                                        tabella_rif,
       to_char(ism.id)                                 id_rif,
       dmi.tipo_richiesta                              tipo_richiesta
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
   and dta.tipo_atto       = 1
   and nvl(f_valore_inp('ANSC',1,1,'X','S'),'N') = 'N'
UNION
-- lista minute di popUP 
-- recuperata dalla minute presentei in DFSC
-- (purche' non gia' censite in DTAT)
-- (ANSC = 'N')
select 1                                               tipo_atto, 
       to_number(null)                                 parte, 
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
       drc.num_colonne                                 num_colonne,
       drc.num_righe                                   num_righe,
       'CIVISM'                                        tabella_rif,
       to_char(ism.id)                                 id_rif,
       dmi.tipo_richiesta                              tipo_richiesta
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
   and dmi.tipo_atto       = 1
   and not exists (select 'x' from civdta dta
                    where dta.tipo_atto = dmi.tipo_atto
                      and dta.cod_mi    = dmi.cod_mi
                      and dta.id_civcta = cta.id)
   and nvl(f_valore_inp('ANSC',1,1,'X','S'),'N') = 'N'
UNION
-- lista minute di popUP 
-- (ANSC = 'S')
select 1                                               tipo_atto, 
       to_number(null)                                 parte, 
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
       drc.num_colonne                                 num_colonne,
       drc.num_righe                                   num_righe,
       'CIVISM'                                        tabella_rif,
       to_char(ism.id)                                 id_rif,
       dmi.tipo_richiesta                              tipo_richiesta
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
   and dmi.tipo_atto       = 1
   and nvl(f_valore_inp('ANSC',1,1,'X','S'),'N') = 'S'
/
comment on table CIVDRF_V_CIT is 'Stato Civile - Formule per Atti di Cittadinanza (view)'
/
