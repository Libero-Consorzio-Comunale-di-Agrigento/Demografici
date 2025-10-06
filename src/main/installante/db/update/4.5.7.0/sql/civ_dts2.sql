--liquibase formatted sql
--changeset snocca:202327121425 runOnChange:true stripComments:false
alter table civdts modify protocollo_t number(5)
/
alter table civdts modify protocollo_s number(5)
/
alter table civdts modify protocollo_c number(5)
/