--liquibase formatted sql
--changeset snocca:202401251037 runOnChange:true stripComments:false
create or replace function f_ANSC_tipo_nascita_soggetto
(a_tipo_ads	IN	varchar2
)

return varchar2

IS

w_tipo			number(2):=1;

-- ansc_107
-- 1 - nato vivo
-- 2 - nato morto
-- 3 - nato vivo ma successivamente deceduto

begin

  if a_tipo_ads = 'SI' then
    w_tipo := 2;
  elsif a_tipo_ads = 'NO' then
    w_tipo := 3;
  end if;

  return w_tipo;
end;
/
