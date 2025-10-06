--liquibase formatted sql
--changeset amonopoli:202303211330 runAlways:true runOnChange:true stripComments:false
create or replace view civpvu_v
AS
select 
-- COD_REC                                            NUMBER(1)
       pvu.cod_rec,
-- UFFICIO                                            NUMBER(2)
       pvu.ufficio,
-- ANNO                                               NUMBER(4)
       pvu.anno, 
-- ATTO                                               NUMBER(4)
       pvu.atto,
-- PARTE                                              NUMBER(1)
       pvu.parte,
-- SERIE                                              VARCHAR2(1)
       pvu.serie,
-- NATURA                                             VARCHAR2(1)
       pvu.natura,
-- DATA_PUB                                           NUMBER(8)
       pvu.data_mat data_pub,
-- COGNOME_NOME_M                                     VARCHAR2(100)
       pvu.cognome_nome_m,
-- DATA_NAS_M                                         NUMBER(8)
       pvu.data_nas_m,
-- SESSO_M                                            VARCHAR2(1)
       pvu.sesso_m,
-- COD_PRO_NAS_M                                      NUMBER(3)
       pvu.cod_pro_nas_m,
-- COD_COM_NAS_M                                      NUMBER(3)
       pvu.cod_com_nas_m,
-- COD_PRO_RES_M                                      NUMBER(3)
       pvu.cod_pro_res_m,
-- COD_COM_RES_M                                      NUMBER(3)
       pvu.cod_com_res_m,
-- COGNOME_NOME_F                                     VARCHAR2(100)
       pvu.cognome_nome_f,
-- DATA_NAS_F                                         NUMBER(8)
       pvu.data_nas_f,
-- SESSO_F                                            VARCHAR2(1)
       pvu.sesso_f,
-- COD_PRO_NAS_F                                      NUMBER(3)
       pvu.cod_pro_nas_f,
-- COD_COM_NAS_F                                      NUMBER(3)
       pvu.cod_com_nas_f,
-- COD_PRO_RES_F                                      NUMBER(3)
       pvu.cod_pro_res_f,
-- COD_COM_RES_F                                      NUMBER(3)
       pvu.cod_com_res_f,
-- VERSIONE                                           NUMBER(3)
       pvu.versione,
-- DATA_VERSIONE                                      NUMBER(8)
       pvu.data_versione,
-- DATA_REG                                           NUMBER(8)
       pvu.data_reg,
-- TERMINALISTA                                       VARCHAR2(8)
       pvu.terminalista,
-- COD_FISCALE_M                                      VARCHAR2(16)
       pvu.cod_fiscale_m,
-- CF_CALCOLATO_M                                     VARCHAR2(1)
       pvu.cf_calcolato_m,
-- COD_FISCALE_F                                      VARCHAR2(16)
       pvu.cod_fiscale_f,
-- CF_CALCOLATO_F                                     VARCHAR2(1)
       pvu.cf_calcolato_f,
-- COD_PRO_MAT                                        NUMBER(3)
       pvu.cod_pro_mat,
-- COD_COM_MAT                                        NUMBER(3)
       pvu.cod_com_mat,
-- NAZIONALITA_M                                      VARCHAR2(3)
       pvu.nazionalita_m,
-- NAZIONALITA_F                                      VARCHAR2(3)
       pvu.nazionalita_f,
-- FLAG_BLOCCATO                                      VARCHAR2(1)
       pvu.flag_bloccato,
-- ANNO_NAS_M                                         VARCHAR2(1)
       pvu.anno_nas_m,
-- ANNO_NAS_F                                         VARCHAR2(1)
       pvu.anno_nas_f,
-- D_DATA_PUB                                         DATE
       pvu.d_data_mat d_data_pub,
-- D_DATA_NAS_M                                       DATE
       pvu.d_data_nas_m,
-- D_DATA_NAS_F                                       DATE
       pvu.d_data_nas_f,
-- D_DATA_VERSIONE                                    DATE
       pvu.d_data_versione,
-- D_DATA_REG                                         DATE
       pvu.d_data_reg,
-- D_DATA_UCI_VERBALE                                 DATE
       pvu.d_data_uci_verbale,
-- ID_ATTO                                            VARCHAR2(25)
       pvu.id_atto,
-- COGNOME_M                                          VARCHAR2(100)
       pvu.cognome_m,
-- NOME_M                                             VARCHAR2(100)
       pvu.nome_m,
-- SENZA_COGNOME_M                                    VARCHAR2(1)
       pvu.senza_cognome_m,
-- SENZA_NOME_M                                       VARCHAR2(1)
       pvu.senza_nome_m,
