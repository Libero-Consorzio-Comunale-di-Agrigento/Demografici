--liquibase formatted sql
--changeset amonopoli:202606111147_2 runAlways:true runOnChange:true stripComments:false
create or replace view anacpm_v_zk
as
select cpm.*,
       rownum id,
       'RES' anagrafe,
       'C' tipo_evento,
       (select id_pratica from anacp4_v_zk where anno_dic = cpm.anno_dic and numero_dic = cpm.numero_dic) id_pratica,
       f_ANA_get_id_pratica('RES', 'C', cpm.anno_dic, cpm.numero_dic) id_dichiarazione
  from anacpm cpm
/
COMMENT ON TABLE ANACPM_V_ZK IS 'Anagrafe - Individui in APR/4 di Cancellazione (view)'
/
