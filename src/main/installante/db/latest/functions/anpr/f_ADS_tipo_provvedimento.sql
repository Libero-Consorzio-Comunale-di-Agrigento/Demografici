--liquibase formatted sql
--changeset amonopoli:202512291610_2 runOnChange:true stripComments:false
CREATE OR REPLACE function f_ADS_tipo_provvedimento
(a_tipo_tribunale       IN 	number
)

return number

IS

w_tipo_provvedimento    number;

BEGIN
  if a_tipo_tribunale in (1,2,3) then
     begin
       select nvl(min(cod_tp),0)
         into w_tipo_provvedimento
         from anadtp
        where descrizione = 'SENTENZA'
          and rownum = 1
       ;
     exception
       when others then
            w_tipo_provvedimento := 4;
     end;

  else
     begin
       select nvl(min(cod_tp),0)
         into w_tipo_provvedimento
         from anadtp
        where (descrizione like 'COMUNICAZIONE%' or descrizione like '%CIVILE%')
          and rownum = 1
       ;
     exception
       when others then
            w_tipo_provvedimento := 0;
     end;

  end if;

  return w_tipo_provvedimento;

END;
/
