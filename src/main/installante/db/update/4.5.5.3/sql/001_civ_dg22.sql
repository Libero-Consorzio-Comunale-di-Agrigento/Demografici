--liquibase formatted sql
--changeset snocca:202212151317
alter table civdg2
modify luogo_nas varchar2(150)
/
