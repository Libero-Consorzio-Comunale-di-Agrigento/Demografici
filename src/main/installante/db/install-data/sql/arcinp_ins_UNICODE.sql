--liquibase formatted sql
--changeset amonopoli:202510081100 runOnChange:true stripComments:false
insert into arcinp
       (parametro, valore, descrizione, gruppo, note, flag_visibile)
select 'UNICODE'
     , 'N'
     , 'CARATTERI SPECIALI'
     , 'GSD'
     , 'Se valorizzato, attiva la pop-up di gestione dei caratteri speciali sia a livello di Stato Civile che di Anagrafe'
     , 'S'
  from dual
 where not exists (select 'x' from arcinp
                    where parametro = 'UNICODE')
/
