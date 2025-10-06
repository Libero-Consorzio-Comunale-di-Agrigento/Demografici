--liquibase formatted sql
--changeset amonopoli:202308011625 runAlways:true runOnChange:true stripComments:false
create or replace view civuci_ANN_v_json as
select uci.id
     , uci.id_atto
     , uci.ufficio
     , uci.anno
     , uci.parte
     , uci.serie
     , uci.atto
-- datiAnnotazione
     , 10 + nvl(ann.sequenza,1) tipoAnnotazione
     , ann.testo_annotazione testoAnnotazione
     , decode(ann.stampa,'S','false','true') flagAnnNonCertificabile
-- ANSC
     , uci.id_atto_ansc idAttoAnsc
     , uci.id_evento_ansc idEventoAnsc
  from civann ann
     , civuci uci
 where ann.id_atto	= uci.id_atto
   and uci.cod_rec	in (0,3)
UNION ALL
select uci.id
     , uci.id_atto
     , uci.ufficio
     , uci.anno
     , uci.parte
     , uci.serie
     , uci.atto
-- datiAnnotazione
     , tli_f.progr_dettaglio tipoAnnotazione
     , dbms_lob.substr(tli_f.testo_clob,4000) testoAnnotazione
     -- progr_dettaglio = 4: convenzioni patrimoniali
     -- progr_dettaglio = 5: cambio cognome, contraente 1
     -- progr_dettaglio = 6: cambio cognome, contraente 2
     , decode(tli_f.progr_dettaglio,4,'false',5,'false',6,'false','true') flagAnnNonCertificabile
-- ANSC
     , uci.id_atto_ansc idAttoAnsc
     , uci.id_evento_ansc idEventoAnsc
  from civtli_formule tli_f
     , civuci uci
 where tli_f.tipo_atto          = -4
   and tli_f.testo_clob         is not null
   and tli_f.richiamo           = 98
   and tli_f.progr_dettaglio    not in (2,3)
   and tli_f.id_atto            = uci.id_atto
   and uci.cod_rec		in (0,3)
 order by 8
/
comment on table civuci_ANN_V_JSON is 'ANSC - Atti di Unione Civile per request JSON - Annotazioni (view)'
/

