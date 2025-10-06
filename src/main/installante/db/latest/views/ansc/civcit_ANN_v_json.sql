--liquibase formatted sql
--changeset amonopoli:202311201440 runAlways:true runOnChange:true stripComments:false
create or replace view civcit_ANN_v_json as
select cit.id
     , cit.id_atto
     , cit.ufficio
     , cit.anno
     , to_number(null) parte
     , to_char(null) serie
     , cit.atto
-- datiAnnotazione
     , 10 + nvl(ann.sequenza,1) tipoAnnotazione
     , ann.testo_annotazione testoAnnotazione
     , decode(ann.stampa,'S','false','true') flagAnnNonCertificabile
-- ANSC
     , cit.id_atto_ansc idAttoAnsc
     , cit.id_evento_ansc idEventoAnsc
  from civann ann
     , civcit cit
 where ann.id_atto              = cit.id_atto
   and cit.cod_rec		in (0,3)
/
comment on table civcit_ANN_V_JSON is 'ANSC - Atti di Cittadinanza per request JSON - Annotazioni (view)'
/

