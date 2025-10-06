--liquibase formatted sql
--changeset amonopoli:202503270900_15 runOnChange:false stripComments:false
insert into a_errori
	 (ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
select 'D00001','Transazione completata','','','S'
  from dual
 where not exists (select 'x' from a_errori where errore = 'D00001')
/
insert into a_errori
	 (ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
select 'D00002','La ricerca non ha riportato nessuna registrazione','','','S'
  from dual
 where not exists (select 'x' from a_errori where errore = 'D00002')
/
