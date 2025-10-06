--liquibase formatted sql
--changeset snocca:202210181701 runOnChange:true
create or replace view AS4_V_ANAGRAFICI as select * from ${global.db.as4.username}.AS4_V_ANAGRAFICI
/
