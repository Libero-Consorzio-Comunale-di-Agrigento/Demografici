--liquibase formatted sql
--changeset amonopoli:202509021625 runOnChange:true stripComments:false
create or replace function f_CDF_numera
 
return number

is

w_cod_cdf		number;

begin
  
  begin
    select nvl(max(cod_cdf),0) + 1
      into w_cod_cdf
      from anacdf
    ;
  exception
    when others then 
         w_cod_cdf := '';
  end;

  return w_cod_cdf;      

exception
  when others then
       w_cod_cdf := '';
       return w_cod_cdf;
end;
/
