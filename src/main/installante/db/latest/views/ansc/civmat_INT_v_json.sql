--liquibase formatted sql
--changeset ftravaglini:202306131526 runAlways:true runOnChange:true stripComments:false
create or replace view civmat_INT_v_json as
select 1 w_ord
     , mat.id
     , mat.id_atto
     , mat.ufficio
     , mat.anno
     , mat.parte
     , mat.serie
     , mat.atto
-- sposo
     , mat.cod_fiscale_m codiceFiscale
     , nvl(occ.cognome,mat.cognome_m) cognome
     , nvl(occ.nome,mat.nome_m) nome
     , 'M' sesso
     , 'maschile' descrizioneSesso
     , to_char(mat.d_data_nas_m,'yyyy-mm-dd') dataNascita
     , f_ANSC_id_comune_al(mat.cod_pro_nas_m,mat.cod_com_nas_m,mat.d_data_nas_m) idComuneNascita
     , f_ANSC_comune_italiano(mat.cod_pro_nas_m,mat.cod_com_nas_m,mat.d_data_nas_m) nomeComuneNascita
     , f_ANSC_id_provincia_al(mat.cod_pro_nas_m,mat.cod_com_nas_m,mat.d_data_nas_m) idProvinciaNascita
     , f_ANSC_provincia_al(mat.cod_pro_nas_m,mat.cod_com_nas_m,mat.d_data_nas_m) siglaProvinciaNascita
     , f_ANSC_id_stato_al(mat.cod_pro_nas_m,mat.cod_com_nas_m,mat.d_data_nas_m) idStatoNascita
     , f_ANSC_stato_al(mat.cod_pro_nas_m,mat.cod_com_nas_m,mat.d_data_nas_m) nomeStatoNascita
     , f_ANSC_comune_estero(mat.cod_pro_nas_m,mat.cod_com_nas_m,mat.d_data_nas_m) comuneEsteroNascita
     , f_ANSC_id_comune_al(mat.cod_pro_res_m,mat.cod_com_res_m,mat.d_data_mat) idComuneResidenza
     , f_ANSC_comune_italiano(mat.cod_pro_res_m,mat.cod_com_res_m,mat.d_data_mat) nomeComuneResidenza
     , f_ANSC_id_provincia_al(mat.cod_pro_res_m,mat.cod_com_res_m,mat.d_data_mat) idProvinciaResidenza
     , f_ANSC_provincia_al(mat.cod_pro_res_m,mat.cod_com_res_m,mat.d_data_mat) siglaProvinciaResidenza
     , f_ANSC_id_stato_al(mat.cod_pro_res_m,mat.cod_com_res_m,mat.d_data_mat) idStatoResidenza
     , f_ANSC_stato_al(mat.cod_pro_res_m,mat.cod_com_res_m,mat.d_data_mat) nomeStatoResidenza
     , f_ANSC_comune_estero(mat.cod_pro_res_m,mat.cod_com_res_m,mat.d_data_mat) comuneEsteroResidenza
     , f_ANSC_id_comune_aire(nvl(ana.matricola_1,ana_r.matricola_1),mat.cod_pro_res_m,mat.cod_com_res_m) idComuneAIRE
     , f_ANSC_comune_aire(nvl(ana.matricola_1,ana_r.matricola_1),mat.cod_pro_res_m,mat.cod_com_res_m) nomeComuneAIRE
     , f_ANSC_id_provincia_aire(nvl(ana.matricola_1,ana_r.matricola_1),mat.cod_pro_res_m,mat.cod_com_res_m) idProvinciaAIRE
     , f_ANSC_provincia_aire(nvl(ana.matricola_1,ana_r.matricola_1),mat.cod_pro_res_m,mat.cod_com_res_m) siglaProvinciaAIRE
--
     , 'o' genere
     , f_ANSC_id_nazionalita(dci_m.ist_ci) idNazionalita
     , f_get_descrizione_DCI(mat.nazionalita_m,'') nazionalita
     , f_ANSC_comprensione(mat.comprensione_m) comprensione
     , decode(cta.sigla, 
         'RCN', 'true', 
         'AVV', 'false', 
         f_ANSC_flag_dichiarante(dpa.tipo_dichiarante,'SO')) flagDichiarante
     , decode(cta.sigla, 
         'RCN', 'true', 
         'AVV', 'false', 
         f_ANSC_flag_firmatario(dpa.tipo_firmatario,'SO')) flagFirmatario
     , decode(cta.sigla, 
         'RCN', 'true', 
         'AVV', 'false', 
         f_ANSC_flag_comparente(dpa.tipo_comparente,'SO')) flagComparente
-- ANSC
     , mat.id_atto_ansc idAttoAnsc
     , mat.id_evento_ansc idEventoAnsc
     , mat.id_soggetto_ansc_m idSoggettoAnsc
     , f_ANSC_id_soggetto_anpr(nvl(ana.matricola_1,ana_r.matricola_1),mat.cod_fiscale_m) idSoggettoAnpr
     , f_ANSC_id_unico_anpr(nvl(ana.matricola_1,ana_r.matricola_1),mat.cod_fiscale_m) idUnicoAnpr
  from civcta cta
     , civdta dta
     , civana ana
     , civana_recupero ana_r
     , anadci dci_m
     , civocc occ
     , civdpa dpa
     , civmat mat
 where cta.id                        (+) = dta.id_civcta
   and dta.id                        (+) = mat.id_civdta
   and ana.id_atto                   (+) = mat.id_atto
   and ana_r.id_atto                 (+) = mat.id_atto
   and dci_m.cod_ci                  (+) = mat.nazionalita_m
   and occ.id_atto                   (+) = mat.id_atto
   and dpa.id_atto                   (+) = mat.id_atto
   and mat.cod_rec                 in (0,3)
