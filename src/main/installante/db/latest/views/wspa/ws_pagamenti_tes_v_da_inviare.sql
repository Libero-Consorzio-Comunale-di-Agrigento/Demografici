--liquibase formatted sql
--changeset amonopoli:202501141300_1 runAlways:true runOnChange:true stripComments:false
create or replace view WS_PAGAMENTI_TES_V_DA_INVIARE
AS
select w.ID,
       w.ANNO_PAGAMENTO,
       w.PROGR_PAGAMENTO,
       w.TERMINALISTA,
       w.DATA_REG,
       w.D_DATA_REG
  from ws_pagamenti_tes w
 where flag_invio_ws||data_invio_ws||note_ws is null
/
comment on table ws_pagamenti_tes_v_da_inviare is 'WS Pagamenti - Testata per Documenti da inviare (view)'
/
