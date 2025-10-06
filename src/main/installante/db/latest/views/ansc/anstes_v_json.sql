--liquibase formatted sql
--changeset snocca:202305050930 runOnChange:true stripComments:false
create or replace view anstes_v_json
       (idOperazione, idComune, dataOraRichiesta, nomeApplicativo, versioneApplicativo, fornitoreApplicativo,
        presaVisione)
as
select to_number(null) idOperazione
     , f_ANSC_valore_inp('ID_COMUNE',1,10,'9','') idComune
     , to_char(sysdate,'yyyy-mm-dd')||'T'||to_char(sysdate,'hh24:mi:ss') dataOraRichiesta
     , 'DE4GSDZK' nomeApplicativo
     , ista.versione versioneApplicativo
     , 'ADS' fornitoreApplicativo
     , 'true' presaVisione
  from ad4_istanze ista
 where istanza =  '${istanzaAD4}'
/
comment on table anstes_v_json is 'ANSC - Testata Richiesta per request JSON (view)'
/