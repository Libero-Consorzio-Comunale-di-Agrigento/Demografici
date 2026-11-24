--liquibase formatted sql
--changeset snocca:202211141527 runOnChange:true stripComments:false
create or replace view anaana_v as
select /*+ PUSH_SUBQ*/
       ana.*
--
     , f_ANA_get_anagrafe(ana.fascia) anagrafe
--
     , f_comune_al(ana.cod_pro_nas,ana.cod_com_nas,ana.data_nas) des_com_nas
     , f_provincia_stato_al(ana.cod_pro_nas,ana.cod_com_nas,'','S','',ana.data_nas) sigla_pro_nas
     , f_comune_al(ana.cod_pro_atto_nas,ana.cod_com_atto_nas,
         f_ANPR_data_atto_rif(2,ana.cod_pro_atto_nas,ana.cod_com_atto_nas,ana.cod_pro_nas,ana.cod_com_nas,ana.data_nas,ana.anno_atto_nas)) des_com_atto_nas
     , f_provincia_stato_al(ana.cod_pro_atto_nas,ana.cod_com_atto_nas,'','S','',
         f_ANPR_data_atto_rif(2,ana.cod_pro_atto_nas,ana.cod_com_atto_nas,ana.cod_pro_nas,ana.cod_com_nas,ana.data_nas,ana.anno_atto_nas)) sigla_pro_atto_nas
     , decode(ana.atto_nas_tr,'','',to_number(f_get_comune_cliente('COD_PRO'))) cod_pro_atto_nas_tr
     , decode(ana.atto_nas_tr,'','',to_number(f_get_comune_cliente('COD_COM'))) cod_com_atto_nas_tr
     , decode(ana.atto_nas_tr,'','',f_get_comune_cliente('DES_COM')) des_com_atto_nas_tr
     , decode(ana.atto_nas_tr,'','',f_get_comune_cliente('SIGLA_PRO')) sigla_pro_atto_nas_tr
--
     , f_comune_al(ana.cod_pro_mat,ana.cod_com_mat,ana.data_mat) des_com_mat
     , f_provincia_stato_al(ana.cod_pro_mat,ana.cod_com_mat,'','S','',ana.data_mat) sigla_pro_mat
     , f_comune_al(ana.cod_pro_atto_mat,ana.cod_com_atto_mat,
         f_ANPR_data_atto_rif(4,ana.cod_pro_atto_mat,ana.cod_com_atto_mat,ana.cod_pro_mat,ana.cod_com_mat,ana.data_mat,ana.anno_atto_mat)) des_com_atto_mat
     , f_provincia_stato_al(ana.cod_pro_atto_mat,ana.cod_com_atto_mat,'','S','',
         f_ANPR_data_atto_rif(4,ana.cod_pro_atto_mat,ana.cod_com_atto_mat,ana.cod_pro_mat,ana.cod_com_mat,ana.data_mat,ana.anno_atto_mat)) sigla_pro_atto_mat
     , decode(ana.atto_mat_tr,'','',to_number(f_get_comune_cliente('COD_PRO'))) cod_pro_atto_mat_tr
     , decode(ana.atto_mat_tr,'','',to_number(f_get_comune_cliente('COD_COM'))) cod_com_atto_mat_tr
     , decode(ana.atto_mat_tr,'','',f_get_comune_cliente('DES_COM')) des_com_atto_mat_tr
     , decode(ana.atto_mat_tr,'','',f_get_comune_cliente('SIGLA_PRO')) sigla_pro_atto_mat_tr
--
     , f_comune_al(ana.cod_pro_ved,ana.cod_com_ved,ana.data_ved) des_com_ved
     , f_provincia_stato_al(ana.cod_pro_ved,ana.cod_com_ved,'','S','',ana.data_ved) sigla_pro_ved
     , f_comune_al(ana.cod_pro_atto_ved,ana.cod_com_atto_ved,
         f_ANPR_data_atto_rif(5,ana.cod_pro_atto_ved,ana.cod_com_atto_ved,ana.cod_pro_ved,ana.cod_com_ved,ana.data_ved,ana.anno_atto_ved)) des_com_atto_ved
     , f_provincia_stato_al(ana.cod_pro_atto_ved,ana.cod_com_atto_ved,'','S','',
         f_ANPR_data_atto_rif(5,ana.cod_pro_atto_ved,ana.cod_com_atto_ved,ana.cod_pro_ved,ana.cod_com_ved,ana.data_ved,ana.anno_atto_ved)) sigla_pro_atto_ved
