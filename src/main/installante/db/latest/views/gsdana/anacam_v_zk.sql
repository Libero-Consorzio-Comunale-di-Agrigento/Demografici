--liquibase formatted sql
--changeset amonopoli:202606111150_2 runAlways:true runOnChange:true stripComments:false
create or replace view anacam_v_zk
as
select cam.*,
       'AIR' anagrafe,
       'E' tipo_evento,
       f_ANA_get_id_pratica('AIR', 'E', cam.anno_protocollo_aire, cam.protocollo_aire) id_pratica,
       f_ANA_get_id_pratica('AIR', 'E', cam.anno_protocollo_aire, cam.protocollo_aire) id_dichiarazione
  from anacam cam
/
comment on table anacam_v_zk is 'Anagrafe - Matricola in Pratiche di Cambio Residenza AIRE (view)'
/
