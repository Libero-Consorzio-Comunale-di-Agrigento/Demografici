--liquibase formatted sql
--changeset amonopoli:202504111120 runOnChange:true stripComments:false
create or replace function f_ANSC_tipo_assenso
(a_tipo_assenso     IN	varchar2
)

return number

IS

w_tipo_assenso		varchar2(2) := a_tipo_assenso;

w_return		number;

begin
  if w_tipo_assenso is not null then
     begin
       select id into w_return 
         from anst37
        where tipo_assenso_ads = w_tipo_assenso
       ;
     exception
       when others then
            w_return := 1;
     end;
  end if;
  
  return w_return;
end;
/
