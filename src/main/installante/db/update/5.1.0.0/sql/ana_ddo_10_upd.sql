--liquibase formatted sql
--changeset amonopoli:202511180857_2 runOnChange:true stripComments:false
update anaddo
   set VERSION = 0
 where version is null
/
