--liquibase formatted sql
--changeset snocca:202210181706 runOnChange:true
create or replace view AS4_V_RECAPITI_CORRENTI as select * from ${global.db.as4.username}.AS4_V_RECAPITI_CORRENTI
/