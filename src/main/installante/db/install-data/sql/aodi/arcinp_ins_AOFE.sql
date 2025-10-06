--liquibase formatted sql
--changeset amonopoli:202503190830_2 runOnChange:true stripComments:false
insert into arcinp (parametro, valore, descrizione, gruppo, flag_visibile)
select 'AOFE', 'N formato=A4 risoluzione=80 tipoAcquisizione=F estensione=PDF','AOFE: ATTIVAZIONE', 'ELE', 'S'
  from dual
 where not exists (select 'x' from arcinp b
                    where b.parametro ='AOFE')
/
