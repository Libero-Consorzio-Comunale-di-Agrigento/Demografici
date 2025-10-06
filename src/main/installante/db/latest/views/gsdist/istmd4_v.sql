--liquibase formatted sql
--changeset amonopoli:202503211250_1 runOnChange:true stripComments:false
create or replace view istmd4_v
AS
select md4.*
  from istmd4 md4
/
comment on table istmd4_V is 'ISTAT - Dati per Compilazione Modello D.4 (view)'
/
