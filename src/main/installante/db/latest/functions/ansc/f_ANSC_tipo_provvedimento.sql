--liquibase formatted sql
--changeset snocca:202310031644 runOnChange:true stripComments:false
create or replace function f_ANSC_tipo_provvedimento
(a_tipo_provvedimento     IN	varchar2
)

return varchar2

IS

w_tipo_provvedimento		varchar2(2) := a_tipo_provvedimento;

w_return		varchar2(255);

begin
  if w_tipo_provvedimento is not null then
     begin
       select id into w_return 
         from anst99
        where tipo_provvedimento_ads = w_tipo_provvedimento
       ;
     exception
       when others then
            w_return := '';
     end;
  end if;
  
  return w_return;
end;
/
