--liquibase formatted sql
--changeset amonopoli:202303211325_1 runAlways:true runOnChange:true stripComments:false
create or replace view civcit_v_CER
as
SELECT cit.*,
-- parte
       to_number(null) parte,
-- serie
       to_char(null) serie,
-- des_com_nas
       to_char(null) des_com_nas,
-- sigla_pro_nas
       to_char(null) sigla_pro_nas,
-- des_com_res
       to_char(null) des_com_res,
-- sigla_pro_res
       to_char(null) sigla_pro_res,
-- flag_com_in_sospeso
       to_char(null) flag_com_in_sospeso,
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
       to_char(null) cognome_1_lista,
-- nome_lista
       to_char(null) nome_1_lista,
-- sesso_lista
       to_char(null) sesso_1_lista,
-- d_data_cit_lista
       to_date(null) d_data_evento_lista,
-- flag_residente
       to_char(null) flag_residente,
-- flag_nel_comune
       to_char(null) flag_evento_nel_comune,
-- flag_firmato_usc_ansc
       to_char(null) flag_firmato_usc_ansc
  FROM civcit cit
 WHERE cit.cod_rec in (0,3,5)
   and cit.natura  in ('O','T','D')
/
comment on table civcit_v_CER is 'Stato Civile - Atti di Cittadinanza x Certificazione (view)'
/
