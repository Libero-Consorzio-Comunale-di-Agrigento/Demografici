--liquibase formatted sql
--changeset amonopoli:202505191635 runOnChange:true stripComments:false
create or replace view civana_totale
      (ID, ID_ATTO,
       TIPO_ATTO, UFFICIO, ANNO, ATTO, PARTE, SERIE,
       MATRICOLA_1, MATRICOLA_2,
       UFFICIO_ORIG, ANNO_ORIG, ATTO_ORIG, PARTE_ORIG, SERIE_ORIG, COD_PRO_ATTO_ORIG, COD_COM_ATTO_ORIG, ID_ATTO_ANSC_ORIG,
--
       FLAG_AGGIORNATO_NA0,
       COMPOSIZIONE_COMPLETA_NA0,
--
       des_com_atto, sigla_pro_atto, cod_rec, id_atto_ansc,
       numero_unico, natura,
       cognome_nome, sesso, data_nas, cod_pro_nas, cod_com_nas, cod_pro_res, cod_com_res, cod_fiscale, cf_calcolato, nazionalita,
       cognome_nome_m, sesso_m, data_nas_m, cod_pro_nas_m, cod_com_nas_m, cod_pro_res_m, cod_com_res_m, cod_fiscale_m, cf_calcolato_m, nazionalita_m,
       cognome_nome_f, sesso_f, data_nas_f, cod_pro_nas_f, cod_com_nas_f, cod_pro_res_f, cod_com_res_f, cod_fiscale_f, cf_calcolato_f, nazionalita_f,
       data_cit, data_decorrenza,
       paternita, nazionalita_pd,
       maternita, nazionalita_md,
       anno_nas,
       data_mor, cod_pro_mor, cod_com_mor, flag_gg_imprecisato, flag_mm_imprecisato, flag_aa_imprecisato,
       data_mat, cod_pro_mat, cod_com_mat, data_div,
       cambio_cognome_m, cognome_agg_m, cambio_cognome_f, cognome_agg_f)
AS
select ana.ID
     , ana.ID_ATTO
     , ana.TIPO_ATTO
     , ana.UFFICIO
     , ana.ANNO
     , ana.ATTO
     , ana.PARTE
     , ana.SERIE
     , ana.MATRICOLA_1
     , ana.MATRICOLA_2
     , ana.UFFICIO_ORIG
     , ana.ANNO_ORIG
     , ana.ATTO_ORIG
     , ana.PARTE_ORIG
     , ana.SERIE_ORIG
     , ana.COD_PRO_ATTO_ORIG
     , ana.COD_COM_ATTO_ORIG
     , ana.ID_ATTO_ANSC_ORIG
--
     , to_char(null) flag_aggiornato_na0
     , empty_clob() composizione_completa_na0
