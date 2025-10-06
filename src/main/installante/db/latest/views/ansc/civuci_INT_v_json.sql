--liquibase formatted sql
--changeset ftravaglini:202306191740 runAlways:true runOnChange:true stripComments:false
create or replace view civuci_INT_v_json as
select 1 w_ord
     , uci.id
     , uci.id_atto
     , uci.ufficio
     , uci.anno
     , uci.parte
     , uci.serie
     , uci.atto
-- coniuge1
     , uci.cod_fiscale_m codiceFiscale
     , nvl(occ.cognome,uci.cognome_m) cognome
     , nvl(occ.nome,uci.nome_m) nome
     , uci.sesso_m sesso
     , decode(uci.sesso_m, 'F', 'femminile', 'M', 'maschile') descrizioneSesso
     , to_char(uci.d_data_nas_m,'yyyy-mm-dd') dataNascita
     , f_ANSC_id_comune_al(uci.cod_pro_nas_m,uci.cod_com_nas_m,uci.d_data_nas_m) idComuneNascita
     , f_ANSC_comune_italiano(uci.cod_pro_nas_m,uci.cod_com_nas_m,uci.d_data_nas_m) nomeComuneNascita
     , f_ANSC_id_provincia_al(uci.cod_pro_nas_m,uci.cod_com_nas_m,uci.d_data_nas_m) idProvinciaNascita
     , f_ANSC_provincia_al(uci.cod_pro_nas_m,uci.cod_com_nas_m,uci.d_data_nas_m) siglaProvinciaNascita
     , f_ANSC_id_stato_al(uci.cod_pro_nas_m,uci.cod_com_nas_m,uci.d_data_nas_m) idStatoNascita
     , f_ANSC_stato_al(uci.cod_pro_nas_m,uci.cod_com_nas_m,uci.d_data_nas_m) nomeStatoNascita
     , f_ANSC_comune_estero(uci.cod_pro_nas_m,uci.cod_com_nas_m,uci.d_data_nas_m) comuneEsteroNascita
     , f_ANSC_id_comune_al(uci.cod_pro_res_m,uci.cod_com_res_m,uci.d_data_mat) idComuneResidenza
     , f_ANSC_comune_italiano(uci.cod_pro_res_m,uci.cod_com_res_m,uci.d_data_mat) nomeComuneResidenza
     , f_ANSC_id_provincia_al(uci.cod_pro_res_m,uci.cod_com_res_m,uci.d_data_mat) idProvinciaResidenza
     , f_ANSC_provincia_al(uci.cod_pro_res_m,uci.cod_com_res_m,uci.d_data_mat) siglaProvinciaResidenza
     , f_ANSC_id_stato_al(uci.cod_pro_res_m,uci.cod_com_res_m,uci.d_data_mat) idStatoResidenza
     , f_ANSC_stato_al(uci.cod_pro_res_m,uci.cod_com_res_m,uci.d_data_mat) nomeStatoResidenza
     , f_ANSC_comune_estero(uci.cod_pro_res_m,uci.cod_com_res_m,uci.d_data_mat) comuneEsteroResidenza
     , f_ANSC_id_comune_aire(nvl(ana.matricola_1,ana_r.matricola_1),uci.cod_pro_res_m,uci.cod_com_res_m) idComuneAIRE
     , f_ANSC_comune_aire(nvl(ana.matricola_1,ana_r.matricola_1),uci.cod_pro_res_m,uci.cod_com_res_m) nomeComuneAIRE
     , f_ANSC_id_provincia_aire(nvl(ana.matricola_1,ana_r.matricola_1),uci.cod_pro_res_m,uci.cod_com_res_m) idProvinciaAIRE
     , f_ANSC_provincia_aire(nvl(ana.matricola_1,ana_r.matricola_1),uci.cod_pro_res_m,uci.cod_com_res_m) siglaProvinciaAIRE
--
     , decode(uci.sesso_m, 'F', 'a', 'M', 'o') genere
     , f_ANSC_id_nazionalita(dci_m.ist_ci) idNazionalita
     , f_get_descrizione_DCI(uci.nazionalita_m, '') nazionalita
     , f_ANSC_comprensione(uci.comprensione_m) comprensione
     , f_ANSC_flag_dichiarante(dpa.tipo_dichiarante,'C1') flagDichiarante
     , f_ANSC_flag_firmatario(dpa.tipo_firmatario,'C1') flagFirmatario
     , f_ANSC_flag_comparente(dpa.tipo_comparente,'C1') flagComparente
-- ANSC
     , uci.id_atto_ansc idAttoAnsc
     , uci.id_evento_ansc idEventoAnsc
     , uci.id_soggetto_ansc_m idSoggettoAnsc
     , f_ANSC_id_soggetto_anpr(nvl(ana.matricola_1,ana_r.matricola_1),uci.cod_fiscale_m) idSoggettoAnpr
     , f_ANSC_id_unico_anpr(nvl(ana.matricola_1,ana_r.matricola_1),uci.cod_fiscale_m) idUnicoAnpr
  from civana ana
     , civana_recupero ana_r
     , anadci dci_m
     , civocc occ
     , civdpa dpa
     , civuci uci
 where ana.id_atto                   (+) = uci.id_atto
   and ana_r.id_atto                 (+) = uci.id_atto
   and dci_m.cod_ci                  (+) = uci.nazionalita_m
   and occ.id_atto                   (+) = uci.id_atto
   and dpa.id_atto                   (+) = uci.id_atto
   and uci.cod_rec                 in (0,3)
