--liquibase formatted sql
--changeset amonopoli:202306091510_1 runOnChange:true stripComments:false
insert into arcinp (parametro,valore,descrizione) 
select 'SCIA_LOGO','N','STAMPA C.I.A.:LOGO'
  from dual
 where not exists (select 'x' 
		     from arcinp
	            where parametro = 'SCIA_LOGO')
/