-- COGNOME_F                                          VARCHAR2(100)
       pvu.cognome_f,
-- NOME_F                                             VARCHAR2(100)
       pvu.nome_f,
-- SENZA_COGNOME_F                                    VARCHAR2(1)
       pvu.senza_cognome_f,
-- SENZA_NOME_F                                       VARCHAR2(1)
       pvu.senza_nome_f,
-- ID_CIVDTA                                          NUMBER(10)
       pvu.id_civdta,
-- ID                                                 NUMBER(10)
       pvu.id,
-- VERSION                                            NUMBER(20)
       pvu.version,
-- des_com_nas_m
       f_comune_al(pvu.cod_pro_nas_m,pvu.cod_com_nas_m,pvu.data_nas_m) des_com_nas_m,
-- sigla_pro_nas_m
       f_provincia_stato_al(pvu.cod_pro_nas_m,pvu.cod_com_nas_m,'','S','',pvu.data_nas_m) sigla_pro_nas_m,
-- des_com_res_m
       f_comune_al(pvu.cod_pro_res_m,pvu.cod_com_res_m,pvu.data_mat) des_com_res_m,
-- sigla_pro_res_m
       f_provincia_stato_al(pvu.cod_pro_res_m,pvu.cod_com_res_m,'','S','',pvu.data_mat) sigla_pro_res_m,
-- des_com_nas_f
       f_comune_al(pvu.cod_pro_nas_f,pvu.cod_com_nas_f,pvu.data_nas_f) des_com_nas_f,
-- sigla_pro_nas_f
       f_provincia_stato_al(pvu.cod_pro_nas_f,pvu.cod_com_nas_f,'','S','',pvu.data_nas_f) sigla_pro_nas_f,
-- des_com_res_f
       f_comune_al(pvu.cod_pro_res_f,pvu.cod_com_res_f,pvu.data_mat) des_com_res_f,
-- sigla_pro_res_f
       f_provincia_stato_al(pvu.cod_pro_res_f,pvu.cod_com_res_f,'','S','',pvu.data_mat) sigla_pro_res_f,
-- des_com_mat
       f_comune_al(pvu.cod_pro_mat,pvu.cod_com_mat,pvu.data_mat) des_com_mat,
-- sigla_pro_mat
       f_provincia_stato_al(pvu.cod_pro_mat,pvu.cod_com_mat,'','S','',pvu.data_mat) sigla_pro_mat,
-- flag_com_in_sospeso
       f_CIV_flag_com_in_sospeso(-4,pvu.ufficio,pvu.anno,pvu.parte,pvu.serie,pvu.atto) flag_com_in_sospeso,
-- cognome_m_lista
       decode(pvu.natura,'N','*** ANNULLATO',pvu.cognome_m)	cognome_1_lista,
-- nome_m_lista
       decode(pvu.natura,'N','',pvu.nome_m)			nome_1_lista,
-- sesso_m_lista
       decode(pvu.natura,'N','',pvu.sesso_m)			sesso_1_lista,
-- cognome_f_lista
       decode(pvu.natura,'N','*** ANNULLATO',pvu.cognome_f)	cognome_2_lista,
-- nome_f_lista
       decode(pvu.natura,'N','',pvu.nome_f)			nome_2_lista,
-- sesso_f_lista
       decode(pvu.natura,'N','',pvu.sesso_f)			sesso_2_lista,
-- d_data_pub_lista
       decode(pvu.natura,'N',to_date(null),pvu.d_data_mat)	d_data_evento_lista,
-- flag_residente
       decode(f_get_comune_cliente('COD_COMUNE'),lpad(pvu.cod_pro_res_m,3,'0')||lpad(pvu.cod_com_res_m,3,'0'),'S',
         decode(f_get_comune_cliente('COD_COMUNE'),lpad(pvu.cod_pro_res_f,3,'0')||lpad(pvu.cod_com_res_f,3,'0'),'S','N')) flag_residente,
-- flag_nel_comune
       decode(f_get_comune_cliente('COD_COMUNE'),lpad(pvu.cod_pro_mat,3,'0')||lpad(pvu.cod_com_mat,3,'0'),'S','N') flag_evento_nel_comune,
-- flag_modello_d3u
       f_CIV_flag_modello_istat('D3U',pvu.id_atto) flag_modello_d3u
  from civuci pvu
 where pvu.cod_rec          in (0,3)
   and pvu.parte||pvu.serie is null
   and pvu.natura           in ('V','N')
--   and pvu.natura_uci      = 'V'
/
comment on table civpvu_v is 'Stato Civile - Processi Verbali per Unioni Civili (view)'
/
