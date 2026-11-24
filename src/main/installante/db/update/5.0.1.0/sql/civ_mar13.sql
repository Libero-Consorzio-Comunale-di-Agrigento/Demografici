--liquibase formatted sql
--changeset amonopoli:202512231250 runOnChange:true stripComments:false
alter table civmar
modify legge_conv varchar2(4000)
/
