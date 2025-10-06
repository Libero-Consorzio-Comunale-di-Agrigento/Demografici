--liquibase formatted sql
--changeset amonopoli:2023007031210 runOnChange:true stripComments:false
create or replace view cercem_CIT_v_json as
select cit.id id
     , cit.id_atto id_atto
     , decode(dpa.cognome_dic, '',
         cit.cognome,
         dpa.cognome_dic) RIC_cognome
     , decode(dpa.cognome_dic, '',
         cit.nome,
         dpa.nome_dic) RIC_nome
     , decode(dpa.cognome_dic, '',
         cit.sesso,
         dpa.sesso_dic) RIC_sesso
     , decode(dpa.cognome_dic, '',
         to_char(cit.d_data_nas,'yyyy-mm-dd'),
         to_char(dpa.d_data_nas_dic,'yyyy-mm-dd')) RIC_dataNascita
     , decode(dpa.cognome_dic, '',
         f_ANSC_id_comune_al(cit.cod_pro_nas,cit.cod_com_nas,cit.d_data_nas),
         f_ANSC_id_comune_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic)) RIC_idComuneNascita
     , decode(dpa.cognome_dic, '',
         f_ANSC_comune_al(cit.cod_pro_nas,cit.cod_com_nas,cit.d_data_nas),
         f_ANSC_comune_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic)) RIC_nomeComuneNascita
     , decode(dpa.cognome_dic, '',
         f_ANSC_id_provincia_al(cit.cod_pro_nas,cit.cod_com_nas,cit.d_data_nas),
         f_ANSC_id_provincia_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic)) RIC_idProvinciaNascita
     , decode(dpa.cognome_dic, '',
         f_ANSC_provincia_al(cit.cod_pro_nas,cit.cod_com_nas,cit.d_data_nas),
         f_ANSC_provincia_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic)) RIC_siglaProvinciaNascita
     , decode(dpa.cognome_dic, '',
         f_ANSC_id_stato_al(cit.cod_pro_nas,cit.cod_com_nas,cit.d_data_nas),
         f_ANSC_id_stato_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic)) RIC_idStatoNascita
     , decode(dpa.cognome_dic, '',
         f_ANSC_stato_al(cit.cod_pro_nas,cit.cod_com_nas,cit.d_data_nas),
         f_ANSC_stato_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic)) RIC_nomeStatoNascita
     , decode(dpa.cognome_dic, '',
         f_ANSC_id_comune_al(cit.cod_pro_res,cit.cod_com_res,''),
         f_ANSC_id_comune_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,'')) RIC_idComuneResidenza
     , decode(dpa.cognome_dic, '',
         f_ANSC_comune_al(cit.cod_pro_res,cit.cod_com_res,''),
         f_ANSC_comune_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,'')) RIC_nomeComuneResidenza
     , decode(dpa.cognome_dic, '',
         f_ANSC_id_provincia_al(cit.cod_pro_res,cit.cod_com_res,''),
         f_ANSC_id_provincia_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,'')) RIC_idProvinciaResidenza
     , decode(dpa.cognome_dic, '',
         f_ANSC_provincia_al(cit.cod_pro_res,cit.cod_com_res,''),
         f_ANSC_provincia_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,'')) RIC_siglaProvinciaResidenza
     , decode(dpa.cognome_dic, '',
         f_ANSC_id_stato_al(cit.cod_pro_res,cit.cod_com_res,''),
         f_ANSC_id_stato_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,'')) RIC_idStatoResidenza
     , decode(dpa.cognome_dic, '',
         f_ANSC_stato_al(cit.cod_pro_res,cit.cod_com_res,''),
         f_ANSC_stato_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,'')) RIC_nomeStatoResidenza
     , decode(dpa.cognome_dic, '',
         f_ANSC_id_nazionalita(dci.ist_ci),
         f_ANSC_id_nazionalita(dci_dic.ist_ci)) RIC_idNazionalita
     , decode(dpa.cognome_dic, '',
         f_get_descrizione_dci(cit.nazionalita,''),
         f_get_descrizione_dci(dpa.nazionalita_dic,'')) RIC_nazionalita
     , to_char(null) RIC_indirizzoResidenza
     , to_char(null) RIC_codiceFiscale
     , to_char(null) RIC_idSoggettoAnpr
     , to_char(null) RIC_numeroDocumento
     , to_char(null) RIC_tipologiaDocumento
     , to_char(null) RIC_dataScadenza
     , to_char(null) RIC_rilasciatoDa
     , to_char(null) RIC_dataRilascio
-- ANSC
     , cit.id_atto_ansc idAttoAnsc
     , cit.id_atto_ansc idAnsc
     , cit.id_evento_ansc idEventoAnsc
     , cit.id_evento_ansc idEvento
     , cit.id_soggetto_ansc BEN_idSoggettoAnsc
     , '1' idTipoCertificato
     , '1' idTipoCertificato_1
     , '2' idTipoCertificato_2
     , '3' idTipoCertificato_3
  from arccom m
     , anadci dci_dic
     , anadci dci
     , civdpa dpa
     , civcit cit
 where (m.cod_provincia,m.cod_comune) = (select pro_cliente, com_cliente from menuditta)
   and dci.cod_ci     (+) = cit.nazionalita
   and dci_dic.cod_ci (+) = dpa.nazionalita_dic
   and dpa.id_atto    (+) = cit.id_atto
   and cit.id_atto_ansc   is not null
/
comment on table CERCEM_CIT_V_JSON is 'ANSC - Dati Certificato per request JSON (view)'
/
