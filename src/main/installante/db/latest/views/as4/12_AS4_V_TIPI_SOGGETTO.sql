--liquibase formatted sql
--changeset snocca:202210181712 runOnChange:true
create or replace view AS4_V_TIPI_SOGGETTO as select * from ${global.db.as4.username}.AS4_V_TIPI_SOGGETTO
/