UNION
select 2 w_ord
     , mat.id
     , mat.id_atto
     , mat.ufficio
     , mat.anno
     , mat.parte
     , mat.serie
     , mat.atto
-- sposa
     , mat.cod_fiscale_f codiceFiscale
     , nvl(occ.cognome_cn,mat.cognome_f) cognome
     , nvl(occ.nome_cn,mat.nome_f) nome
     , 'F' sesso
     , 'femminile' descrizioneSesso
     , to_char(mat.d_data_nas_f,'yyyy-mm-dd') dataNascita
     , f_ANSC_id_comune_al(mat.cod_pro_nas_f,mat.cod_com_nas_f,mat.d_data_nas_f) idComuneNascita
     , f_ANSC_comune_italiano(mat.cod_pro_nas_f,mat.cod_com_nas_f,mat.d_data_nas_f) nomeComuneNascita
     , f_ANSC_id_provincia_al(mat.cod_pro_nas_f,mat.cod_com_nas_f,mat.d_data_nas_f) idProvinciaNascita
     , f_ANSC_provincia_al(mat.cod_pro_nas_f,mat.cod_com_nas_f,mat.d_data_nas_f) siglaProvinciaNascita
     , f_ANSC_id_stato_al(mat.cod_pro_nas_f,mat.cod_com_nas_f,mat.d_data_nas_f) idStatoNascita
     , f_ANSC_stato_al(mat.cod_pro_nas_f,mat.cod_com_nas_f,mat.d_data_nas_f) nomeStatoNascita
     , f_ANSC_comune_estero(mat.cod_pro_nas_f,mat.cod_com_nas_f,mat.d_data_nas_f) comuneEsteroNascita
     , f_ANSC_id_comune_al(mat.cod_pro_res_f,mat.cod_com_res_f,mat.d_data_mat) idComuneResidenza
     , f_ANSC_comune_italiano(mat.cod_pro_res_f,mat.cod_com_res_f,mat.d_data_mat) nomeComuneResidenza
     , f_ANSC_id_provincia_al(mat.cod_pro_res_f,mat.cod_com_res_f,mat.d_data_mat) idProvinciaResidenza
     , f_ANSC_provincia_al(mat.cod_pro_res_f,mat.cod_com_res_f,mat.d_data_mat) siglaProvinciaResidenza
     , f_ANSC_id_stato_al(mat.cod_pro_res_f,mat.cod_com_res_f,mat.d_data_mat) idStatoResidenza
     , f_ANSC_stato_al(mat.cod_pro_res_f,mat.cod_com_res_f,mat.d_data_mat) nomeStatoResidenza
     , f_ANSC_comune_estero(mat.cod_pro_res_f,mat.cod_com_res_f,mat.d_data_mat) comuneEsteroResidenza
     , f_ANSC_id_comune_aire(nvl(ana.matricola_2,ana_r.matricola_2),mat.cod_pro_res_f,mat.cod_com_res_f) idComuneAIRE
     , f_ANSC_comune_aire(nvl(ana.matricola_2,ana_r.matricola_2),mat.cod_pro_res_f,mat.cod_com_res_f) nomeComuneAIRE
     , f_ANSC_id_provincia_aire(nvl(ana.matricola_2,ana_r.matricola_2),mat.cod_pro_res_f,mat.cod_com_res_f) idProvinciaAIRE
     , f_ANSC_provincia_aire(nvl(ana.matricola_2,ana_r.matricola_2),mat.cod_pro_res_f,mat.cod_com_res_f) siglaProvinciaAIRE
--
     , 'a' genere
     , f_ANSC_id_nazionalita(dci_f.ist_ci) idNazionalita
     , f_get_descrizione_DCI(mat.nazionalita_f,'') nazionalita
     , f_ANSC_comprensione(mat.comprensione_f) comprensione
     , decode(cta.sigla, 
         'RCN', 'true', 
         'AVV', 'false', 
         f_ANSC_flag_dichiarante(dpa.tipo_dichiarante,'SA')) flagDichiarante
     , decode(cta.sigla, 
         'RCN', 'true', 
         'AVV', 'false', 
         f_ANSC_flag_firmatario(dpa.tipo_firmatario,'SA')) flagFirmatario
     , decode(cta.sigla, 
         'RCN', 'true', 
         'AVV', 'false', 
         f_ANSC_flag_comparente(dpa.tipo_comparente,'SA')) flagComparente
-- ANSC
     , mat.id_atto_ansc idAttoAnsc
     , mat.id_evento_ansc idEventoAnsc
     , mat.id_soggetto_ansc_f idSoggettoAnsc
     , f_ANSC_id_soggetto_anpr(nvl(ana.matricola_2,ana_r.matricola_2),mat.cod_fiscale_f) idSoggettoAnpr
     , f_ANSC_id_unico_anpr(nvl(ana.matricola_2,ana_r.matricola_2),mat.cod_fiscale_f) idUnicoAnpr
  from civcta cta
     , civdta dta
     , civana ana
     , civana_recupero ana_r
     , anadci dci_f
     , civocc occ
     , civdpa dpa
     , civmat mat
 where cta.id                        (+) = dta.id_civcta
   and dta.id                        (+) = mat.id_civdta
   and ana.id_atto                   (+) = mat.id_atto
   and ana_r.id_atto                 (+) = mat.id_atto
   and dci_f.cod_ci                  (+) = mat.nazionalita_f
   and occ.id_atto                   (+) = mat.id_atto
   and dpa.id_atto                   (+) = mat.id_atto
   and mat.cod_rec                 in (0,3)
 order by 1
/
comment on table CIVMAT_INT_V_JSON is 'ANSC - Atti di Matrimonio per request JSON - INTESTATARI (view)'
/

 