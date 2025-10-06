--liquibase formatted sql
--changeset amonopoli:202501141730 runOnChange:true stripComments:false
create or replace function f_WSPA_get_min_id_rif
(a_anno_pagamento	IN	number
,a_progr_pagamento	IN	number
,a_campo		IN	varchar2
)

return number

IS

w_campo			varchar2(255) := upper(a_campo);

w_anno_rif		number;
w_progr_rif		number;
w_id_tabella_rif	number;

w_return		number;

begin
  if a_anno_pagamento is not null and a_progr_pagamento is not null and a_campo is not null then
     begin
       select min(ws.anno_rif), min(ws.progr_rif), min(ws.id_tabella_rif)
         into w_anno_rif, w_progr_rif, w_id_tabella_rif
         from ws_pagamenti ws
        where anno_pagamento = a_anno_pagamento
          and progr_pagamento = a_progr_pagamento
       ;
     exception
       when others then
            w_return := '';
     end; 

     if w_campo = 'ANNO' then
        w_return := w_anno_rif;

     elsif w_campo = 'PROGR' then
        w_return := w_progr_rif;

     elsif w_campo = 'ID' then
        w_return := w_id_tabella_rif;

     else 
        w_return := '';

     end if;

  end if;

  return w_return;

end;
/
