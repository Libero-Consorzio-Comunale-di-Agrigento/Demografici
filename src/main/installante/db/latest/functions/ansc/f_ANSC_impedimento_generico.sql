--liquibase formatted sql
--changeset ftravaglini:202308071000 runOnChange:true stripComments:false
create or replace function f_ANSC_impedimento_generico
(a_impedimento_uci		IN	varchar2
)

return number

IS

w_return		 number;

-- ANST95 - Impedimento Generico
-- 0 = Nessun impedimento 
-- 1 = Coniuge 1
-- 2 = Coniuge 2 
-- 3 = Entrambi Coniugi

begin
  begin
    if nvl(a_impedimento_uci,'NE') = 'NE' then
      w_return := 0;
    elsif a_impedimento_uci = 'C1' then
      w_return := 1;
    elsif a_impedimento_uci = 'C2' then
      w_return := 2;
    elsif a_impedimento_uci = 'EN' then
      w_return := 3;
    end if;

    exception
      when others then
          w_return := 0;
    end;
  return w_return;
end;
/