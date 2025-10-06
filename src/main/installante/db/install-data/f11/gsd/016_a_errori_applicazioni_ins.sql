--liquibase formatted sql
--changeset amonopoli:202503270900_16 runOnChange:false stripComments:false
insert into a_errori_applicazioni (AP_ERRORE, ERRORE, STILE)
select 'FRM-41050','',''
  from dual
 where not exists (select 'x' from a_errori_applicazioni where ap_errore = 'FRM-41050')
/
insert into a_errori_applicazioni (AP_ERRORE, ERRORE, STILE)
select 'FRM-41051','',''
  from dual
 where not exists (select 'x' from a_errori_applicazioni where ap_errore = 'FRM-41051')
/
insert into a_errori_applicazioni (AP_ERRORE, ERRORE, STILE)
select 'FRM-40400','D00001','S'
  from dual
 where not exists (select 'x' from a_errori_applicazioni where ap_errore = 'FRM-40400')
/
insert into a_errori_applicazioni (AP_ERRORE, ERRORE, STILE)
select 'FRM-40350','D00002','S'
  from dual
 where not exists (select 'x' from a_errori_applicazioni where ap_errore = 'FRM-40350')
/
