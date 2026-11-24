--liquibase formatted sql
--changeset amonopoli:202606111540 runAlways:true runOnChange:true stripComments:false
create or replace view anadco_v_zk
AS
select dco.*,
       dco.tipo_comunicazione||dco.cod_modello id_anamod,
--     decode(dco.tipo_comunicazione, 
--       'P', codice_co||' - '||dco.descrizione,
--       'C', codice_co||' - '||(select descrizione from anamod mod where cod_modello = dco.cod_modello and tipo_modello = 'C')||'- '||dco.descrizione) descrizione_estesa
       decode(dco.tipo_comunicazione, 
         'P', dco.descrizione,
         'C', (select descrizione from anamod mod where cod_modello = dco.cod_modello and tipo_modello = 'C')||'- '||dco.descrizione) descrizione_estesa
  from anadco_zk dco
/
comment on table anadco_v_zk is 'Anagrafe - Dizionario Comunicazioni - zk (view)'
/
