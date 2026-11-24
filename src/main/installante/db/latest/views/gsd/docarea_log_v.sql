--liquibase formatted sql
--changeset amonopoli:202305260925_4 runAlways:true runOnChange:true stripComments:false
create or replace view DOCAREA_LOG_v
AS
select t.*
     , t.note note_vis
     , t.campo_clob info_vis
  from docarea_log t
/
comment on table DOCAREA_LOG_v is 'DOCAREA - Tabella di Log (view)'
/
