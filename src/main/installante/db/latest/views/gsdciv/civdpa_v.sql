--liquibase formatted sql
--changeset amonopoli:202303270925 runAlways:true runOnChange:true stripComments:false
create or replace view civdpa_v
as
SELECT dpa.*,
-- flag_rito_cattolico
       decode(dpa.tipo_atto, 4, decode(upper(dpa.rito),'CATTOLICO','S')) flag_rito_cattolico,
-- tipo_trasmissione
       decode(dpa.tipo_atto, 5, f_CIV_tipo_trasmissione(dpa.tipo_atto, dpa.id_atto)) tipo_trasmissione,
-- des_com_atto_orig
       f_comune_al(dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,dpa.data_atto_orig) des_com_atto_orig,
-- sigla_pro_atto_orig
       f_provincia_stato_al(dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,'','S','',dpa.data_atto_orig) sigla_pro_atto_orig,
-- des_com_nas_dic
       f_comune_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,to_char(dpa.d_data_nas_dic,'j')) des_com_nas_dic,
-- sigla_pro_nas_dic
       f_provincia_stato_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,'','S','',to_char(dpa.d_data_nas_dic,'j')) sigla_pro_nas_dic,
-- des_com_res_dic
       f_comune_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,to_char(dpa.d_data_nas_dic,'j')) des_com_res_dic,
-- sigla_pro_res_dic
       f_provincia_stato_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,'','S','',to_char(dpa.d_data_nas_dic,'j')) sigla_pro_res_dic,
-- des_com_accordo
       f_comune_al(dpa.accordo_cod_pro,dpa.accordo_cod_com,to_char(dpa.d_accordo_data,'j')) des_com_accordo,
-- sigla_pro_accordo
       f_provincia_stato_al(dpa.accordo_cod_pro,dpa.accordo_cod_com,'','S','',to_char(dpa.d_accordo_data,'j')) sigla_pro_accordo,
-- des_com_prov
       f_comune_al(dpa.cod_pro_prov,dpa.cod_com_prov,'') des_com_prov,
-- sigla_pro_prov
       f_provincia_stato_al(dpa.cod_pro_prov,dpa.cod_com_prov,'','S','','') sigla_pro_prov,
-- des_com_ente_straniero
       f_comune_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'') des_com_ente_straniero,
-- sigla_pro_ente_straniero
       f_provincia_stato_al(dpa.ente_straniero_cod_pro,dpa.ente_straniero_cod_com,'','S','','') sigla_pro_ente_straniero,
-- des_com_atto_notarile
       f_comune_al(dpa.atto_notarile_cod_pro,dpa.atto_notarile_cod_com,'') des_com_atto_notarile,
-- sigla_pro_atto_notarile
       f_provincia_stato_al(dpa.atto_notarile_cod_pro,dpa.atto_notarile_cod_com,'','S','','') sigla_pro_atto_notarile,
-- des_com_atto_ric_pre_1
       f_comune_al(dpa.riconoscimento_pre_cod_pro_1,dpa.riconoscimento_pre_cod_com_1,to_char(dpa.d_riconoscimento_pre_data_1,'j')) des_com_atto_ric_pre_1,
-- sigla_pro_atto_ric_pre_1
       f_provincia_stato_al(dpa.riconoscimento_pre_cod_pro_1,dpa.riconoscimento_pre_cod_com_1,'','S','',to_char(dpa.d_riconoscimento_pre_data_1,'j')) sigla_pro_atto_ric_pre_1,
-- des_com_atto_ric_pre_2
       f_comune_al(dpa.riconoscimento_pre_cod_pro_2,dpa.riconoscimento_pre_cod_com_2,to_char(dpa.d_riconoscimento_pre_data_2,'j')) des_com_atto_ric_pre_2,
-- sigla_pro_atto_ric_pre_2
       f_provincia_stato_al(dpa.riconoscimento_pre_cod_pro_2,dpa.riconoscimento_pre_cod_com_2,'','S','',to_char(dpa.d_riconoscimento_pre_data_2,'j')) sigla_pro_atto_ric_pre_2,
-- des_com_separazione
       f_comune_al(dpa.separazione_cod_pro,dpa.separazione_cod_com,'') des_com_separazione,
-- sigla_pro_separazione
       f_provincia_stato_al(dpa.separazione_cod_pro,dpa.separazione_cod_com,'','S','','') sigla_pro_separazione,
-- des_com_costituzione_uci_1
       f_comune_al(dpa.costituzione_uci_cod_pro_1,dpa.costituzione_uci_cod_com_1,'') des_com_costituzione_uci_1,
-- sigla_pro_costituzione_uci_1
       f_provincia_stato_al(dpa.costituzione_uci_cod_pro_1,dpa.costituzione_uci_cod_com_1,'','S','','') sigla_pro_costituzione_uci_1,
