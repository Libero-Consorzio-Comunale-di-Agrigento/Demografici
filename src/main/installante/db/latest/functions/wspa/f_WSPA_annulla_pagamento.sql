--liquibase formatted sql
--changeset amonopoli:202501151310 runOnChange:true stripComments:false
create or replace function f_WSPA_annulla_pagamento
(a_chiave_provider	IN	number
,a_terminalista		IN	varchar2
)

return clob

IS

w_anno_pagamento    number := '';
w_progr_pagamento   number := '';

w_servizio	varchar2(255) := 'ELIMINA_DOVUTO';
w_iuv		varchar2(255) := a_chiave_provider;

w_flag_errore	varchar2(255);
w_messaggio	varchar2(32000);
w_url		varchar2(4000);

w_return	clob;

begin
  w_return := '';

  if a_chiave_provider is null then
     w_return := 'Richiesta non consentita: chiave di ricerca pagamento (IUV) non disponibile';

  else
     begin
       ws_pagamenti_pkg.ws_depag(w_anno_pagamento,w_progr_pagamento,w_servizio,w_iuv,w_flag_errore,w_messaggio,w_url);
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
