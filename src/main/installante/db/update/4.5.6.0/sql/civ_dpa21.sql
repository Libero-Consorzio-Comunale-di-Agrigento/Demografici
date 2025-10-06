--liquibase formatted sql
--changeset snocca:202304131415
alter table civdpa
modify tipo_dichiarante varchar2(20)
/
