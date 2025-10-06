--liquibase formatted sql
--changeset snocca:202210181705 runOnChange:true
create or replace view AS4_V_RECAPITI as select * from ${global.db.as4.username}.AS4_V_RECAPITI
/
