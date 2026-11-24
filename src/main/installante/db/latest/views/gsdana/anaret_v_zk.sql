--liquibase formatted sql
--changeset amonopoli:202606111151_1 runAlways:true runOnChange:true stripComments:false
create or replace view anaret_v_zk
as
select ret.*,
       'RES' anagrafe,
       'R' tipo_evento
  from anaret ret
/
COMMENT ON TABLE ANARET_v_zk IS 'Anagrafe - Dati preparatori per Pratiche di Rettifica (view)'
/
