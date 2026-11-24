--liquibase formatted sql
--changeset amonopoli:202606111151_2 runAlways:true runOnChange:true stripComments:false
create or replace view anarem_v_zk
as
select rem.*,
       'RES' anagrafe,
       'R' tipo_evento,
       f_ANA_get_id_pratica('RES', 'R', rem.anno_pratica, rem.pratica) id_dichiarazione
  from anarem rem
/
comment on table anarem_v_zk is 'Anagrafe - Matricola in Pratiche di Rettifica (view)'
/
