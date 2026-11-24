--liquibase formatted sql
--changeset amonopoli:202303211325 runAlways:true runOnChange:true stripComments:false
create or replace view civcit_v
as
SELECT cit.*,
-- parte
       to_number(null) parte,
-- serie
       to_char(null) serie,
-- des_com_nas
       f_comune_al(cit.cod_pro_nas,cit.cod_com_nas,cit.data_nas) des_com_nas,
-- sigla_pro_nas
       f_provincia_stato_al(cit.cod_pro_nas,cit.cod_com_nas,'','S','',cit.data_nas) sigla_pro_nas,
-- des_com_res
       f_comune_al(cit.cod_pro_res,cit.cod_com_res,cit.data_cit) des_com_res,
-- sigla_pro_res
       f_provincia_stato_al(cit.cod_pro_res,cit.cod_com_res,'','S','',cit.data_cit) sigla_pro_res,
-- flag_com_in_sospeso
       f_CIV_flag_com_in_sospeso(1,cit.ufficio,cit.anno,'','',cit.atto) flag_com_in_sospeso,
-- ufficio_lista
       cit.ufficio ufficio_lista,
-- anno_lista
       decode(f_flag_ANSC(), 
         'S', decode(cit.id_atto_ansc, '', cit.anno),
              cit.anno) anno_lista,
-- parte_lista
       to_number(null) parte_lista,
-- serie_lista
       to_char(null) serie_lista,
-- atto_lista
       decode(f_flag_ANSC(), 
         'S', decode(cit.id_atto_ansc, '', 
                decode(cit.numero_unico, '', cit.atto, cit.numero_unico)),
              cit.atto) atto_lista,
-- id_atto_ansc_lista
       decode(f_flag_ANSC(), 
         'S', cit.id_atto_ansc,
              to_char(null)) id_atto_ansc_lista,
-- cognome_lista
       decode(cit.natura,'N','*** ANNULLATO',cit.cognome) 	cognome_1_lista,
-- nome_lista
       decode(cit.natura,'N','',cit.nome) 			nome_1_lista,
-- sesso_lista
       decode(cit.natura,'N','',cit.sesso) 			sesso_1_lista,
-- d_data_cit_lista
       decode(cit.natura,'N',to_date(null),cit.d_data_cit) 	d_data_evento_lista,
-- flag_residente
       decode(f_get_comune_cliente('COD_COMUNE'),lpad(cit.cod_pro_res,3,'0')||lpad(cit.cod_com_res,3,'0'),'S','N') flag_residente,
-- flag_nel_comune
       to_char(null) flag_evento_nel_comune,
-- flag_firmato_usc_ansc
       f_ANSC_flag_firmato('CIT', cit.id, 'USC') flag_firmato_usc_ansc
  FROM civcit cit
 WHERE cit.cod_rec in (0,3)
/
comment on table civcit_v is 'Stato Civile - Atti di Cittadinanza (view)'
/
