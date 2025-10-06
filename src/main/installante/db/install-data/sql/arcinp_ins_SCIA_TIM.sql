--liquibase formatted sql
--changeset amonopoli:202306091510_2 runOnChange:true stripComments:false
insert into arcinp (parametro,valore,descrizione) 
select 'SCIA_TIM','N','STAMPA C.I.A.:TIMBRO' 
  from dual
 where not exists (select 'x' 
		     from arcinp
	            where parametro = 'SCIA_TIM')
/
