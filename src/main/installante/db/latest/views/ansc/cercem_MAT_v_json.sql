--liquibase formatted sql
--changeset ftravaglini:202306201515 runOnChange:true stripComments:false
create or replace view cercem_MAT_v_json as
select mat.id id
     , mat.id_atto id_atto
     , to_char(null) RIC_indirizzoResidenza
     , to_char(null) RIC_codiceFiscale
     , to_char(null) RIC_idSoggettoAnpr
     , to_char(null) RIC_numeroDocumento
     , to_char(null) RIC_tipologiaDocumento
     , to_char(null) RIC_dataScadenza
     , to_char(null) RIC_rilasciatoDa
     , to_char(null) RIC_dataRilascio
     , decode(dpa.nome_dic, '', mat.nome_m,
                                dpa.nome_dic) RIC_nome
     , decode(dpa.nome_dic, '', mat.cognome_m,
                                dpa.cognome_dic) RIC_cognome
     , decode(dpa.nome_dic, '', 'M',
                                dpa.sesso_dic) RIC_sesso
     , decode(dpa.nome_dic, '', to_char(mat.d_data_nas_m,'yyyy-mm-dd'),
                                to_char(dpa.d_data_nas_dic,'yyyy-mm-dd')) RIC_dataNascita
     , decode(dpa.nome_dic, '', f_ANSC_id_stato_al(mat.cod_pro_nas_m,mat.cod_com_nas_m,mat.d_data_nas_m),
                                f_ANSC_id_stato_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic)) RIC_idStatoNascita
     , decode(dpa.nome_dic, '', f_ANSC_stato_al(mat.cod_pro_nas_m,mat.cod_com_nas_m,mat.d_data_nas_m),
                                f_ANSC_stato_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic)) RIC_nomeStatoNascita
     , decode(dpa.nome_dic, '', f_ANSC_id_stato_al(mat.cod_pro_res_m,mat.cod_com_res_m,mat.d_data_mat),
                                f_ANSC_id_stato_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,mat.d_data_mat)) RIC_idStatoResidenza
     , decode(dpa.nome_dic, '', f_ANSC_stato_al(mat.cod_pro_res_m,mat.cod_com_res_m,mat.d_data_mat),
                                f_ANSC_stato_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,mat.d_data_mat)) RIC_nomeStatoResidenza
     , decode(dpa.nome_dic, '', f_ANSC_id_comune_al(mat.cod_pro_nas_m,mat.cod_com_nas_m,mat.d_data_nas_m),
                                f_ANSC_id_comune_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic)) RIC_idComuneNascita
     , decode(dpa.nome_dic, '', f_ANSC_comune_al(mat.cod_pro_nas_m,mat.cod_com_nas_m,mat.d_data_nas_m),
                                f_ANSC_comune_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic)) RIC_nomeComuneNascita
     , decode(dpa.nome_dic, '', f_ANSC_id_provincia_al(mat.cod_pro_nas_m,mat.cod_com_nas_m,mat.d_data_nas_m),
                                f_ANSC_id_provincia_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic)) RIC_idProvinciaNascita
     , decode(dpa.nome_dic, '', f_ANSC_provincia_al(mat.cod_pro_nas_m,mat.cod_com_nas_m,mat.d_data_nas_m),
                                f_ANSC_provincia_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,dpa.d_data_nas_dic)) RIC_siglaProvinciaNascita
     , decode(dpa.nome_dic, '', f_ANSC_id_comune_al(mat.cod_pro_res_m,mat.cod_com_res_m,mat.d_data_mat),
                                f_ANSC_id_comune_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,mat.d_data_mat)) RIC_idComuneResidenza
     , decode(dpa.nome_dic, '', f_ANSC_comune_al(mat.cod_pro_res_m,mat.cod_com_res_m,mat.d_data_mat),
                                f_ANSC_comune_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,mat.d_data_mat)) RIC_nomeComuneResidenza
     , decode(dpa.nome_dic, '', f_ANSC_id_provincia_al(mat.cod_pro_res_m,mat.cod_com_res_m,mat.d_data_mat),
                                f_ANSC_id_provincia_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,mat.d_data_mat)) RIC_idProvinciaResidenza
     , decode(dpa.nome_dic, '', f_ANSC_provincia_al(mat.cod_pro_res_m,mat.cod_com_res_m,mat.d_data_mat),
                                f_ANSC_provincia_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,mat.d_data_mat)) RIC_siglaProvinciaResidenza
     , decode(dpa.nome_dic, '', f_get_descrizione_DCI(mat.nazionalita_m, ''),
                                f_get_descrizione_DCI(dpa.nazionalita_dic, '')) RIC_nazionalita
     , decode(dpa.nome_dic, '', f_ANSC_id_nazionalita(dci_m.ist_ci),
                                f_ANSC_id_nazionalita(dci_dic.ist_ci)) RIC_idNazionalita
     , 'true' RIC_flagDichiarante
     , 'true' RIC_flagComparente
     , 'true' RIC_flagFirmatario
-- ANSC
     , mat.id_atto_ansc idAttoAnsc
     , mat.id_atto_ansc idAnsc
     , mat.id_evento_ansc idEventoAnsc
     , mat.id_evento_ansc idEvento
     , mat.id_soggetto_ansc_m BEN_idSoggettoAnsc
     , '1' idTipoCertificato
     , '1' idTipoCertificato_1
     , '2' idTipoCertificato_2
     , '3' idTipoCertificato_3
  from arccom m
     , anadci dci_dic
     , anadci dci_m
     , civdpa dpa
     , civmat mat
 where (m.cod_provincia,m.cod_comune) = (select pro_cliente, com_cliente from menuditta)
   and dci_dic.cod_ci     (+) = dpa.nazionalita_dic
   and dci_m.cod_ci       (+) = mat.nazionalita_m
   and dpa.id_atto        (+) = mat.id_atto
   and mat.id_atto_ansc   is not null
/
comment on table CERCEM_MAT_V_JSON is 'ANSC - Dati Certificato per request JSON (view)'
/
