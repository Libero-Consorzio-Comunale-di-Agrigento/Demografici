--liquibase formatted sql
--changeset amonopoli:202501141200 runOnChange:true stripComments:false
insert into ws_pagamenti_tes
       (id, anno_pagamento, progr_pagamento,
        flag_invio_ws, data_invio_ws, note_ws,
        TERMINALISTA, DATA_REG, chiave_provider, url_provider,
        d_data_invio_ws, d_data_reg, flag_annullato)
select '',
       v.ANNO_PAGAMENTO,
       v.PROGR_PAGAMENTO,
       v.FLAG_INVIO_WS,
       v.DATA_INVIO_WS,
       v.NOTE_WS,
       v.TERMINALISTA,
       v.DATA_REG,
       v.CHIAVE_PROVIDER,
       v.URL_PROVIDER,
       to_date(v.DATA_INVIO_WS,'j'),
       to_date(v.DATA_REG,'j'),
       v.FLAG_ANNULLATO
  from ws_pagamenti_tes_v v
 where not exists (select 1 from ws_pagamenti_tes b
                    where b.anno_pagamento  = v.anno_pagamento
                      and b.progr_pagamento = v.progr_pagamento)
/