--
     , f_comune_al(ana.cod_pro_div,ana.cod_com_div,ana.data_div) des_com_div
     , f_provincia_stato_al(ana.cod_pro_div,ana.cod_com_div,'','S','',ana.data_div) sigla_pro_div
     , f_comune_al(ana.cod_pro_atto_div,ana.cod_com_atto_div,
         f_ANPR_data_atto_rif(4,ana.cod_pro_atto_div,ana.cod_com_atto_div,ana.cod_pro_div,ana.cod_com_div,ana.data_div,ana.anno_atto_div)) des_com_atto_div
     , f_provincia_stato_al(ana.cod_pro_atto_div,ana.cod_com_atto_div,'','S','',
         f_ANPR_data_atto_rif(4,ana.cod_pro_atto_div,ana.cod_com_atto_div,ana.cod_pro_div,ana.cod_com_div,ana.data_div,ana.anno_atto_div)) sigla_pro_atto_div
--
     , f_comune_al(ana.cod_pro_mor,ana.cod_com_mor,ana.data_mor) des_com_mor
     , f_provincia_stato_al(ana.cod_pro_mor,ana.cod_com_mor,'','S','',ana.data_mor) sigla_pro_mor
     , f_comune_al(ana.cod_pro_atto_mor, ana.cod_com_atto_mor,
         f_ANPR_data_atto_rif(5,ana.cod_pro_atto_mor,ana.cod_com_atto_mor,ana.cod_pro_mor,ana.cod_com_mor,ana.data_mor,ana.anno_atto_mor)) des_com_atto_mor
     , f_provincia_stato_al(ana.cod_pro_atto_mor, ana.cod_com_atto_mor, '', 'S', '',
         f_ANPR_data_atto_rif(5,ana.cod_pro_atto_mor,ana.cod_com_atto_mor,ana.cod_pro_mor,ana.cod_com_mor,ana.data_mor,ana.anno_atto_mor)) sigla_pro_atto_mor
     , decode(ana.atto_mor_tr,'','',to_number(f_get_comune_cliente('COD_PRO'))) cod_pro_atto_mor_tr
     , decode(ana.atto_mor_tr,'','',to_number(f_get_comune_cliente('COD_COM'))) cod_com_atto_mor_tr
     , decode(ana.atto_mor_tr,'','',f_get_comune_cliente('DES_COM')) des_com_atto_mor_tr
     , decode(ana.atto_mor_tr,'','',f_get_comune_cliente('SIGLA_PRO')) sigla_pro_atto_mor_tr
--
     , f_get_descrizione_DSC(ana.stato_civile,ana.sesso,'','','') des_stato_civile
     , f_get_descrizione_DCI(ana.nazionalita,'') des_nazionalita
     , decode(ana.cod_prof, '', to_char(null), ana.sesso||lpad(ana.cod_prof,5,'0')) id_anadpr
     , f_get_descrizione_DPR(ana.cod_prof,ana.sesso) des_cod_prof
     , decode(ana.rapporto_par, '', '', ana.sesso||ana.rapporto_par) id_anadrp
     , f_get_descrizione_DRP(ana.rapporto_par,ana.sesso) des_rapporto_par
     , f_get_descrizione_DTS(ana.titolo_studio) des_titolo_studio
--
     , to_number(null) ist_np_NB
     , to_number(null) ist_ts_NB
--
     , f_domicilio_digitale(ana.matricola) domicilio_digitale
