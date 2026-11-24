--liquibase formatted sql
--changeset mdematteis:202602111542 runOnChange:true
insert into arcinp
(parametro, valore, descrizione, gruppo, note, flag_visibile)
select 'LISTE_PSEZ'
     , 'S'
     , 'LISTE: PROGR. SEZ.'
     , 'ELE'
     , 'Se valorizzato, attiva la visualizzazione della colonna Prog. Sez. con il numero di sezione (solo in caso di elaborazione con flag "alfabetico" attivo)'
     , 'S'
from dual
where not exists (select 'x' from arcinp
                  where parametro = 'LISTE_PSEZ')
/
