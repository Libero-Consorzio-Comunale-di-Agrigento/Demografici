--liquibase formatted sql
--changeset amonopoli:202305260925_5 runAlways:true runOnChange:true stripComments:false
create or replace view FIRMAREMOTA_LOG_v
AS
select t.*
     , t.note note_vis
     , t.campo_clob info_vis
  from FIRMAREMOTA_log t
/
comment on table FIRMAREMOTA_LOG_v is 'FIRMAREMOTA - Tabella di Log (view)'
/
