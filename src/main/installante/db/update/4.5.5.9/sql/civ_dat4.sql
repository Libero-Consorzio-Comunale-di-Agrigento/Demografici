--liquibase formatted sql
--changeset snocca:202212151317
alter table civdat
modify protocollo NUMBER(9)
/
