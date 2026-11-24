--liquibase formatted sql
--changeset amonopoli:202303031650_1 runAlways:true runOnChange:true stripComments:false
create or replace view civnas_v_CER
as
SELECT nas.*,
-- des_com_nas
       to_char(null) des_com_nas,
-- sigla_pro_nas
       to_char(null) sigla_pro_nas,
-- des_com_res
       to_char(null) des_com_res,
-- sigla_pro_res
       to_char(null) sigla_pro_res,
-- des_com_nas_pd
       to_char(null) des_com_nas_pd,
-- sigla_pro_nas_pd
       to_char(null) sigla_pro_nas_pd,
-- des_com_res_pd
       to_char(null) des_com_res_pd,
-- sigla_pro_res_pd
       to_char(null) sigla_pro_res_pd,
-- des_com_nas_md
       to_char(null) des_com_nas_md,
-- sigla_pro_nas_md
       to_char(null) sigla_pro_nas_md,
-- des_com_res_md
       to_char(null) des_com_res_md,
-- sigla_pro_res_md
       to_char(null) sigla_pro_res_md,
-- flag_com_in_sospeso
       to_char(null) flag_com_in_sospeso,
-- ufficio_lista
       nas.ufficio ufficio_lista,
-- anno_lista
       decode(f_flag_ANSC(),
         'S', decode(nas.id_atto_ansc, '', nas.anno),
              nas.anno) anno_lista,
-- parte_lista
       decode(f_flag_ANSC(),
         'S', decode(nas.id_atto_ansc, '',
                decode(nas.numero_unico, '', nas.parte)),
              nas.parte) parte_lista,
-- serie_lista
       decode(f_flag_ANSC(),
         'S', decode(nas.id_atto_ansc, '',
                decode(nas.numero_unico, '', nas.serie)),
              nas.serie) serie_lista,
-- atto_lista
       decode(f_flag_ANSC(),
         'S', decode(nas.id_atto_ansc, '',
                decode(nas.numero_unico, '', nas.atto, nas.numero_unico)),
              nas.atto) atto_lista,
-- id_atto_ansc_lista
       decode(f_flag_ANSC(),
         'S', nas.id_atto_ansc,
              to_char(null)) id_atto_ansc_lista,
-- cognome_lista
       to_char(null) cognome_1_lista,
-- nome_lista
       to_char(null) nome_1_lista,
-- sesso_lista
       to_char(null) sesso_1_lista,
-- d_data_nas_lista
       to_date(null) d_data_evento_lista,
-- flag_residente
       to_char(null) flag_residente,
-- flag_nel_comune
       to_char(null) flag_evento_nel_comune,
-- flag_modello_p4
       to_char(null) flag_modello_p4,
-- flag_firmato_usc_ansc
       to_char(null) flag_firmato_usc_ansc
  FROM civnas nas
 WHERE nas.cod_rec in (0,3,5)
   and nas.natura  in ('O','T','D')
/
comment on table civnas_v_CER is 'Stato Civile - Atti di Nascita x Certificazione (view)'
/
