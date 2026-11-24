--liquibase formatted sql
--changeset amonopoli:202510271245 runOnChange:true stripComments:false
INSERT INTO cerdfc ( COMPETENZA, COD_FC, DESCRIZIONE, CONDIZIONE_SQL)
SELECT 'SC','ANS','Atti provenienza ANSC',NULL
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM cerdfc WHERE COMPETENZA='SC' and COD_FC='ANS')
/
