--liquibase formatted sql
--changeset amonopoli:202305260925_2 runAlways:true runOnChange:true stripComments:false
create or replace view ISTAT_LOG_v
AS
select t.*
     , t.note note_vis
  from istat_log t
/
comment on table ISTAT_LOG_v is 'ISTAT - Tabella di Log (view)'
/
