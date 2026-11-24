--liquibase formatted sql
--changeset amonopoli:202606051355 runOnChange:true stripComments:false
alter table ansc_log
modify servizio varchar2(100)
/
