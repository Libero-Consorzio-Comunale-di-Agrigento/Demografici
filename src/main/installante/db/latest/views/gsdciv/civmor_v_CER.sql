--liquibase formatted sql
--changeset amonopoli:202303211327_1 runAlways:true runOnChange:true stripComments:false
create or replace view civmor_v_CER
as
SELECT mor.*,
-- des_stato_civile
       to_char(null) des_stato_civile,
-- des_com_mor
       to_char(null) des_com_mor,
-- sigla_pro_mor
       to_char(null) sigla_pro_mor,
-- des_com_nas
       to_char(null) des_com_nas,
-- sigla_pro_nas
       to_char(null) sigla_pro_nas,
-- des_com_res
       to_char(null) des_com_res,
-- sigla_pro_res
       to_char(null) sigla_pro_res,
-- des_com_nas_cn
       to_char(null) des_com_nas_cn,
-- sigla_pro_nas_cn
       to_char(null) sigla_pro_nas_cn,
-- des_com_res_cn
       to_char(null) des_com_res_cn,
-- sigla_pro_res_cn
       to_char(null) sigla_pro_res_cn,
-- flag_com_in_sospeso
       to_char(null) flag_com_in_sospeso,
-- ufficio_lista
       mor.ufficio ufficio_lista,
-- anno_lista
       decode(f_flag_ANSC(),
         'S', decode(mor.id_atto_ansc, '', mor.anno),
              mor.anno) anno_lista,
-- parte_lista
       decode(f_flag_ANSC(),
         'S', decode(mor.id_atto_ansc, '',
                decode(mor.numero_unico, '', mor.parte)),
              mor.parte) parte_lista,
-- serie_lista
       decode(f_flag_ANSC(),
         'S', decode(mor.id_atto_ansc, '',
                decode(mor.numero_unico, '', mor.serie)),
              mor.serie) serie_lista,
-- atto_lista
       decode(f_flag_ANSC(),
         'S', decode(mor.id_atto_ansc, '',
                decode(mor.numero_unico, '', mor.atto, mor.numero_unico)),
              mor.atto) atto_lista,
-- id_atto_ansc_lista
       decode(f_flag_ANSC(), 
         'S', mor.id_atto_ansc,
              to_char(null)) id_atto_ansc_lista,
-- cognome_lista
       to_char(null) cognome_1_lista,
-- nome_lista
       to_char(null) nome_1_lista,
-- sesso_lista
       to_char(null) sesso_1_lista,
-- d_data_mor_lista
       to_date(null) d_data_evento_lista,
-- flag_residente
       to_char(null) flag_residente,
-- flag_nel_comune
       to_char(null) flag_evento_nel_comune,
-- flag_modello_d4
       to_char(null) flag_modello_d4,
-- flag_modello_d4bis
       to_char(null) flag_modello_d4bis,
-- flag_firmato_usc_ansc
       to_char(null) flag_firmato_usc_ansc
  FROM civmor mor
 WHERE mor.cod_rec in (0,3,5)
   and mor.natura  in ('O','T','D')
/
comment on table civmor_v_CER is 'Stato Civile - Atti di Morte x Certificazione (view)'
/
