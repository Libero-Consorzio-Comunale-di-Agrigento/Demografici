--liquibase formatted sql
--changeset amonopoli:202402201150 runOnChange:true stripComments:false
create or replace function f_flag_comune_estero
(a_cod_provincia	IN	number
,a_cod_comune		IN	number
)

return varchar2

IS

w_flag		varchar2(255);

begin
  w_flag := '';

  if a_cod_provincia > 200 then
     if a_cod_provincia not in (701,702,703) then
        w_flag := 'S';
     elsif a_cod_comune < 500 then
        w_flag := 'S';
     end if;
  end if;

  return w_flag;
end;
/