--
     , to_number(decode(ana.fascia,
         1, f_get_comune_cliente('COD_PRO'),
         2, f_get_comune_cliente('COD_PRO'),
         3, f_get_campo_FAM(ana.cod_fam_unique,'COD_PRO_AIRE'),
         4, f_get_campo_FAM(ana.cod_fam_unique,'COD_PRO_AIRE'),
         6, f_get_campo_FAM(ana.cod_fam_unique,'COD_PRO_RES'))) cod_pro_res
     , to_number(decode(ana.fascia,
         1, f_get_comune_cliente('COD_COM'),
         2, f_get_comune_cliente('COD_COM'),
         3, f_get_campo_FAM(ana.cod_fam_unique,'COD_COM_AIRE'),
         4, f_get_campo_FAM(ana.cod_fam_unique,'COD_COM_AIRE'),
         6, f_get_campo_FAM(ana.cod_fam_unique,'COD_COM_RES'))) cod_com_res
     , decode(ana.fascia,
         1, f_get_comune_cliente('DES_COM'),
         2, f_get_comune_cliente('DES_COM'),
         3, f_get_campo_FAM(ana.cod_fam_unique,'DES_COM_AIRE'),
         4, f_get_campo_FAM(ana.cod_fam_unique,'DES_COM_AIRE'),
         6, f_get_campo_FAM(ana.cod_fam_unique,'DES_COM_RES')) des_com_res
     , decode(ana.fascia,
         1, f_get_comune_cliente('SIGLA_PRO'),
         2, f_get_comune_cliente('SIGLA_PRO'),
         3, f_get_campo_FAM(ana.cod_fam_unique,'SIGLA_PRO_AIRE'),
         4, f_get_campo_FAM(ana.cod_fam_unique,'SIGLA_PRO_AIRE'),
         6, f_get_campo_FAM(ana.cod_fam_unique,'SIGLA_PRO_RES')) sigla_pro_res
     , decode(ana.fascia,
         1, f_get_campo_FAM(ana.cod_fam_unique,'INDIRIZZO_COMPLETO_INT'),
         2, f_indirizzo_ana(ana.cod_fam,ana.fascia,ana.data_ult_eve,ana.matricola,'INDIRIZZO_COMPLETO'),
         3, f_get_campo_FAM(ana.cod_fam_unique,'VIA_AIRE'),
         4, f_indirizzo_ana(ana.cod_fam,ana.fascia,ana.data_ult_eve,ana.matricola,'INDIRIZZO_COMPLETO') ,
         6, f_get_campo_FAM(ana.cod_fam_unique,'VIA_RES')) indirizzo_res
     , decode(ana.fascia,
         1, f_get_campo_FAM(ana.cod_fam_unique,'CAP'),
         2, f_get_campo_FAM(ana.cod_fam_unique,'CAP'),
         3, f_get_campo_FAM(ana.cod_fam_unique,'ZIPCODE'),
         4, f_get_campo_FAM(ana.cod_fam_unique,'ZIPCODE'),
         5, f_get_campo_FAM(ana.cod_fam_unique,'CAP'),
         6, f_get_campo_FAM(ana.cod_fam_unique,'CAP')) cap_res
     , decode(ana.fascia,
         3, f_get_campo_FAM(ana.cod_fam_unique,'PROVINCIA_CONTEA'),
         4, f_get_campo_FAM(ana.cod_fam_unique,'PROVINCIA_CONTEA')) provincia_contea_air
     , decode(ana.fascia,
         3, f_get_campo_FAM(ana.cod_fam_unique,'PRESSO'),
         4, f_get_campo_FAM(ana.cod_fam_unique,'PRESSO')) presso_air
     , decode(ana.fascia,
         3, f_get_campo_FAM(ana.cod_fam_unique,'CODICE_CONSOLATO'),
         4, f_get_campo_FAM(ana.cod_fam_unique,'CODICE_CONSOLATO')) cod_consolato_air
     , decode(ana.fascia,
         3, f_get_campo_FAM(ana.cod_fam_unique,'SEDE_CONSOLATO'),
         4, f_get_campo_FAM(ana.cod_fam_unique,'SEDE_CONSOLATO')) sede_consolato_air
     , decode(ana.fascia,
         1, decode(f_get_campo_FAM(ana.cod_fam_unique,'FLAG_SENZA_FISSA_DIMORA'),'S','S')) flag_senza_fissa_dimora
     , decode(ana.fascia,
         1, f_get_campo_NCO(ana.fascia,ana.cod_fam,'FLAG_COABITANTE')) flag_nucleo_coabitante
     , decode(ana.fascia,
         1, f_get_campo_NCO(ana.fascia,ana.cod_fam,'COD_FAM_UNIQUE')) cod_fam_unique_coabitante
     , decode(ana.fascia,
         1, f_get_campo_DCE('RES','I',ana.fascia,ana.stato,'','DESCRIZIONE_'||ana.sesso),
         2, f_get_campo_DCE('RES','C',ana.fascia,ana.stato,'','DESCRIZIONE_'||ana.sesso),
         3, f_get_campo_DCE('AIR','I',ana.fascia,ana.stato,'','DESCRIZIONE_'||ana.sesso),
         4, f_get_campo_DCE('AIR','C',ana.fascia,ana.stato,'','DESCRIZIONE_'||ana.sesso),
         5, f_get_campo_DCE('RES','',ana.fascia,ana.stato,'','DESCRIZIONE_'||ana.sesso),
         6, f_get_campo_DCE('NRE','',ana.fascia,ana.stato,'','DESCRIZIONE_'||ana.sesso)) des_stato_ana
