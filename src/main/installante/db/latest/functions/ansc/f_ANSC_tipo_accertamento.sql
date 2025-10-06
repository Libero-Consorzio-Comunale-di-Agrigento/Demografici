--liquibase formatted sql
--changeset amonopoli:202305251830 runOnChange:true stripComments:false
create or replace function f_ANSC_tipo_accertamento
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
-- 1 - attestazione di nascita - AN
-- 2 - constatazione di avvenuto parto - CP
-- 3 - dichiarazione sostitutiva - DS
-- 4 - presenza figlio - PF (eliminato con versione ansc 1.12.0)


  if a_tipo_atto||a_id_atto||a_tipo_ads is null then
     goto fine;
  end if;

  if a_tipo_ads is null then
     begin
       select upper(dbms_lob.substr(tli_f.testo_clob,4000,1))
         into w_testo
         from civtli_formule tli_f
        where tli_f.tipo_atto       = a_tipo_atto
          and tli_f.id_atto         = a_id_atto
          and tli_f.richiamo        = 6
          and tli_f.progr_dettaglio = 0
          and rownum = 1
       ;
     exception
       when others then
            w_testo := '';
     end;

     if w_testo is not null then
        if w_testo like '%NON%MI%VIENE%PRESENTATO%' then
           if w_testo like '%ATTESTAZIONE%' then
              w_tipo_ads := 'AN';
           elsif w_testo like '%CONSTATAZIONE%' then
              w_tipo_ads := 'CP';
           elsif w_testo like '%DICHIARAZIONE%' then
              w_tipo_ads := 'DS';
           else
              w_tipo_ads := 'AN';
           end if;

--        elsif w_testo like '%MI%VIENE%PRESENTATO%' then
--           w_tipo_ads := 'PF';
        else
           w_tipo_ads := 'AN';
        end if;
     end if;
  
  else 
     w_tipo_ads := upper(a_tipo_ads);
  end if;

  if w_tipo_ads is not null then
     begin
       select t78.id
         into w_tipo
         from anst78 t78
        where tipo_accertamento_ads = w_tipo_ads
       ;
     exception
       when others then
            w_tipo := '1';
     end;
  end if;

<< fine >>

  return w_tipo;
end;
/
