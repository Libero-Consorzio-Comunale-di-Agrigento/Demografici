--liquibase formatted sql
--changeset amonopoli:202503190830_3 runOnChange:true stripComments:false
insert into arcinp (parametro, valore, descrizione, gruppo, flag_visibile)
select 'AOFF', 'N formato=A3 risoluzione=80', 'AOFF: ATTIVAZIONE', 'ANA', 'S'
  from dual
 where not exists (select 'x' from arcinp
		    where parametro ='AOFF')
/
insert into arcinp (parametro, valore, descrizione, gruppo, flag_visibile)
select 'AOSI', 'N formato=A4 risoluzione=80', 'AOSI: ATTIVAZIONE', 'ANA', 'S'
  from dual
 where not exists (select 'x' from arcinp
		    where parametro ='AOSI')
/
