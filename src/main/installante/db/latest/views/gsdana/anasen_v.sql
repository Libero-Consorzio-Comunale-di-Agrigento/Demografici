--liquibase formatted sql
--changeset amonopoli:202504021245 runAlways:true runOnChange:true stripComments:false
create or replace view anasen_v
AS
select sen.*
-- 
     , f_comune_al(sen.cod_pro_trib,sen.cod_com_trib,'') des_com_trib
     , f_provincia_stato_al(sen.cod_pro_trib,sen.cod_com_trib,'','S','','') sigla_pro_trib
     , f_comune_al(sen.cod_pro_atto_tr,sen.cod_com_atto_tr,sen.data_atto_tr) des_com_atto_tr
     , f_provincia_stato_al(sen.cod_pro_atto_tr,sen.cod_com_atto_tr,'','S','',sen.data_atto_tr) sigla_pro_atto_tr
--
     , f_get_descrizione_TSE(sen.tipo_sentenza) des_tipo_sentenza
     , f_get_descrizione_DTP(sen.tipo_provvedimento) des_tipo_provvedimento
     , f_get_descrizione_DEN(sen.ente_provvedimento) des_ente_provvedimento
  from anasen sen
/
comment on table anasen_v is 'Anagrafe - Provvedimento / Sentenze dell''Individuo (view)'
/
