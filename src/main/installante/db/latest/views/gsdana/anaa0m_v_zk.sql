--liquibase formatted sql
--changeset amonopoli:202606111148_2 runAlways:true runOnChange:true stripComments:false
create or replace view anaa0m_v_zk
as
select a0m.*,
       decode(a0m.anno_pratica||a0m.pratica, '', 'AIR', 'RES') anagrafe,
       decode(a0m.anno_pratica||a0m.pratica, '', 'I', 'C') tipo_evento,
       decode(a0m.anno_pratica||a0m.pratica,
         '', f_ANA_get_id_pratica('AIR', 'I', a0m.anno_protocollo_aire, a0m.protocollo_aire),
             f_ANA_get_id_pratica('RES', 'C', a0m.anno_pratica, a0m.pratica)) id_pratica,
       decode(a0m.anno_pratica||a0m.pratica,
         '', f_ANA_get_id_pratica('AIR', 'I', a0m.anno_protocollo_aire, a0m.protocollo_aire),
             f_ANA_get_id_pratica('RES', 'C', a0m.anno_pratica, a0m.pratica)) id_dichiarazione
  from anaa0m a0m
/
COMMENT ON TABLE ANAA0M_v_zk IS 'Anagrafe - Matricole in AIRE/01 (view)'
/
