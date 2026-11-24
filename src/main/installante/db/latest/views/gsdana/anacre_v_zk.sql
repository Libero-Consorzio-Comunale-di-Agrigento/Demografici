--liquibase formatted sql
--changeset amonopoli:202606111146_1 runAlways:true runOnChange:true stripComments:false
create or replace view anacre_v_zk
as
select cre.*,
       'RES' anagrafe,
       'E' tipo_evento
  from anacre cre
/
comment on table anacre_v_zk is 'Anagrafe - Dati preparatori per pratiche di Cambio Residenza (view)'
/
