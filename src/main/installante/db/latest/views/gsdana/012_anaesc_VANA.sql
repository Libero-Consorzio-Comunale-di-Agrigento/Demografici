--liquibase formatted sql
--changeset amonopoli:202504011135_2 runAlways:true runOnChange:true stripComments:false
create or replace view anaesc_VANA
AS
select e.*
     , f_cognome(e.cognome_nome_cn) cognome_cn
     , f_nome(e.cognome_nome_cn) nome_cn
     , to_date(e.DATA_REG,'j') d_data_reg
     , to_date(e.DATA_EVE,'j') d_data_eve
     , to_date(e.DATA_MAT,'j') d_data_mat
     , to_date(e.DATA_VED,'j') d_data_ved
     , to_date(e.DATA_DIV,'j') d_data_div
-- cod_pro_eve, cod_com_eve, des_com_eve, sigla_pro_eve
     , decode(e.cod_eve,
              93, COD_PRO_MAT,
              94, COD_PRO_VED,
              99, COD_PRO_DIV) cod_pro_eve
     , decode(e.cod_eve,
              93, COD_COM_MAT,
              94, COD_COM_VED,
              99, COD_COM_DIV) cod_com_eve
     , decode(e.cod_eve,
         93, f_comune_al(e.COD_PRO_MAT,e.COD_COM_MAT,e.DATA_MAT),
         94, f_comune_al(e.COD_PRO_VED,e.COD_COM_VED,e.DATA_VED),
         99, f_comune_al(e.COD_PRO_DIV,e.COD_COM_DIV,e.DATA_DIV)) des_com_eve
     , decode(e.cod_eve,
         93, f_provincia_stato_al(e.COD_PRO_MAT,e.COD_COM_MAT,'','S','',e.DATA_MAT),
         94, f_provincia_stato_al(e.COD_PRO_VED,e.COD_COM_VED,'','S','',e.DATA_VED),
         99, f_provincia_stato_al(e.COD_PRO_DIV,e.COD_COM_DIV,'','S','',e.DATA_DIV)) sigla_pro_eve
-- cod_pro_atto, cod_com_atto, des_com_atto, sigla_pro_atto
     , decode(e.cod_eve,
              93, COD_PRO_ATTO_MAT,
              94, COD_PRO_ATTO_VED,
              99, COD_PRO_ATTO_DIV) cod_pro_atto
     , decode(e.cod_eve,
              93, COD_COM_ATTO_MAT,
              94, COD_COM_ATTO_VED,
              99, COD_COM_ATTO_DIV) cod_com_atto
     , decode(e.cod_eve,
         93, f_comune_al(e.COD_PRO_ATTO_MAT,e.COD_COM_ATTO_MAT,e.DATA_MAT),
         94, f_comune_al(e.COD_PRO_ATTO_VED,e.COD_COM_ATTO_VED,e.DATA_VED),
         99, f_comune_al(e.COD_PRO_ATTO_DIV,e.COD_COM_ATTO_DIV,e.DATA_DIV)) des_com_atto
     , decode(e.cod_eve,
         93, f_provincia_stato_al(e.COD_PRO_ATTO_MAT,e.COD_COM_ATTO_MAT,'','S','',e.DATA_MAT),
         94, f_provincia_stato_al(e.COD_PRO_ATTO_VED,e.COD_COM_ATTO_VED,'','S','',e.DATA_VED),
         99, f_provincia_stato_al(e.COD_PRO_ATTO_DIV,e.COD_COM_ATTO_DIV,'','S','',e.DATA_DIV)) sigla_pro_atto
-- atto, parte, serie, ufficio, anno_atto, atto_digitale
     , decode(e.cod_eve,
         93, e.atto_mat,
         94, e.atto_ved,
         99, e.atto_div) atto
     , decode(e.cod_eve,
         93, e.parte_mat,
         94, e.parte_ved,
         99, e.parte_div) parte
     , decode(e.cod_eve,
         93, e.serie_mat,
         94, e.serie_ved,
         99, e.serie_div) serie
     , decode(e.cod_eve,
         93, e.ufficio_mat,
         94, e.ufficio_ved,
         99, e.ufficio_div) ufficio
     , decode(e.cod_eve,
         93, e.anno_atto_mat,
         94, e.anno_atto_ved,
         99, e.anno_atto_div) anno_atto
     , decode(e.cod_eve,
         93, e.atto_mat_digitale,
         94, e.atto_ved_digitale,
         99, e.atto_div_digitale) atto_digitale
-- atto_tr, parte_tr, serie_tr, ufficio_tr, anno_atto_tr, atto_tr_digitale
     , decode(e.cod_eve,
         93, e.atto_mat_tr) atto_tr
     , decode(e.cod_eve,
         93, e.parte_mat_tr) parte_tr
     , decode(e.cod_eve,
         93, e.serie_mat_tr) serie_tr
     , decode(e.cod_eve,
         93, e.ufficio_mat_tr) ufficio_tr
     , decode(e.cod_eve,
         93, e.anno_atto_mat_tr) anno_atto_tr
     , decode(e.cod_eve,
         93, e.atto_mat_tr_digitale) atto_tr_digitale
-- ID
     , rownum id
  from anaesc e
/
comment on table anaesc_VANA is 'Anagrafe - Eventi di Stato Civie dell''Individuo per Visualizzazione (view)'

/
