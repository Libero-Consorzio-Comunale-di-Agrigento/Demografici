--liquibase formatted sql
--changeset amonopoli:202303211327 runAlways:true runOnChange:true stripComments:false
create or replace view civmor_v
as
SELECT mor.*,
-- des_stato_civile
       f_get_descrizione_DSC(mor.stato_civile,mor.sesso,'','','') des_stato_civile,
-- des_com_mor
       f_comune_al(mor.cod_pro_mor,mor.cod_com_mor,mor.data_mor) des_com_mor,
-- sigla_pro_mor
       f_provincia_stato_al(mor.cod_pro_mor,mor.cod_com_mor,'','S','',mor.data_mor) sigla_pro_mor,
-- des_com_nas
       f_comune_al(mor.cod_pro_nas,mor.cod_com_nas,mor.data_nas) des_com_nas,
-- sigla_pro_nas
       f_provincia_stato_al(mor.cod_pro_nas,mor.cod_com_nas,'','S','',mor.data_nas) sigla_pro_nas,
-- des_com_res
       f_comune_al(mor.cod_pro_res,mor.cod_com_res,mor.data_mor) des_com_res,
-- sigla_pro_res
       f_provincia_stato_al(mor.cod_pro_res,mor.cod_com_res,'','S','',mor.data_mor) sigla_pro_res,
-- des_com_nas_cn
       f_comune_al(mor.cod_pro_nas_cn,mor.cod_com_nas_cn,to_char(mor.d_data_nas_cn,'j')) des_com_nas_cn,
-- sigla_pro_nas_cn
       f_provincia_stato_al(mor.cod_pro_nas_cn,mor.cod_com_nas_cn,'','S','',to_char(mor.d_data_nas_cn,'j')) sigla_pro_nas_cn,
-- des_com_res_cn
       f_comune_al(mor.cod_pro_res_cn,mor.cod_com_res_cn,mor.data_mor) des_com_res_cn,
-- sigla_pro_res_cn
       f_provincia_stato_al(mor.cod_pro_res_cn,mor.cod_com_res_cn,'','S','',mor.data_mor) sigla_pro_res_cn,
-- flag_com_in_sospeso
       f_CIV_flag_com_in_sospeso(5,mor.ufficio,mor.anno,mor.parte,mor.serie,mor.atto) flag_com_in_sospeso,
-- cognome_lista
       decode(mor.natura,'N','*** ANNULLATO',mor.cognome) 	cognome_1_lista,
-- nome_lista
       decode(mor.natura,'N','',mor.nome) 			nome_1_lista,
-- sesso_lista
       decode(mor.natura,'N','',mor.sesso) 			sesso_1_lista,
-- d_data_mor_lista
       decode(mor.natura,'N',to_date(null),mor.d_data_mor) 	d_data_evento_lista,
-- flag_residente
       decode(f_get_comune_cliente('COD_COMUNE'),lpad(mor.cod_pro_res,3,'0')||lpad(mor.cod_com_res,3,'0'),'S','N') flag_residente,
-- flag_nel_comune
       decode(f_get_comune_cliente('COD_COMUNE'),lpad(mor.cod_pro_mor,3,'0')||lpad(mor.cod_com_mor,3,'0'),'S','N') flag_evento_nel_comune,
-- flag_modello_d4
       f_CIV_flag_modello_istat('D4',mor.id_atto) flag_modello_d4,
-- flag_modello_d4bis
       f_CIV_flag_modello_istat('D4BIS',mor.id_atto) flag_modello_d4bis,
-- flag_firmato_usc_ansc
       f_ANSC_flag_firmato('MOR', mor.id, 'USC') flag_firmato_usc_ansc
  FROM civmor mor
 WHERE mor.cod_rec in (0,3)
/
comment on table civmor_v is 'Stato Civile - Atti di Morte (view)'
/
