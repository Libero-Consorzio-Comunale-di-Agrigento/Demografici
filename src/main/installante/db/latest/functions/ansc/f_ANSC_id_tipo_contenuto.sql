--liquibase formatted sql
--changeset amonopoli:202310101220 runOnChange:true stripComments:false
create or replace function f_ANSC_id_tipo_contenuto
(a_tipo_atto_ansc	IN	varchar2
,a_natura_ads		IN	varchar2
,a_tipo_richiesta_ads	IN	varchar2
)

return varchar2

IS


w_tipo_atto_ansc	varchar2(255) := a_tipo_atto_ansc;

w_return		varchar2(255);

begin
--
-- 1 - ATTO
-- 2 - ANNOTAZIONE
-- 3 - TRASCRIZIONE
-- 4 - ANNOTAZIONE AUTOMATICA
--

  if a_tipo_atto_ansc is not null then
     if w_tipo_atto_ansc like 'Trascr%' then 
        w_return:= '3';
     elsif w_tipo_atto_ansc = 'Annotazione' then
        w_return := '2';
     else
        w_return:= '1';
     end if;

  else	-- a_tipo_atto_ansc is not null
     if a_natura_ads = 'O' then
        w_return := '1';
     elsif a_natura_ads in ('T','D') then
        w_return := '3';
     elsif nvl(a_tipo_richiesta_ads,' ') = 'DIC' then
        w_return := '1';
     elsif nvl(a_tipo_richiesta_ads,' ') = 'TRA' then
        w_return := '3';
     else
        w_return := '1';
     end if;

  end if;

<< fine >>

  return w_return;
end;
/
