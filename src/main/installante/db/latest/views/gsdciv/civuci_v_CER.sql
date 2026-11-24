--liquibase formatted sql
--changeset amonopoli:202303211329_1 runAlways:true runOnChange:true stripComments:false
create or replace view civuci_v_CER
as
SELECT uci.*,
-- des_com_nas_m
       to_char(null) des_com_nas_m,
-- sigla_pro_nas_m
       to_char(null) sigla_pro_nas_m,
-- des_com_res_m
       to_char(null) des_com_res_m,
-- sigla_pro_res_m
       to_char(null) sigla_pro_res_m,
-- des_com_nas_f
       to_char(null) des_com_nas_f,
-- sigla_pro_nas_f
       to_char(null) sigla_pro_nas_f,
-- des_com_res_f
       to_char(null) des_com_res_f,
-- sigla_pro_res_f
       to_char(null) sigla_pro_res_f,
-- des_com_mat
       to_char(null) des_com_mat,
-- sigla_pro_mat
       to_char(null) sigla_pro_mat,
-- flag_com_in_sospeso
       to_char(null) flag_com_in_sospeso,
-- flag_divorzio
       to_char(null) flag_divorzio,
-- ufficio_lista
       uci.ufficio ufficio_lista,
-- anno_lista
       decode(f_flag_ANSC(),
         'S', decode(uci.id_atto_ansc, '', uci.anno),
              uci.anno) anno_lista,
-- parte_lista
       decode(f_flag_ANSC(),
         'S', decode(uci.id_atto_ansc, '',
                decode(uci.numero_unico, '', uci.parte)),
              uci.parte) parte_lista,
-- serie_lista
       decode(f_flag_ANSC(),
         'S', decode(uci.id_atto_ansc, '',
                decode(uci.numero_unico, '', uci.serie)),
              uci.serie) serie_lista,
-- atto_lista
       decode(f_flag_ANSC(),
         'S', decode(uci.id_atto_ansc, '',
                decode(uci.numero_unico, '', uci.atto, uci.numero_unico)),
              uci.atto) atto_lista,
-- id_atto_ansc_lista
       decode(f_flag_ANSC(), 
         'S', uci.id_atto_ansc,
              to_char(null)) id_atto_ansc_lista,
-- cognome_m_lista
       to_char(null) cognome_1_lista,
-- nome_m_lista
       to_char(null) nome_1_lista,
-- sesso_m_lista
       to_char(null) sesso_1_lista,
-- cognome_f_lista
       to_char(null) cognome_2_lista,
-- nome_f_lista
       to_char(null) nome_2_lista,
-- sesso_f_lista
       to_char(null) sesso_2_lista,
-- d_data_mat_lista
       to_date(null) d_data_evento_lista,
-- flag_residente
       to_char(null) flag_residente,
-- flag_nel_comune
       to_char(null) flag_evento_nel_comune,
-- flag_modello_d3u
       to_char(null) flag_modello_d3u,
-- flag_modello_sdsu
       to_char(null) flag_modello_sdsu,
-- flag_firmato_usc_ansc
       to_char(null) flag_firmato_usc_ansc
  FROM civuci uci
 WHERE uci.cod_rec          in (0,3,5)
   and uci.natura           in ('O','T','D')
/
comment on table civuci_v_CER is 'Stato Civile - Atti di Unione Civile x Certificazione (view)'
/