--
     , m.descrizione
     , m.sigla_provincia
     , decode(ana.tipo_atto,
         1, cit.cod_rec,
         2, nas.cod_rec,
         4, mat.cod_rec,
        -4, uci.cod_rec,
         5, mor.cod_rec)
     , decode(ana.tipo_atto,
         1, cit.id_atto_ansc,
         2, nas.id_atto_ansc,
         4, mat.id_atto_ansc,
        -4, uci.id_atto_ansc,
         5, mor.id_atto_ansc)
     , decode(ana.tipo_atto,
         1, cit.numero_unico,
         2, nas.numero_unico,
         4, mat.numero_unico,
        -4, uci.numero_unico,
         5, mor.numero_unico)
     , decode(ana.tipo_atto,
         1, cit.natura,
         2, nas.natura,
         4, mat.natura,
        -4, uci.natura,
         5, mor.natura)
     , decode(ana.tipo_atto,
         1, cit.cognome_nome,
         2, nas.cognome_nome,
         5, mor.cognome_nome)
     , decode(ana.tipo_atto,
         1, cit.sesso,
         2, nas.sesso,
         5, mor.sesso)
     , decode(ana.tipo_atto,
         1, cit.data_nas,
         2, nas.data_nas,
         5, mor.data_nas)
     , decode(ana.tipo_atto,
         1, cit.cod_pro_nas,
         2, nas.cod_pro_nas,
         5, mor.cod_pro_nas)
     , decode(ana.tipo_atto,
         1, cit.cod_com_nas,
         2, nas.cod_com_nas,
         5, mor.cod_com_nas)
     , decode(ana.tipo_atto,
         1, cit.cod_pro_res,
         2, nas.cod_pro_res,
         5, mor.cod_pro_res)
     , decode(ana.tipo_atto,
         1, cit.cod_com_res,
         2, nas.cod_com_res,
         5, mor.cod_com_res)
     , decode(ana.tipo_atto,
         1, cit.cod_fiscale,
         2, nas.cod_fiscale,
         5, mor.cod_fiscale)
     , decode(ana.tipo_atto,
         1, cit.cf_calcolato,
         2, nas.cf_calcolato,
         5, mor.cf_calcolato)
     , decode(ana.tipo_atto,
         1, cit.nazionalita,
         2, nas.nazionalita,
         5, mor.nazionalita)
     , decode(ana.tipo_atto,
         4, mat.cognome_nome_m,
        -4, uci.cognome_nome_m)
     , decode(ana.tipo_atto,
         4, mat.sesso_m,
        -4, uci.sesso_m)
     , decode(ana.tipo_atto,
         4, mat.data_nas_m,
        -4, uci.data_nas_m)
     , decode(ana.tipo_atto,
         4, mat.cod_pro_nas_m,
        -4, uci.cod_pro_nas_m)
     , decode(ana.tipo_atto,
         4, mat.cod_com_nas_m,
        -4, uci.cod_com_nas_m)
     , decode(ana.tipo_atto,
         4, mat.cod_pro_res_m,
        -4, uci.cod_pro_res_m)
     , decode(ana.tipo_atto,
         4, mat.cod_com_res_m,
        -4, uci.cod_com_res_m)
     , decode(ana.tipo_atto,
         4, mat.cod_fiscale_m,
        -4, uci.cod_fiscale_m)
     , decode(ana.tipo_atto,
         4, mat.cf_calcolato_m,
        -4, uci.cf_calcolato_m)
     , decode(ana.tipo_atto,
         4, mat.nazionalita_m,
        -4, uci.nazionalita_m)
     , decode(ana.tipo_atto,
         4, mat.cognome_nome_f,
        -4, uci.cognome_nome_f)
     , decode(ana.tipo_atto,
         4, mat.sesso_f,
        -4, uci.sesso_f)
     , decode(ana.tipo_atto,
         4, mat.data_nas_f,
        -4, uci.data_nas_f)
     , decode(ana.tipo_atto,
         4, mat.cod_pro_nas_f,
        -4, uci.cod_pro_nas_f)
     , decode(ana.tipo_atto,
         4, mat.cod_com_nas_f,
        -4, uci.cod_com_nas_f)
     , decode(ana.tipo_atto,
         4, mat.cod_pro_res_f,
        -4, uci.cod_pro_res_f)
     , decode(ana.tipo_atto,
         4, mat.cod_com_res_f,
        -4, uci.cod_com_res_f)
     , decode(ana.tipo_atto,
         4, mat.cod_fiscale_f,
        -4, uci.cod_fiscale_f)
     , decode(ana.tipo_atto,
         4, mat.cf_calcolato_f,
        -4, uci.cf_calcolato_f)
     , decode(ana.tipo_atto,
         4, mat.nazionalita_f,
        -4, uci.nazionalita_f)
     , decode(ana.tipo_atto,
        1, cit.data_cit)
     , decode(ana.tipo_atto,
        1, to_number(cit.data_decorrenza))
     , decode(ana.tipo_atto,
         2, nas.paternita)
     , decode(ana.tipo_atto,
         2, nas.nazionalita_pd)
     , decode(ana.tipo_atto,
         2, nas.maternita)
     , decode(ana.tipo_atto,
         2, nas.nazionalita_md)
     , decode(ana.tipo_atto,
         2, nas.anno_nas)
     , decode(ana.tipo_atto,
         5, mor.data_mor)
     , decode(ana.tipo_atto,
         5, mor.cod_pro_mor)
     , decode(ana.tipo_atto,
         5, mor.cod_com_mor)
     , decode(ana.tipo_atto,
         5, mor.flag_gg_imprecisato)
     , decode(ana.tipo_atto,
         5, mor.flag_mm_imprecisato)
     , decode(ana.tipo_atto,
         5, mor.flag_aa_imprecisato)
     , decode(ana.tipo_atto,
         4, mat.data_mat,
        -4, uci.data_mat)
     , decode(ana.tipo_atto,
         4, mat.cod_pro_mat,
        -4, uci.cod_pro_mat)
     , decode(ana.tipo_atto,
         4, mat.cod_com_mat,
        -4, uci.cod_com_mat)
     , decode(ana.tipo_atto,
         4, mat.data_div,
        -4, uci.data_div)
     , decode(ana.tipo_atto,
        -4, uci.cambio_cognome_m)
     , decode(ana.tipo_atto,
        -4, uci.cognome_agg_m)
     , decode(ana.tipo_atto,
        -4, uci.cambio_cognome_f)
     , decode(ana.tipo_atto,
        -4, uci.cognome_agg_f)
  from (select cit.cod_rec
             , cit.id_atto
             , cit.id_atto_ansc
             , cit.numero_unico
             , cit.natura
             , cit.cognome_nome
             , cit.sesso
             , cit.data_nas
             , cit.cod_pro_nas
             , cit.cod_com_nas
             , cit.cod_pro_res
             , cit.cod_com_res
             , cit.cod_fiscale
             , cit.cf_calcolato
             , cit.nazionalita
             , cit.data_cit
             , to_char(cit.d_data_decorrenza,'j') data_decorrenza
          from civcit cit
         where cit.cod_rec = 0) cit
     , (select nas.cod_rec
             , nas.id_atto
             , nas.id_atto_ansc
             , nas.numero_unico
             , nas.natura
             , nas.cognome_nome
             , nas.sesso
             , nas.data_nas		-- valorizza anche DATA_ULT_EVE
             , nas.cod_pro_nas
             , nas.cod_com_nas
             , nas.cod_pro_res
             , nas.cod_com_res
             , nas.cod_fiscale
             , nas.cf_calcolato
             , nas.nazionalita
             , nas.paternita
             , nas.nazionalita_pd
             , nas.maternita
             , nas.nazionalita_md
             , nas.anno_nas
          from civnas nas
         where nas.cod_rec = 0) nas
     , (select mat.cod_rec
             , mat.id_atto
             , mat.id_atto_ansc
             , mat.numero_unico
             , mat.natura
             , mat.cognome_nome_m
             , 'M' sesso_m
             , mat.data_nas_m
             , mat.cod_pro_nas_m
             , mat.cod_com_nas_m
             , mat.cod_pro_res_m
             , mat.cod_com_res_m
             , mat.cod_fiscale_m
             , mat.cf_calcolato_m
             , mat.nazionalita_m
             , mat.cognome_nome_f
             , 'F' sesso_f
             , mat.data_nas_f
             , mat.cod_pro_nas_f
             , mat.cod_com_nas_f
             , mat.cod_pro_res_f
             , mat.cod_com_res_f
             , mat.cod_fiscale_f
             , mat.cf_calcolato_f
             , mat.nazionalita_f
             , mat.data_mat
             , mat.cod_pro_mat
             , mat.cod_com_mat
             , nvl(dpa.accordo_data,mat.data_mat) data_div	-- valorizza DATA_DIV_ANA
          from civdpa dpa
             , civmat mat
         where dpa.id_atto (+) = mat.id_atto
           and mat.cod_rec = 0) mat
     , (select uci.cod_rec
             , uci.id_atto
             , uci.id_atto_ansc
             , uci.numero_unico
             , uci.natura
             , uci.cognome_nome_m
             , uci.sesso_m
             , uci.data_nas_m
             , uci.cod_pro_nas_m
             , uci.cod_com_nas_m
             , uci.cod_pro_res_m
             , uci.cod_com_res_m
             , uci.cod_fiscale_m
             , uci.cf_calcolato_m
             , uci.nazionalita_m
             , uci.cognome_nome_f
             , uci.sesso_f
             , uci.data_nas_f
             , uci.cod_pro_nas_f
             , uci.cod_com_nas_f
             , uci.cod_pro_res_f
             , uci.cod_com_res_f
             , uci.cod_fiscale_f
             , uci.cf_calcolato_f
             , uci.nazionalita_f
             , uci.data_mat
             , uci.cod_pro_mat
             , uci.cod_com_mat
             , nvl(dpa.accordo_data,uci.data_mat) data_div	-- valorizza DATA_DIV_ANA
             , uci.cambio_cognome_m
             , uci.cognome_agg_m
             , uci.cambio_cognome_f
             , uci.cognome_agg_f
          from civdpa dpa
             , civuci uci
         where dpa.id_atto (+) = uci.id_atto
           and uci.natura != 'V'
           and uci.cod_rec = 0) uci
     , (select mor.cod_rec
             , mor.id_atto
             , mor.id_atto_ansc
             , mor.numero_unico
             , mor.natura
             , mor.cognome_nome
             , mor.sesso
             , mor.data_nas
             , mor.cod_pro_nas
             , mor.cod_com_nas
             , mor.cod_pro_res
             , mor.cod_com_res
             , mor.cod_fiscale
             , mor.cf_calcolato
             , mor.nazionalita
             , mor.data_mor
             , mor.cod_pro_mor
             , mor.cod_com_mor
             , mor.flag_gg_imprecisato
             , mor.flag_mm_imprecisato
             , mor.flag_aa_imprecisato
          from civmor mor
         where mor.cod_rec = 0) mor
     , arccom m
     , civana ana
 where (m.cod_provincia, m.cod_comune) = (select pro_cliente, com_cliente from menuditta)
   and cit.id_atto (+) = ana.id_atto
   and nas.id_atto (+) = ana.id_atto
   and mat.id_atto (+) = ana.id_atto
   and uci.id_atto (+) = ana.id_atto
   and mor.id_atto (+) = ana.id_atto
   and nvl(f_valore_inp('ECIV_ANSC',1,1,'X','S'),'N') = 'N'
