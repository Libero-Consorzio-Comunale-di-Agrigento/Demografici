--liquibase formatted sql
--changeset vmigliore:202501201012 runOnChange:true
insert into arcinp
       (parametro, valore, descrizione, gruppo, note, flag_visibile)
select 'STATS_URL'
     , '/stats'
     , 'SMART STATS: URL'
     , 'GSD'
     , 'URL di SmartStats. Può essere relativo (es. /stats) o assoluto (es. https://x.x.x.x/stats)'
     , 'S'
  from dual
 where not exists (select 'x' from arcinp
                    where parametro = 'STATS_URL')
/
