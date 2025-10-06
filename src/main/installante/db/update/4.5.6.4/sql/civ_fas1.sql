--liquibase formatted sql
--changeset amonopoli:202307241025 runOnChange:true stripComments:false
alter table civfas modify id_atto varchar2(25)
/
