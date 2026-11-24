--liquibase formatted sql
--changeset amonopoli:202606111620_2 runOnChange:true stripComments:false
alter table anacom_prot disable all triggers
/
update anacom_prot
   set d_data_protocollo = to_date(data_protocollo,'j')
 where d_data_protocollo is null
   and data_protocollo   is not null
/
alter table anacom_prot enable all triggers
/
