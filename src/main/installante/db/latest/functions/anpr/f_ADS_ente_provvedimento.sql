--liquibase formatted sql
--changeset amonopoli:202512291610_1 runOnChange:true stripComments:false
CREATE OR REPLACE function f_ADS_ente_provvedimento
(a_tipo_tribunale       IN 	number
,a_tipo_cessazione	IN	number	default NULL
)

return number

IS

w_ente    number(10);

BEGIN

  begin
    select nvl(min(den.cod_en),4)
      into w_ente
      from anaden den
         , anpt31 t31
     where den.cod_en          = t31.cod_en_ads
       and t31.codice_anpr_ads = a_tipo_tribunale
       and t31.codice          = a_tipo_cessazione
       and rownum = 1
    ;
  exception
    when others then
         w_ente := 4;
  end;

  if w_ente is null then
     begin
       select nvl(min(den.cod_en),4)
         into w_ente
         from anaden den
        where den.codice_anpr = a_tipo_tribunale
          and rownum = 1
       ;
     exception
       when others then
            w_ente := 4;
     end;
  end if;

  return w_ente;
END;
/
