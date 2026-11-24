--liquibase formatted sql
--changeset amonopoli:202606111035 runOnChange:true stripComments:false
create or replace view anasap_v_zk
AS
select sap.*
  from anasap sap
/
comment on table anasap is 'Anagrafe - Stato Avanzamento Pratiche'
/