UNION ALL
select
-- ID
       to_number(na0.anno||lpad(nvl(na0.idNotifica,rownum),10,'0'))
-- ID_ATTO
     , na0.idAnsc
-- TIPO_ATTO
-- idTipoEvento: 1 - 'Nascita', 2 - 'Morte', 3 - 'Matrimonio', 4 - 'Unione Civile', 5 - 'Cittadinanza'
     , decode(na0.idTipoEvento, 1, 2, 2, 5, 3, 4, 4, -4, 5, 1)
-- UFFICIO
     , decode(na0.idTipoEvento, 1, nas.ufficio, 2, mor.ufficio, 3, mat.ufficio, 4, uci.ufficio, 5, cit.ufficio)
-- ANNO
--     , nvl(decode(na0.idTipoEvento, 1, nas.anno, 2, mor.anno, 3, mat.anno, 4, uci.anno, 5, cit.anno), na0.anno)
     , decode(na0.idTipoEvento, 1, nas.anno, 2, mor.anno, 3, mat.anno, 4, uci.anno, 5, cit.anno)
-- ATTO
--     , nvl(decode(na0.idTipoEvento, 1, nas.atto, 2, mor.atto, 3, mat.atto, 4, uci.atto, 5, cit.atto), na0.numeroComunale)
     , decode(na0.idTipoEvento, 1, nas.atto, 2, mor.atto, 3, mat.atto, 4, uci.atto, 5, cit.atto)
