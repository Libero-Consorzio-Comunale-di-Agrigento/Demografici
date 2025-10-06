--liquibase formatted sql
--changeset snocca:202310111058 runOnChange:true stripComments:false
create or replace function f_ANSC_tipo_assistenza_minore
(a_tipo_assistenza_minore     IN	varchar2
)

return number

IS

w_tipo_assistenza_minore varchar2(4) := a_tipo_assistenza_minore;

w_return		number;

begin
  if w_tipo_assistenza_minore is not null then
     begin
       select id into w_return 
         from anst51
        where tipo_assistenza_ads = w_tipo_assistenza_minore
       ;
     exception
       when others then
            w_return := 1;
     end;
  end if;
  
  return w_return;
end;
/
