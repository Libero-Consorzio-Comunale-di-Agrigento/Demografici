--liquibase formatted sql
--changeset amonopoli:202501301445 runOnChange:true stripComments:false
create or replace function f_ANSC_flag_ufficiale_sindaco
(a_qualifica_utente_ads		IN	varchar2
)

return varchar2

IS


w_return  varchar2(255);

begin

  if upper(a_qualifica_utente_ads) = 'SINDACO' then
     w_return := 'S';
  end if;

  return w_return;

end;
/
