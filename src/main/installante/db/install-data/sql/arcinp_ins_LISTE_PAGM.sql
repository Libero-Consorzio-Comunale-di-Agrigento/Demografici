--liquibase formatted sql
--changeset dfiloni:202603191100 runOnChange:true stripComments:false
insert into arcinp
(parametro, valore, descrizione, gruppo, note, flag_visibile)
select 'LISTE_PAGM'
     , 'N'
     , 'LISTE: N. INIZ. PAG.'
     , 'ELE'
     , 'Se valorizzato, attiva la visualizzazione della text box per indicare il numero della prima pagina da stampare nelle liste sezionali'
     , 'S'
from dual
where not exists (select 'x' from arcinp
                  where parametro = 'LISTE_PAGM')
/
