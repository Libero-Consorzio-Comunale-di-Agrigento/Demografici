--liquibase formatted sql
--changeset vmigliore:202501141600 runOnChange:true stripComments:false
create or replace function f_WSPA_progr_pagamento
(a_anno 		IN 	    number)

return number

IS

w_numero        number      := 0;
w_contatore     number;

w_errore	varchar(4000);
errore		exception;

begin
  if a_anno is null then
     return 0;
  end if;

  -- Ottengo il numero dal contatore
  begin
    select nvl(max(numero), 0)
      into w_contatore
      from ws_pagamenti_n01
     where anno = a_anno
    ;
  exception
    when others then
         w_errore := 'errore in sel_ws_pagamenti_n01 ('||sqlerrm||')';
         raise errore;
  end;

  w_numero := w_contatore + 1;

  -- Se il numero selezionato è maggiore del contatore aggiorno il contatore
  if w_numero > w_contatore then
     begin
       update ws_pagamenti_n01
          set numero = w_numero
        where anno = a_anno
       ;
     exception
       when others then
            w_errore := 'errore in upd_ws_pagamenti_n01 ('||sqlerrm||')';
            raise errore;
     end;

     if SQL%ROWCOUNT = 0 then
        begin
          insert into ws_pagamenti_n01 (anno, numero)
          values (a_anno, w_numero)
          ;
        exception
          when others then
               w_errore := 'errore in ins_ws_pagamenti_n01 ('||sqlerrm||')';
               raise errore;
        end;
     end if;
  end if;

  return w_numero;

exception
  when errore then
--       rollback;
--       raise_application_error(-20999, w_errore);
       return 0;
  when others then
       w_errore := 'errore ('||sqlerrm||')';
--       rollback;
--       raise_application_error(-20999, w_errore);
       return 0;
end;
/
