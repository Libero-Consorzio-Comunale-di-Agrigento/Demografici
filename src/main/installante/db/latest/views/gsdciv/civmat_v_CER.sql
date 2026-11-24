--liquibase formatted sql
--changeset amonopoli:202303211326_1 runAlways:true runOnChange:true stripComments:false
create or replace view civmat_v_CER
as
SELECT mat.*,
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
       mat.ufficio ufficio_lista,
-- anno_lista
       decode(f_flag_ANSC(),
         'S', decode(mat.id_atto_ansc, '', mat.anno),
              mat.anno) anno_lista,
-- parte_lista
       decode(f_flag_ANSC(),
         'S', decode(mat.id_atto_ansc, '',
                decode(mat.numero_unico, '', mat.parte)),
              mat.parte) parte_lista,
-- serie_lista
       decode(f_flag_ANSC(),
         'S', decode(mat.id_atto_ansc, '',
                decode(mat.numero_unico, '', mat.serie)),
              mat.serie) serie_lista,
-- atto_lista
       decode(f_flag_ANSC(),
         'S', decode(mat.id_atto_ansc, '',
                decode(mat.numero_unico, '', mat.atto, mat.numero_unico)),
              mat.atto) atto_lista,
-- id_atto_ansc_lista
       decode(f_flag_ANSC(), 
         'S', mat.id_atto_ansc,
              to_char(null)) id_atto_ansc_lista,
-- cognome_m_lista
       to_char(null) cognome_1_lista,
-- nome_m_lista
       to_char(null) nome_1_lista,
-- cognome_f_lista
       to_char(null) cognome_2_lista,
-- nome_f_lista
       to_char(null) nome_2_lista,
-- d_data_mat_lista
       to_date(null) d_data_evento_lista,
-- flag_residente
       to_char(null) flag_residente,
-- flag_nel_comune
       to_char(null) flag_evento_nel_comune,
-- flag_modello_d3
       to_char(null) flag_modello_d3,
-- flag_modello_sc
       to_char(null) flag_modello_sc,
-- flag_modello_sdsu
       to_char(null) flag_modello_sdsu,
-- flag_firmato_usc_ansc
       to_char(null) flag_firmato_usc_ansc
  FROM civmat mat
 WHERE mat.cod_rec         in (0,3,5)
   and mat.natura  in ('O','T','D')
/
comment on table civmat_v_CER is 'Stato Civile - Atti di Matrimonio x Certificazione (view)'
/
