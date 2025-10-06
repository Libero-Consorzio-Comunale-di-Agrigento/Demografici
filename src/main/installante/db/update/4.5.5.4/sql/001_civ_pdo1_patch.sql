--liquibase formatted sql
--changeset snocca:202301021718 runOnChange:true
alter table CIVPDO disable all triggers
/
update CIVPDO
   set id_atto           = f_CIV_get_id_atto(tipo_atto,ufficio,anno,parte,serie,atto)
/
alter table CIVPDO enable all triggers
/
