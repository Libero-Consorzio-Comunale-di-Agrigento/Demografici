--liquibase formatted sql
--changeset amonopoli:202305260925_1 runAlways:true runOnChange:true stripComments:false
create or replace view ANSC_LOG_v
AS
select t.*
     , '('||t.servizio||decode(t.id_atto, '', '', ' - '||t.id_atto)||') '||t.note note_vis
     , t.campo_clob info_vis
  from ansc_log t
/
comment on table ANSC_LOG_v is 'ANSC - Tabella di Log (view)'
/
