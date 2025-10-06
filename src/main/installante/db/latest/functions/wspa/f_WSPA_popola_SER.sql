--liquibase formatted sql
--changeset vmigliore:202501201005 runOnChange:true stripComments:false
create or replace function f_WSPA_popola_SER

return number

IS

w_return	number;

begin
  begin
    insert into ws_pagamenti_ser
           (cod_servizio, descrizione, cod_tassonomia, des_tassonomia, cod_depag, flag_default)
    select 'CER', 'Rilascio Certificati', '103', 'Diritti di segreteria per certificati anagrafici', '', 'S'
      from dual
     where not exists (select 'x' from ws_pagamenti_ser b
                        where b.cod_servizio = 'CER')
    UNION
    select 'CIE', 'Rilascio CIE', '100', 'Emissione carta d''identitÃ  Elettronica', '', ''
      from dual
     where not exists (select 'x' from ws_pagamenti_ser b
                        where b.cod_servizio = 'CIE')
    UNION
    select 'CDI', 'Rilascio CI cartacea', '104', 'Costo per emissione Carta d''identitÃ  cartacea', '', ''
      from dual
     where not exists (select 'x' from ws_pagamenti_ser b
                        where b.cod_servizio = 'CDI')
    UNION
    select 'MAT', 'Servizio Celebrazione Matrimoni', '102', 'Servizio celebrazione matrimoni civili', '', ''
      from dual
     where not exists (select 'x' from ws_pagamenti_ser b
                        where b.cod_servizio = 'MAT')
    UNION
    select 'DIV', 'Diritto per Seperazione / Divorzi', '101', 'Diritto fisso Separazione/Divorzi', '', ''
      from dual
     where not exists (select 'x' from ws_pagamenti_ser b
                        where b.cod_servizio = 'DIV')
    ;
    if sql%found then
       w_return := 1;
    else
       w_return := 0;
    end if;
  exception
    when others then
         w_return := -1;
  end;

  return w_return;

end;
/