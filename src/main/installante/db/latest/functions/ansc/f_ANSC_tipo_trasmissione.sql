--liquibase formatted sql
--changeset amonopoli:202305251255_1 runOnChange:true stripComments:false
create or replace function f_ANSC_tipo_trasmissione
(a_tipo_atto		IN	number
,a_id_atto 		IN	varchar2
,a_tipo_ads	IN	varchar2
)

return varchar2

IS

w_tipo_ads		varchar2(255);

w_testo			varchar2(4000);
w_tipo			varchar2(10);

begin
-- 1 - Avviso - AV
-- 2 - Notizia - NO
-- 3 - Denuncia - DE
-- 4 - Nullaosta - NU
-- 5 - Accertamento - AC

  if a_tipo_atto||a_id_atto||a_tipo_ads is null then
     goto fine;
  end if;

  if w_tipo_ads is null then
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
  
  else 
     w_tipo_ads := upper(a_tipo_ads);
  end if;

  if w_tipo_ads is not null then
     begin
       select t66.id
         into w_tipo
         from anst66 t66
        where tipo_trasmissione_ads = w_tipo_ads
       ;
     exception
       when others then
            w_tipo := 1;
     end;
  end if;

<< fine >>

  return w_tipo;
end;
/
