--liquibase formatted sql
--changeset snocca:202401231036 runOnChange:true stripComments:false
alter table civdpa modify nota_rif varchar2(25)
/