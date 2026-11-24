--liquibase formatted sql
--changeset amonopoli:202606111148_1 runAlways:true runOnChange:true stripComments:false
create or replace view anaa01_v_zk
as
select a01.*,
       decode(a01.anno_pratica||a01.pratica, '', 'AIR', 'RES') anagrafe,
       decode(a01.anno_pratica||a01.pratica, '', 'I', 'C') tipo_evento,
-- des_com_eve
       f_comune_al(a01.cod_pro_eve,a01.cod_com_eve,'') des_com_eve,
-- sigla_pro_eve
       f_provincia_stato_al(a01.cod_pro_eve,a01.cod_com_eve,'','S','','') sigla_pro_eve,
-- des_com_aire
       f_comune_al(a01.cod_pro_aire,a01.cod_com_aire,'') des_com_aire,
-- sigla_pro_aire
       f_provincia_stato_al(a01.cod_pro_aire,a01.cod_com_aire,'','S','','') sigla_pro_aire
  from anaa01 a01
/
COMMENT ON TABLE ANAA01_v_zk IS 'Anagrafe - Modello AIRE/01 (view)'
/
