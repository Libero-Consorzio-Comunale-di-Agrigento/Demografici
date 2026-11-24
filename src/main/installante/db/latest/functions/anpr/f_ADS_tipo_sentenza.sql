--liquibase formatted sql
--changeset amonopoli:202512291610_3 runOnChange:true stripComments:false
CREATE OR REPLACE function f_ADS_tipo_sentenza
(a_tipo_cessazione	IN	number
,a_tipo_tribunale	IN	number	default NULL
)

return number

IS

w_tipo_sentenza    number := 0;

BEGIN
  begin
    select nvl(min(tse.cod_se),0)
      into w_tipo_sentenza
      from anatse tse
         , anpt31 t31
     where tse.flag_divorzio          = t31.flag_divorzio_ads
       and nvl(t31.codice_anpr_ads,0) = nvl(a_tipo_tribunale,0)
       and t31.codice                 = a_tipo_cessazione
       and rownum = 1
    ;
  exception
    when others then
         w_tipo_sentenza := 0;
  end;

  if w_tipo_sentenza is null then
     begin
       select nvl(min(tse.cod_se),0)
         into w_tipo_sentenza
         from anatse tse
            , anpt31 t31
        where tse.flag_divorzio = t31.flag_divorzio_ads
          and t31.codice        = a_tipo_cessazione
          and rownum = 1
       ;
     exception
       when others then
            w_tipo_sentenza := 0;
     end;
  end if;

<< fine >>
  return w_tipo_sentenza;
END;
/
