--liquibase formatted sql
--changeset ftravaglini:202306201505 runOnChange:true stripComments:false
create or replace view cercem_UCI_v_json as
select uci.id id
     , uci.id_atto id_atto
     , to_char(null) RIC_indirizzoResidenza
     , to_char(null) RIC_codiceFiscale
     , to_char(null) RIC_idSoggettoAnpr
     , to_char(null) RIC_numeroDocumento
     , to_char(null) RIC_tipologiaDocumento
     , to_char(null) RIC_dataScadenza
     , to_char(null) RIC_rilasciatoDa
     , to_char(null) RIC_dataRilascio
     , decode(dpa.nome_dic, '', uci.nome_m,
                                dpa.nome_dic) RIC_nome
     , decode(dpa.nome_dic, '', uci.cognome_m,
                                dpa.cognome_dic) RIC_cognome
     , decode(dpa.nome_dic, '', uci.sesso_m,
                                dpa.sesso_dic) RIC_sesso
     , decode(dpa.nome_dic, '', to_char(uci.d_data_nas_m,'yyyy-mm-dd'),
                                to_char(dpa.d_data_nas_dic,'yyyy-mm-dd')) RIC_dataNascita
     , decode(dpa.nome_dic, '', f_ANSC_id_stato_al(uci.cod_pro_nas_m,uci.cod_com_nas_m,uci.d_data_nas_m),
                                f_ANSC_id_stato_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic)) RIC_idStatoNascita
     , decode(dpa.nome_dic, '', f_ANSC_stato_al(uci.cod_pro_nas_m,uci.cod_com_nas_m,uci.d_data_nas_m),
                                f_ANSC_stato_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic)) RIC_nomeStatoNascita
     , decode(dpa.nome_dic, '', f_ANSC_id_stato_al(uci.cod_pro_res_m,uci.cod_com_res_m,uci.d_data_mat),
                                f_ANSC_id_stato_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,uci.d_data_mat)) RIC_idStatoResidenza
     , decode(dpa.nome_dic, '', f_ANSC_stato_al(uci.cod_pro_res_m,uci.cod_com_res_m,uci.d_data_mat),
                                f_ANSC_stato_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,uci.d_data_mat)) RIC_nomeStatoResidenza
     , decode(dpa.nome_dic, '', f_ANSC_id_comune_al(uci.cod_pro_nas_m,uci.cod_com_nas_m,uci.d_data_nas_m),
                                f_ANSC_id_comune_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic)) RIC_idComuneNascita
     , decode(dpa.nome_dic, '', f_ANSC_comune_al(uci.cod_pro_nas_m,uci.cod_com_nas_m,uci.d_data_nas_m),
                                f_ANSC_comune_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic)) RIC_nomeComuneNascita
     , decode(dpa.nome_dic, '', f_ANSC_id_provincia_al(uci.cod_pro_nas_m,uci.cod_com_nas_m,uci.d_data_nas_m),
                                f_ANSC_id_provincia_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic)) RIC_idProvinciaNascita
     , decode(dpa.nome_dic, '', f_ANSC_provincia_al(uci.cod_pro_nas_m,uci.cod_com_nas_m,uci.d_data_nas_m),
                                f_ANSC_provincia_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic)) RIC_siglaProvinciaNascita
     , decode(dpa.nome_dic, '', f_ANSC_id_comune_al(uci.cod_pro_res_m,uci.cod_com_res_m,uci.d_data_mat),
                                f_ANSC_id_comune_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,uci.d_data_mat)) RIC_idComuneResidenza
     , decode(dpa.nome_dic, '', f_ANSC_comune_al(uci.cod_pro_res_m,uci.cod_com_res_m,uci.d_data_mat),
                                f_ANSC_comune_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,uci.d_data_mat)) RIC_nomeComuneResidenza
     , decode(dpa.nome_dic, '', f_ANSC_id_provincia_al(uci.cod_pro_res_m,uci.cod_com_res_m,uci.d_data_mat),
                                f_ANSC_id_provincia_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,uci.d_data_mat)) RIC_idProvinciaResidenza
     , decode(dpa.nome_dic, '', f_ANSC_provincia_al(uci.cod_pro_res_m,uci.cod_com_res_m,uci.d_data_mat),
                                f_ANSC_provincia_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,uci.d_data_mat)) RIC_siglaProvinciaResidenza
     , decode(dpa.nome_dic, '', f_get_descrizione_DCI(uci.nazionalita_m, ''),
                                f_get_descrizione_DCI(dpa.nazionalita_dic, '')) RIC_nazionalita
     , decode(dpa.nome_dic, '', f_ANSC_id_nazionalita(dci_m.ist_ci),
                                f_ANSC_id_nazionalita(dci_dic.ist_ci)) RIC_idNazionalita
     , 'true' RIC_flagDichiarante
     , 'true' RIC_flagComparente
     , 'true' RIC_flagFirmatario
-- ANSC
     , uci.id_atto_ansc idAttoAnsc
     , uci.id_atto_ansc idAnsc
     , uci.id_evento_ansc idEventoAnsc
     , uci.id_evento_ansc idEvento
     , uci.id_soggetto_ansc_m BEN_idSoggettoAnsc
     , '1' idTipoCertificato
     , '1' idTipoCertificato_1
     , '2' idTipoCertificato_2
     , '3' idTipoCertificato_3
  from arccom m
     , anadci dci_dic
     , anadci dci_m
     , civdpa dpa
     , civuci uci
 where (m.cod_provincia,m.cod_comune) = (select pro_cliente, com_cliente from menuditta)
   and dci_dic.cod_ci     (+) = dpa.nazionalita_dic
   and dci_m.cod_ci       (+) = uci.nazionalita_m
   and dpa.id_atto        (+) = uci.id_atto
   and uci.id_atto_ansc   is not null
/
comment on table CERCEM_UCI_V_JSON is 'ANSC - Dati Certificato per request JSON (view)'
/
