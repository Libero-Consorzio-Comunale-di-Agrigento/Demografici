--liquibase formatted sql
--changeset amonopoli:202305251500_1 runOnChange:true stripComments:false
create or replace function f_CIV_testo_formula
(a_testo_a4	IN	varchar2
,a_testo_a3	IN	varchar2
)

return varchar2

IS

w_atti_a3	varchar2(255) := nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'N');
w_testo		varchar2(32000);

begin
  if a_testo_a4 is not null then
     if w_atti_a3 = 'S' then
        w_testo := nvl(a_testo_a3,a_testo_a4);
     else
        w_testo := a_testo_a4;
     end if;
  end if;

  return w_testo;
end;
/