-- PARTE
     , decode(na0.idTipoEvento, 1, nas.parte, 2, mor.parte, 3, mat.parte, 4, uci.parte, 5, to_number(null))
-- SERIE
     , decode(na0.idTipoEvento, 1, nas.serie, 2, mor.serie, 3, mat.serie, 4, uci.serie, 5, to_char(null))
-- MATRICOLA_1
-- idTipoEvento: 1 - 'Nascita', 2 - 'Morte', 3 - 'Matrimonio', 4 - 'Unione Civile', 5 - 'Cittadinanza'
     , decode(na0.idTipoEvento,
         1, f_ADS_matricola(na0.idSchedaSoggettoAnpr_PD, na0.codFiscale_PD, na0.cognome_PD, na0.nome_1, na0.sesso_PD, na0.dataNascita_PD),
            f_ADS_matricola(na0.idSchedaSoggettoAnpr_1, na0.codFiscale_1, na0.cognome_1, na0.nome_1, na0.sesso_1, na0.dataNascita_1))
-- MATRICOLA_2
-- idTipoEvento: 1 - 'Nascita', 2 - 'Morte', 3 - 'Matrimonio', 4 - 'Unione Civile', 5 - 'Cittadinanza'
     , decode(na0.idTipoEvento,
         1, f_ADS_matricola(na0.idSchedaSoggettoAnpr_MD, na0.codFiscale_MD, na0.cognome_MD, na0.nome_MD, na0.sesso_MD, na0.dataNascita_MD),
         2, f_ADS_matricola(na0.idSchedaSoggettoAnpr_CN, na0.codFiscale_CN, na0.cognome_CN, na0.nome_CN, na0.sesso_CN, na0.dataNascita_CN),
            f_ADS_matricola(na0.idSchedaSoggettoAnpr_2, na0.codFiscale_2, na0.cognome_2, na0.nome_2, na0.sesso_2, na0.dataNascita_2))
