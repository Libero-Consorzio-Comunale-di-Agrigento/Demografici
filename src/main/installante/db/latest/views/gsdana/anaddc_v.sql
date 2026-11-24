--liquibase formatted sql
--changeset amonopoli:202606170900 runAlways:true runOnChange:true stripComments:false
create or replace view anaddc_v
as
select ddc.*
     , ddc.tipo_modello||ddc.cod_modello id_anamod
  from anaddc ddc
/
comment on table anaddc_v is 'Anagrafe - Relazione Modello / Enti Destinatari (view)'
/
