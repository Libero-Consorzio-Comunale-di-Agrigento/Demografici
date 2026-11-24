--liquibase formatted sql
--changeset amonopoli:202602231625 runAlways:true runOnChange:true stripComments:false
create or replace view cerinc_USC_v_json 
AS
select inc.anno_emissione||lpad(inc.progr_emissione,6,'0') id
     , '1' idTipoFirma
     , '2' idModalitaInput
     , to_char(null) inputFirma1 -- username firma
     , to_char(null) inputFirma2 -- pwd firma
     , to_char(null) inputFirma3 -- otp firma
  from cerinc inc
/
comment on table cerinc_USC_v_json is 'ANSC - Dati Firma Ufficiale di Stato Civile per request JSON (view)'
/
