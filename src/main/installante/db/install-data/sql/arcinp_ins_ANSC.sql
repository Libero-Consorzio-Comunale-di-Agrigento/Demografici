--liquibase formatted sql
--changeset snocca:202304071505 runOnChange:true
insert into arcinp
       (parametro, valore, descrizione, gruppo, note, flag_visibile)
select 'ANSC'
     , ''
     , 'INTEGRAZIONE ANSC'
     , 'CIV'
     , 'Se valorizzato, attiva l''integrazione con L''Archivio Nazionale informatizzato dei registri dello Stato Civile.'
     , 'S'
  from dual
 where not exists (select 'x' from arcinp
                    where parametro = 'ANSC')
/
