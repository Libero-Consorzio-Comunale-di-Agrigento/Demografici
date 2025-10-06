--liquibase formatted sql
--changeset vmigliore:202501201000 runOnChange:true stripComments:false
create or replace function f_WSPA_popola_VDC

return number

IS

w_return	number;

begin
  begin
    insert into ws_pagamenti_vdc
           (tabella_rif, cod_diritto_rif, fascia_tariffaria_rif)
    select 'CERCEM', cod_diritto, fascia_tariffaria
      from cerdtd dtd
     where not exists (select 1
                         from ws_pagamenti_vdc
                        where tabella_rif = 'CERCEM'
                          and cod_diritto_rif = dtd.cod_diritto
                          and fascia_tariffaria_rif = dtd.fascia_tariffaria)
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