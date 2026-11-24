--liquibase formatted sql
--changeset amonopoli:202510301045_2 runOnChange:true stripComments:false
alter table civism
modify cod_mi number(3)
/
