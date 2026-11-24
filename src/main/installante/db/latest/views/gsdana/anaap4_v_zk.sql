--liquibase formatted sql
--changeset amonopoli:202606111145_1 runAlways:true runOnChange:true stripComments:false
create or replace view anaap4_v_zk
as
select ap4.*,
       'RES' anagrafe,
       'I' tipo_evento,
       'RES-I-INI-'||nvl(ap4.tipo_richiesta,0) id_iniziativa,
       'RES-I-RIC-'||nvl(ap4.richiesta,0) id_richiesta,
       'RES-I-PRO-'||nvl(ap4.provvedimento,0) id_provvedimento,
-- des_com_eve
       f_comune_al(ap4.cod_pro_eve,ap4.cod_com_eve,'') des_com_eve,
-- sigla_pro_eve
       f_provincia_stato_al(ap4.cod_pro_eve,ap4.cod_com_eve,'','S','','') sigla_pro_eve,
-- des_com_iscr_aire
       f_comune_al(ap4.cod_pro_iscr_aire,ap4.cod_com_iscr_aire,'') des_com_iscr_aire,
-- sigla_pro_iscr_aire
       f_provincia_stato_al(ap4.cod_pro_iscr_aire,ap4.cod_com_iscr_aire,'','S','','') sigla_pro_iscr_aire
  from anaap4 ap4
/
COMMENT ON TABLE ANAAP4_v_zk IS 'Anagrafe - Testata Modello APR4 di Iscrizione (view)'
/
