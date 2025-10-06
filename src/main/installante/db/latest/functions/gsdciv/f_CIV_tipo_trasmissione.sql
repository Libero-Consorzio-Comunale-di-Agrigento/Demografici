--liquibase formatted sql
--changeset amonopoli:202309061535 runOnChange:true stripComments:false
create or replace function f_CIV_tipo_trasmissione
(a_tipo_atto		IN	number
,a_id_atto 		IN	varchar2
)

return varchar2

IS

w_testo			varchar2(4000);

w_tipo_ads		varchar2(255);

begin
-- 1 - Avviso - AV
-- 2 - Notizia - NO
-- 3 - Denuncia - DE
-- 4 - Nullaosta - NU
-- 5 - Accertamento - AC

  if a_tipo_atto||a_id_atto is null then
     goto fine;
  end if;

  begin
    select upper(dpa.documento_tes)
      into w_testo
      from civdpa dpa
     where dpa.tipo_atto = a_tipo_atto
       and dpa.id_atto   = a_id_atto
       and dpa.documento_tes is not null
       and rownum = 1
    ;
  exception
    when others then
         w_testo := '';
  end;

  if w_testo is not null then
     if w_testo like '%AVVISO%' then
        w_tipo_ads := 'AV';
     elsif w_testo like '%NOTIZIA%' then
        w_tipo_ads := 'NO';
     elsif w_testo like '%DENUNCIA%' then
        w_tipo_ads := 'DE';
     elsif w_testo like '%NULLA%OSTA%' then
        w_tipo_ads := 'NU';
     elsif w_testo like '%ACCERTAMENTO%' then
        w_tipo_ads := 'AC';
     else
        w_tipo_ads := 'AV';
     end if;
  end if;
  
<< fine >>

  return w_tipo_ads;
end;
/
