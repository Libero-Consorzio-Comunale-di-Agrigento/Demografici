--liquibase formatted sql
--changeset vmigliore:202501101800 runAlways:true stripComments:false
create or replace view WS_PAGAMENTI_DOC_V as
select doc.*
from WS_PAGAMENTI_DOC doc
/
comment on table ws_pagamenti_doc_v is 'WS Pagamenti - Relazione Documenti / Servizi DePag (view)'
/