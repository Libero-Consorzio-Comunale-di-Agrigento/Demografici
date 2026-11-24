--liquibase formatted sql
--changeset amonopoli:202606111155 runAlways:true runOnChange:true stripComments:false
create or replace view anadoi_v_zk
AS
select doi.*,
-- des_contratto_locazione
       f_comune_al(doi.cod_pro_contratto_locazione,doi.cod_com_contratto_locazione,'') des_com_contratto_locazione,
-- sigla_contratto_locazione
       f_provincia_stato_al(doi.cod_pro_contratto_locazione,doi.cod_com_contratto_locazione,'','S','','') sigla_pro_contratto_locazione,
-- des_proprieta_locazione
       f_comune_al(doi.cod_pro_proprieta_locazione,doi.cod_com_proprieta_locazione,'') des_com_proprieta_locazione,
-- sigla_proprieta_locazione
       f_provincia_stato_al(doi.cod_pro_proprieta_locazione,doi.cod_com_proprieta_locazione,'','S','','') sigla_pro_proprieta_locazione,
-- des_contratto_comodato
       f_comune_al(doi.cod_pro_contratto_comodato,doi.cod_com_contratto_comodato,'') des_com_contratto_comodato,
-- sigla_contratto_comodato
       f_provincia_stato_al(doi.cod_pro_contratto_comodato,doi.cod_com_contratto_comodato,'','S','','') sigla_pro_contratto_comodato,
-- des_proprieta_comodato
       f_comune_al(doi.cod_pro_proprieta_comodato,doi.cod_com_proprieta_comodato,'') des_com_proprieta_comodato,
-- sigla_proprieta_comodato
       f_provincia_stato_al(doi.cod_pro_proprieta_comodato,doi.cod_com_proprieta_comodato,'','S','','') sigla_pro_proprieta_comodato
  from anadoi doi
/
comment on table anadoi_v_zk is 'Anagrafe - Dati Occupazione Immobile (view)'
/

