--liquibase formatted sql
--changeset amonopoli:202305191535_2 runAlways:true runOnChange:true stripComments:false
create or replace view civmor_USC_v_json
AS
select nas.id
     , '1' idTipoFirma
     , '2' idModalitaInput
     , to_char(null) inputFirma1 -- username firma
     , to_char(null) inputFirma2 -- pwd firma
     , to_char(null) inputFirma3 -- otp firma
     --, 'VGVzdFVzZXI=' inputFirma1 -- username firma
     --, 'VGVzdFBhc3N3b3Jk' inputFirma2 -- pwd firma
     --, 'VGVzdE90cA==' inputFirma3 -- otp firma
     , nas.id_atto_ansc idAttoAnsc
     , nas.id_evento_ansc idEventoAnsc
  from civmor nas
/
comment on table civmor_USC_v_json is 'ANSC - Dati Firma Ufficiale di Stato Civile per request JSON (view)'
/
