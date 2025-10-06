--liquibase formatted sql
--changeset amonopoli:202503211249_3 runOnChange:true stripComments:false
create or replace view istmd3_v_MAT
AS
select v.*
  from istmd3_v v
/
comment on table ISTmd3_V_MAT is 'ISTAT - Dati per Compilazione Modello D.3 (view) x Matrimoni'
/