UNION
select 2 w_ord
     , uci.id
     , uci.id_atto
     , uci.ufficio
     , uci.anno
     , uci.parte
     , uci.serie
     , uci.atto
-- coniuge2
     , uci.cod_fiscale_f codiceFiscale
     , nvl(occ.cognome_cn,uci.cognome_f) cognome
     , nvl(occ.nome_cn,uci.nome_f) nome
     , uci.sesso_f sesso
     , decode(uci.sesso_f, 'F', 'femminile', 'M', 'maschile') descrizioneSesso
     , to_char(uci.d_data_nas_f,'yyyy-mm-dd') dataNascita
     , f_ANSC_id_comune_al(uci.cod_pro_nas_f,uci.cod_com_nas_f,uci.d_data_nas_f) idComuneNascita
     , f_ANSC_comune_italiano(uci.cod_pro_nas_f,uci.cod_com_nas_f,uci.d_data_nas_f) nomeComuneNascita
     , f_ANSC_id_provincia_al(uci.cod_pro_nas_f,uci.cod_com_nas_f,uci.d_data_nas_f) idProvinciaNascita
     , f_ANSC_provincia_al(uci.cod_pro_nas_f,uci.cod_com_nas_f,uci.d_data_nas_f) siglaProvinciaNascita
     , f_ANSC_id_stato_al(uci.cod_pro_nas_f,uci.cod_com_nas_f,uci.d_data_nas_f) idStatoNascita
     , f_ANSC_stato_al(uci.cod_pro_nas_f,uci.cod_com_nas_f,uci.d_data_nas_f) nomeStatoNascita
     , f_ANSC_comune_estero(uci.cod_pro_nas_f,uci.cod_com_nas_f,uci.d_data_nas_f) comuneEsteroNascita
     , f_ANSC_id_comune_al(uci.cod_pro_res_f,uci.cod_com_res_f,uci.d_data_mat) idComuneResidenza
     , f_ANSC_comune_italiano(uci.cod_pro_res_f,uci.cod_com_res_f,uci.d_data_mat) nomeComuneResidenza
     , f_ANSC_id_provincia_al(uci.cod_pro_res_f,uci.cod_com_res_f,uci.d_data_mat) idProvinciaResidenza
     , f_ANSC_provincia_al(uci.cod_pro_res_f,uci.cod_com_res_f,uci.d_data_mat) siglaProvinciaResidenza
     , f_ANSC_id_stato_al(uci.cod_pro_res_f,uci.cod_com_res_f,uci.d_data_mat) idStatoResidenza
     , f_ANSC_stato_al(uci.cod_pro_res_f,uci.cod_com_res_f,uci.d_data_mat) nomeStatoResidenza
     , f_ANSC_comune_estero(uci.cod_pro_res_f,uci.cod_com_res_f,uci.d_data_mat) comuneEsteroResidenza
     , f_ANSC_id_comune_aire(nvl(ana.matricola_2,ana_r.matricola_2),uci.cod_pro_res_f,uci.cod_com_res_f) idComuneAIRE
     , f_ANSC_comune_aire(nvl(ana.matricola_2,ana_r.matricola_2),uci.cod_pro_res_f,uci.cod_com_res_f) nomeComuneAIRE
     , f_ANSC_id_provincia_aire(nvl(ana.matricola_2,ana_r.matricola_2),uci.cod_pro_res_f,uci.cod_com_res_f) idProvinciaAIRE
     , f_ANSC_provincia_aire(nvl(ana.matricola_2,ana_r.matricola_2),uci.cod_pro_res_f,uci.cod_com_res_f) siglaProvinciaAIRE
--
     , decode(uci.sesso_f, 'F', 'a', 'M', 'o') genere
     , f_ANSC_id_nazionalita(dci_f.ist_ci) idNazionalita
     , f_get_descrizione_DCI(uci.nazionalita_f, '') nazionalita
     , f_ANSC_comprensione(uci.comprensione_f) comprensione
     , f_ANSC_flag_dichiarante(dpa.tipo_dichiarante,'C2') flagDichiarante
     , f_ANSC_flag_firmatario(dpa.tipo_firmatario,'C2') flagFirmatario
     , f_ANSC_flag_comparente(dpa.tipo_comparente,'C2') flagComparente
-- ANSC
     , uci.id_atto_ansc idAttoAnsc
     , uci.id_evento_ansc idEventoAnsc
     , uci.id_soggetto_ansc_f idSoggettoAnsc
     , f_ANSC_id_soggetto_anpr(nvl(ana.matricola_2,ana_r.matricola_2),uci.cod_fiscale_f) idSoggettoAnpr
     , f_ANSC_id_unico_anpr(nvl(ana.matricola_2,ana_r.matricola_2),uci.cod_fiscale_f) idUnicoAnpr
  from civana ana
     , civana_recupero ana_r
     , anadci dci_f
     , civocc occ
     , civdpa dpa
     , civuci uci
 where ana.id_atto                   (+) = uci.id_atto
   and ana_r.id_atto                 (+) = uci.id_atto
   and dci_f.cod_ci                  (+) = uci.nazionalita_f
   and occ.id_atto                   (+) = uci.id_atto
   and dpa.id_atto                   (+) = uci.id_atto
   and uci.cod_rec                 in (0,3)
 order by 1
/
comment on table CIVUCI_INT_V_JSON is 'ANSC - Atti di Unione Civile per request JSON - INTESTATARI (view)'
/

