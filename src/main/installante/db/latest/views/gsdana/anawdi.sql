--liquibase formatted sql
--changeset amonopoli:202307311200 runOnChange:true stripComments:false
create or replace view anawdi
	(FASCIA, STATO, MATRICOLA, COGNOME_NOME, SESSO,
	 NAZIONALITA, NAZIONALITA_ISTAT, COD_FAM,
	 TIPO_DI, NUMERO_DI, DATA_EMISSIONE_DI, 
	 DATA_SCADENZA_DI, FLAG_SCADENZA_ILLIMITATA_DI,
	 ENTE_EMISSIONE_DI, COD_PRO_ENTE_DI, COD_COM_ENTE_DI,
	 NATURA_DI, MOTIVO_DI, VAL_ESPATRIO_DI, 
         ID_ANADOC, D_DATA_EMISSIONE_DI, D_DATA_SCADENZA_DI)
AS
select ana.fascia,
	ana.stato,
	ana.matricola,	
	ana.cognome_nome,
	ana.sesso,
	ana.nazionalita,
	dci.ist_ci,
	ana.cod_fam,
	to_char(null), 		--doc_v.tipo_documento,
	to_char(null), 		--doc_v.numero,
	to_number(null), 	--doc_v.data_emissione,	
	to_number(null), 	--doc_v.data_scadenza,
	to_char(null), 		--doc_v.flag_scadenza_illimitata,
	to_number(null), 	--doc_v.ente_emissione,
	to_number(null), 	--doc_v.cod_pro_ente,
	to_number(null), 	--doc_v.cod_com_ente,
	to_char(null), 		--doc_v.natura_documento,
	to_number(null), 	--doc_v.motivo_documento,
	to_char(null), 		--doc_v.espatrio,
        to_number(null), 	--doc_v.id id_anadoc,
	to_date(null), 		--to_date(doc_v.data_emissione,'j'),	
	to_date(null) 	--to_date(doc_v.data_scadenza,'j')
  from anadci dci, anaana ana
 where dci.cod_ci	(+)	= ana.nazionalita
   and not exists (select 'x' 
                     from anaddo ddo,anadoc doc
                    where ddo.flag_identita    = 'S'
                      and ddo.cod_do           = doc.tipo_documento   
                      and doc.natura_documento != 'A'
                      and doc.progr_documento  = 1
                      and doc.matricola        = ana.matricola)
UNION ALL
select ana.fascia,
	ana.stato,
	ana.matricola,	
	ana.cognome_nome,
	ana.sesso,
	ana.nazionalita,
	dci.ist_ci,
	ana.cod_fam,
	doc.tipo_documento,
	doc.numero,
	doc.data_emissione,	
	doc.data_scadenza,
	doc.flag_scadenza_illimitata,
	doc.ente_emissione,
	doc.cod_pro_ente,
	doc.cod_com_ente,
	doc.natura_documento,
	doc.motivo_documento,
	doc.espatrio,
        doc.id id_anadoc,
	to_date(doc.data_emissione,'j'),	
	to_date(doc.data_scadenza,'j')
  from anadci dci, anaana ana, anadoc doc
 where dci.cod_ci	(+)	= ana.nazionalita
   and ana.matricola            = doc.matricola
   and doc.id                   = f_WDI_get_id_anadoc(ana.matricola)
/
comment on table anawdi is 'Anagrafe - Dati Documento di Identità (view)'
/
