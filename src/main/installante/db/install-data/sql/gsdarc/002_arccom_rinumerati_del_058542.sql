--liquibase formatted sql
--changeset amonopoli:202511101105 runOnChange:true stripComments:false
delete arccom_rinumerati
 where cod_provincia = 58
   and cod_comune    = 542
/
