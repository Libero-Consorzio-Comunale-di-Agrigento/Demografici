--liquibase formatted sql
--changeset amonopoli:202305181305_5 runAlways:true runOnChange:true stripComments:false
create or replace view civcit_ALL_v_json as
select cit.id
     , cit.id_atto
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
     , civcit cit
 where t09.id               = ddo.codice_ansc
   and ddo.id               = fas.id_civddo
   and faa.id_allegato_ansc is not null
   and faa.id_civfas        = fas.id
   and fas.id_atto          = cit.id_atto
/
comment on table civcit_ALL_v_json is 'ANSC - Allegati Atto di Cittadinanza per request JSON (view)'
/