-- UFFICIO_ORIG
     , to_number(null)
-- ANNO_ORIG
     , to_number(null)
-- ATTO_ORIG
     , to_number(null)
-- PARTE_ORIG
     , to_number(null)
-- SERIE_ORIG
     , to_char(null)
-- COD_PRO_ATTO_ORIG
     , to_number(null)
-- COD_COM_ATTO_ORIG
     , to_number(null)
-- ID_ATTO_ANSC_ORIG
     , to_char(null)
-- FLAG_AGGIORNATO_NA0
     , na0.flag_aggiornato
-- COMPOSIZONE_COMPLETA_NA0
     , na0.composizioneCompleta
-- DES_COM_ATTO
     , na0.REG_nomeComune
-- SIGLA_PRO_ATTO
     , na0.REG_siglaProvinciaIstat
-- COD_REC
     , 0
-- ID_ATTO_ANSC
     , na0.idAnsc
-- NUMERO_UNICO
     , na0.numeroComunale
-- NATURA
-- idTipoEvento: 1 - 'Nascita', 2 - 'Morte', 3 - 'Matrimonio', 4 - 'Unione Civile', 5 - 'Cittadinanza'
     , decode(na0.idTipoEvento,
         1, nvl(nas.natura, 'O'),
         2, nvl(mor.natura, 'O'),
         3, nvl(mat.natura, decode(na0.idTipoNotifica,'SC10','D','O')),
         4, nvl(uci.natura, decode(na0.idTipoNotifica,'SC12','D','O')),
         5, nvl(cit.natura, 'A'))
-- COGNOME_NOME
     , na0.cognome_1||'/'||na0.nome_1
-- SESSO
     , na0.sesso_1
-- DATA_NAS
     , f_ADS_data(na0.dataNascita_1)
-- COD_PRO_NAS
     , to_number(substr(f_ADS_codice_comune(na0.NAS_codiceIstat_1, na0.NAS_nomeComune_1, na0.NAS_siglaProvinciaIstat_1, na0.NAS_codiceStato_1, na0.NAS_descrizioneLocalita_1, na0.dataNascita_1),1,3))
-- COD_COM_NAS
     , to_number(substr(f_ADS_codice_comune(na0.NAS_codiceIstat_1, na0.NAS_nomeComune_1, na0.NAS_siglaProvinciaIstat_1, na0.NAS_codiceStato_1, na0.NAS_descrizioneLocalita_1, na0.dataNascita_1),4,3))
-- COD_PRO_RES
     , to_number(substr(f_ADS_codice_comune(na0.RES_codiceIstat_1, na0.RES_nomeComune_1, na0.RES_siglaProvinciaIstat_1, na0.RES_codiceStato_1, na0.RES_descrizioneLocalita_1, na0.dataNascita_1),1,3))
-- COD_COM_RES
     , to_number(substr(f_ADS_codice_comune(na0.RES_codiceIstat_1, na0.RES_nomeComune_1, na0.RES_siglaProvinciaIstat_1, na0.RES_codiceStato_1, na0.RES_descrizioneLocalita_1, na0.dataNascita_1),4,3))
