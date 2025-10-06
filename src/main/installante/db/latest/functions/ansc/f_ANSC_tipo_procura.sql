--liquibase formatted sql
--changeset ftravaglini:202308301510 runOnChange:true stripComments:false
create or replace function f_ANSC_tipo_procura
(a_tipo_dichiarante		IN	varchar2
)

return number

IS

w_tipo_procura		number;

-- anst33
-- 1 - della madre
-- 2 - del padre


begin
  if a_tipo_dichiarante = 'PM' then
     w_tipo_procura := 1;
  elsif a_tipo_dichiarante = 'PP' then 
     w_tipo_procura := 2;
  else 
     w_tipo_procura := null;
  end if;

  return w_tipo_procura;
end;
/
