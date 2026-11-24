--liquibase formatted sql
--changeset amonopoli:202606111530_2 runOnChange:true stripComments:false
update anadcc 
   set tipo_comunicazione = 'C'
 where tipo_comunicazione is null
/
