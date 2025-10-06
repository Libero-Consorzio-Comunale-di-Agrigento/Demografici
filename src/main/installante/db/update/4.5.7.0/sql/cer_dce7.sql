--liquibase formatted sql
--changeset snocca:202401031537 runOnChange:true stripComments:false
alter table cerdce modify descrizione varchar2(60)
/