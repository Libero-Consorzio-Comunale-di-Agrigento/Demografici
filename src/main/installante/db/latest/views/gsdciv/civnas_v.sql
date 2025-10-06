--liquibase formatted sql
--changeset amonopoli:202303031650 runAlways:true runOnChange:true stripComments:false
create or replace view civnas_v
as
SELECT nas.*,
-- des_com_nas
       f_comune_al(nas.cod_pro_nas,nas.cod_com_nas,nas.data_nas) des_com_nas,
-- sigla_pro_nas
       f_provincia_stato_al(nas.cod_pro_nas,nas.cod_com_nas,'','S','',nas.data_nas) sigla_pro_nas,
-- des_com_res
       f_comune_al(nas.cod_pro_res,nas.cod_com_res,nas.data_nas) des_com_res,
-- sigla_pro_res
       f_provincia_stato_al(nas.cod_pro_res,nas.cod_com_res,'','S','',nas.data_nas) sigla_pro_res,
-- des_com_nas_pd
       f_comune_al(nas.cod_pro_nas_pd,nas.cod_com_nas_pd,to_char(nas.d_data_nas_pd,'j')) des_com_nas_pd,
-- sigla_pro_nas_pd
       f_provincia_stato_al(nas.cod_pro_nas_pd,nas.cod_com_nas_pd,'','S','',to_char(nas.d_data_nas_pd,'j')) sigla_pro_nas_pd,
-- des_com_res_pd
       f_comune_al(nas.cod_pro_res_pd,nas.cod_com_res_pd,nas.data_nas) des_com_res_pd,
-- sigla_pro_res_pd
       f_provincia_stato_al(nas.cod_pro_res_pd,nas.cod_com_res_pd,'','S','',nas.data_nas) sigla_pro_res_pd,
-- des_com_nas_md
       f_comune_al(nas.cod_pro_nas_md,nas.cod_com_nas_md,to_char(nas.d_data_nas_md,'j')) des_com_nas_md,
-- sigla_pro_nas_md
       f_provincia_stato_al(nas.cod_pro_nas_md,nas.cod_com_nas_md,'','S','',to_char(nas.d_data_nas_md,'j')) sigla_pro_nas_md,
-- des_com_res_md
       f_comune_al(nas.cod_pro_res_md,nas.cod_com_res_md,nas.data_nas) des_com_res_md,
-- sigla_pro_res_md
       f_provincia_stato_al(nas.cod_pro_res_md,nas.cod_com_res_md,'','S','',nas.data_nas) sigla_pro_res_md,
-- flag_com_in_sospeso
       f_CIV_flag_com_in_sospeso(2,nas.ufficio,nas.anno,nas.parte,nas.serie,nas.atto) flag_com_in_sospeso,
-- cognome_lista
       decode(nas.natura,'N','*** ANNULLATO',nas.cognome) 	cognome_1_lista,
-- nome_lista
       decode(nas.natura,'N','',nas.nome) 			nome_1_lista,
-- sesso_lista
       decode(nas.natura,'N','',nas.sesso) 			sesso_1_lista,
-- d_data_nas_lista
       decode(nas.natura,'N',to_date(null),nas.d_data_nas) 	d_data_evento_lista,
-- flag_residente
       decode(f_get_comune_cliente('COD_COMUNE'),lpad(nas.cod_pro_res,3,'0')||lpad(nas.cod_com_res,3,'0'),'S','N') flag_residente,
-- flag_nel_comune
       decode(f_get_comune_cliente('COD_COMUNE'),lpad(nas.cod_pro_nas,3,'0')||lpad(nas.cod_com_nas,3,'0'),'S','N') flag_evento_nel_comune,
-- flag_modello_p4
       f_CIV_flag_modello_istat('P4',nas.id_atto) flag_modello_p4,
-- flag_firmato_usc_ansc
       f_ANSC_flag_firmato('NAS', nas.id, 'USC') flag_firmato_usc_ansc
  FROM civnas nas
 WHERE nas.cod_rec in (0,3)
/
comment on table civnas_v is 'Stato Civile - Atti di Nascita (view)'
/
