--liquibase formatted sql
--changeset amonopoli:202503190830_1 runOnChange:true stripComments:false
insert into arcinp (parametro, valore, descrizione, gruppo, flag_visibile)
select 'AODI', 'N formato=A4 risoluzione=80 estensione=pdf', 'AODI: ATTIVAZIONE', 'ANA', 'S'
  from dual
 where not exists (select 'x' from arcinp
		    where parametro ='AODI')
/
