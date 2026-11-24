--liquibase formatted sql
--changeset vmigliore:202502121300 runAlways:true runOnChange:true stripComments:false
create or replace view anamov_v
AS
select mov.*
--
     , f_MOV_descrizione_evento(mov.anno_progr,mov.numero_progr) des_evento
--
     , decode(mov.rapporto_par_prec, '', to_char(null),
         decode(nvl(mov.sesso_prec,mov.sesso), '', to_char(null),
           nvl(mov.sesso_prec,mov.sesso)||mov.rapporto_par_prec)) id_anadrp_prec
     , decode(mov.cod_prof_prec, '', to_char(null),
         decode(nvl(mov.sesso_prec,mov.sesso), '', to_char(null),
           nvl(mov.sesso_prec,mov.sesso)||lpad(mov.cod_prof_prec,5,'0'))) id_anadpr_prec
     , decode(mov.rapporto_par, '', to_char(null),
         decode(mov.sesso, '', to_char(null),
           mov.sesso||mov.rapporto_par)) id_anadrp
     , decode(mov.cod_prof, '', to_char(null),
         decode(mov.sesso, '', to_char(null),
           mov.sesso||lpad(mov.cod_prof,5,'0'))) id_anadpr
--
     , f_get_descrizione_DSC(mov.stato_civile_prec,mov.sesso_prec,'','','') des_stato_civile_prec
     , f_get_descrizione_DSC(mov.stato_civile,mov.sesso,'','','') des_stato_civile
--
     , f_cognome(mov.cognome_nome_prec) cognome_prec
     , f_nome(mov.cognome_nome_prec) nome_prec
     , f_cognome(mov.paternita_prec) cognome_pd_prec
     , f_nome(mov.paternita_prec) nome_pd_prec
     , f_cognome(mov.maternita_prec) cognome_md_prec
     , f_nome(mov.maternita_prec) nome_md_prec
     , f_cognome(mov.cognome_nome_cn_prec) cognome_cn_prec
     , f_nome(mov.cognome_nome_cn_prec) nome_cn_prec
     , f_cognome(mov.intestatario_prec) cognome_intestatario_prec
     , f_nome(mov.intestatario_prec) nome_intestatario_prec
     , f_cognome(mov.cognome_nome) cognome
     , f_nome(mov.cognome_nome) nome
     , f_cognome(mov.paternita) cognome_pd
     , f_nome(mov.paternita) nome_pd
     , f_cognome(mov.maternita) cognome_md
     , f_nome(mov.maternita) nome_md
     , f_cognome(mov.cognome_nome_cn) cognome_cn
     , f_nome(mov.cognome_nome_cn) nome_cn
     , f_cognome(mov.intestatario) cognome_intestatario
     , f_nome(mov.intestatario) nome_intestatario
--
     , f_comune_al(mov.COD_PRO_EVE,mov.COD_COM_EVE,'') des_com_eve
     , decode(mov.cod_mov, 97, 'S', 98, 'S') flag_solo_campi_variati
