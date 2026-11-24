--liquibase formatted sql
--changeset amonopoli:202511180855_2 runOnChange:true stripComments:false
update anadtp
   set VERSION = 0
 where version is null
/
