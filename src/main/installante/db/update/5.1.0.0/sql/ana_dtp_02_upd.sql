--liquibase formatted sql
--changeset amonopoli:202512031130_2 runOnChange:true stripComments:false
update anadtp
   set version = 0
 where version is null
/

