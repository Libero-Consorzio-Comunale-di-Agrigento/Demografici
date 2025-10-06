--liquibase formatted sql
--changeset amonopoli:202503211241_2 runOnChange:true stripComments:false
create or replace view ISTD7B_int
	(archivio, punto, des_punto)
AS
-- nati nel comune (1.1)
select 'NAS','2.1','Nati - nel Comune'
  from dual
UNION
-- nati in altro comune
select 'NAS','2.2','Nati - in Altro Comune'
  from dual
UNION
-- nati all'estero
select 'NAS','2.3','Nati - all''Estero'
  from dual
UNION
-- MORTI NEL COMUNE
select 'MOR','3.1','Morti - nel Comune'
  from dual
UNION
-- MORTI IN ALTRO COMUNE
select 'MOR','3.2','Morti - in Altro Comune'
  from dual
UNION
-- MORTI ALL'ESTERO
select 'MOR','3.3','Morti - all''Estero'
  from dual
UNION
-- ISCRITTI DA ALTRO COMUNE
select 'ISC','5.1','Iscritti - da Altro Comune'
  from dual
UNION
-- iscritti dall'estero
select 'ISC','5.2','Iscritti - dall''Estero'
  from dual
UNION
-- iscritti per altri motivi
select 'ISC','5.3','Iscritti - per Altri Motivi'
  from dual
UNION
-- cancellati da altro comune
select 'CNC','6.1','Cancellati - per Altro Comune'
  from dual
UNION
-- cancellati dall'estero
select 'CNC','6.2','Cancellati - per l''Estero'
  from dual
UNION
--cancellati per altri motivi
select 'CNC','6.3','Cancellati - per Altri Motivi'
  from dual
/
comment on table ISTD7B_INT is 'ISTAT - Dati per Compilazione Modello D7B - Intestazioni (view)'
/
