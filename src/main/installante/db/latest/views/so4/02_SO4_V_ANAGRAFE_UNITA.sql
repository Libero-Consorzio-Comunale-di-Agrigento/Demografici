--liquibase formatted sql
--changeset snocca:202210190902 runOnChange:true
create or replace view SO4_V_ANAGRAFE_UNITA as select * from so4_anagrafe_unita
/