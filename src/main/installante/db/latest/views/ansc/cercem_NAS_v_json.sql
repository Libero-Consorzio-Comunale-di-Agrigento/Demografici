--liquibase formatted sql
--changeset amonopoli:2023053111605_1 runOnChange:true stripComments:false
create or replace view cercem_nas_v_json as
select nas.id id
     , nas.id_atto id_atto
     , decode(nas.cognome_pd||nas.nome_pd,'',
         nas.cognome_md,
         nas.cognome_pd) RIC_cognome
     , decode(nas.cognome_pd||nas.nome_pd,'',
         nas.nome_md,
         nas.nome_pd) RIC_nome
     , decode(nas.cognome_pd||nas.nome_pd,'',
         'F',
         'M') RIC_sesso
     , decode(nas.cognome_pd||nas.nome_pd,'',
         to_char(nas.d_data_nas_md,'yyyy-mm-dd'),
         to_char(nas.d_data_nas_pd,'yyyy-mm-dd')) RIC_dataNascita
     , decode(nas.cognome_pd||nas.nome_pd,'',
         f_ANSC_id_comune_al(nas.cod_pro_nas_md,nas.cod_com_nas_md,nas.d_data_nas_md),
         f_ANSC_id_comune_al(nas.cod_pro_nas_pd,nas.cod_com_nas_pd,nas.d_data_nas_pd)) RIC_idComuneNascita
     , decode(nas.cognome_pd||nas.nome_pd,'',
         f_ANSC_comune_al(nas.cod_pro_nas_md,nas.cod_com_nas_md,nas.d_data_nas_md),
         f_ANSC_comune_al(nas.cod_pro_nas_pd,nas.cod_com_nas_pd,nas.d_data_nas_pd)) RIC_nomeComuneNascita
     , decode(nas.cognome_pd||nas.nome_pd,'',
         f_ANSC_id_provincia_al(nas.cod_pro_nas_md,nas.cod_com_nas_md,nas.d_data_nas_md),
         f_ANSC_id_provincia_al(nas.cod_pro_nas_pd,nas.cod_com_nas_pd,nas.d_data_nas_pd)) RIC_idProvinciaNascita
     , decode(nas.cognome_pd||nas.nome_pd,'',
         f_ANSC_provincia_al(nas.cod_pro_nas_md,nas.cod_com_nas_md,nas.d_data_nas_md),
         f_ANSC_provincia_al(nas.cod_pro_nas_pd,nas.cod_com_nas_pd,nas.d_data_nas_pd)) RIC_siglaProvinciaNascita
     , decode(nas.cognome_pd||nas.nome_pd,'',
         f_ANSC_id_stato_al(nas.cod_pro_nas_md,nas.cod_com_nas_md,nas.d_data_nas_md),
         f_ANSC_id_stato_al(nas.cod_pro_nas_pd,nas.cod_com_nas_pd,nas.d_data_nas_pd)) RIC_idStatoNascita
     , decode(nas.cognome_pd||nas.nome_pd,'',
         f_ANSC_stato_al(nas.cod_pro_nas_md,nas.cod_com_nas_md,nas.d_data_nas_md),
         f_ANSC_stato_al(nas.cod_pro_nas_pd,nas.cod_com_nas_pd,nas.d_data_nas_pd)) RIC_nomeStatoNascita
     , decode(nas.cognome_pd||nas.nome_pd,'',
         f_ANSC_id_comune_al(nas.cod_pro_res_md,nas.cod_com_res_md,''),
         f_ANSC_id_comune_al(nas.cod_pro_res_pd,nas.cod_com_res_pd,'')) RIC_idComuneResidenza
     , decode(nas.cognome_pd||nas.nome_pd,'',
         f_ANSC_comune_al(nas.cod_pro_res_md,nas.cod_com_res_md,''),
         f_ANSC_comune_al(nas.cod_pro_res_pd,nas.cod_com_res_pd,'')) RIC_nomeComuneResidenza
     , decode(nas.cognome_pd||nas.nome_pd,'',
         f_ANSC_id_provincia_al(nas.cod_pro_res_md,nas.cod_com_res_md,''),
         f_ANSC_id_provincia_al(nas.cod_pro_res_pd,nas.cod_com_res_pd,'')) RIC_idProvinciaResidenza
     , decode(nas.cognome_pd||nas.nome_pd,'',
         f_ANSC_provincia_al(nas.cod_pro_res_md,nas.cod_com_res_md,''),
         f_ANSC_provincia_al(nas.cod_pro_res_pd,nas.cod_com_res_pd,'')) RIC_siglaProvinciaResidenza
     , decode(nas.cognome_pd||nas.nome_pd,'',
         f_ANSC_id_stato_al(nas.cod_pro_res_md,nas.cod_com_res_md,''),
         f_ANSC_id_stato_al(nas.cod_pro_res_pd,nas.cod_com_res_pd,'')) RIC_idStatoResidenza
     , decode(nas.cognome_pd||nas.nome_pd,'',
         f_ANSC_stato_al(nas.cod_pro_res_md,nas.cod_com_res_md,''),
         f_ANSC_stato_al(nas.cod_pro_res_pd,nas.cod_com_res_pd,'')) RIC_nomeStatoResidenza
     , decode(nas.cognome_pd||nas.nome_pd,'',
         f_ANSC_id_nazionalita(dci_md.ist_ci),
         f_ANSC_id_nazionalita(dci_pd.ist_ci)) RIC_idNazionalita
     , decode(nas.cognome_pd||nas.nome_pd,'',
         f_get_descrizione_dci(nas.nazionalita_md,''),
         f_get_descrizione_dci(nas.nazionalita_pd,'')) RIC_nazionalita
     , to_char(null) RIC_indirizzoResidenza
     , to_char(null) RIC_codiceFiscale
     , to_char(null) RIC_idSoggettoAnpr
     , to_char(null) RIC_numeroDocumento
     , to_char(null) RIC_tipologiaDocumento
     , to_char(null) RIC_dataScadenza
     , to_char(null) RIC_rilasciatoDa
     , to_char(null) RIC_dataRilascio
-- ANSC
     , nas.id_atto_ansc idAttoAnsc
     , nas.id_atto_ansc idAnsc
     , nas.id_evento_ansc idEventoAnsc
     , nas.id_evento_ansc idEvento
     , nas.id_soggetto_ansc BEN_idSoggettoAnsc
     , '1' idTipoCertificato
     , '1' idTipoCertificato_1
     , '2' idTipoCertificato_2
     , '3' idTipoCertificato_3
  from arccom m
     , anadci dci_md
     , anadci dci_pd
     , civnas nas
 where (m.cod_provincia,m.cod_comune) = (select pro_cliente, com_cliente from menuditta)
   and dci_md.cod_ci (+) = nas.nazionalita_md
   and dci_pd.cod_ci (+) = nas.nazionalita_pd
   and nas.id_atto_ansc  is not null
/
comment on table CERCEM_NAS_V_JSON is 'ANSC - Dati Certificato per request JSON (view)'
/
