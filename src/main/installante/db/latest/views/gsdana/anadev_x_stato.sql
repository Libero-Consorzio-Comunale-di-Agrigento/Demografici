--liquibase formatted sql
--changeset amonopoli:202502211555 runOnChange:true stripComments:false
create or replace view anadev_x_stato
AS
select dev.* 
  from anadev dev
 where exists (select 1 from anadce
                where cod_eve = dev.cod_ev
                  and cod_mov in (1,2,3,4,5,6))
/
comment on table anadev_x_stato is 'Anagrafe - Lista codici per decodifca campo STATO'
/
