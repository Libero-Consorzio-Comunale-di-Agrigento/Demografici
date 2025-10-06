--liquibase formatted sql
--changeset amonopoli:2023007031205_2 runAlways:true runOnChange:true stripComments:false
create or replace view civcit_USC_v_json
AS
select nas.id
     , '1' idTipoFirma
     , '2' idModalitaInput
     , to_char(null) inputFirma1 -- username firma
     , to_char(null) inputFirma2 -- pwd firma
     , to_char(null) inputFirma3 -- otp firma
     , nas.id_atto_ansc idAttoAnsc
     , nas.id_evento_ansc idEventoAnsc
  from civcit nas
/
comment on table civcit_USC_v_json is 'ANSC - Dati Firma Ufficiale di Stato Civile per request JSON (view)'
/
