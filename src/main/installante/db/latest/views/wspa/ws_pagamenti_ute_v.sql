--liquibase formatted sql
--changeset amonopoli:202501221700 runAlways:true runOnChange:true stripComments:false
create or replace view WS_PAGAMENTI_UTE_V 
as
select ute.*
  from ws_pagamenti_ute ute
/
comment on table ws_pagamenti_ute_v is 'WS Pagamenti - Utenti / Identificativi Operatore (view)'
/
