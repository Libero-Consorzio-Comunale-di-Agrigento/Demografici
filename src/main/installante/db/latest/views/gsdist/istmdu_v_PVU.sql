--liquibase formatted sql
--changeset amonopoli:202503211251_3 runOnChange:true stripComments:false
create or replace view istmdu_v_PVU
AS
select v.*
  from istmdu_v v
/
comment on table ISTmdu_v_PVU is 'ISTAT - Dati per Compilazione Modello D.3U (view) x Processi Verbali'
/
