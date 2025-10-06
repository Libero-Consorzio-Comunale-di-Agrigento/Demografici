--liquibase formatted sql
--changeset amonopoli:202310101510 runOnChange:true stripComments:false
create or replace function f_ANSC_tipo_consenso
(a_tipo_consenso     IN	varchar2
)

return number

IS

w_tipo_consenso		varchar2(2) := a_tipo_consenso;

w_return		number;

begin
  if w_tipo_consenso is not null then
     begin
       select id into w_return 
         from anst12
        where tipo_consenso_ads = w_tipo_consenso
       ;
     exception
       when others then
            w_return := 1;
     end;
  end if;
  
  return w_return;
end;
/
