--liquibase formatted sql
--changeset amonopoli:202305181305_3 runAlways:true runOnChange:true stripComments:false
create or replace view civmor_ALL_v_json as
select mor.id
     , mor.id_atto
     , faa.id_allegato_ANSC id_allegato
     , ddo.codice_ansc idTipoAllegato
     , '3' idStatoAllegato
     , faa.hash_allegato_ANSC hashAllegato
     , t09.descrizione descrizione
     , fas.id id_civfas
     , faa.id id_civfas_alle
     , decode(faa.flag_da_attestare_ansc,'S','true','false') flagAttConformita
  from anst09 t09
     , civddo ddo
     , civfas_alle faa
     , civfas fas
     , civmor mor
 where t09.id               = ddo.codice_ansc
   and ddo.id               = fas.id_civddo
   and faa.id_allegato_ansc is not null
   and faa.id_civfas        = fas.id
   and fas.id_atto          = mor.id_atto
/
comment on table civmor_ALL_v_json is 'ANSC - Allegati Atto di Morte per request JSON (view)'
/


