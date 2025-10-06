--liquibase formatted sql
--changeset amonopoli:202503211251_1 runOnChange:true stripComments:false
create or replace view istmdu_v
AS
select mdu.*
-- regime_patrimoniale
     , f_IST_get_campo_MDU(mdu.id_atto_mat,'REGIME_PATRIMONIALE') regime_patrimoniale
-- des_com_res_post_m
     , f_comune_al(mdu.cod_pro_res_post_m,mdu.cod_com_res_post_m,'') des_com_res_post_m
-- sigla_pro_res_post_m
     , f_provincia_stato_al(mdu.cod_pro_res_post_m,mdu.cod_com_res_post_m,'','S','','') sigla_pro_res_post_m
-- des_com_res_post_f
     , f_comune_al(mdu.cod_pro_res_post_f,mdu.cod_com_res_post_f,'') des_com_res_post_f
-- sigla_pro_res_post_f
     , f_provincia_stato_al(mdu.cod_pro_res_post_f,mdu.cod_com_res_post_f,'','S','','') sigla_pro_res_post_f
  from istmdu mdu
/
comment on table istmdu_V is 'ISTAT - Dati per Compilazione Modello D.3.U (view)'
/
