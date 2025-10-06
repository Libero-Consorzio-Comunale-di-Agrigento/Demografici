--liquibase formatted sql
--changeset amonopoli:202309261510 runOnChange:true stripComments:false
create or replace function f_ANSC_soggetto_impedimento
(a_impossibilitato		 IN	varchar2           
)

return number

IS

w_return		 number;

-- ANSC_95
-- 1 = Coniuge 1, 
-- 2 = Coniuge 2, 
-- 3 = Entrambi Coniugi

begin
  begin
    if a_impossibilitato = 'C1' then
      w_return := 1;
    elsif a_impossibilitato = 'C2' then
      w_return := 2;
    elsif a_impossibilitato = 'SO' then
      w_return := 1;
    elsif a_impossibilitato = 'SA' then
      w_return := 2;
    elsif a_impossibilitato = 'EN' then
      w_return := 3;
    else
      w_return := 0;
    end if;

    exception
      when others then
          w_return := 0;
    end;
  return w_return;
end;
/