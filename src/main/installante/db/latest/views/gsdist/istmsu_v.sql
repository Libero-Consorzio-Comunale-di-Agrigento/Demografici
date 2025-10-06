--liquibase formatted sql
--changeset amonopoli:202312151640 runOnChange:true stripComments:false
create or replace view istmsu_v
AS
select msu.*
-- d_data_stipula_accordo
     , f_IST_data_stipula_accordo(-4, msu.id_atto, msu.cod_modello) d_data_stipula_accordo
-- d_data_trascr_conferma
     , f_IST_data_trascr_conferma(-4, msu.id_atto, msu.cod_modello) d_data_trascr_conferma
-- cod_istat_trib
     , decode(msu.tipo_procedura,
         3, f_IST_cod_tribunale(msu.cod_pro_trib,msu.cod_com_trib),
         4, f_IST_cod_corte_appello(msu.cod_pro_trib,msu.cod_com_trib)) cod_istat_trib
-- des_com_trib
     , f_comune_al(msu.cod_pro_trib,msu.cod_com_trib,'') des_com_trib
-- sigla_pro_trib
     , f_provincia_stato_al(msu.cod_pro_trib,msu.cod_com_trib,'','S','','') sigla_pro_trib
-- des_com_uci
     , f_comune_al(msu.cod_pro_uci,msu.cod_com_uci,'') des_com_uci
-- sigla_pro_uci
     , f_provincia_stato_al(msu.cod_pro_uci,msu.cod_com_uci,'','S','','') sigla_pro_uci
-- des_com_res_1
     , f_comune_al(msu.cod_pro_res_1,msu.cod_com_res_1,'') des_com_res_1
-- sigla_pro_mat_m
     , f_provincia_stato_al(msu.cod_pro_res_1,msu.cod_com_res_1,'','S','','') sigla_pro_res_1
-- des_com_res_2
     , f_comune_al(msu.cod_pro_res_2,msu.cod_com_res_2,'') des_com_res_2
-- sigla_pro_mat_m
     , f_provincia_stato_al(msu.cod_pro_res_2,msu.cod_com_res_2,'','S','','') sigla_pro_res_2
  from istmsu msu
/
comment on table istmsu_v is 'ISTAT - Dati per Compilazione Modello SDSU - Scioglimenti (view)'
/
