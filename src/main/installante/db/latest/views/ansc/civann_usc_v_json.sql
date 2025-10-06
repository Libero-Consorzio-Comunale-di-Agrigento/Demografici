--liquibase formatted sql
--changeset amonopoli:202311281310_1 runAlways:true runOnChange:true stripComments:false
create or replace view civann_usc_v_json
AS
select ann.id
     , '1' idTipoFirma
     , '2' idModalitaInput
     , to_char(null) inputFirma1 -- username firma
     , to_char(null) inputFirma2 -- pwd firma
     , to_char(null) inputFirma3 -- otp firma
     , ann.id_atto_ansc idAttoAnsc
     , ann.id_evento_ansc idEventoAnsc
  from civann ann
/
comment on table civann_USC_v_json is 'ANSC - Dati Firma Ufficiale di Stato Civile per request JSON (view)'
/
