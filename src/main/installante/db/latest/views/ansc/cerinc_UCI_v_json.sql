--liquibase formatted sql
--changeset amonopoli:202310061205_4 runOnChange:true stripComments:false
create or replace view cerinc_uci_v_json as
select inc.id id
     , uci.id_atto id_atto
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
-- ANSC
     , uci.id_atto_ansc idAttoAnsc
     , uci.id_atto_ansc idAnsc
     , uci.id_evento_ansc idEventoAnsc
     , uci.id_evento_ansc idEvento
     , uci.id_soggetto_ansc_m BEN_idSoggettoAnsc_1
     , uci.id_soggetto_ansc_f BEN_idSoggettoAnsc_2
     , f_ANSC_id_tipo_certificato(dce.codice_anpr) idTipoCertificato
     , f_ANSC_con_paternita_maternita(dce.codice_anpr) conPaternitaMaternita
     , f_ANSC_flag_semplificato(dce.codice_anpr) flagSemplificato
     , f_ANSC_id_tipo_uso(dce.codice_anpr,dri.codice_anpr) idTipoUso
     , f_ANSC_valido_estero(dce.codice_anpr,dri.codice_anpr) validoEstero
     , f_ANSC_uso_matrimonio(dce.codice_anpr,dri.codice_anpr) usoMatrimonio
  from anadci dci_ric
     , civuci uci
     , cerdri dri
     , cerdce dce
     , cercem cem
     , cerinc_zk inc
 where dci_ric.cod_ci (+)  = cem.nazionalita_richiedente
   and uci.id_atto_ansc    is not null
   and uci.ufficio         = inc.ufficio
   and uci.anno            = inc.anno
   and uci.atto            = inc.atto
   and nvl(uci.parte,0)    = nvl(inc.parte,0)
   and nvl(uci.serie,' ')  = nvl(inc.serie,' ')
   and dce.tipo_archivio   = -4
   and dri.cod_ri          = cem.modalita_rilascio
   and dce.cod_certificato = cem.cod_certificato
   and cem.anno_emissione  = inc.anno_emissione
   and cem.progr_emissione = inc.progr_emissione
/
comment on table cerinc_uci_V_JSON is 'ANSC - Dati Certificato per request JSON (view)'
/
