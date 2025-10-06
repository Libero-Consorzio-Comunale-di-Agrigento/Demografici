--liquibase formatted sql
--changeset amonopoli:202501150850 runOnChange:true stripComments:false
create or replace function f_WSPA_get_url
(a_chiave_provider	IN	varchar2
,a_url			IN	varchar2	default NULL
)

return varchar2

IS

w_provider	varchar2(255) := f_WSPA_get_provider();

w_url		varchar2(32000);

begin

  if a_chiave_provider is not null then
     if w_provider = 'DEPAG' then
        w_url := ws_pagamenti_pkg.f_depag_get_url(a_chiave_provider);
     elsif w_provider = 'NEXTSTEP' then
        w_url := a_url;
     end if;
  end if;

  return w_url;

end;
/
