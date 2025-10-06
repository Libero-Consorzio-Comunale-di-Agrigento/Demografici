--liquibase formatted sql
--changeset amonopoli:202309211255 runAlways:true runOnChange:true stripComments:false
create or replace view civmar_v
AS
select v.*
     , f_comune_al(v.cod_pro_atto_nas,v.cod_com_atto_nas,f_CIV_data_atto_rif_j(to_number(v.data_nas_atto),to_number(rtrim(v.anno_nas)))) des_com_nas
     , f_provincia_stato_al(v.cod_pro_atto_nas,v.cod_com_atto_nas,'','S','S',f_CIV_data_atto_rif_j(to_number(v.data_nas_atto),to_number(rtrim(v.anno_nas)))) sigla_pro_nas
     , f_comune_al(v.cod_pro_aff_1,v.cod_com_aff_1,'') des_com_aff_1
     , f_provincia_stato_al(v.cod_pro_aff_1,v.cod_com_aff_1,'','S','S','') sigla_pro_aff_1
     , f_comune_al(v.cod_pro_aff_2,v.cod_com_aff_2,'') des_com_aff_2
     , f_provincia_stato_al(v.cod_pro_aff_2,v.cod_com_aff_2,'','S','S','') sigla_pro_aff_2
     , f_get_flag_comune_utente(v.cod_pro_atto_nas,v.cod_com_atto_nas) flag_comune_utente_nas
  from (select mar.*
             , f_CIV_get_campo(mar.tipo_atto,mar.id_atto,'DATA_NAS') data_nas_atto
          from civmar mar) v
/
comment on table CIVMAR_V is 'Stato Civile - Composizione: Dati a Margine (view)'
/
