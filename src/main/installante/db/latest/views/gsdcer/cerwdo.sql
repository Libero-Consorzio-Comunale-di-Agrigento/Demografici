--liquibase formatted sql
--changeset amonopoli:202410091525_1 runOnChange:true stripComments:false
create or replace view cerwdo
	(MATRICOLA, COD_DO, PROGR_DOCUMENTO, FLAG_IDENTITA, FLAG_STRANIERI, FLAG_NAZIONALITA_ITA, COD_EN,
         TIPO_DOCUMENTO, DES_ENTE_EMISSIONE, DATA_EMISSIONE, DES_COM_EMISSIONE, SIGLA_PRO_EMISSIONE, 
         CATEGORIA, NUMERO, ESPATRIO, DATA_SCADENZA, DES_QUESTURA)
as
SELECT doc.matricola,
       ddo.cod_do, 
       doc.progr_documento,
       ddo.flag_identita,
       ddo.flag_stranieri,
       decode(ana.nazionalita,'I','S') flag_nazionalita_ita,
       den.cod_en,
       DECODE(ddo.cod_do,
         'CC','Carta Circ.',
         'CI','Carta d''Id.',
         'CE','CIE        ',
         'LL','L.di Lavoro',
         'LP','L. Pensione',
         'PS','P. di Sogg.',
         'CS','C. di Sogg.',
         'PT','Patente    ',
              TRANSLATE(INITCAP(LOWER(ddo.descrizione)),'D','d')) TIPO_DOCUMENTO,
       decode(den.descrizione,'COMUNE',null,den.descrizione) DES_ENTE_EMISSIONE,
       DECODE(doc.data_emissione,'','','del '||TO_CHAR(TO_DATE(doc.data_emissione,'j'),'dd/mm/yyyy')) DATA_EMISSIONE,
       DECODE(doc.cod_pro_ente,'','','a '||com.descrizione||' ('||com.sigla_provincia||')') DES_COM_EMISSIONE,
       com.sigla_provincia sigla_EMISSIONE,
       DECODE(doc.categoria,'','','Cat. '||INITCAP(LOWER(dca.descrizione))) CATEGORIA,
       doc.numero NUMERO,
       DECODE(ddo.flag_identita,'S',
         DECODE(doc.espatrio,'','Esp: NO','S','Esp: SI','Inibizione all''Espatrio'),'') ESPATRIO,
       DECODE(doc.data_scadenza,'','','(valida fino al '||TO_CHAR(TO_DATE(doc.data_scadenza,'j'),'dd/mm/yyyy')||')') DATA_SCADENZA,
       DECODE(doc.cod_pro_ente,'','','a '||com.descrizione||' ('||com.sigla_provincia||')') DES_QUESTURA
  FROM arccom com, ANADCA dca, ANADEN den, ANADDO ddo,
       anaana ana, anadoc doc
 WHERE com.cod_provincia (+)       = doc.cod_pro_ente
   AND com.cod_comune    (+)       = doc.cod_com_ente
   AND dca.cod_ca        (+)       = doc.categoria
   AND den.cod_en                  = doc.ente_emissione
   AND ddo.cod_do                  = doc.tipo_documento
   AND doc.progr_documento         = decode(ddo.flag_identita,'S',1,
                                       decode(ddo.cod_do,'LL',1,
                                         doc.progr_documento))
   AND ((doc.natura_documento in ('O','D') and doc.tipo_documento != 'CE')
        or doc.tipo_documento = 'CE')    
   AND ana.matricola               = doc.matricola
/
comment on table cerwdo is 'Certificazione - Documenti Individuo (view)'
/