--
     , f_get_campo_DI(ana.matricola,'TIPO_DOCUMENTO') tipo_DI
     , f_get_campo_DI(ana.matricola,'NUMERO') numero_DI
     , f_get_campo_DI(ana.matricola,'DATA_EMISSIONE') data_emissione_DI
     , to_date(f_get_campo_DI(ana.matricola,'DATA_EMISSIONE'),'j') d_data_emissione_DI
     , f_get_campo_DI(ana.matricola, 'DATA_SCADENZA') data_scadenza_DI
     , to_date(f_get_campo_DI(ana.matricola, 'DATA_SCADENZA'),'j') d_data_scadenza_DI
     , f_get_campo_DI(ana.matricola,'COD_PRO_ENTE') cod_pro_ente_DI
     , f_get_campo_DI(ana.matricola,'COD_COM_ENTE') cod_com_ente_DI
     , f_get_campo_DI(ana.matricola,'DES_COM_ENTE') des_com_ente_DI
     , f_get_campo_DI(ana.matricola,'SIGLA_PRO_ENTE') sigla_pro_ente_DI
     , decode(f_get_campo_DI(ana.matricola,'VAL_ESPATRIO'),'S','S') flag_val_espatrio_DI
--
     , f_get_campo_DS(ana.matricola,'TIPO_DOCUMENTO') tipo_DS
     , f_get_campo_DS(ana.matricola,'NUMERO') numero_DS
     , f_get_campo_DS(ana.matricola,'DATA_EMISSIONE') data_emissione_DS
     , to_date(f_get_campo_DS(ana.matricola,'DATA_EMISSIONE'),'j') d_data_emissione_DS
     , f_get_campo_DS(ana.matricola, 'DATA_SCADENZA') data_scadenza_DS
     , to_date(f_get_campo_DS(ana.matricola, 'DATA_SCADENZA'),'j') d_data_scadenza_DS
     , f_get_campo_DS(ana.matricola,'COD_PRO_ENTE') cod_pro_ente_DS
     , f_get_campo_DS(ana.matricola,'COD_COM_ENTE') cod_com_ente_DS
     , f_get_campo_DS(ana.matricola,'DES_COM_ENTE') des_com_ente_DS
     , f_get_campo_DS(ana.matricola,'SIGLA_PRO_ENTE') sigla_pro_ente_DS
     , f_get_campo_DS(ana.matricola,'FLAG_SCADENZA_ILLIMITATA') flag_scadenza_illimitata_DS
--
     , f_get_campo_CDF_x_matricola(ana.matricola,'COD_CDF') cod_cdf
     , f_get_campo_CDF_x_matricola(ana.matricola,'ID') id_anacdf
--
     , f_flag_data_convenzionale(ana.matricola,11,ana.data_inizio_res) flag_data_convenzionale_RES
     , f_flag_data_convenzionale(ana.matricola,10,ana.data_inizio_fam) flag_data_convenzionale_FAM
--
     , f_ANPR_id_scheda(ana.matricola,'','','','','') id_soggetto_anpr
     , f_ANPR_id_unico(ana.matricola,'') id_unico_anpr
     , to_number(null) id_famiglia_anpr
     , to_number(null) tipo_scheda_anpr
     , f_TPR_enable_soggetto('RES','I',ana.fascia, ana.stato, '', '', 'ANA') flag_TPR_enable_RES_I
     , f_TPR_enable_soggetto('RES','E',ana.fascia, ana.stato, '', '', 'ANA') flag_TPR_enable_RES_E
     , f_TPR_enable_soggetto('RES','C',ana.fascia, ana.stato, '', '', 'ANA') flag_TPR_enable_RES_C
     , f_TPR_enable_soggetto('RES','R',ana.fascia, ana.stato, '', '', 'ANA') flag_TPR_enable_RES_R
     , f_TPR_enable_soggetto('AIR','I',ana.fascia, ana.stato, '', '', 'ANA') flag_TPR_enable_AIR_I
     , f_TPR_enable_soggetto('AIR','E',ana.fascia, ana.stato, '', '', 'ANA') flag_TPR_enable_AIR_E
     , f_TPR_enable_soggetto('AIR','C',ana.fascia, ana.stato, '', '', 'ANA') flag_TPR_enable_AIR_C
     , f_TPR_enable_soggetto('AIR','R',ana.fascia, ana.stato, '', '', 'ANA') flag_TPR_enable_AIR_R
     , f_ANA_esiste_DOC(ana.matricola,'PT') flag_esiste_DOC_PT
     , f_ANA_esiste_DOC(ana.matricola,'CC') flag_esiste_DOC_CC
  from anaana ana
/
comment on table ANAANA_V is 'Anagrafe - Soggetti (view)'
/
