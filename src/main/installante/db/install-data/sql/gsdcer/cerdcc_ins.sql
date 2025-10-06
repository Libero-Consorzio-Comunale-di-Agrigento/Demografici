--liquibase formatted sql
--changeset amonopoli:202410251405 runOnChange:true stripComments:false
INSERT INTO cerdcc ( COD_CC, DESCRIZIONE, CONDIZIONE_SQL) 
SELECT 1,'vedovo','ana_stato_civile = ''VE''' 
  FROM DUAL 
 WHERE NOT EXISTS (SELECT 1 FROM cerdcc WHERE COD_CC=1)
/
INSERT INTO cerdcc ( COD_CC, DESCRIZIONE, CONDIZIONE_SQL) 
SELECT 2,'libero da vincoli matrimoniali','ana_stato_civile not in (''CN'',''NC'')' 
  FROM DUAL 
 WHERE NOT EXISTS (SELECT 1 FROM cerdcc WHERE COD_CC=2)
/
INSERT INTO cerdcc ( COD_CC, DESCRIZIONE, CONDIZIONE_SQL) 
SELECT 3,'cittadino italiano','ana_nazionalita = ''I''' 
  FROM DUAL 
 WHERE NOT EXISTS (SELECT 1 FROM cerdcc WHERE COD_CC=3)
/
INSERT INTO cerdcc ( COD_CC, DESCRIZIONE, CONDIZIONE_SQL) 
SELECT 4,'coniugato o vedovo','ana_stato_civile in (''CN'',''VE'')' 
  FROM DUAL 
 WHERE NOT EXISTS (SELECT 1 FROM cerdcc WHERE COD_CC=4)
/
INSERT INTO cerdcc ( COD_CC, DESCRIZIONE, CONDIZIONE_SQL) 
SELECT 5,'elettore','ele_stato = ''E''' 
  FROM DUAL 
 WHERE NOT EXISTS (SELECT 1 FROM cerdcc WHERE COD_CC=5)
/
INSERT INTO cerdcc ( COD_CC, DESCRIZIONE, CONDIZIONE_SQL) 
SELECT 6,'coniugato','ana_stato_civile = ''CN''' 
  FROM DUAL 
 WHERE NOT EXISTS (SELECT 1 FROM cerdcc WHERE COD_CC=6)
/
INSERT INTO cerdcc ( COD_CC, DESCRIZIONE, CONDIZIONE_SQL) 
SELECT 7,'eta'' maggiore di 15 anni','add_months(ana_d_data_nas,180) <= trunc(sysdate)' 
  FROM DUAL 
 WHERE NOT EXISTS (SELECT 1 FROM cerdcc WHERE COD_CC=7)
/
INSERT INTO cerdcc ( COD_CC, DESCRIZIONE, CONDIZIONE_SQL) 
SELECT 8,'eta'' maggiore di 18 anni','add_months(ana_d_data_nas,216) <= trunc(sysdate)' 
  FROM DUAL 
 WHERE NOT EXISTS (SELECT 1 FROM cerdcc WHERE COD_CC=8)
/
INSERT INTO cerdcc ( COD_CC, DESCRIZIONE, CONDIZIONE_SQL) 
SELECT 9,'eta'' maggiore di 14 anni','add_months(ana_d_data_nas,168) <= trunc(sysdate)' 
  FROM DUAL 
 WHERE NOT EXISTS (SELECT 1 FROM cerdcc WHERE COD_CC=9)
/
INSERT INTO cerdcc ( COD_CC, DESCRIZIONE, CONDIZIONE_SQL) 
SELECT 10,'cittadino straniero UE','ana_nazionalita != ''I'' and dci_cee = ''S''' 
  FROM DUAL 
 WHERE NOT EXISTS (SELECT 1 FROM cerdcc WHERE COD_CC=10)
/
INSERT INTO cerdcc ( COD_CC, DESCRIZIONE, CONDIZIONE_SQL) 
SELECT 11,'elettore liste aggiunte','ela_stato = ''E''' 
  FROM DUAL 
 WHERE NOT EXISTS (SELECT 1 FROM cerdcc WHERE COD_CC=11)
