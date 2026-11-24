--liquibase formatted sql
--changeset amonopoli:202511111445 runAlways:true runOnChange:true stripComments:false
create or replace view anaauc_v
AS
select auc.*,
--
       decode(auc.rapporto_par, '', to_char(null), auc.sesso_mor||auc.rapporto_par) id_anadrp,
--
       f_comune_al(auc.cod_pro_nas_mor,auc.cod_com_nas_mor,auc.data_nas_mor) des_com_nas_mor,
       f_provincia_stato_al(auc.cod_pro_nas_mor,auc.cod_com_nas_mor,'','S','',auc.data_nas_mor) sigla_pro_nas_mor,
       f_comune_al(auc.cod_pro_mor,auc.cod_com_mor,data_mor) des_com_mor,
       f_provincia_stato_al(auc.cod_pro_mor,auc.cod_com_mor,'','S','',auc.data_mor) sigla_pro_mor,
       f_comune_al(auc.cod_pro_atto_mor,auc.cod_com_atto_mor,'') des_com_atto_mor,
       f_provincia_stato_al(auc.cod_pro_atto_mor,auc.cod_com_atto_mor,'','S','','') sigla_pro_atto_mor
  from anaauc auc
/
comment on table anaauc is 'Anagrafe - Dati di Affidamento di Urna Cineraria (view)'
/
