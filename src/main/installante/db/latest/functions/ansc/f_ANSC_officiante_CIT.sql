--liquibase formatted sql
--changeset amonopoli:202503111240 runOnChange:true stripComments:false
create or replace function f_ANSC_officiante_CIT
(a_qualifica_utente		IN	varchar2
)

return varchar2

IS

w_codice_ads		varchar2(255);

w_qualifica		varchar2(255);

w_id			varchar2(10);

begin
--  1 - Sindaco - SIN 
--  2 - Vicesindaco - VSI 
--  3 - Assessore - ASS
--  4 - Consigliere delegato dal Sindaco - CON

  w_qualifica := upper(a_qualifica_utente);

  if w_qualifica is not null then
     if w_qualifica like '%SINDACO%' then
        w_codice_ads := 'SIN';
     elsif w_qualifica like '%VICESINDACO%' then
        w_codice_ads := 'VSI';
     elsif w_qualifica like '%ASSESSORE%' then
        w_codice_ads := 'ASS';
     elsif w_qualifica like '%CONSIGLIERE%' then
        w_codice_ads := 'CON';
     else
        w_codice_ads := '';
     end if; 
  end if;

  if w_codice_ads is not null then
     begin
       select t121.id
         into w_id
         from anst121 t121
        where codice_ads = w_codice_ads
       ;
     exception
       when others then
            w_id := '';
     end;
  end if;

<< fine >>

  return w_id;
end;
/