--
     , f_provincia_stato_al(mov.COD_PRO_EVE,mov.COD_COM_EVE,'','S','','') sigla_pro_eve
     , f_comune_al(mov.COD_PRO_AIRE_PREC,mov.COD_COM_AIRE_PREC,'') des_com_aire_prec
     , f_provincia_stato_al(mov.COD_PRO_AIRE_PREC,mov.COD_COM_AIRE_PREC,'','S','','') sigla_pro_aire_prec
     , f_comune_al(mov.COD_PRO_NAS_PREC,mov.COD_COM_NAS_PREC,mov.data_nas_prec) des_com_nas_prec
     , f_provincia_stato_al(mov.COD_PRO_NAS_PREC,mov.COD_COM_NAS_PREC,'','S','',mov.data_nas_prec) sigla_pro_nas_prec
     , f_comune_al(mov.COD_PRO_MAT_PREC,mov.COD_COM_MAT_PREC,mov.data_mat_prec) des_com_mat_prec
     , f_provincia_stato_al(mov.COD_PRO_MAT_PREC,mov.COD_COM_MAT_PREC,'','S','',mov.data_mat_prec) sigla_pro_mat_prec
     , f_comune_al(mov.COD_PRO_VED_PREC,mov.COD_COM_VED_PREC,mov.data_ved) des_com_ved_prec
     , f_provincia_stato_al(mov.COD_PRO_VED_PREC,mov.COD_COM_VED_PREC,'','S','',mov.data_ved_prec) sigla_pro_ved_prec
     , f_comune_al(mov.COD_PRO_DIV_PREC,mov.COD_COM_DIV_PREC,mov.data_div_prec) des_com_div_prec
     , f_provincia_stato_al(mov.COD_PRO_DIV_PREC,mov.COD_COM_DIV_PREC,'','S','',mov.data_div_prec) sigla_pro_div_prec
     , f_comune_al(mov.COD_PRO_MOR_PREC,mov.COD_COM_MOR_PREC,mov.data_mor_prec) des_com_mor_prec
     , f_provincia_stato_al(mov.COD_PRO_MOR_PREC,mov.COD_COM_MOR_PREC,'','S','',mov.data_mor_prec) sigla_pro_mor_prec
     , f_comune_al(mov.COD_PRO_ATTO_NAS_PREC,mov.COD_COM_ATTO_NAS_PREC,'') des_com_atto_nas_prec
     , f_provincia_stato_al(mov.COD_PRO_ATTO_NAS_PREC,mov.COD_COM_ATTO_NAS_PREC,'','S','','') sigla_pro_atto_nas_prec
     , f_comune_al(mov.COD_PRO_ATTO_MAT_PREC,mov.COD_COM_ATTO_MAT_PREC,'') des_com_atto_mat_prec
     , f_provincia_stato_al(mov.COD_PRO_ATTO_MAT_PREC,mov.COD_COM_ATTO_MAT_PREC,'','S','','') sigla_pro_atto_mat_prec
     , f_comune_al(mov.COD_PRO_ATTO_VED_PREC,mov.COD_COM_ATTO_VED_PREC,'') des_com_atto_ved_prec
     , f_provincia_stato_al(mov.COD_PRO_ATTO_VED_PREC,mov.COD_COM_ATTO_VED_PREC,'','S','','') sigla_pro_atto_ved_prec
     , f_comune_al(mov.COD_PRO_ATTO_DIV_PREC,mov.COD_COM_ATTO_DIV_PREC,'') des_com_atto_div_prec
     , f_provincia_stato_al(mov.COD_PRO_ATTO_DIV_PREC,mov.COD_COM_ATTO_DIV_PREC,'','S','','') sigla_pro_atto_div_prec
     , f_comune_al(mov.COD_PRO_ATTO_MOR_PREC,mov.COD_COM_ATTO_MOR_PREC,'') des_com_atto_mor_prec
     , f_provincia_stato_al(mov.COD_PRO_ATTO_MOR_PREC,mov.COD_COM_ATTO_MOR_PREC,'','S','','') sigla_pro_atto_mor_prec
     , f_comune_al(mov.COD_PRO_AIRE,mov.COD_COM_AIRE,'') des_com_aire
     , f_provincia_stato_al(mov.COD_PRO_AIRE,mov.COD_COM_AIRE,'','S','','') sigla_pro_aire
     , f_comune_al(mov.COD_PRO_NAS,mov.COD_COM_NAS,mov.data_nas) des_com_nas
     , f_provincia_stato_al(mov.COD_PRO_NAS,mov.COD_COM_NAS,'','S','',mov.data_nas) sigla_pro_nas
     , f_comune_al(mov.COD_PRO_MAT,mov.COD_COM_MAT,mov.data_mat) des_com_mat
     , f_provincia_stato_al(mov.COD_PRO_MAT,mov.COD_COM_MAT,'','S','',mov.data_mat) sigla_pro_mat
     , f_comune_al(mov.COD_PRO_VED,mov.COD_COM_VED,mov.data_ved) des_com_ved
     , f_provincia_stato_al(mov.COD_PRO_VED,mov.COD_COM_VED,'','S','',mov.data_ved) sigla_pro_ved
     , f_comune_al(mov.COD_PRO_DIV,mov.COD_COM_DIV,mov.data_div) des_com_div
     , f_provincia_stato_al(mov.COD_PRO_DIV,mov.COD_COM_DIV,'','S','',mov.data_div) sigla_pro_div
     , f_comune_al(mov.COD_PRO_MOR,mov.COD_COM_MOR,mov.data_mor) des_com_mor
     , f_provincia_stato_al(mov.COD_PRO_MOR,mov.COD_COM_MOR,'','S','',mov.data_mor) sigla_pro_mor
     , f_comune_al(mov.COD_PRO_ATTO_NAS,mov.COD_COM_ATTO_NAS,'') des_com_atto_nas
     , f_provincia_stato_al(mov.COD_PRO_ATTO_NAS,mov.COD_COM_ATTO_NAS,'','S','','') sigla_pro_atto_nas
     , f_comune_al(mov.COD_PRO_ATTO_MAT,mov.COD_COM_ATTO_MAT,'') des_com_atto_mat
     , f_provincia_stato_al(mov.COD_PRO_ATTO_MAT,mov.COD_COM_ATTO_MAT,'','S','','') sigla_pro_atto_mat
     , f_comune_al(mov.COD_PRO_ATTO_VED,mov.COD_COM_ATTO_VED,'') des_com_atto_ved
     , f_provincia_stato_al(mov.COD_PRO_ATTO_VED,mov.COD_COM_ATTO_VED,'','S','','') sigla_pro_atto_ved
     , f_comune_al(mov.COD_PRO_ATTO_DIV,mov.COD_COM_ATTO_DIV,'') des_com_atto_div
     , f_provincia_stato_al(mov.COD_PRO_ATTO_DIV,mov.COD_COM_ATTO_DIV,'','S','','') sigla_pro_atto_div
     , f_comune_al(mov.COD_PRO_ATTO_MOR,mov.COD_COM_ATTO_MOR,'') des_com_atto_mor
     , f_provincia_stato_al(mov.COD_PRO_ATTO_MOR,mov.COD_COM_ATTO_MOR,'','S','','') sigla_pro_atto_mor
     , f_comune_al(mov.COD_PRO_ISCR_AIRE,mov.COD_COM_ISCR_AIRE,'') des_com_iscr_aire
     , f_provincia_stato_al(mov.COD_PRO_ISCR_AIRE,mov.COD_COM_ISCR_AIRE,'','S','','') sigla_pro_iscr_aire
