--liquibase formatted sql
--changeset amonopoli:202501151015_1 runOnChange:true stripComments:false
create or replace function f_WSPA_get_servizio
(a_tabella_rif		IN	varchar2
,a_cod_certificato_rif	IN	varchar2
,a_tipo_codice		IN	varchar2
)

return varchar2

IS

w_tipo_codice	varchar2(255) := upper(a_tipo_codice);
w_cod_servizio	varchar2(255);
w_cod_depag  	varchar2(255);

w_return	varchar2(255);

begin
  w_return := '';

  if a_tabella_rif is not null then
     begin
       select ser.cod_servizio, ser.cod_depag
         into w_cod_servizio, w_cod_depag
         from ws_pagamenti_ser ser
            , ws_pagamenti_doc doc
        where ser.cod_servizio = doc.cod_servizio
          and doc.tabella_rif  = a_tabella_rif
          and doc.cod_certificato_rif = a_cod_certificato_rif
          and rownum = 1
       ;
       if a_tipo_codice = 'DEPAG' then
          w_return := w_cod_depag;
       elsif a_tipo_codice = 'DEPAG_ID' then
          w_return := w_cod_servizio;
       end if;
     exception
       when others then
            w_return := '';
     end;
  end if;

  return w_return;

end;
/
