--liquibase formatted sql
--changeset amonopoli:202303211329 runAlways:true runOnChange:true stripComments:false
create or replace view civuci_v
as
SELECT uci.*,
-- des_com_nas_m
       f_comune_al(uci.cod_pro_nas_m,uci.cod_com_nas_m,uci.data_nas_m) des_com_nas_m,
-- sigla_pro_nas_m
       f_provincia_stato_al(uci.cod_pro_nas_m,uci.cod_com_nas_m,'','S','',uci.data_nas_m) sigla_pro_nas_m,
-- des_com_res_m
       f_comune_al(uci.cod_pro_res_m,uci.cod_com_res_m,uci.data_mat) des_com_res_m,
-- sigla_pro_res_m
       f_provincia_stato_al(uci.cod_pro_res_m,uci.cod_com_res_m,'','S','',uci.data_mat) sigla_pro_res_m,
-- des_com_nas_f
       f_comune_al(uci.cod_pro_nas_f,uci.cod_com_nas_f,uci.data_nas_f) des_com_nas_f,
-- sigla_pro_nas_f
       f_provincia_stato_al(uci.cod_pro_nas_f,uci.cod_com_nas_f,'','S','',uci.data_nas_f) sigla_pro_nas_f,
-- des_com_res_f
       f_comune_al(uci.cod_pro_res_f,uci.cod_com_res_f,uci.data_mat) des_com_res_f,
-- sigla_pro_res_f
       f_provincia_stato_al(uci.cod_pro_res_f,uci.cod_com_res_f,'','S','',uci.data_mat) sigla_pro_res_f,
-- des_com_mat
       f_comune_al(uci.cod_pro_mat,uci.cod_com_mat,uci.data_mat) des_com_mat,
-- sigla_pro_mat
       f_provincia_stato_al(uci.cod_pro_mat,uci.cod_com_mat,'','S','',uci.data_mat) sigla_pro_mat,
-- flag_com_in_sospeso
       f_CIV_flag_com_in_sospeso(-4,uci.ufficio,uci.anno,uci.parte,uci.serie,uci.atto) flag_com_in_sospeso,
-- flag_divorzio
       decode(cta.id, '', decode(uci.parte||uci.serie||uci.natura,'2D','S'), cta.flag_divorzio) flag_divorzio,
-- cognome_m_lista
       decode(uci.natura,'N','*** ANNULLATO',uci.cognome_m)	cognome_1_lista,
-- nome_m_lista
       decode(uci.natura,'N','',uci.nome_m)			nome_1_lista,
-- sesso_m_lista
       decode(uci.natura,'N','',uci.sesso_m)			sesso_1_lista,
-- cognome_f_lista
       decode(uci.natura,'N','*** ANNULLATO',uci.cognome_f)	cognome_2_lista,
-- nome_f_lista
       decode(uci.natura,'N','',uci.nome_f)			nome_2_lista,
-- sesso_f_lista
       decode(uci.natura,'N','',uci.sesso_f)			sesso_2_lista,
-- d_data_mat_lista
       decode(uci.natura,'N',to_date(null),uci.d_data_mat)	d_data_evento_lista,
-- flag_residente
       decode(f_get_comune_cliente('COD_COMUNE'),lpad(uci.cod_pro_res_m,3,'0')||lpad(uci.cod_com_res_m,3,'0'),'S',
         decode(f_get_comune_cliente('COD_COMUNE'),lpad(uci.cod_pro_res_f,3,'0')||lpad(uci.cod_com_res_f,3,'0'),'S','N')) flag_residente,
-- flag_nel_comune
       decode(f_get_comune_cliente('COD_COMUNE'),lpad(uci.cod_pro_mat,3,'0')||lpad(uci.cod_com_mat,3,'0'),'S','N') flag_evento_nel_comune,
-- flag_modello_d3u
       f_CIV_flag_modello_istat('D3U',uci.id_atto) flag_modello_d3u,
-- flag_modello_sdsu
       CASE WHEN uci.anno >= 2024 THEN f_CIV_flag_modello_istat('SU',uci.id_atto) ELSE NULL END flag_modello_sdsu,
-- flag_firmato_usc_ansc
       f_ANSC_flag_firmato('UCI', uci.id, 'USC') flag_firmato_usc_ansc
  FROM civcta cta, civdta dta, civuci uci
 WHERE cta.id (+)           = dta.id_civcta
   and dta.id (+)           = uci.id_civdta
   and uci.cod_rec          in (0,3)
--   and uci.parte||uci.serie is not null
   and uci.natura           in ('O','T','D','N')
--   and uci.natura_uci      != 'V'
/
comment on table civuci_v is 'Stato Civile - Atti di Unione Civile (view)'
/
