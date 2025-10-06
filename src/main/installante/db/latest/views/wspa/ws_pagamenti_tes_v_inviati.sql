--liquibase formatted sql
--changeset amonopoli:202501141300_2 runAlways:true runOnChange:true stripComments:false
create or replace view WS_PAGAMENTI_TES_V_INVIATI
AS
select w.*,
       f_WSPA_get_pagatore(f_WSPA_get_min_id_rif(w.anno_pagamento,w.progr_pagamento,'ANNO'),
                           f_WSPA_get_min_id_rif(w.anno_pagamento,w.progr_pagamento,'PROGR'),
                           'COD_FISCALE') cod_fiscale_pagatore,
       f_WSPA_get_tot_documenti(w.anno_pagamento,w.progr_pagamento,'DOCUMENTI') tot_documenti
  from ws_pagamenti_tes w
 where flag_invio_ws||data_invio_ws||note_ws is not null
/
comment on table ws_pagamenti_tes_v_inviati is 'WS Pagamenti - Testata per Documenti inviati (view)'
/
