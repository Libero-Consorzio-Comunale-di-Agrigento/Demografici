--liquibase formatted sql
--changeset amonopoli:202605190959 runAlways:true runOnChange:true stripComments:false
create or replace view anadce_v
AS
select dce.*
--
     , decode(dce.anagrafe||'-'||dce.tipo_evento, 'RES-I', decode(dce.cod_eve, 4, 'S')) flag_reimmigrazione_aire
  from anadce dce
/
comment on table anadce_v is 'Anagrafe - Dizionario Codici Evento e Relazioni (view)'
/