-- COD_FISCALE
     , na0.codFiscale_1
-- CF_CALCOLATO
     , to_char(null)
-- NAZIONALITA
     , f_ADS_nazionalita(na0.NAZ_codiceStato_1)
-- COGNOME_NOME_M
     , na0.cognome_1||'/'||na0.nome_1
-- SESSO_M
     , na0.sesso_1
-- DATA_NAS_M
     , f_ADS_data(na0.dataNascita_1)
-- COD_PRO_NAS_M
     , to_number(substr(f_ADS_codice_comune(na0.NAS_codiceIstat_1, na0.NAS_nomeComune_1, na0.NAS_siglaProvinciaIstat_1, na0.NAS_codiceStato_1, na0.NAS_descrizioneLocalita_1, na0.dataNascita_1),1,3))
-- COD_COM_NAS_M
     , to_number(substr(f_ADS_codice_comune(na0.NAS_codiceIstat_1, na0.NAS_nomeComune_1, na0.NAS_siglaProvinciaIstat_1, na0.NAS_codiceStato_1, na0.NAS_descrizioneLocalita_1, na0.dataNascita_1),4,3))
-- COD_PRO_RES_M
     , to_number(substr(f_ADS_codice_comune(na0.RES_codiceIstat_1, na0.RES_nomeComune_1, na0.RES_siglaProvinciaIstat_1, na0.RES_codiceStato_1, na0.RES_descrizioneLocalita_1, na0.dataNascita_1),1,3))
-- COD_COM_RES_M
     , to_number(substr(f_ADS_codice_comune(na0.RES_codiceIstat_1, na0.RES_nomeComune_1, na0.RES_siglaProvinciaIstat_1, na0.RES_codiceStato_1, na0.RES_descrizioneLocalita_1, na0.dataNascita_1),4,3))
-- COD_FISCALE_M
     , na0.codFiscale_1
-- CF_CALCOLATO_M
     , to_char(null)
-- NAZIONALITA_M
     , f_ADS_nazionalita(na0.NAZ_codiceStato_1)
-- COGNOME_NOME_F
     , rtrim(na0.cognome_2||'/'||na0.nome_2,'/')
-- SESSO_F
     , na0.sesso_2
-- DATA_NAS_F
     , f_ADS_data(na0.dataNascita_2)
-- COD_PRO_NAS_F
     , to_number(substr(f_ADS_codice_comune(na0.NAS_codiceIstat_2, na0.NAS_nomeComune_2, na0.NAS_siglaProvinciaIstat_2, na0.NAS_codiceStato_2, na0.NAS_descrizioneLocalita_2, na0.dataNascita_2),1,3))
-- COD_COM_NAS_F
     , to_number(substr(f_ADS_codice_comune(na0.NAS_codiceIstat_2, na0.NAS_nomeComune_2, na0.NAS_siglaProvinciaIstat_2, na0.NAS_codiceStato_2, na0.NAS_descrizioneLocalita_2, na0.dataNascita_2),4,3))
-- COD_PRO_RES_F
     , to_number(substr(f_ADS_codice_comune(na0.RES_codiceIstat_2, na0.RES_nomeComune_2, na0.RES_siglaProvinciaIstat_2, na0.RES_codiceStato_2, na0.RES_descrizioneLocalita_2, na0.dataNascita_2),1,3))
-- COD_COM_RES_F
     , to_number(substr(f_ADS_codice_comune(na0.RES_codiceIstat_2, na0.RES_nomeComune_2, na0.RES_siglaProvinciaIstat_2, na0.RES_codiceStato_2, na0.RES_descrizioneLocalita_2, na0.dataNascita_2),4,3))
-- COD_FISCALE_F
     , na0.codFiscale_2
-- CF_CALCOLATO_F
     , to_char(null)
-- NAZIONALITA_F
     , f_ADS_nazionalita(na0.NAZ_codiceStato_2)
-- DATA_CIT
     , decode(na0.idTipoEvento,
         5, f_ADS_data(na0.dataValidita))
