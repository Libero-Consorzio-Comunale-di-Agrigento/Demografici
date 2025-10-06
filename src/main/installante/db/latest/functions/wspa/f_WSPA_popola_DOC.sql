--liquibase formatted sql
--changeset vmigliore:202501201006 runOnChange:true stripComments:false
create or replace function f_WSPA_popola_DOC

return number

IS

w_return	number;

begin
  begin
    insert into ws_pagamenti_doc
           (tabella_rif, cod_certificato_rif, cod_servizio)
    select 'CERCEM', dce.cod_certificato, wps.cod_servizio
      from ws_pagamenti_ser wps
         , cerdce dce
     where wps.cod_servizio    = 'CIE'
       and wps.cod_depag       is not null
       and dce.cod_certificato in ('CIE')
       and exists (select 'x' from cerddc ddc
                    where ddc.cod_certificato = dce.cod_certificato)
       and not exists (select 'x' from ws_pagamenti_doc wpd
                        where wpd.tabella_rif         = 'CERCEM'
                          and wpd.cod_certificato_rif = dce.cod_certificato)
    UNION
    select 'CERCEM', dce.cod_certificato, wps.cod_servizio
      from ws_pagamenti_ser wps
         , cerdce dce
     where wps.cod_servizio    = 'CDI'
       and wps.cod_depag       is not null
       and dce.cod_certificato in ('CDI','CDA','CDN',
                                   'CI1','CA1','CN1',
                                   'CI2','CA2','CN2',
                                   'CI3','CA3','CN3',
                                   'CI4','CA4','CN4',
                                   'CI5','CA5','CN6',
                                   'CI6','CA6','CN6',
                                   'CI7','CA7','CN7',
                                   'CI8','CA8','CN8',
                                   'CI9','CA9','CN9')
       and exists (select 'x' from cerddc ddc
                    where ddc.cod_certificato = dce.cod_certificato)
       and not exists (select 'x' from ws_pagamenti_doc wpd
                        where wpd.tabella_rif         = 'CERCEM'
                          and wpd.cod_certificato_rif = dce.cod_certificato)
    UNION
    select 'CERCEM', dce.cod_certificato, wps.cod_servizio
      from ws_pagamenti_ser wps
         , cerdce dce
     where wps.cod_servizio    = 'CER'
       and wps.cod_depag       is not null
       and dce.cod_certificato not in ('CIE',
                                       'CDI','CDA','CDN',
                                       'CI1','CA1','CN1',
                                       'CI2','CA2','CN2',
                                       'CI3','CA3','CN3',
                                       'CI4','CA4','CN4',
                                       'CI5','CA5','CN6',
                                       'CI6','CA6','CN6',
                                       'CI7','CA7','CN7',
                                       'CI8','CA8','CN8',
                                       'CI9','CA9','CN9')
       and exists (select 'x' from cerddc ddc
                    where ddc.cod_certificato = dce.cod_certificato)
       and not exists (select 'x' from ws_pagamenti_doc wpd
                        where wpd.tabella_rif         = 'CERCEM'
                          and wpd.cod_certificato_rif = dce.cod_certificato)
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

