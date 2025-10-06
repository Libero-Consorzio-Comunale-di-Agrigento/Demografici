--liquibase formatted sql
--changeset snocca:202401081237 runOnChange:true stripComments:false
alter table civmar modify ufficio_nas varchar2(2)
/