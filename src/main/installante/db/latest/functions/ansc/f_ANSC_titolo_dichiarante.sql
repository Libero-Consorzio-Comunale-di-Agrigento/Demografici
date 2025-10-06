--liquibase formatted sql
--changeset ftravaglini:202308291520 runOnChange:true stripComments:false
create or replace function f_ANSC_titolo_dichiarante
(a_tipo_dichiarante		IN	varchar2
)

return number

IS

w_tipo_dichiarante		number;

-- anst34
-- 1 - medico - ME
-- 2 - ostetrica - OS
-- 3 - altro - AL


begin
  if a_tipo_dichiarante is null then
     goto fine;
  end if;

  begin
    select t34.id
      into w_tipo_dichiarante
      from anst34 t34
     where qualifica_ads = a_tipo_dichiarante
    ;
  exception
    when others then
         w_tipo_dichiarante := 3;
  end;

<< fine >>
  return w_tipo_dichiarante;

end;
/
