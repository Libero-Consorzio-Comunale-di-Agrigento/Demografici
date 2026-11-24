--liquibase formatted sql
--changeset amonopoli:202606161450_2 runOnChange:true stripComments:false
alter table anatpr disable all triggers
/
update anatpr
   set version = 0
 where version is null
/
alter table anatpr enable all triggers
/