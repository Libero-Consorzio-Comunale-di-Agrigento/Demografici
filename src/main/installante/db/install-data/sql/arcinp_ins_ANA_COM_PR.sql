--liquibase formatted sql
--changeset amonopoli:202511191145 runOnChange:true stripComments:false
insert into arcinp
       (parametro, valore, descrizione, gruppo, note, flag_visibile)
select 'ANA_COM_PR','A','COM. ANA: PRINCIPALE','ANA',
       'Valori ammessi: ''S'' - ''N'' - ''A''
Nell''ambito della stampa delle comunicazioni di stato civile, abilita la possibilità di modificare il check di "documento principale" nella lista degli allegati collegati alla comunicazione da stampare.
I valori possibili assumono questo significato:
- ''S'': il flag e'' visibile per tutte le comunicazioni
- ''N'': il flag NON e'' visibile per alcuna comunicazione
- ''A'': il flag e'' visibile per le SOLE comunicazioni individuate come "Adempimenti"',
       'S'
  from dual
 where not exists (select 'x' from arcinp
                    where parametro = 'ANA_COM_PR')
/
