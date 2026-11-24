--liquibase formatted sql
--changeset amonopoli:202501101045 runAlways:true runOnChange:true stripComments:false
create or replace view WS_PAGAMENTI_LOG_v
AS
select v.*
     , v.note note_vis
     , v.campo_clob info_vis
  from ws_pagamenti_log v
/
comment on table WS_PAGAMENTI_LOG_v is 'WS Pagamenti - Tabella di Log (view)'
/
