--liquibase formatted sql
--changeset amonopoli:202310121250 runOnChange:true stripComments:false
create or replace function f_ANSC_motivo_recupero
(a_motivo_recupero     IN	varchar2
)

return number

IS

w_motivo_recupero	varchar2(255) := a_motivo_recupero;

w_return		number;

begin
  if w_motivo_recupero is not null then
     begin
       select id into w_return 
         from anst96
        where motivo_recupero_ads = w_motivo_recupero
       ;
     exception
       when others then
            w_return := '101';
     end;
  end if;
  
  return w_return;
end;
/
