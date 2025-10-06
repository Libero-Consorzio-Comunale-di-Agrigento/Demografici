--liquibase formatted sql
--changeset ftravaglini:202306190920 runOnChange:true stripComments:false
create or replace function f_ANSC_officiante
(a_tipo_atto		IN	varchar2
,a_id_atto		IN	varchar2
,a_codice_ads		IN	varchar2
)

return varchar2

IS

w_codice_ads		varchar2(255);

w_rito			varchar2(255);
w_nome_usc		varchar2(255);
w_qualifica_usc		varchar2(255);
w_nome_prov		varchar2(255);
w_qualifica_prov	varchar2(255);
w_nome_min		varchar2(255);
w_qualifica_min		varchar2(255);
w_nome_min_art		varchar2(255);
w_qualifica_min_art	varchar2(255);

w_qualifica           	varchar2(255);

w_id			varchar2(10);

begin
-- rito civile
--  1 - Sindaco - SIN 
--  2 - Vicesindaco - VSI 
--  3 - Ufficiale di Stato Civile - USC   
--  4 - Comune Cittadino - CIT  
--  8 - Comandante Nave - CNA  
--  9 - Comandante Aereo - CAE 
-- 11 - Assessore - ASS
-- 12 - Consigliere delegato dal Sindaco - CON
-- 
-- rito religioso (cattolico)
--  5 - Parroco - PAR  
--  6 - Diacono - DIA  
--  7 - Cappellano Militare - CMI  
--
-- rito religioso (acattolico)
-- 10 - Ministro di culto - MCU  
--

  if a_tipo_atto||a_id_atto||a_codice_ads is null then
     goto fine;
  end if;

  if w_codice_ads is null then
     begin
       select dpa.rito,
              upper(dpa.ufficiale_utente),
              upper(dpa.qualifica_utente),
              upper(dpa.ufficiale_prov),
              upper(dpa.qualifica_prov),
              upper(dpa.ministro),
              upper(dpa.qualita_1),
              upper(dpa.ministro_art)
         into w_rito, 
              w_nome_usc,
              w_qualifica_usc,
              w_nome_prov,
              w_qualifica_prov,
              w_nome_min,
              w_qualifica_min,
              w_nome_min_art
         from civdpa dpa
        where dpa.tipo_atto = a_tipo_atto
          and dpa.id_atto   = a_id_atto
          and rownum = 1
       ;
       if nvl(w_nome_min,'X') = nvl(w_nome_min_art,'Y') then
          w_qualifica_min_art := w_qualifica_min;
       end if;
     exception
       when others then
            w_rito              := '';
            w_nome_usc          := '';
            w_qualifica_usc     := '';
            w_nome_min          := '';
            w_qualifica_min     := '';
            w_nome_min_art      := '';
            w_qualifica_min_art := '';
     end;

     if w_rito is null and nvl(w_qualifica_prov,w_qualifica_usc) is not null then
        w_qualifica := nvl(w_qualifica_prov,w_qualifica_usc);
-- rito civile
        if w_qualifica like '%UFFICIALE%STATO%CIVILE%' then
           w_codice_ads := 'USC';
        elsif w_qualifica like '%VICESINDACO%' then
           w_codice_ads := 'VSI';
        elsif w_qualifica like '%SINDACO%' then
           w_codice_ads := 'SIN';
        elsif w_qualifica like '%CITTADINO%' then
           w_codice_ads := 'CIT';
        elsif w_qualifica like '%COMANDANTE%NAVE%' then
           w_codice_ads := 'CNA';
        elsif w_qualifica like '%COMANDANTE%AEREO%' then
           w_codice_ads := 'CAE';
        elsif w_qualifica like '%ASSESSORE%' then
           w_codice_ads := 'ASS';
        elsif w_qualifica like '%CONSIGLIERE%' then
           w_codice_ads := 'CON';
        else
           w_codice_ads := 'USC';
        end if; 

     elsif w_rito is not null then
-- rito religioso
        if upper(w_rito) = 'CATTOLICO' then
-- rito cattolico
           w_qualifica := w_qualifica_min_art;
           if w_qualifica like '%PARROCO%' then
              w_codice_ads := 'PAR';
           elsif w_qualifica like '%DIACONO%' then
              w_codice_ads := 'DIA';
           elsif w_qualifica like '%CAPPELLANO%MILITARE%' then
              w_codice_ads := 'CMI';
           else
              w_codice_ads := 'PAR';
           end if;
        elsif upper(w_rito) != 'CATTOLICO' then
           w_codice_ads := 'MCU';
        end if;
     end if;
 
  else 
     w_codice_ads := upper(a_codice_ads);
  end if;

  if w_codice_ads is not null then
     begin
       select t46.id
         into w_id
         from anst46 t46
        where codice_ads = w_codice_ads
       ;
     exception
       when others then
            if w_rito is null then
               w_id := 3;
            elsif upper(w_rito) = 'CATTOLICO' then
               w_id := 5;
            elsif upper(w_rito) != 'CATTOLICO' then
               w_id := 10;
            end if;
     end;
  end if;

<< fine >>

  return w_id;
end;
/
