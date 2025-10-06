--liquibase formatted sql
--changeset amonopoli:202312151635 runOnChange:true stripComments:false
create or replace view istmsc_v
AS
select msc.*
-- d_data_stipula_accordo
     , f_IST_data_stipula_accordo(4, msc.id_atto, msc.cod_modello) d_data_stipula_accordo
-- d_data_trascr_conferma
     , f_IST_data_trascr_conferma(4, msc.id_atto, msc.cod_modello) d_data_trascr_conferma
-- cod_istat_trib
     , decode(msc.tipo_procedura,
         3, f_IST_cod_tribunale(msc.cod_pro_trib,msc.cod_com_trib),
         4, f_IST_cod_corte_appello(msc.cod_pro_trib,msc.cod_com_trib)) cod_istat_trib
-- des_com_trib
     , f_comune_al(msc.cod_pro_trib,msc.cod_com_trib,'') des_com_trib
-- sigla_pro_trib
     , f_provincia_stato_al(msc.cod_pro_trib,msc.cod_com_trib,'','S','','') sigla_pro_trib
-- des_com_sep
     , f_comune_al(msc.cod_pro_sep,msc.cod_com_sep,'') des_com_sep
-- sigla_pro_sep
     , f_provincia_stato_al(msc.cod_pro_sep,msc.cod_com_sep,'','S','','') sigla_pro_sep
-- des_com_mat
     , f_comune_al(msc.cod_pro_mat,msc.cod_com_mat,'') des_com_mat
-- sigla_pro_mat
     , f_provincia_stato_al(msc.cod_pro_mat,msc.cod_com_mat,'','S','','') sigla_pro_mat
-- des_com_albo_avv_m
     , f_comune_al(msc.cod_pro_albo_avv_m,msc.cod_com_albo_avv_m,'') des_com_albo_avv_m
-- sigla_pro_albo_avv_m
     , f_provincia_stato_al(msc.cod_pro_albo_avv_m,msc.cod_com_albo_avv_m,'','S','','') sigla_pro_albo_avv_m
-- des_com_albo_avv_f
     , f_comune_al(msc.cod_pro_albo_avv_f,msc.cod_com_albo_avv_f,'') des_com_albo_avv_f
-- sigla_pro_albo_avv_f
     , f_provincia_stato_al(msc.cod_pro_albo_avv_f,msc.cod_com_albo_avv_f,'','S','','') sigla_pro_albo_avv_f
-- des_com_res_m
     , f_comune_al(msc.cod_pro_res_m,msc.cod_com_res_m,'') des_com_res_m
-- sigla_pro_mat_m
     , f_provincia_stato_al(msc.cod_pro_res_m,msc.cod_com_res_m,'','S','','') sigla_pro_res_m
-- des_com_res_f
     , f_comune_al(msc.cod_pro_res_f,msc.cod_com_res_f,'') des_com_res_f
-- sigla_pro_mat_m
     , f_provincia_stato_al(msc.cod_pro_res_f,msc.cod_com_res_f,'','S','','') sigla_pro_res_f
  from istmsc msc
/
comment on table istmsc_V is 'ISTAT - Dati per Compilazione Modello SDSU - Separazioni / Divorzi (view)'
/
