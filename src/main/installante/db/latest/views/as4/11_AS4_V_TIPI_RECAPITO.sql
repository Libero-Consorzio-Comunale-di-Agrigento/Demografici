--liquibase formatted sql
--changeset snocca:202210181711 runOnChange:true
create or replace view AS4_V_TIPI_RECAPITO as select * from ${global.db.as4.username}.AS4_V_TIPI_RECAPITO
/