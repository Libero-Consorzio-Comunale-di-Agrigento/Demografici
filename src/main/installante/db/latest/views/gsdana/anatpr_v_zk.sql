--liquibase formatted sql
--changeset amonopoli:202606111030 runAlways:true runOnChange:true stripComments:false
create or replace view anatpr_v_zk
as
select tpr.*,
       f_TPR_des_variazione(tpr.anagrafe, tpr.tipo_evento, tpr.cod_variazione) des_variazione,
       f_TPR_max_evento_pratica(tpr.anagrafe, tpr.tipo_evento, tpr.anno_pratica, tpr.pratica) max_evento_pratica,
       f_TPR_gg_monitoraggio(tpr.anagrafe, tpr.tipo_evento, tpr.anno_pratica, tpr.pratica, tpr.data_pratica, 
         f_TPR_max_evento_pratica(tpr.anagrafe, tpr.tipo_evento, tpr.anno_pratica, tpr.pratica)) gg_monitoraggio,
       tpr.anagrafe||'-'||tpr.tipo_evento||'-'||'INI'||'-'||nvl(tpr.iniziativa,0) id_iniziativa,
       f_flag_preliminare(tpr.anagrafe,tpr.tipo_evento,tpr.anno_pratica,tpr.pratica) flag_perfezionamento_P
  from anatpr tpr
/
comment on table anatpr_v_zk is 'Anagrafe - Testata Pratiche (view)'
/
