--liquibase formatted sql
--changeset amonopoli:202311201435 runAlways:true runOnChange:true stripComments:false
create or replace view civnas_ANN_v_json as
select nas.id
     , nas.id_atto
     , nas.ufficio
     , nas.anno
     , nas.parte
     , nas.serie
     , nas.atto
-- datiAnnotazione
     , 10 + nvl(ann.sequenza,1) tipoAnnotazione
     , ann.testo_annotazione testoAnnotazione
     , decode(ann.stampa,'S','false','true') flagAnnNonCertificabile
-- ANSC
     , nas.id_atto_ansc idAttoAnsc
     , nas.id_evento_ansc idEventoAnsc
  from civann ann
     , civnas nas
 where ann.id_atto              = nas.id_atto
   and nas.cod_rec		in (0,3)
UNION ALL
select nas.id
     , nas.id_atto
     , nas.ufficio
     , nas.anno
     , nas.parte
     , nas.serie
     , nas.atto
-- datiAnnotazione
     , tli_f.progr_dettaglio tipoAnnotazione
     , dbms_lob.substr(tli_f.testo_clob,4000) testoAnnotazione
     , 'true' flagAnnNonCertificabile
-- ANSC
     , nas.id_atto_ansc idAttoAnsc
     , nas.id_evento_ansc idEventoAnsc
  from civtli_formule tli_f
     , civnas nas
 where tli_f.tipo_atto          = 2
   and tli_f.testo_clob         is not null
   and tli_f.richiamo           = 98
   and tli_f.progr_dettaglio    not in (1,2,3)
   and tli_f.id_atto            = nas.id_atto
   and nas.cod_rec		in (0,3)
 order by 8
/
comment on table civnas_ANN_V_JSON is 'ANSC - Atti di Nascita per request JSON - Annotazioni (view)'
/

