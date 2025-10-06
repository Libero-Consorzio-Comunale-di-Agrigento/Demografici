--liquibase formatted sql
--changeset snocca:202310271325 runOnChange:true
insert into arcinp
       (parametro, valore, descrizione, gruppo, note, flag_visibile)
select 'ANSC_INT'
     , 'N'
     , 'ANSC:INTEST. ATTI'
     , 'CIV'
     , 'Se valorizzato, attiva la composizione dell''intestazione dell''atto con l''indicazione del numero comunale .'
     , 'S'
  from dual
 where not exists (select 'x' from arcinp
                    where parametro = 'ANSC_INT')
/
