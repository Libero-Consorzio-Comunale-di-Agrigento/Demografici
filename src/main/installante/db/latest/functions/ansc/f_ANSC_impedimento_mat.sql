--liquibase formatted sql
--changeset ftravaglini:202306151240 runOnChange:true stripComments:false
create or replace function f_ANSC_impedimento_mat
(a_cod_impedimento     IN	varchar2        
)

return number

IS

w_cod_impedimento	varchar2(2) := a_cod_impedimento;

w_return		number;

begin
  if w_cod_impedimento is not null then
     begin
       select id into w_return 
         from anst48
        where impedimento_mat_ads = w_cod_impedimento
       ;
     exception
       when others then
            w_return := 0;
     end;
  end if;
  
  return w_return;
end;
/
