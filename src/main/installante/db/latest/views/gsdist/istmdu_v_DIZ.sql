--liquibase formatted sql
--changeset amonopoli:202503211251_0 runOnChange:true stripComments:false
create or replace view istmdu_v_DIZ
AS
select v.*
  from istmd3_v_DIZ v
/
comment on table ISTmdu_v_DIZ is 'ISTAT - Modello D.3U - Codifiche'
/
