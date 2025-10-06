--liquibase formatted sql
--changeset amonopoli:202306261420 runAlways:true runOnChange:true stripComments:false
create or replace view civspo_v
AS
select v.*
     , f_comune_al(v.cod_pro_atto_nas_m,v.cod_com_atto_nas_m,f_CIV_data_atto_rif_j(to_number(v.data_nas_m_atto),v.anno_atto_nas_m)) des_com_atto_nas_m
     , f_provincia_stato_al(v.cod_pro_atto_nas_m,v.cod_com_atto_nas_m,'','S','S',f_CIV_data_atto_rif_j(to_number(v.data_nas_m_atto),v.anno_atto_nas_m)) sigla_pro_atto_nas_m
     , f_comune_al(v.cod_pro_atto_nas_f,v.cod_com_atto_nas_f,f_CIV_data_atto_rif_j(to_number(v.data_nas_f_atto),v.anno_atto_nas_f)) des_com_atto_nas_f
     , f_provincia_stato_al(v.cod_pro_atto_nas_f,v.cod_com_atto_nas_f,'','S','S',f_CIV_data_atto_rif_j(to_number(v.data_nas_f_atto),v.anno_atto_nas_f)) sigla_pro_atto_nas_f
     , f_comune_al(v.cod_pro_atto_mat,v.cod_com_atto_mat,f_CIV_data_atto_rif_j('',v.anno_atto_mat)) des_com_atto_mat
     , f_provincia_stato_al(v.cod_pro_atto_mat,v.cod_com_atto_mat,'','S','S',f_CIV_data_atto_rif_j('',v.anno_atto_mat)) sigla_pro_atto_mat
     , f_comune_al(v.cod_pro_mat,v.cod_com_mat,to_char(v.d_data_mat,'j')) des_com_mat
     , f_provincia_stato_al(v.cod_pro_mat,v.cod_com_mat,'','S','S',to_char(v.d_data_mat,'j')) sigla_pro_mat
     , f_get_flag_comune_utente(v.cod_pro_atto_nas_m,v.cod_com_atto_nas_m) flag_comune_utente_m
     , f_get_flag_comune_utente(v.cod_pro_atto_nas_f,v.cod_com_atto_nas_f) flag_comune_utente_f
     , f_get_flag_comune_utente(v.cod_pro_atto_mat,v.cod_com_atto_mat) flag_comune_utente_mat
  from (select spo.*
             , f_CIV_get_campo(spo.tipo_atto,spo.id_atto,'DATA_NAS_M') data_nas_m_atto
             , f_CIV_get_campo(spo.tipo_atto,spo.id_atto,'DATA_NAS_F') data_nas_f_atto
          from civspo spo) v
/
comment on table CIVSPO is 'Stato Civile - Composizione: Dati degli Sposi (view)'
/
