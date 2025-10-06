--liquibase formatted sql
--changeset amonopoli:202407230940 runOnChange:true stripComments:false
INSERT INTO cerdfc ( COMPETENZA, COD_FC, DESCRIZIONE, CONDIZIONE_SQL)
SELECT 'AN','DEC','Deceduti','ana_stato = 50'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM cerdfc WHERE COMPETENZA='AN' and COD_FC='DEC')
/
INSERT INTO cerdfc ( COMPETENZA, COD_FC, DESCRIZIONE, CONDIZIONE_SQL)
SELECT 'AN','EIR','Emigrati / Irreperibili','ana_fascia = 2 and ana_stato in (select cod_eve from anadce where anagrafe = ''RES'' and tipo_evento = ''C'' and tipo_evento_istat in (''M'',''I'',''A''))'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM cerdfc WHERE COMPETENZA='AN' and COD_FC='EIR')
/
INSERT INTO cerdfc ( COMPETENZA, COD_FC, DESCRIZIONE, CONDIZIONE_SQL)
SELECT 'AN','EMI','Emigrati','ana_fascia = 2 and ana_stato in (select cod_eve from anadce where anagrafe = ''RES'' and tipo_evento = ''C'' and tipo_evento_istat in (''M''))'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM cerdfc WHERE COMPETENZA='AN' and COD_FC='EMI')
/
INSERT INTO cerdfc ( COMPETENZA, COD_FC, DESCRIZIONE, CONDIZIONE_SQL)
SELECT 'AN','IAI','Iscritti A.I.R.E.','ana_fascia = 3'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM cerdfc WHERE COMPETENZA='AN' and COD_FC='IAI')
/
INSERT INTO cerdfc ( COMPETENZA, COD_FC, DESCRIZIONE, CONDIZIONE_SQL)
SELECT 'AN','IRP','Irreperibili Presunti (AIRE)','ana_fascia = 4 and ana_stato in (54,58,59)'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM cerdfc WHERE COMPETENZA='AN' and COD_FC='IRP')
/
INSERT INTO cerdfc ( COMPETENZA, COD_FC, DESCRIZIONE, CONDIZIONE_SQL)
SELECT 'AN','IRR','Irreperibili / Cancellati d''Ufficio','ana_fascia = 2 and ana_stato in (select cod_eve from anadce where anagrafe = ''RES'' and tipo_evento = ''C'' and tipo_evento_istat in (''I'',''A''))'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM cerdfc WHERE COMPETENZA='AN' and COD_FC='IRR')
/
INSERT INTO cerdfc ( COMPETENZA, COD_FC, DESCRIZIONE, CONDIZIONE_SQL)
SELECT 'AN','NRE','Non Residenti','ana_fascia in (5,6)'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM cerdfc WHERE COMPETENZA='AN' and COD_FC='NRE')
/
INSERT INTO cerdfc ( COMPETENZA, COD_FC, DESCRIZIONE, CONDIZIONE_SQL)
SELECT 'AN','RES','Residenti','ana_fascia + 0 = 1'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM cerdfc WHERE COMPETENZA='AN' and COD_FC='RES')
/
INSERT INTO cerdfc ( COMPETENZA, COD_FC, DESCRIZIONE, CONDIZIONE_SQL)
SELECT 'SC','OR0','Originali gia'' stampati','civ_natura = ''O'' and civ_cod_rec = 0'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM cerdfc WHERE COMPETENZA='SC' and COD_FC='OR0')
/
INSERT INTO cerdfc ( COMPETENZA, COD_FC, DESCRIZIONE, CONDIZIONE_SQL)
SELECT 'SC','ORI','Originali','civ_natura = ''O'''
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM cerdfc WHERE COMPETENZA='SC' and COD_FC='ORI')
/
INSERT INTO cerdfc ( COMPETENZA, COD_FC, DESCRIZIONE, CONDIZIONE_SQL)
SELECT 'SC','OT0','Originali / Trascritti gia'' stampati','civ_natura in (''O'',''T'') and civ_cod_rec = 0'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM cerdfc WHERE COMPETENZA='SC' and COD_FC='OT0')
/
INSERT INTO cerdfc ( COMPETENZA, COD_FC, DESCRIZIONE, CONDIZIONE_SQL)
SELECT 'SC','OTR','Originali / Trascritti','civ_natura in (''O'',''T'')'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM cerdfc WHERE COMPETENZA='SC' and COD_FC='OTR')
/
INSERT INTO cerdfc ( COMPETENZA, COD_FC, DESCRIZIONE, CONDIZIONE_SQL)
SELECT 'SC','TUT','Tutti',NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM cerdfc WHERE COMPETENZA='SC' and COD_FC='TUT')
/
INSERT INTO cerdfc ( COMPETENZA, COD_FC, DESCRIZIONE, CONDIZIONE_SQL)
SELECT 'SC','DIV','Divorzi / Scioglimenti',NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM cerdfc WHERE COMPETENZA='SC' and COD_FC='DIV')
/
