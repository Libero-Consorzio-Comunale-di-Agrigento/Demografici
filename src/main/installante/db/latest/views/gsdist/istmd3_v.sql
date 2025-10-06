--liquibase formatted sql
--changeset amonopoli:202503211249_1 runOnChange:true stripComments:false
create or replace view istmd3_v
AS
select md3.*
-- rito
     , decode(md3.atto_mat,'',to_char(null),
         decode(to_char(md3.parte_mat)||md3.serie_mat,'2A','1','2')) rito
-- regime_patrimoniale
     , f_IST_get_campo_MD3(md3.id_atto_mat,'REGIME_PATRIMONIALE') regime_patrimoniale
-- des_com_res_post_m
     , f_comune_al(md3.cod_pro_res_post_m,md3.cod_com_res_post_m,'') des_com_res_post_m
-- sigla_pro_res_post_m
     , f_provincia_stato_al(md3.cod_pro_res_post_m,md3.cod_com_res_post_m,'','S','','') sigla_pro_res_post_m
-- des_com_res_post_f
     , f_comune_al(md3.cod_pro_res_post_f,md3.cod_com_res_post_f,'') des_com_res_post_f
-- sigla_pro_res_post_f
     , f_provincia_stato_al(md3.cod_pro_res_post_f,md3.cod_com_res_post_f,'','S','','') sigla_pro_res_post_f
  from istmd3 md3
/
comment on table ISTmd3_V is 'ISTAT - Dati per Compilazione Modello D.3 (view)'
/
