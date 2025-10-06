--liquibase formatted sql
--changeset amonopoli:202501141715 runOnChange:true stripComments:false
create or replace function f_WSPA_get_tot_documenti
(a_anno_pagamento	IN	number
,a_progr_pagamento	IN	number
,a_campo		IN	varchar2
)

return number

IS

w_campo			varchar2(255) := upper(a_campo);

w_tot_documenti		number;
w_tot_da_inviare	number;
w_tot_inviati		number;
w_tot_da_annullare	number;
w_tot_annullati		number;
  
w_return		number;

begin
  if a_anno_pagamento is not null and a_progr_pagamento is not null and a_campo is not null then
     begin
       select count(decode(ws.flag_annullato, '', ws.progr_rif, '')),
              count(decode(ws.flag_annullato, '', decode(ws.flag_invio_ws,'', ws.progr_rif,''))),
              count(decode(ws.flag_annullato, '', decode(ws.flag_invio_ws,'S', ws.progr_rif,''))),
              count(decode(ws.flag_annullato, '', decode(ws.flag_da_annullare,'S', ws.progr_rif,''))),
              count(decode(ws.flag_annullato, '', '', ws.progr_rif))
         into w_tot_documenti,
              w_tot_da_inviare,
              w_tot_inviati,
              w_tot_da_annullare,
              w_tot_annullati
         from ws_pagamenti ws
        where anno_pagamento = a_anno_pagamento
          and progr_pagamento = a_progr_pagamento
       ;
     exception
       when others then
            w_tot_documenti    := 0;
            w_tot_da_inviare   := 0;
            w_tot_inviati      := 0;
            w_tot_da_annullare := 0;
            w_tot_annullati    := 0;
     end; 

     if w_campo = 'DOCUMENTI' then
        w_return := w_tot_documenti;

     elsif w_campo = 'DA_INVIARE' then
        w_return := w_tot_da_inviare;

     elsif w_campo = 'INVIATI' then
        w_return := w_tot_inviati;

     elsif w_campo = 'DA_ANNULLARE' then
        w_return := w_tot_da_annullare;

     elsif w_campo = 'ANNULLATI' then
        w_return := w_tot_annullati;

     else 
        w_return := '';

     end if;
  end if;

  return w_return;

end;
/
