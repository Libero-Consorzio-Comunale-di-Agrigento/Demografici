--liquibase formatted sql
--changeset snocca:202310101331 runOnChange:true stripComments:false
create or replace function f_ANSC_tipo_mancato_consenso
(a_tipo_mancato_consenso     IN	varchar2
)

return number

IS

w_tipo_mancato_consenso		varchar2(2) := a_tipo_mancato_consenso;

w_return		number;

begin
  if w_tipo_mancato_consenso is not null then
     begin
       select id into w_return 
         from anst35
        where tipo_mancato_consenso_ads = w_tipo_mancato_consenso
       ;
     exception
       when others then
            w_return := 1;
     end;
  end if;
  
  return w_return;
end;
/
