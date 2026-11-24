--liquibase formatted sql
--changeset amonopoli:202503050925_1 runAlways:true runOnChange:true stripComments:false
create or replace view anaeve_v
AS
select eve.*
--
     , f_ANA_get_anagrafe(eve.cod_mov) anagrafe
--
     , f_get_campo_VIE(eve.cod_via,'DENOM_UFF') des_cod_via
     , f_comune_al(eve.COD_PRO_EVE,eve.COD_COM_EVE,'') des_com_eve
     , f_provincia_stato_al(eve.COD_PRO_EVE,eve.COD_COM_EVE,'','S','','') sigla_pro_eve
     , f_comune_al(eve.COD_PRO_RIC,eve.COD_COM_RIC,'') des_com_ric
     , f_provincia_stato_al(eve.COD_PRO_RIC,eve.COD_COM_RIC,'','S','','') sigla_pro_ric
     , f_comune_al(eve.COD_PRO_AIRE,eve.COD_COM_AIRE,'') des_com_aire
     , f_provincia_stato_al(eve.COD_PRO_AIRE,eve.COD_COM_AIRE,'','S','','') sigla_pro_aire
     , f_comune_al(eve.COD_PRO_ISCR_AIRE,eve.COD_COM_ISCR_AIRE,'') des_com_iscr_aire
     , f_provincia_stato_al(eve.COD_PRO_ISCR_AIRE,eve.COD_COM_ISCR_AIRE,'','S','','') sigla_pro_iscr_aire
  from anaeve eve
/
comment on table anaeve_v is 'Anagrafe - Eventi (view)'
/
