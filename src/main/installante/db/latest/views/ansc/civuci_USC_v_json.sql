--liquibase formatted sql
--changeset ftravaglini:202306201445 runAlways:true runOnChange:true stripComments:false
create or replace view civuci_USC_v_json
AS
select uci.id
     , '1' idTipoFirma
     , '2' idModalitaInput
     , to_char(null) inputFirma1 -- username firma
     , to_char(null) inputFirma2 -- pwd firma
     , to_char(null) inputFirma3 -- otp firma
     --, 'VGVzdFVzZXI=' inputFirma1 -- username firma
     --, 'VGVzdFBhc3N3b3Jk' inputFirma2 -- pwd firma
     --, 'VGVzdE90cA==' inputFirma3 -- otp firma
     , uci.id_atto_ansc idAttoAnsc
     , uci.id_evento_ansc idEventoAnsc
  from civuci uci
/
comment on table civuci_USC_v_json is 'ANSC - Dati Firma Ufficiale di Stato Civile per request JSON (view)'
/
