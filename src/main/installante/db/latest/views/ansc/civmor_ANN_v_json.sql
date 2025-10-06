--liquibase formatted sql
--changeset amonopoli:202311201445 runAlways:true runOnChange:true stripComments:false
create or replace view civmor_ANN_v_json as
select mor.id
     , mor.id_atto
     , mor.ufficio
     , mor.anno
     , mor.parte
     , mor.serie
     , mor.atto
-- datiAnnotazione
     , 10 + nvl(sequenza,1) tipoAnnotazione
     , ann.testo_annotazione testoAnnotazione
     , decode(ann.stampa,'S','false','true') flagAnnNonCertificabile
-- ANSC
     , mor.id_atto_ansc idAttoAnsc
     , mor.id_evento_ansc idEventoAnsc
  from civann ann
     , civmor mor
 where ann.id_atto	= mor.id_atto
   and mor.cod_rec	in (0,3)
UNION ALL
select mor.id
     , mor.id_atto
     , mor.ufficio
     , mor.anno
     , mor.parte
     , mor.serie
     , mor.atto
-- datiAnnotazione
     , tli_f.progr_dettaglio tipoAnnotazione
     , dbms_lob.substr(tli_f.testo_clob,4000) testoAnnotazione
     , 'true' flagAnnNonCertificabile
-- ANSC
     , mor.id_atto_ansc idAttoAnsc
     , mor.id_evento_ansc idEventoAnsc
  from civtli_formule tli_f
     , civmor mor
 where tli_f.tipo_atto          = 5
   and tli_f.testo_clob         is not null
   and tli_f.richiamo           = 98
   and tli_f.progr_dettaglio    not in (2,3)
   and tli_f.id_atto            = mor.id_atto
   and mor.cod_rec		in (0,3)
 order by 8
/
comment on table civmor_ANN_V_JSON is 'ANSC - Atti di Morte per request JSON - Annotazioni (view)'
/