--
     , to_date(mov.DATA_EVE,'j') d_data_eve
     , to_date(mov.DATA_INIZIO_FAM,'j') d_data_inizio_fam
     , to_date(mov.DATA_INIZIO_RES,'j') d_data_inizio_res
     , to_date(mov.DATA_REG,'j') d_data_reg
     , to_date(mov.DATA_NAS_PREC,'j') d_data_nas_prec
     , to_date(mov.DATA_MAT_PREC,'j') d_data_mat_prec
     , to_date(mov.DATA_VED_PREC,'j') d_data_ved_prec
     , to_date(mov.DATA_DIV_PREC,'j') d_data_div_prec
     , to_date(mov.DATA_DIV_GIU_PREC,'j') d_data_div_giu_prec
     , to_date(mov.DATA_DIV_ANN_PREC,'j') d_data_div_ann_prec
     , to_date(mov.DATA_MOR_PREC,'j') d_data_mor_prec
     , to_date(mov.DATA_INIZIO_NAZ_PREC,'j') d_data_inizio_naz_prec
     , to_date(mov.DATA_NAS,'j') d_data_nas
     , to_date(mov.DATA_MAT,'j') d_data_mat
     , to_date(mov.DATA_VED,'j') d_data_ved
     , to_date(mov.DATA_DIV,'j') d_data_div
     , to_date(mov.DATA_DIV_GIU,'j') d_data_div_giu
     , to_date(mov.DATA_DIV_ANN,'j') d_data_div_ann
     , to_date(mov.DATA_MOR,'j') d_data_mor
     , to_date(mov.DATA_INIZIO_NAZ,'j') d_data_inizio_naz
--
     , to_char(null) COD_CONSOLATO_AIRE_PREC
     , to_char(null) SEDE_CONSOLATO_AIRE_PREC
     , to_char(null) COD_CONSOLATO_AIRE
     , to_char(null) SEDE_CONSOLATO_AIRE
--
     , mov.anno_progr||lpad(mov.numero_progr,6,'0') ID
  from anamov mov
 where mov.MATRICOLA is not null
   and mov.COD_MOV is not null
   and mov.COD_EVE is not null
/
comment on table anamov_v is 'Anagrafe - Archivio Movimenti (view)'
/
