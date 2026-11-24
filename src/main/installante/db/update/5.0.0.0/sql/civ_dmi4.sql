--liquibase formatted sql
--changeset amonopoli:202510301045_1 runOnChange:true stripComments:false
alter table civdmi
modify cod_mi number(3)
/
