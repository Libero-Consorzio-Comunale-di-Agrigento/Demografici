--liquibase formatted sql
--changeset amonopoli:202504171045 runOnChange:true stripComments:false
update cerdce
   set descrizione = substr(descrizione,8)||' - ANSC'
 where upper(descrizione) like 'ANSC - %'
/
update cerdce
   set descrizione = substr(descrizione,8)||' - ANPR'
 where upper(descrizione) like 'ANPR - %'
/
update cerdce
   set descrizione = substr(descrizione,12)||' - ANPR NRE'
 where upper(descrizione) like 'ANPR NRE - %'
/
update cerdce
   set descrizione = substr(descrizione,12)||' - ANPR NRE'
 where upper(descrizione) like 'NRE ANPR - %'
/
