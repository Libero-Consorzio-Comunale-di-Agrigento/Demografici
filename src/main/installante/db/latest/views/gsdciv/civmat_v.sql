--liquibase formatted sql
--changeset amonopoli:202303211326 runAlways:true runOnChange:true stripComments:false
create or replace view civmat_v
as
SELECT mat.*,
-- des_com_nas_m
       f_comune_al(mat.cod_pro_nas_m,mat.cod_com_nas_m,mat.data_nas_m) des_com_nas_m,
-- sigla_pro_nas_m
       f_provincia_stato_al(mat.cod_pro_nas_m,mat.cod_com_nas_m,'','S','',mat.data_nas_m) sigla_pro_nas_m,
-- des_com_res_m
       f_comune_al(mat.cod_pro_res_m,mat.cod_com_res_m,mat.data_mat) des_com_res_m,
-- sigla_pro_res_m
       f_provincia_stato_al(mat.cod_pro_res_m,mat.cod_com_res_m,'','S','',mat.data_mat) sigla_pro_res_m,
-- des_com_nas_f
       f_comune_al(mat.cod_pro_nas_f,mat.cod_com_nas_f,mat.data_nas_f) des_com_nas_f,
-- sigla_pro_nas_f
       f_provincia_stato_al(mat.cod_pro_nas_f,mat.cod_com_nas_f,'','S','',mat.data_nas_f) sigla_pro_nas_f,
-- des_com_res_f
       f_comune_al(mat.cod_pro_res_f,mat.cod_com_res_f,mat.data_mat) des_com_res_f,
-- sigla_pro_res_f
       f_provincia_stato_al(mat.cod_pro_res_f,mat.cod_com_res_f,'','S','',mat.data_mat) sigla_pro_res_f,
-- des_com_mat
       f_comune_al(mat.cod_pro_mat,mat.cod_com_mat,mat.data_mat) des_com_mat,
-- sigla_pro_mat
       f_provincia_stato_al(mat.cod_pro_mat,mat.cod_com_mat,'','S','',mat.data_mat) sigla_pro_mat,
-- flag_com_in_sospeso
       f_CIV_flag_com_in_sospeso(4,mat.ufficio,mat.anno,mat.parte,mat.serie,mat.atto) flag_com_in_sospeso,
-- flag_divorzio
       decode(cta.id, '', decode(mat.parte||mat.serie||mat.natura,'2CD','S'), cta.flag_divorzio) flag_divorzio,
-- cognome_m_lista
       decode(mat.natura,'N','*** ANNULLATO',mat.cognome_m)	cognome_1_lista,
-- nome_m_lista
       decode(mat.natura,'N','',mat.nome_m)			nome_1_lista,
-- cognome_f_lista
       decode(mat.natura,'N','*** ANNULLATO',mat.cognome_f)	cognome_2_lista,
-- nome_f_lista
       decode(mat.natura,'N','',mat.nome_f)			nome_2_lista,
-- d_data_mat_lista
       decode(mat.natura,'N',to_date(null),mat.d_data_mat)	d_data_evento_lista,
-- flag_residente
       decode(f_get_comune_cliente('COD_COMUNE'),lpad(mat.cod_pro_res_m,3,'0')||lpad(mat.cod_com_res_m,3,'0'),'S',
         decode(f_get_comune_cliente('COD_COMUNE'),lpad(mat.cod_pro_res_f,3,'0')||lpad(mat.cod_com_res_f,3,'0'),'S','N')) flag_residente,
-- flag_nel_comune
       decode(f_get_comune_cliente('COD_COMUNE'),lpad(mat.cod_pro_mat,3,'0')||lpad(mat.cod_com_mat,3,'0'),'S','N') flag_evento_nel_comune,
-- flag_modello_d3
       f_CIV_flag_modello_istat('D3',mat.id_atto) flag_modello_d3,
-- flag_modello_sc
       CASE WHEN mat.anno < 2024  THEN f_CIV_flag_modello_istat('SC',mat.id_atto) ELSE NULL END flag_modello_sc,
-- flag_modello_sdsu
       CASE WHEN mat.anno >= 2024 THEN f_CIV_flag_modello_istat('SC',mat.id_atto) ELSE NULL END flag_modello_sdsu,
-- flag_firmato_usc_ansc
       f_ANSC_flag_firmato('MAT', mat.id, 'USC') flag_firmato_usc_ansc
  FROM civcta cta
     , civdta dta
     , civmat mat
 WHERE cta.id (+)          = dta.id_civcta
   and dta.id (+)          = mat.id_civdta
   and mat.cod_rec         in (0,3)
   and mat.natura          in ('O','T','D','N')
/
comment on table civmat_v is 'Stato Civile - Atti di Matrimonio (view)'
/
