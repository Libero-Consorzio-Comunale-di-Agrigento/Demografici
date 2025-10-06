--liquibase formatted sql
--changeset snocca:202302101755 runOnChange:true
insert into arcinp
       (parametro, valore, descrizione, gruppo, note, flag_visibile)
select 'TANN_BLOC'
     , ''
     , 'ANNOTAZ:BLOCCO TESTO'
     , 'CIV'
     , 'Se valorizzato, deve contenere l''elenco delle formule delle annotazioni per le quali si vuole inibire la modifica del testo.
Le formule da bloccare devono essere separate dal carattere '',''.'
     , 'S'
  from dual
 where not exists (select 'x' from arcinp
                    where parametro = 'TANN_BLOC')
/