-- des_com_costituzione_uci_2
       f_comune_al(dpa.costituzione_uci_cod_pro_2,dpa.costituzione_uci_cod_com_2,'') des_com_costituzione_uci_2,
-- sigla_pro_costituzione_uci_2
       f_provincia_stato_al(dpa.costituzione_uci_cod_pro_2,dpa.costituzione_uci_cod_com_2,'','S','','') sigla_pro_costituzione_uci_2,
-- des_com_autorita_giudiziaria
       f_comune_al(dpa.autorita_giud_cod_pro,dpa.autorita_giud_cod_com,'') des_com_autorita_giudiziaria,
-- sigla_pro_autorita_giudiziaria
       f_provincia_stato_al(dpa.autorita_giud_cod_pro,dpa.autorita_giud_cod_com,'','S','','') sigla_pro_autorita_giudiziaria,
-- des_com_pubblico_impiego
       f_comune_al(dpa.pubblico_impiego_cod_pro,dpa.pubblico_impiego_cod_com,'') des_com_pubblico_impiego,
-- sigla_pro_pubblico_impiego
       f_provincia_stato_al(dpa.pubblico_impiego_cod_pro,dpa.pubblico_impiego_cod_com,'','S','','') sigla_pro_pubblico_impiego,
-- des_com_fine_opposizione
       f_comune_al(dpa.fine_opposizione_cod_pro,dpa.fine_opposizione_cod_com,'') des_com_fine_opposizione,
-- sigla_pro_fine_opposizione
       f_provincia_stato_al(dpa.fine_opposizione_cod_pro,dpa.fine_opposizione_cod_com,'','S','','') sigla_pro_fine_opposizione,
-- des_com_atto_assenso
       f_comune_al(dpa.atto_assenso_cod_pro,dpa.atto_assenso_cod_com,'') des_com_atto_assenso,
-- sigla_pro_atto_assenso
       f_provincia_stato_al(dpa.atto_assenso_cod_pro,dpa.atto_assenso_cod_com,'','S','','') sigla_pro_atto_assenso,
-- des_com_impedimento_eta
       f_comune_al(dpa.impedimento_eta_cod_pro,dpa.impedimento_eta_cod_com,'') des_com_impedimento_eta,
-- sigla_pro_impedimento_eta
       f_provincia_stato_al(dpa.impedimento_eta_cod_pro,dpa.impedimento_eta_cod_com,'','S','','') sigla_pro_impedimento_eta,
-- des_com_impedimento_par
       f_comune_al(dpa.impedimento_par_cod_pro,dpa.impedimento_par_cod_com,'') des_com_impedimento_par,
-- sigla_pro_impedimento_par
       f_provincia_stato_al(dpa.impedimento_par_cod_pro,dpa.impedimento_par_cod_com,'','S','','') sigla_pro_impedimento_par,
-- des_com_impedimento_tmp
       f_comune_al(dpa.impedimento_tmp_cod_pro,dpa.impedimento_tmp_cod_com,'') des_com_impedimento_tmp,
-- sigla_pro_impedimento_tmp
       f_provincia_stato_al(dpa.impedimento_tmp_cod_pro,dpa.impedimento_tmp_cod_com,'','S','','') sigla_pro_impedimento_tmp,
-- des_com_separazione_conf
       f_comune_al(dpa.separazione_conf_cod_pro,dpa.separazione_conf_cod_com,'') des_com_separazione_conf,
-- sigla_pro_separazione_conf
       f_provincia_stato_al(dpa.separazione_conf_cod_pro,dpa.separazione_conf_cod_com,'','S','','') sigla_pro_separazione_conf,
-- des_com_accertamento
       f_comune_al(dpa.accertamento_cod_pro,dpa.accertamento_cod_com,'') des_com_accertamento,
-- sigla_pro_accertamento
       f_provincia_stato_al(dpa.accertamento_cod_pro,dpa.accertamento_cod_com,'','S','','') sigla_pro_accertamento,
-- des_com_giuramento
       f_comune_al(dpa.giuramento_cod_pro,dpa.giuramento_cod_com,'') des_com_giuramento,
-- sigla_pro_giuramento
       f_provincia_stato_al(dpa.giuramento_cod_pro,dpa.giuramento_cod_com,'','S','','') sigla_pro_giuramento,
-- des_com_certificato_uci
       f_comune_al(dpa.certificato_uci_cod_pro,dpa.certificato_uci_cod_com,'') des_com_certificato_uci,
-- sigla_pro_certificato_uci
       f_provincia_stato_al(dpa.certificato_uci_cod_pro,dpa.certificato_uci_cod_com,'','S','','') sigla_pro_certificato_uci
  FROM civdpa dpa
/
comment on table CIVDPA_V is 'Stato Civile - Composizione: Dati di Provenienza dell''Atto (view)'
/
