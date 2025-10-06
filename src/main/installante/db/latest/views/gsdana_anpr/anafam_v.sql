--liquibase formatted sql
--changeset amonopoli:202502261540 runAlways:true stripComments:false
create or replace view anafam_v
AS
--
-- FASCIA          - decodifica con EFascia
-- TIPO_FAM        - valorizzato a '1' indica Convivenza (altrimenti null)
-- COD_VIA         - decodifica su ARCVIE (id: COD_VIA)
-- TIPO_CONVIVENZA - decodifica su ANATCV (id: COD_TC)
--
select /*+ PUSH_SUBQ*/
       fam.*
--
     , decode(fam.fascia, 1, 'RES', 2, 'RES', 3, 'AIR', 4, 'AIR', 6, 'NRE') anagrafe
     , f_FAM_matricola_CF(fam.fascia, fam.cod_fam) matricola_CF
--
     , f_comune_al(fam.COD_PRO_AIRE,fam.COD_COM_AIRE,'') des_com_aire
     , f_provincia_stato_al(fam.COD_PRO_AIRE,fam.COD_COM_AIRE,'','S','','') sigla_pro_aire
     , f_comune_al(fam.COD_PRO_RES,fam.COD_COM_RES,'') des_com_res
     , f_provincia_stato_al(fam.COD_PRO_RES,fam.COD_COM_RES,'','S','','') sigla_pro_res
--
     , f_stato_interno(fam.COD_VIA,fam.NUM_CIV,fam.SUFFISSO,fam.INTERNO,fam.SUB_INTERNO,fam.SCALA,fam.COD_FAM,fam.PIANO) des_stato_interno
     , f_intestatario_interno(fam.COD_VIA,fam.NUM_CIV,fam.SUFFISSO,fam.INTERNO,fam.SUB_INTERNO,fam.SCALA,fam.COD_FAM,fam.PIANO) des_intestatario_interno
--
     , decode(fam.fascia,
         3, f_get_campo_COM(fam.cod_pro_aire,fam.cod_com_aire,'','','','','','CODICE_CONSOLATO')) cod_consolato_aire
     , decode(fam.fascia,
         3, f_get_campo_COM(fam.cod_pro_aire,fam.cod_com_aire,'','','','','','SEDE_CONSOLATO')) sede_consolato_aire
--
     , decode(fam.fascia,
         1, f_ANPR_id_scheda('','',1,fam.cod_fam,'',''),
         2, f_ANPR_id_scheda('','',1,fam.cod_fam,'',''),
         3, f_ANPR_id_scheda('','',3,fam.cod_fam,'',''),
         4, f_ANPR_id_scheda('','',3,fam.cod_fam,'',''),
         6, f_ANPR_id_scheda('','',6,fam.cod_fam,'','')) id_famiglia_anpr
  from anafam fam
/
comment on table anafam_v is 'Anagrafe - Famiglie (view)'
/
