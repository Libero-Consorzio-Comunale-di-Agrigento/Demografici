--liquibase formatted sql
--changeset amonopoli:202503211249_4 runOnChange:true stripComments:false
create or replace view istmd3_v_PUB
AS
select v.*
  from istmd3_v v
/
comment on table ISTmd3_v_PUB is 'ISTAT - Dati per Compilazione Modello D.3 (view) x Verbali Pubblicazione'
/
