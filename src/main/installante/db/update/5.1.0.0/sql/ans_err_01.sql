--liquibase formatted sql
--changeset amonopoli:202606160845 runOnChange:true stripComments:false
alter table anserr
modify codice_errore varchar2(20)
/

