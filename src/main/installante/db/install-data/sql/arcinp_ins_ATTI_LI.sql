--liquibase formatted sql
--changeset snocca:202303031032 runOnChange:true
insert into arcinp
       (parametro, valore, descrizione, gruppo, note, flag_visibile)
select 'ATTI_LI'
     , ''
     , 'PRE-DATA A MARGINE'
     , 'CIV'
     , 'Dicitura da anteporre alla data a margine'
     , 'S'
  from dual
 where not exists (select 'x' from arcinp
                    where parametro = 'ATTI_LI')
/
update arcinp set flag_visibile = 'S'
where parametro = 'ATTI_LI'
/
