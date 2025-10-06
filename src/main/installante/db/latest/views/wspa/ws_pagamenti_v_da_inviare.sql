--liquibase formatted sql
--changeset amonopoli:202501141150_1 runAlways:true runOnChange:true stripComments:false
create or replace view WS_PAGAMENTI_V_DA_INVIARE
AS
select w.ID,
       w.ANNO_PAGAMENTO,
       w.PROGR_PAGAMENTO,
       w.TABELLA_RIF,
       w.ANNO_RIF,
       w.PROGR_RIF,
       w.TERMINALISTA,
       w.DATA_REG,
       w.FLAG_ANNULLATO,
       w.ID_TABELLA_RIF,
       w.D_DATA_REG,
       w.ID_WS_PAGAMENTI_TES,
       f_WSPA_get_provider() provider,
       f_WSPA_get_servizio_x_id_rif(w.tabella_rif,w.id_tabella_rif,'DEPAG_ID') cod_servizio_depag,
       f_WSPA_get_servizio_x_id_rif(w.tabella_rif,w.id_tabella_rif,'DEPAG') servizio_depag
  from ws_pagamenti w
 where flag_invio_ws||data_invio_ws||note_ws is null
/
comment on table ws_pagamenti_v_da_inviare is 'WS Pagamenti - Documenti da inviare (view)'
/
