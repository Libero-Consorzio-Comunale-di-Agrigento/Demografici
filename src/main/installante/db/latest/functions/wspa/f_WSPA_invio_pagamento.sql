--liquibase formatted sql
--changeset amonopoli:202501151230 runOnChange:true stripComments:false
create or replace function f_WSPA_invio_pagamento
(a_anno_pagamento	IN	number
,a_progr_pagamento	IN	number
,a_terminalista		IN	varchar2
)

return clob

IS

w_flag_errore	varchar2(255);
w_messaggio	varchar2(32000);
w_url		varchar2(4000);

w_return	clob;

begin
  w_return := '';

  if a_anno_pagamento is null or a_progr_pagamento is null then
     w_return := 'Invio non consentito: estremi pagamento non presenti';

  else
     begin
       ws_pagamenti_pkg.ws_attivazione(a_anno_pagamento,a_progr_pagamento,w_flag_errore,w_messaggio,w_url);
     exception
       when others then
            w_return := 'Errore in invocazione WS Pagamenti';
            goto fine;
     end;

     if w_flag_errore is not null then
        if w_messaggio is not null then
           w_return := 'Errore in invio richiesta del WS: '||w_messaggio;
        else
           w_return := 'Errore in invio richiesta del WS';
        end if;
     end if;
  end if;

<< fine >>
  return w_return;

end;
/
