--liquibase formatted sql
--changeset snocca:202210181710 runOnChange:true
create or replace view AS4_V_TIPI_CONTATTO as select * from ${global.db.as4.username}.AS4_V_TIPI_CONTATTO
/