/
INSERT INTO cerdcc ( COD_CC, DESCRIZIONE, CONDIZIONE_SQL) 
SELECT 12,'cittadino italiano / libero da vincoli matrimoniali','ana_nazionalita = ''I'' and ana_stato_civile not in (''CN'',''NC'')' 
  FROM DUAL 
 WHERE NOT EXISTS (SELECT 1 FROM cerdcc WHERE COD_CC=12)
/
INSERT INTO cerdcc ( COD_CC, DESCRIZIONE, CONDIZIONE_SQL) 
SELECT 13,'cittadino straniero','ana_nazionalita != ''I''' 
  FROM DUAL 
 WHERE NOT EXISTS (SELECT 1 FROM cerdcc WHERE COD_CC=13)
/
INSERT INTO cerdcc ( COD_CC, DESCRIZIONE, CONDIZIONE_SQL) 
SELECT 14,'cittadino italiano / eta'' minore 15 anni','ana_nazionalita = ''I'' and add_months(ana_d_data_nas,180) > trunc(sysdate)' 
  FROM DUAL 
 WHERE NOT EXISTS (SELECT 1 FROM cerdcc WHERE COD_CC=14)
/
INSERT INTO cerdcc ( COD_CC, DESCRIZIONE, CONDIZIONE_SQL) 
SELECT 15,'eta'' minore 15 anni','add_months(ana_d_data_nas,180) > trunc(sysdate)' 
  FROM DUAL 
 WHERE NOT EXISTS (SELECT 1 FROM cerdcc WHERE COD_CC=15)
/
INSERT INTO cerdcc ( COD_CC, DESCRIZIONE, CONDIZIONE_SQL) 
SELECT 16,'atto nascita presente','atto_nascita is not null' 
  FROM DUAL 
 WHERE NOT EXISTS (SELECT 1 FROM cerdcc WHERE COD_CC=16)
/
INSERT INTO cerdcc ( COD_CC, DESCRIZIONE, CONDIZIONE_SQL) 
SELECT 17,'convivenza di fatto','f_flag_CDF(matricola) = ''S''' 
  FROM DUAL 
 WHERE NOT EXISTS (SELECT 1 FROM cerdcc WHERE COD_CC=17)
/
INSERT INTO cerdcc ( COD_CC, DESCRIZIONE, CONDIZIONE_SQL) 
SELECT 18,'unito civilmente','ana_stato_civile = ''UC''' 
  FROM DUAL 
 WHERE NOT EXISTS (SELECT 1 FROM cerdcc WHERE COD_CC=18)
/
INSERT INTO cerdcc ( COD_CC, DESCRIZIONE, CONDIZIONE_SQL) 
SELECT 19,'in famiglia','ana_rapporto_par not in (''CC'',''IC'')' 
  FROM DUAL 
 WHERE NOT EXISTS (SELECT 1 FROM cerdcc WHERE COD_CC=19)
/
INSERT INTO cerdcc ( COD_CC, DESCRIZIONE, CONDIZIONE_SQL) 
SELECT 20,'in convivenza','ana_rapporto_par in (''CC'',''IC'')' 
  FROM DUAL 
 WHERE NOT EXISTS (SELECT 1 FROM cerdcc WHERE COD_CC=20)
/
INSERT INTO cerdcc ( COD_CC, DESCRIZIONE, CONDIZIONE_SQL) 
SELECT 21,'presente in archivio elettorale','exists (select 1 from eleana where matricola = ana_matricola UNION select 1 from eleela where matricola = ana_matricola)' 
  FROM DUAL 
 WHERE NOT EXISTS (SELECT 1 FROM cerdcc WHERE COD_CC=21)
/
INSERT INTO cerdcc ( COD_CC, DESCRIZIONE, CONDIZIONE_SQL) 
SELECT 22,'presente in liste di leva','exists (select 1 from levruo where matricola = ana_matricola)' 
  FROM DUAL 
 WHERE NOT EXISTS (SELECT 1 FROM cerdcc WHERE COD_CC=22)
/
