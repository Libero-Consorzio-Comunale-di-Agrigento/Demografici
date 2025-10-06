--liquibase formatted sql
--changeset amonopoli:202501211605 runAlways:true runOnChange:true stripComments:false
create or replace view WS_PAGAMENTI_WRK_V
AS
select w.*
     , to_char(to_date(w.data_scadenza,'yyyy-mm-dd'),'dd-mm-yyyy') data_scadenza_ddmmyyyy
     , to_char(to_date(w.ip_data_pagamento,'yyyy-mm-dd'),'dd-mm-yyyy') ip_data_pagamento_ddmmyyyy
  from ws_pagamenti_wrk w
/
comment on table ws_pagamenti_wrk_v is 'WS Pagamenti - Tabella di Working per importa dati ottenuti dal servizio LeggiDovuto (view)'
/
