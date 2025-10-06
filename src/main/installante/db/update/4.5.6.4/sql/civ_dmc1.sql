--liquibase formatted sql
--changeset snocca:202307250815 runOnChange:true stripComments:false
alter table civdmc modify descrizione varchar2(300)
/
