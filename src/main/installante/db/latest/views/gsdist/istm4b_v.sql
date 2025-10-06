--liquibase formatted sql
--changeset amonopoli:202503211247_1 runOnChange:true stripComments:false
create or replace view istm4b_v
AS
select m4b.*
-- des_com_res_mat
     , f_comune_al(m4b.cod_pro_res_mat,m4b.cod_com_res_mat,'') des_com_res_mat
-- sigla_pro_res_mat
     , f_provincia_stato_al(m4b.cod_pro_res_mat,m4b.cod_com_res_mat,'','S','','') sigla_pro_res_mat
  from istm4b m4b
/
comment on table istm4b_V is 'ISTAT - Dati per Compilazione Modello D.4 (view)'
/
