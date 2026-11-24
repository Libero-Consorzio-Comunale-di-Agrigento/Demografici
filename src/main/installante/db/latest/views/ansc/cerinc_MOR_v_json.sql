--liquibase formatted sql
--changeset amonopoli:202310061205_2 runOnChange:true stripComments:false
create or replace view cerinc_mor_v_json as
select inc.id id
     , mor.id_atto id_atto
     , f_cognome(cem.richiedente) RIC_cognome
     , f_nome(cem.richiedente) RIC_nome
     , cem.sesso_richiedente RIC_sesso
     , to_char(cem.d_data_nas_richiedente,'yyyy-mm-dd') RIC_dataNascita
     , f_ANSC_id_comune_al(cem.cod_pro_nas_richiedente,cem.cod_com_nas_richiedente,cem.d_data_nas_richiedente) RIC_idComuneNascita
     , f_ANSC_comune_al(cem.cod_pro_nas_richiedente,cem.cod_com_nas_richiedente,cem.d_data_nas_richiedente) RIC_nomeComuneNascita
     , f_ANSC_id_provincia_al(cem.cod_pro_nas_richiedente,cem.cod_com_nas_richiedente,cem.d_data_nas_richiedente) RIC_idProvinciaNascita
     , f_ANSC_provincia_al(cem.cod_pro_nas_richiedente,cem.cod_com_nas_richiedente,cem.d_data_nas_richiedente) RIC_siglaProvinciaNascita
     , f_ANSC_id_stato_al(cem.cod_pro_nas_richiedente,cem.cod_com_nas_richiedente,cem.d_data_nas_richiedente) RIC_idStatoNascita
     , f_ANSC_stato_al(cem.cod_pro_nas_richiedente,cem.cod_com_nas_richiedente,cem.d_data_nas_richiedente) RIC_nomeStatoNascita
     , to_char(null) RIC_idComuneResidenza
     , to_char(null) RIC_nomeComuneResidenza
     , to_char(null) RIC_idProvinciaResidenza
     , to_char(null) RIC_siglaProvinciaResidenza
     , to_char(null) RIC_idStatoResidenza
     , to_char(null) RIC_nomeStatoResidenza
     , f_ANSC_id_nazionalita(dci_ric.ist_ci) RIC_idNazionalita
     , f_get_descrizione_dci(cem.nazionalita_richiedente,'') RIC_nazionalita
     , to_char(null) RIC_indirizzoResidenza
     , cem.cod_fiscale_richiedente RIC_codiceFiscale
     , to_char(null) RIC_idSoggettoAnpr
     , to_char(null) RIC_numeroDocumento
     , to_char(null) RIC_tipologiaDocumento
     , to_char(null) RIC_dataScadenza
     , to_char(null) RIC_rilasciatoDa
     , to_char(null) RIC_dataRilascio
-- Ente Richiedente
     , cem.ente_richiedente ENT_nomeEnte
     , f_ANSC_id_comune_al(cem.cod_pro_ente_richiedente,cem.cod_com_ente_richiedente,'') ENT_idComuneEnte
     , f_ANSC_comune_italiano(cem.cod_pro_ente_richiedente,cem.cod_com_ente_richiedente,'') ENT_nomeComuneEnte
     , f_ANSC_id_provincia_al(cem.cod_pro_ente_richiedente,cem.cod_com_ente_richiedente,'') ENT_idProvinciaEnte
     , f_ANSC_provincia_al(cem.cod_pro_ente_richiedente,cem.cod_com_ente_richiedente,'') ENT_siglaProvinciaEnte
     , f_ANSC_id_stato_al(cem.cod_pro_ente_richiedente,cem.cod_com_ente_richiedente,'') ENT_nazioneEnte
     , f_ANSC_stato_al(cem.cod_pro_ente_richiedente,cem.cod_com_ente_richiedente,'') ENT_nomeNazioneEnte
     , cem.id_consolato_ansc_richiedente ENT_idAnagraficaConsolato
     , t97_er.descrizione ENT_nomeAnagraficaConsolato
-- ANSC
     , mor.id_atto_ansc idAttoAnsc
     , mor.id_atto_ansc idAnsc
     , mor.id_evento_ansc idEventoAnsc
     , mor.id_evento_ansc idEvento
     , mor.id_soggetto_ansc BEN_idSoggettoAnsc
     , f_ANSC_id_tipo_certificato(dce.codice_anpr) idTipoCertificato
     , f_ANSC_con_paternita_maternita(dce.codice_anpr) conPaternitaMaternita
     , f_ANSC_flag_semplificato(dce.codice_anpr) flagSemplificato
     , f_ANSC_id_tipo_uso(dce.codice_anpr,dri.codice_anpr) idTipoUso
     , f_ANSC_valido_estero(dce.codice_anpr,dri.codice_anpr) validoEstero
     , f_ANSC_uso_matrimonio(dce.codice_anpr,dri.codice_anpr) usoMatrimonio
  from anadci dci_ric
     , civmor mor
     , cerdri dri
     , cerdce dce
     , cercem cem
     , cerinc_zk inc
     , anst97 t97_er
 where dci_ric.cod_ci (+)  = cem.nazionalita_richiedente
   and t97_er.id      (+)  = cem.id_consolato_ansc_richiedente
   and mor.id_atto_ansc    is not null
   and nvl(mor.ufficio,0)  = nvl(inc.ufficio,0)
   and mor.anno            = inc.anno
   and mor.atto            = inc.atto
   and nvl(mor.parte,0)    = nvl(inc.parte,0)
   and nvl(mor.serie,' ')  = nvl(inc.serie,' ')
   and dce.tipo_archivio   = 5
   and dri.cod_ri          = cem.modalita_rilascio
   and dce.cod_certificato = cem.cod_certificato
   and cem.anno_emissione  = inc.anno_emissione
   and cem.progr_emissione = inc.progr_emissione
/
comment on table cerinc_mor_V_JSON is 'ANSC - Dati Certificato per request JSON (view)'
/
