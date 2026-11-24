--liquibase formatted sql
--changeset amonopoli:202606111555 runAlways:true runOnChange:true stripComments:false
create or replace view anadct_v
AS
select dct.*,
       (select cod_modello                     from anadco_zk where codice_co = dct.codice_co) cod_modello,
       (select tipo_comunicazione||cod_modello from anadco_zk where codice_co = dct.codice_co) id_anamod,
       (select ente_destinatario               from anadco_zk where codice_co = dct.codice_co) ente_destinatario,
       (select tipo_documento_rif              from anadco_zk where codice_co = dct.codice_co) tipo_documento_rif,
       (select flag_priorita                   from anadco_zk where codice_co = dct.codice_co) flag_priorita,
       (select flag_soggetto                   from anadco_zk where codice_co = dct.codice_co) flag_soggetto
  from anadct dct
/
comment on table anadct_v is 'Anagrafe - Dizionario Comunicazioni per Tipo di Pratica - zk (view)'
/
