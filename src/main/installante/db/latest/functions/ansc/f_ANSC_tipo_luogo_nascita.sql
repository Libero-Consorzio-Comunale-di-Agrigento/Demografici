--liquibase formatted sql
--changeset amonopoli:202505211055_3 runOnChange:true stripComments:false
create or replace function f_ANSC_tipo_luogo_nascita
(a_tipo_luogo     IN	varchar2
)

return number

IS

w_tipo_luogo		varchar2(2) := a_tipo_luogo;

w_return		number;

begin
  if w_tipo_luogo is not null then
     begin
       select id into w_return 
         from anst41
        where tipo_luogo_ads = w_tipo_luogo
       ;
     exception
       when others then
            w_return := null;
     end;
  end if;
  
  return w_return;
end;
/
