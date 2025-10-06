--liquibase formatted sql
--changeset snocca:202212211622
alter table civdpa
modify AUTORITA_PROV varchar2(150)
/