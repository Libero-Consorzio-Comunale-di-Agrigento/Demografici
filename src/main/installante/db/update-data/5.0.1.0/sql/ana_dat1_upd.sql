--liquibase formatted sql
--changeset amonopoli:202511180850_2 runOnChange:true stripComments:false
update anadat 
   set VERSION = 0
 where version is null
/
