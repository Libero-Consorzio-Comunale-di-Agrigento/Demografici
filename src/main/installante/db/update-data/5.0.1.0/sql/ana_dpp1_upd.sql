--liquibase formatted sql
--changeset amonopoli:202511180851_2 runOnChange:true stripComments:false
update anadpp 
   set VERSION = 0
 where version is  null
/
