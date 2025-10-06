--liquibase formatted sql
--changeset snocca:202210181704 runOnChange:true
create or replace view AS4_V_CONTATTI as select * from ${global.db.as4.username}.AS4_V_CONTATTI
/