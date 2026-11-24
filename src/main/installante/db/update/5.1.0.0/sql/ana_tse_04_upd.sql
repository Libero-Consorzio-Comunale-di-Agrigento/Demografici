--liquibase formatted sql
--changeset amonopoli:202512031125_2 runOnChange:true stripComments:false
update anatse
   set version = 0
 where version is null
/

