--liquibase formatted sql
--changeset amonopoli:202606111145_2 runAlways:true runOnChange:true stripComments:false
create or replace view anaapm_v_zk
as
select apm.*,
       apm.sesso||lpad(apm.ist_rp,2,'0') ID_ANADPI,
       'RES' anagrafe,
       'I' tipo_evento,
       f_ANA_get_id_pratica('RES', 'I', apm.anno_dic, apm.numero_dic) id_pratica
  from anaapm apm
/
COMMENT ON TABLE ANAAPM_v_zk IS 'Anagrafe - Individui in APR/4 di iscrizione (view)'
/
