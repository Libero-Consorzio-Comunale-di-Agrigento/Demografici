--liquibase formatted sql
--changeset snocca:202402141350 runAlways:true runOnChange:true stripComments:false
create or replace view civdmc_v
as
select dmc.*, t03.descrizione as descrizione_usecase
  from civdmc dmc, anst03 t03
 where dmc.id = t03.id
/