-- DATA_DECORRENZA
     , decode(na0.idTipoEvento,
         5, f_ADS_data(na0.dataValidita))
-- PATERNITA
     , decode(na0.idTipoEvento,
         1, na0.cognome_PD||'/'||na0.nome_PD)
-- NAZIONALITA_PD
     , decode(na0.idTipoEvento,
         1, f_ADS_nazionalita(na0.NAZ_codiceStato_PD))
-- MATERNITA
     , decode(na0.idTipoEvento,
         1, na0.cognome_MD||'/'||na0.nome_MD)
-- NAZIONALITA_MD
     , decode(na0.idTipoEvento,
         1, f_ADS_nazionalita(na0.NAZ_codiceStato_MD))
-- ANNO_NAS
-- idTipoEvento: 1 - 'Nascita', 2 - 'Morte', 3 - 'Matrimonio', 4 - 'Unione Civile', 5 - 'Cittadinanza'
     , decode(na0.idTipoEvento,
         1, decode(substr(na0.dataNascita_1,6,5),'00-00','S'))
-- DATA_MOR
     , f_ADS_data(na0.MOR_dataEvento)
-- COD_PRO_MOR
     , to_number(substr(f_ADS_codice_comune(na0.MOR_codiceIstat, na0.MOR_nomeComune, na0.MOR_siglaProvinciaIstat, na0.MOR_codiceStato, na0.MOR_descrizioneLocalita, na0.MOR_dataEvento),1,3))
-- COD_COM_MOR
     , to_number(substr(f_ADS_codice_comune(na0.MOR_codiceIstat, na0.MOR_nomeComune, na0.MOR_siglaProvinciaIstat, na0.MOR_codiceStato, na0.MOR_descrizioneLocalita, na0.MOR_dataEvento),4,3))
-- FLAG_GG_IMPRECISATO
     , to_char(null)
-- FLAG_MM_IMPRECISATO
     , to_char(null)
-- FLAG_AA_IMPRECISATO
     , to_char(null)
-- DATA_MAT
     ,  decode(na0.idTipoEvento,
         3, decode(na0.idTipoNotifica,'SC10',
              decode(na0.TRA_dataTrascrizione,'',f_ADS_data(na0.dataFormazioneAtto),f_ADS_data(na0.TRA_dataTrascrizione)),
              f_ADS_data(na0.MAT_dataEvento)),
         4, decode(na0.idTipoNotifica,'SC12',
              decode(na0.TRA_dataTrascrizione,'',f_ADS_data(na0.dataFormazioneAtto),f_ADS_data(na0.TRA_dataTrascrizione)),
              f_ADS_data(na0.UCI_dataEvento)))
-- COD_PRO_MAT
-- idTipoEvento: 1 - 'Nascita', 2 - 'Morte', 3 - 'Matrimonio', 4 - 'Unione Civile', 5 - 'Cittadinanza'
     , decode(na0.idTipoEvento,
         3, decode(na0.idTipoNotifica,'SC10',
              decode(na0.TRA_nomeEnte, '',
                to_number(substr(f_ADS_codice_comune(na0.REG_codiceIstat, na0.REG_nomeComune, na0.REG_siglaProvinciaIstat, '', '', na0.dataFormazioneAtto),1,3)),
                to_number(substr(f_ADS_codice_comune(na0.TRA_codiceIstat, na0.TRA_nomeComune, na0.TRA_siglaProvinciaIstat, na0.TRA_codiceStato, na0.TRA_descrizioneLocalita, na0.TRA_dataTrascrizione),1,3))),
              to_number(substr(f_ADS_codice_comune(na0.MAT_codiceIstat, na0.MAT_nomeComune, na0.MAT_siglaProvinciaIstat, na0.MAT_codiceStato, na0.MAT_descrizioneLocalita, na0.MAT_dataEvento),1,3))),
         4, decode(na0.idTipoNotifica,'SC12',
              decode(na0.TRA_nomeEnte, '',
                to_number(substr(f_ADS_codice_comune(na0.REG_codiceIstat, na0.REG_nomeComune, na0.REG_siglaProvinciaIstat, '', '', na0.dataFormazioneAtto),1,3)),
                to_number(substr(f_ADS_codice_comune(na0.TRA_codiceIstat, na0.TRA_nomeComune, na0.TRA_siglaProvinciaIstat, na0.TRA_codiceStato, na0.TRA_descrizioneLocalita, na0.TRA_dataTrascrizione),1,3))),
              to_number(substr(f_ADS_codice_comune(na0.UCI_codiceIstat, na0.UCI_nomeComune, na0.UCI_siglaProvinciaIstat, na0.UCI_codiceStato, na0.UCI_descrizioneLocalita, na0.UCI_dataEvento),1,3))))
