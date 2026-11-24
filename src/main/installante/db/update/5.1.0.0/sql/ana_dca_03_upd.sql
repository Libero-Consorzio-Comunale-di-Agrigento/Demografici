--liquibase formatted sql
--changeset amonopoli:202511180853_2 runOnChange:true stripComments:false
update anadca 
   set VERSION = 0
 where version is null
/
