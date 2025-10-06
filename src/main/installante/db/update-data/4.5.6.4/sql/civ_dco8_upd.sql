--liquibase formatted sql
--changeset snocca:202307131800 runOnChange:true stripComments:false
update civdco
   set descrizione = 'UFF. ANAGRAFE ELETTORALE DI RESIDENZA'
 where codice_co   = 2 AND descrizione = 'UFF. ANAGRAFE/ELETTORALE DI RESIDENZA'
/
