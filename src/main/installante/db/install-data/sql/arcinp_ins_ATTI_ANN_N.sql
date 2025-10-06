--liquibase formatted sql
--changeset vmigliore:202504101200 runOnChange:true
insert into arcinp (PARAMETRO, VALORE, DESCRIZIONE, GRUPPO, NOTE, FLAG_VISIBILE)
select 'ATTI_ANN_N',
       'N',
       'ATTI: ANN NUOVA GEST',
       'CIV',
       'Se valorizzato, sulla redazione atto, attiva la gestione delle annotazioni che riferiscono ad atti primari digitali (ANSC)',
       'S'
from dual
where not exists (select 1
                  from arcinp
                  where parametro = 'ATTI_ANN_N')
/