-- COD_COM_MAT
-- idTipoEvento: 1 - 'Nascita', 2 - 'Morte', 3 - 'Matrimonio', 4 - 'Unione Civile', 5 - 'Cittadinanza'
     ,  decode(na0.idTipoEvento,
         3, decode(na0.idTipoNotifica,'SC10',
              decode(na0.TRA_nomeEnte, '',
                to_number(substr(f_ADS_codice_comune(na0.REG_codiceIstat, na0.REG_nomeComune, na0.REG_siglaProvinciaIstat, '', '', na0.dataFormazioneAtto),4,3)),
                to_number(substr(f_ADS_codice_comune(na0.TRA_codiceIstat, na0.TRA_nomeComune, na0.TRA_siglaProvinciaIstat, na0.TRA_codiceStato, na0.TRA_descrizioneLocalita, na0.TRA_dataTrascrizione),4,3))),
              to_number(substr(f_ADS_codice_comune(na0.MAT_codiceIstat, na0.MAT_nomeComune, na0.MAT_siglaProvinciaIstat, na0.MAT_codiceStato, na0.MAT_descrizioneLocalita, na0.MAT_dataEvento),4,3))),
         4, decode(na0.idTipoNotifica,'SC12',
              decode(na0.TRA_nomeEnte, '',
                to_number(substr(f_ADS_codice_comune(na0.REG_codiceIstat, na0.REG_nomeComune, na0.REG_siglaProvinciaIstat, '', '', na0.dataFormazioneAtto),4,3)),
                to_number(substr(f_ADS_codice_comune(na0.TRA_codiceIstat, na0.TRA_nomeComune, na0.TRA_siglaProvinciaIstat, na0.TRA_codiceStato, na0.TRA_descrizioneLocalita, na0.TRA_dataTrascrizione),4,3))),
              to_number(substr(f_ADS_codice_comune(na0.UCI_codiceIstat, na0.UCI_nomeComune, na0.UCI_siglaProvinciaIstat, na0.UCI_codiceStato, na0.UCI_descrizioneLocalita, na0.UCI_dataEvento),4,3))))
-- DATA_DIV
     , decode(na0.SEP_dataTrascrizione_ACC, '',
         decode(na0.SCI_dataEvento,'', to_number(null),
           f_ADS_data(na0.SCI_dataEvento)),
         f_ADS_data(na0.SEP_dataTrascrizione_ACC))
-- CAMBIO_COGNOME_M
     , to_char(null)
-- COGNOME_AGG_M
     , to_char(null)
-- CAMBIO_COGNOME_F
     , to_char(null)
-- COGNOME_AGG_F
     , to_char(null)
  from menuditta m
     , civcit cit
     , civnas nas
     , civmat mat
     , civuci uci
     , civmor mor
     , anpna0 na0
 where cit.id_atto_ansc (+) = na0.idAnsc
   and nas.id_atto_ansc (+) = na0.idAnsc
   and mat.id_atto_ansc (+) = na0.idAnsc
   and uci.id_atto_ansc (+) = na0.idAnsc
   and mor.id_atto_ansc (+) = na0.idAnsc
   and ((na0.codMittente != lpad(m.pro_cliente,3,'0')||lpad(m.com_cliente,3,'0')
         and nvl(f_valore_inp('ECIV_ANSC',1,1,'X','S'),'N') = 'N')
        or nvl(f_valore_inp('ECIV_ANSC',1,1,'X','S'),'N') = 'S')
/
COMMENT ON TABLE civana_totale IS 'Stato Civile - Interfaccia Stato Civile/Anagrafe (view)'
/
