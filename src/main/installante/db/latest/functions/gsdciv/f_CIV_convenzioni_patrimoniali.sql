--liquibase formatted sql
--changeset amonopoli:202312061245 runOnChange:true stripComments:false
create or replace function f_CIV_convenzioni_patrimoniali
(a_tipo_atto		IN	number
,a_parte		IN	number
,a_serie		IN	varchar2
,a_richiamo		IN	number
,a_progr_dettaglio	IN	number
,a_formula		IN	varchar2
,a_tipo_annotazione	IN	varchar2
,a_categoria		IN	varchar2
)

return varchar2

IS

w_flag		varchar2(255);

begin
  if a_tipo_atto = 4 then
     if a_richiamo in (9,13) and a_formula = '62' then
        w_flag := 'SI1';
     elsif a_richiamo in (9,13) and a_formula like '62-BIS%' then
        w_flag := 'SI2';
     elsif a_richiamo = 9 and a_formula = '4-CON-PAT' then
        w_flag := 'NO';
     end if;

  elsif a_tipo_atto = -4 then
     if a_richiamo = 9 and a_formula = '73-SEXIES' then
        w_flag := 'SI1';
     elsif a_richiamo = 9 and a_formula = '73-SEPTIES' then
        w_flag := 'SI2';
     elsif a_richiamo = 9 and a_formula = '0-CON-PAT' then
        w_flag := 'NO';
     elsif a_richiamo = 98 and a_formula = '0-MAR-CON' then
        w_flag := 'SI';
     end if;

  end if;
 
  return w_flag;

end;
/
