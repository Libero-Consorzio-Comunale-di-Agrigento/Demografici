--liquibase formatted sql
--changeset amonopoli:202606111147_1 runAlways:true runOnChange:true stripComments:false
create or replace view anacp4_v_zk
as
select cp4.*,
       'RES' anagrafe,
       'C' tipo_evento,
       f_ANA_get_id_pratica('RES', 'C', cp4.anno_pratica, cp4.pratica) id_pratica,
       f_ANA_get_id_pratica('RES', 'C', cp4.anno_dic, cp4.numero_dic) id_dichiarazione
  from anacp4 cp4
/
COMMENT ON TABLE ANACP4_v_zk IS 'Anagrafe - Testata Modello APR4 di Cancellazione (view)'
/
