--liquibase formatted sql
--changeset amonopoli:202308011535 runAlways:true runOnChange:true stripComments:false
create or replace view civmat_ANN_v_json as
select mat.id
     , mat.id_atto
     , mat.ufficio
     , mat.anno
     , mat.parte
     , mat.serie
     , mat.atto
-- datiAnnotazione
     , 10 + nvl(ann.sequenza,1) tipoAnnotazione
     , ann.testo_annotazione testoAnnotazione
     , decode(ann.stampa,'S','false','true') flagAnnNonCertificabile
-- ANSC
     , mat.id_atto_ansc idAttoAnsc
     , mat.id_evento_ansc idEventoAnsc
  from civann ann
     , civmat mat
 where ann.id_atto	= mat.id_atto
   and mat.cod_rec	in (0,3)
UNION ALL
select mat.id
     , mat.id_atto
     , mat.ufficio
     , mat.anno
     , mat.parte
     , mat.serie
     , mat.atto
-- datiAnnotazione
     , tli_f.progr_dettaglio tipoAnnotazione
     , dbms_lob.substr(tli_f.testo_clob,4000) testoAnnotazione
     -- progr_dettaglio = 4: convenzioni patrimoniali
     , decode(tli_f.progr_dettaglio,4,'false','true') flagAnnNonCertificabile
-- ANSC
     , mat.id_atto_ansc idAttoAnsc
     , mat.id_evento_ansc idEventoAnsc
  from civtli_formule tli_f
     , civmat mat
 where tli_f.tipo_atto          = 4
   and tli_f.testo_clob         is not null
   and tli_f.richiamo           = 98
   and tli_f.progr_dettaglio    not in (2,3)
   and tli_f.id_atto            = mat.id_atto
   and mat.cod_rec		in (0,3)
 order by 8
/
comment on table CIVMAT_ANN_V_JSON is 'ANSC - Atti di Matrimonio per request JSON - Annotazioni (view)'
/
