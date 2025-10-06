--liquibase formatted sql
--changeset amonopoli:202305181311 runAlways:true runOnChange:true stripComments:false
create or replace view civfas_v_json
AS
select faa.id
     , fas.id_atto
     , fas.ufficio
     , fas.anno
     , fas.parte
     , fas.serie
     , fas.atto
--     , '1/2022' protocollo
     ,  f_ANSC_tipo_file(substr(faa.nome,instr(faa.nome,'.',-1)+1)) tipoFile	-- anst10
     , to_char(ddo.codice_ansc) tipoAllegato					-- anst09
--     , '1' stato								-- anst08
     , f_ANSC_stringa(faa.nome,'()') nomeFile
     , ANSC_pkg.f_UTIL_base64_encode(gof.testoocr) contenuto
     , faa.id_allegato_ansc idAllegato
  from civddo ddo
     , gdm_oggetti_file gof
     , civfas_alle faa
     , civfas fas
 where ddo.id (+)          = fas.id_civddo
   and gof.id_oggetto_file = faa.id_oggetto_file_gdm
   and faa.id_civfas       = fas.id
/
comment on table civfas_v_json is 'ANSC - Documenti Fascicolo per request JSON (view)'
/
