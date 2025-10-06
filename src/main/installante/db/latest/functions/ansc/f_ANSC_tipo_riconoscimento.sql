--liquibase formatted sql
--changeset ftravaglini:202309121015 runOnChange:true stripComments:false
create or replace function f_ANSC_tipo_riconoscimento
(a_tipo_riconoscimento     IN	varchar2        
)

return number

IS

w_tipo_riconoscimento		varchar2(2) := a_tipo_riconoscimento;

w_return		number;

begin
  if w_tipo_riconoscimento is not null then
     begin
       select id into w_return 
         from anst98
        where tipo_riconoscimento_ads = w_tipo_riconoscimento
       ;
     exception
       when others then
            w_return := 1;
     end;
  end if;
  
  return w_return;
end;
/
