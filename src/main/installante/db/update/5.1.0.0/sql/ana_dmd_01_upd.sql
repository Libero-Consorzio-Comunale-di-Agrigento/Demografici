--liquibase formatted sql
--changeset amonopoli:202511180854_2 runOnChange:true stripComments:false
update anadmd 
   set VERSION = 0
 where version is null
/
