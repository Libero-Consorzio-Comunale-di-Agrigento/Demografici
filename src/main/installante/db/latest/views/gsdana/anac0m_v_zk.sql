--liquibase formatted sql
--changeset amonopoli:202606111149_2 runAlways:true runOnChange:true stripComments:false
create or replace view anac0m_v_zk
as
select c0m.*,
       decode(c0m.anno_pratica||c0m.pratica, '', 'AIR', 'RES') anagrafe,
       decode(c0m.anno_pratica||c0m.pratica, '', 'C', 'I') tipo_evento,
       decode(c0m.anno_pratica||c0m.pratica,
         '', f_ANA_get_id_pratica('AIR', 'C', c0m.anno_protocollo_aire, c0m.protocollo_aire),
             f_ANA_get_id_pratica('RES', 'I', c0m.anno_pratica, c0m.pratica)) id_pratica,
       decode(c0m.anno_pratica||c0m.pratica,
         '', f_ANA_get_id_pratica('AIR', 'C', c0m.anno_protocollo_aire, c0m.protocollo_aire),
             f_ANA_get_id_pratica('RES', 'I', c0m.anno_pratica, c0m.pratica)) id_dichiarazione
  from anac0m c0m
/
COMMENT ON TABLE ANAC0M_v_zk IS 'Anagrafe - Matricole in AIRE/01 di Cancellazione (view)'
/
