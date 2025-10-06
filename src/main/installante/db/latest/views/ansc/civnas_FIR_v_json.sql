--liquibase formatted sql
--changeset amonopoli:202305181310_1 runAlways:true runOnChange:true stripComments:false
create or replace view civnas_FIR_v_json
AS
select faa.id
     , 'N/D' protocollo
     , f_ANSC_tipo_file(substr(faa.nome,instr(faa.nome,'.',-1)+1)) tipoFile	-- anst10
     , to_char(ddo.codice_ansc) tipoAllegato					-- anst09
     , '1' stato								-- anst08
     , faa.nome nomeFile
     , ANSC_pkg.f_UTIL_base64_encode(gof.testoocr) contenuto
     , faa.id_allegato_ansc idAllegato
     , nas.id_atto_ansc idAttoAnsc
     , nas.id_evento_ansc idEventoAnsc
     , nas.id id_civnas
  from civddo ddo
     , gdm_oggetti_file gof
     , civfas_alle faa
     , civfas fas
     , civnas nas
 where ddo.codice_ansc     = 999
   and ddo.id              = fas.id_civddo
   and gof.id_oggetto_file = faa.id_oggetto_file_gdm
   and faa.id_civfas       = fas.id
   and fas.id_atto         = nas.id_atto
/
comment on table civnas_FIR_v_json is 'ANSC - Documenti Firma Autografa per request JSON (view)'
/
