--liquibase formatted sql
--changeset amonopoli:202310191735 runOnChange:true stripComments:false
create or replace function f_ANSC_tipo_dichiarazione
(a_tipo_atto_ads IN varchar2
,a_categoria_ads IN varchar2
,a_id_usecase_ansc IN number
,a_tipo_ads         IN varchar2
)

return varchar2

IS


w_return  varchar2(255);

begin
--
-- ANST38
-- 1 - Resa dinanzi all'Ufficiale di Stato Civile
-- 2 - Resa dinanzi altro Ufficiale pubblico
-- 3 - Comunicazione scritta
-- 4 - Verbale
--
-- ADS
-- CS("CS", "Comunicazione_scritta"),
-- CV("CV", "Verbale")

  if a_tipo_atto_ads = 5 then
     if a_categoria_ads = 'TEP' and a_id_usecase_ansc = 2212 then
        w_return := '3';
     end if;

  elsif a_tipo_atto_ads in (2, 4, -4) then
     if a_categoria_ads = 'TEP' then
        if a_tipo_ads = 'CS'
           then w_return := '3';
        elsif a_tipo_ads = 'CV'
           then w_return := '4';
        else
           w_return := null;
        end if;
     end if; --TEP
     if a_tipo_atto_ads = -4 and a_categoria_ads = 'TEA' then
        if a_tipo_ads = 'CS'
           then w_return := '3';
        elsif a_tipo_ads = 'CV'
           then w_return := '4';
        else
           w_return := null;
        end if;
     end if; --TEA solo UCI
     if a_tipo_atto_ads in (4,-4) and a_categoria_ads = 'EST' then
        if a_tipo_ads = 'CS'
           then w_return := '3';
        elsif a_tipo_ads = 'CV'
           then w_return := '4';
        else
           w_return := '3';
        end if;
     end if;
     if a_tipo_atto_ads = 4 and a_categoria_ads = 'TEA' then
        if a_id_usecase_ansc = 335003 then -- in viaggio
           w_return := '3';
        end if;
     end if;

  elsif a_tipo_atto_ads = 1 then
     if a_categoria_ads = 'DAQ' and a_id_usecase_ansc = 52153 then
        if a_tipo_ads = 'CS'
           then w_return := '3';
        elsif a_tipo_ads = 'CV'
           then w_return := '4';
        end if;
     end if;
  end if;
  return w_return;
end;
/
