--liquibase formatted sql
--changeset amonopoli:202503211025 runOnChange:true stripComments:false
insert into arcinp (parametro, valore, descrizione, gruppo, flag_visibile)
select 'ISTATEL', 'N', 'INTEGRAZIONE ISTATEL', 'GSD', ''
  from dual
 where not exists (select 'x' from arcinp
		    where parametro = 'ISTATEL')
/
insert into arcinp (parametro, valore, descrizione, gruppo, flag_visibile)
select 'ISTA_DTER', '0', 'IST: U.T. CENSIMENTO', 'GSD', ''
  from dual
 where not exists (select 'x' 
		     from arcinp
	            where parametro = 'ISTA_DTER')
/

