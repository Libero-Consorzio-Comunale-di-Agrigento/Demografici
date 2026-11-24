--liquibase formatted sql
--changeset amonopoli:202511180852_2 runOnChange:true stripComments:false
update anadta 
   set VERSION = 0
 where version is null
/
