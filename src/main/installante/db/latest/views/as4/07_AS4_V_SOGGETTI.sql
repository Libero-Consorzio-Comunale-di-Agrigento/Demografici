--liquibase formatted sql
--changeset snocca:202210181707 runOnChange:true
create or replace view AS4_V_SOGGETTI as select * from ${global.db.as4.username}.AS4_V_SOGGETTI
/