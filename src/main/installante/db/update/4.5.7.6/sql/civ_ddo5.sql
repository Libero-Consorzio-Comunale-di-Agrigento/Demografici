--liquibase formatted sql
--changeset amonopoli:202406130910 runOnChange:true stripComments:false
alter table civddo
modify cod_do varchar2(3)
/
