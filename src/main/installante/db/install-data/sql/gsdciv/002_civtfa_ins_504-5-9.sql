--liquibase formatted sql
--changeset amonopoli:202510291545_2 runOnChange:true stripComments:false
INSERT INTO civtfa ( FORMULA, RIGA, TESTO, TESTO_4000) 
SELECT '504-5-9',1,NULL,'CONCORDATARIO' 
  FROM DUAL 
 WHERE NOT EXISTS (SELECT 1 FROM civtfa WHERE FORMULA='504-5-9')
/
