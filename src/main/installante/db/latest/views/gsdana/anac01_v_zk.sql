--liquibase formatted sql
--changeset amonopoli:202606111149_1 runAlways:true runOnChange:true stripComments:false
create or replace view anac01_v_zk
as
select c01.*,
       decode(c01.anno_pratica||c01.pratica, '', 'AIR', 'RES') anagrafe,
       decode(c01.anno_pratica||c01.pratica, '', 'C', 'I') tipo_evento,
-- des_com_eve
       f_comune_al(c01.cod_pro_eve,c01.cod_com_eve,'') des_com_eve,
-- sigla_pro_eve
       f_provincia_stato_al(c01.cod_pro_eve,c01.cod_com_eve,'','S','','') sigla_pro_eve
  from anac01 c01
/
COMMENT ON TABLE ANAC01_v_zk IS 'Anagrafe - Modello AIRE/01 di Cancellazione (view)'
/
