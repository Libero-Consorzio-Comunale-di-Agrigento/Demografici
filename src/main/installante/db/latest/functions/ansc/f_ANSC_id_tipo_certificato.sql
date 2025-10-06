--liquibase formatted sql
--changeset amonopoli:202502191030_1 runOnChange:true stripComments:false
create or replace function f_ANSC_id_tipo_certificato
(a_codice_anpr	IN	varchar2
)

return varchar2

IS

w_codice_anpr	varchar2(255) := upper(a_codice_anpr);
w_codice_ansc	varchar2(255);

begin
-- ANSC 
-- idTipoCertificato: 1 - Certificato Semplice . 2 - Estratto per riassunto . 3 Estratto integrale
-- flagSemplificato : Indica se il certificato estratto per copia integrale deve essere semplificato ossia senza metadati
--
-- ANPT13
-- S1	Stato Civile - Certificato Semplice
-- S2	Stato Civile - Estratto per Riassunto
-- S3	Stato Civile - Estratto per Copia Integrale
-- S4	Stato Civile - Estratto per Copia Integrale (semplificato)
-- S6	Stato Civile - Certificato Semplice con PT/MD
-- S7	Stato Civile - Estratto per Riassunto con PT/MD

  if w_codice_anpr in ('S1','S2','S3') then
     w_codice_ansc := substr(w_codice_anpr,2,1);
  elsif w_codice_anpr in ('S4') then
     w_codice_ansc := '3';
  elsif w_codice_anpr in ('S6') then
     w_codice_ansc := '1';
  elsif w_codice_anpr in ('S7') then
     w_codice_ansc := '2';
  end if;

<< fine >>

  return w_codice_ansc;
end;
/

