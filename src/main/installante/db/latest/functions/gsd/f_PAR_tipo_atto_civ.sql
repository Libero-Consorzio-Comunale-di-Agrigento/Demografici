--liquibase formatted sql
--changeset amonopoli:202410281245_3 runOnChange:true stripComments:false
create or replace function f_PAR_tipo_atto_civ
(a_fase		IN	varchar2
,a_funzione	IN	varchar2
,a_campo	IN	varchar2
)

return varchar2

IS

w_campo			varchar2(255) := upper(a_campo);
w_tipo_atto		varchar2(255);

begin
  if a_fase||a_funzione is not null then
     if a_fase in ('ACIT','ANAS','AVPB','AMAT','ADIV','AUCI','AMOR') then
        if w_campo = 'COD' then
           w_tipo_atto := substr(a_funzione,2);
        elsif w_campo = 'DES' then
           if substr(a_funzione,2) = 'CIT' then
              w_tipo_atto := 'Atti di Cittadinanza';
           elsif substr(a_funzione,2) = 'NAS' then
              w_tipo_atto := 'Atti di Nascita';
           elsif substr(a_funzione,2) = 'VPB' then
              w_tipo_atto := 'Verbali di Pubblicazione';
           elsif substr(a_funzione,2) = 'MAT' then
              w_tipo_atto := 'Atti di Matrimonio';
           elsif substr(a_funzione,2) = 'DIV' then
              w_tipo_atto := 'Atti di Divorzio';
           elsif substr(a_funzione,2) = 'UCI' then
              w_tipo_atto := 'Atti di Unione Civile';
           elsif substr(a_funzione,2) = 'MOR' then
              w_tipo_atto := 'Atti di Morte';
           end if;
        end if;
     elsif a_fase = 'SCPW' then
        if w_campo = 'COD' then
           w_tipo_atto := substr(a_funzione,2,1);
           if w_tipo_atto = 'U' then 
              w_tipo_atto := '-4';
           end if;
        elsif w_campo = 'DES' then
           if substr(a_funzione,2,1) = '0' then
              w_tipo_atto := 'Formule Annotazione';
           elsif substr(a_funzione,2,1) = '1' then
              w_tipo_atto := 'Atti di Cittadinanza';
           elsif substr(a_funzione,2,1) = '2' then
              w_tipo_atto := 'Atti di Nascita';
           elsif substr(a_funzione,2,1) = '3' then
              w_tipo_atto := 'Verbali di Pubblicazione';
           elsif substr(a_funzione,2,1) = '4' then
              w_tipo_atto := 'Atti di Matrimonio';
           elsif substr(a_funzione,2,1) = '5' then
              w_tipo_atto := 'Atti di Morte';
           elsif substr(a_funzione,2,1) = 'U' then
              w_tipo_atto := 'Atti di Unione Civile';
           end if;
        end if;
     end if;
  end if;
 
  return w_tipo_atto;

end;
/
