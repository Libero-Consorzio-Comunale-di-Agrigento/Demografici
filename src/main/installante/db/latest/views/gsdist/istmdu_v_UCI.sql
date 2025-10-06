--liquibase formatted sql
--changeset amonopoli:202503211251_4 runOnChange:true stripComments:false
create or replace view istmdu_v_UCI
AS
select v.*
  from istmdu_v v
/
comment on table ISTmdu_v_UCI is 'ISTAT - Dati per Compilazione Modello D.3U (view) x Unioni civili'
/
