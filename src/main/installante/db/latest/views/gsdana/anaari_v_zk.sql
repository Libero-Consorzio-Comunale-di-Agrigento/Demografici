--liquibase formatted sql
--changeset amonopoli:202606111235 runAlways:true runOnChange:true stripComments:false
create or replace view anaari_v_zk
AS
select ari.*,
-- des_com_rec
       f_comune_al(ari.cod_pro_rec,ari.cod_com_rec,'') des_com_rec,
-- sigla_pro_rec
       f_provincia_stato_al(ari.cod_pro_rec,ari.cod_com_rec,'','S','','') sigla_pro_rec
  from anaari ari
/
comment on table anaari_v_zk is 'Anagrafe - Archivio Recapiti dell''Individuo (view)'
/
