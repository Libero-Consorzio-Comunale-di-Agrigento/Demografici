--liquibase formatted sql
--changeset amonopoli:202510301045_3 runOnChange:true stripComments:false
alter table civdta
modify cod_mi number(3)
/
