--liquibase formatted sql
--changeset amonopoli:202606111150_1 runAlways:true runOnChange:true stripComments:false
create or replace view anacaa_v_zk
as
select caa.*,
       'AIR' anagrafe,
       'E' tipo_evento,
       f_ANA_get_id_pratica('AIR', 'E', caa.anno_protocollo_aire, caa.protocollo_aire) id_pratica,
       f_ANA_get_id_pratica('AIR', 'E', caa.anno_protocollo_aire, caa.protocollo_aire) id_dichiarazione
  from anacaa caa
/
comment on table anacaa_v_zk is 'Anagrafe - Dati preparatori per pratiche di Cambio Residenza AIRE (view)'
/
