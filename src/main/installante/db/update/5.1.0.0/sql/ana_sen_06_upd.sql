--liquibase formatted sql
--changeset amonopoli:202606101300_2 runOnChange:true stripComments:false
alter table anasen disable all triggers
/
update anasen
   set id_anamov = anno_progr_mov||lpad(numero_progr_mov,6,'0')
 where anno_progr_mov is not null
   and numero_progr_mov is not null
/
alter table anasen enable all triggers
/
