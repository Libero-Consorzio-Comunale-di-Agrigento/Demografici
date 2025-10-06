--liquibase formatted sql
--changeset amonopoli:202307171705_1 runOnChange:true stripComments:false
create or replace function f_ANSC_tipologia_documento
(a_tipo_documento 		IN	varchar2
)

return varchar2

IS

w_tipo			varchar2(10);

begin
-- 1 - patente
-- 2 - passaporto
-- 3 - carta identita

  if a_tipo_documento is null then
     goto fine;
  end if;

  if a_tipo_documento in ('PT') then
     w_tipo := '1';

  elsif a_tipo_documento in ('PP') then
     w_tipo := '2';

  elsif a_tipo_documento in ('CI','CE','DI') then
     w_tipo := '3';

  else
     w_tipo := '3';
  end if;

<< fine >>

  return w_tipo;
end;
/
