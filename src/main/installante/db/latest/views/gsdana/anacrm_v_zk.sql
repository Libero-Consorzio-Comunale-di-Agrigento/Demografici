--liquibase formatted sql
--changeset amonopoli:202606111146_2 runAlways:true runOnChange:true stripComments:false
create or replace view anacrm_v_zk
as
select crm.*,
       'RES' anagrafe,
       'E' tipo_evento,
       f_ANA_get_id_pratica('RES', 'E', crm.anno_pratica, crm.pratica) id_dichiarazione
  from anacrm crm
/
comment on table anacrm_v_zk is 'Anagrafe - Matricola in Pratiche di Cambio Residenza (view)'
/
