--liquibase formatted sql
--changeset amonopoli:202511180858_2 runOnChange:true stripComments:false
update anaden
   set VERSION = 0
 where version is null
/
