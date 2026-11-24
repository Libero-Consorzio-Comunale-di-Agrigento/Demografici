--liquibase formatted sql
--changeset amonopoli:202303211328 runAlways:true runOnChange:true stripComments:false
CREATE OR REPLACE VIEW CIVPUB_V
AS
SELECT pub.*, 
-- des_com_nas_m
       f_comune_al(pub.cod_pro_nas_m,pub.cod_com_nas_m,pub.data_nas_m) des_com_nas_m,
-- sigla_pro_nas_m
       f_provincia_stato_al(pub.cod_pro_nas_m,pub.cod_com_nas_m,'','S','',pub.data_nas_m) sigla_pro_nas_m,
-- des_com_res_m
       f_comune_al(pub.cod_pro_res_m,pub.cod_com_res_m,pub.data_pub) des_com_res_m,
-- sigla_pro_res_m
       f_provincia_stato_al(pub.cod_pro_res_m,pub.cod_com_res_m,'','S','',pub.data_pub) sigla_pro_res_m,
-- des_com_nas_f
       f_comune_al(pub.cod_pro_nas_f,pub.cod_com_nas_f,pub.data_nas_f) des_com_nas_f,
-- sigla_pro_nas_f
       f_provincia_stato_al(pub.cod_pro_nas_f,pub.cod_com_nas_f,'','S','',pub.data_nas_f) sigla_pro_nas_f,
-- des_com_res_f
       f_comune_al(pub.cod_pro_res_f,pub.cod_com_res_f,pub.data_pub) des_com_res_f,
-- sigla_pro_res_f
       f_provincia_stato_al(pub.cod_pro_res_f,pub.cod_com_res_f,'','S','',pub.data_pub) sigla_pro_res_f,
-- des_com_mat
       f_comune_al(pub.cod_pro_mat,pub.cod_com_mat,pub.data_pub) des_com_mat,
-- sigla_pro_mat
       f_provincia_stato_al(pub.cod_pro_mat,pub.cod_com_mat,'','S','',pub.data_pub) sigla_pro_mat,
-- flag_com_in_sospeso
       f_CIV_flag_com_in_sospeso(3,pub.ufficio,pub.anno,pub.parte,pub.serie,pub.atto) flag_com_in_sospeso,
-- ufficio_lista
       pub.ufficio ufficio_lista,
-- anno_lista
       pub.anno anno_lista,
-- parte_lista
       pub.parte parte_lista,
-- serie_lista
       pub.serie serie_lista,
-- atto_lista
       pub.atto atto_lista,
-- id_atto_ansc_lista
       to_char(null) id_atto_ansc_lista,
-- cognome_m_lista
       decode(pub.natura,'N','*** ANNULLATO',pub.cognome_m)	cognome_1_lista,
-- nome_m_lista
       decode(pub.natura,'N','',pub.nome_m)			nome_1_lista,
-- cognome_f_lista
       decode(pub.natura,'N','*** ANNULLATO',pub.cognome_f)	cognome_2_lista,
-- nome_f_lista
       decode(pub.natura,'N','',pub.nome_f)			nome_2_lista,
-- d_data_pub_lista
       decode(pub.natura,'N',to_date(null),pub.d_data_pub)	d_data_evento_lista,
-- flag_residente
       decode(f_get_comune_cliente('COD_COMUNE'),lpad(pub.cod_pro_res_m,3,'0')||lpad(pub.cod_com_res_m,3,'0'),'S',
         decode(f_get_comune_cliente('COD_COMUNE'),lpad(pub.cod_pro_res_f,3,'0')||lpad(pub.cod_com_res_f,3,'0'),'S','N')) flag_residente,
-- flag_nel_comune
       decode(f_get_comune_cliente('COD_COMUNE'),lpad(pub.cod_pro_mat,3,'0')||lpad(pub.cod_com_mat,3,'0'),'S','N') flag_evento_nel_comune,
-- flag_modello_d3
       f_CIV_flag_modello_istat('D3',pub.id_atto) flag_modello_d3
  FROM civpub pub
 WHERE pub.cod_rec in (0,3)
/
comment on table civpub_v is 'Stato Civile - Verbali di Pubblicazione (view)'
/
