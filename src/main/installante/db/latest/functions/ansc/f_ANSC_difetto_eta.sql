--liquibase formatted sql
--changeset ftravaglini:202306151225 runOnChange:true stripComments:false
create or replace function f_ANSC_difetto_eta
(a_cod_difetto     IN	varchar2        
)

return number

IS

w_cod_difetto		varchar2(2) := a_cod_difetto;

w_return		number;

begin
  if w_cod_difetto is not null then
     begin
       select id into w_return 
         from anst47
        where difetto_eta_ads = w_cod_difetto
       ;
     exception
       when others then
            w_return := 1;
     end;
  end if;
  
  return w_return;
end;
/
