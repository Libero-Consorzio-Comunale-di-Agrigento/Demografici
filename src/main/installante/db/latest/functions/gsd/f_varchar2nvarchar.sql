--liquibase formatted sql
--changeset amonopoli:202510081035 runOnChange:true stripComments:false
create or replace function f_varchar2nvarchar
(a_varchar        varchar2)

return nvarchar2

IS

w_nvarchar         nvarchar2(32000);

begin
  if a_varchar is not null then
     w_nvarchar := a_varchar;
  end if;

  return w_nvarchar;
end;
/
