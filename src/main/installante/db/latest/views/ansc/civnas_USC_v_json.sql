--liquibase formatted sql
--changeset amonopoli:202305181310_2 runAlways:true runOnChange:true stripComments:false
create or replace view civnas_USC_v_json
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
  from civnas nas
/
comment on table civnas_USC_v_json is 'ANSC - Dati Firma Ufficiale di Stato Civile per request JSON (view)'
/
