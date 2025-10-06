--liquibase formatted sql
--changeset amonopoli:202501141150_2 runAlways:true runOnChange:true stripComments:false
create or replace view WS_PAGAMENTI_V_INVIATI
AS
select w.*
  from ws_pagamenti w
 where flag_invio_ws||data_invio_ws||note_ws is not null
/
comment on table ws_pagamenti_v_inviati is 'WS Pagamenti - Documenti inviati (view)'
/
