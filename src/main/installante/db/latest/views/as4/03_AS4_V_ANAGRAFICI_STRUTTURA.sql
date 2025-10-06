--liquibase formatted sql
--changeset snocca:202210181703 runOnChange:true
create or replace view AS4_V_ANAGRAFICI_STRUTTURA as select * from ${global.db.as4.username}.AS4_V_ANAGRAFICI_STRUTTURA
/