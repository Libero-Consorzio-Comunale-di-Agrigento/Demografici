--liquibase formatted sql
--changeset amonopoli:202402271455 runAlways:true runOnChange:true stripComments:false
create or replace view cercem_v
AS
select cem.*
     , (cem.anno_emissione||lpad(cem.progr_emissione,6,'0')) id_emissione
-- des_com_nas_richiedente
     , f_comune_al(cem.COD_PRO_NAS_RICHIEDENTE,cem.COD_COM_NAS_RICHIEDENTE,cem.DATA_NAS_RICHIEDENTE) des_com_nas_richiedente
-- sigla_pro_nas_richiedente
     , f_provincia_stato_al(cem.COD_PRO_NAS_RICHIEDENTE,cem.COD_COM_NAS_RICHIEDENTE,'','S','',cem.DATA_NAS_RICHIEDENTE) sigla_pro_nas_richiedente
-- des_com_nas_beneficiario
     , f_comune_al(cem.COD_PRO_NAS_BENEFICIARIO,cem.COD_COM_NAS_BENEFICIARIO,to_char(cem.D_DATA_NAS_BENEFICIARIO,'j')) des_com_nas_beneficiario
-- sigla_pro_nas_beneficiario
     , f_provincia_stato_al(cem.COD_PRO_NAS_BENEFICIARIO,cem.COD_COM_NAS_BENEFICIARIO,'','S','',to_char(cem.D_DATA_NAS_BENEFICIARIO,'j')) sigla_pro_nas_beneficiario
-- des_com_ente_richiedente
     , f_comune_al(cem.COD_PRO_ENTE_RICHIEDENTE,cem.COD_COM_ENTE_RICHIEDENTE,'') des_com_ente_richiedente
-- sigla_pro_ente_richiedente
     , f_provincia_stato_al(cem.COD_PRO_ENTE_RICHIEDENTE,cem.COD_COM_ENTE_RICHIEDENTE,'','S','','') sigla_pro_ente_richiedente
-- richiedente
     , decode(cem.id_cerdtr, 3, cem.ente_richiedente || ' - ' || f_comune_al(cem.COD_PRO_ENTE_RICHIEDENTE,cem.COD_COM_ENTE_RICHIEDENTE,'') || ' ' || f_provincia_stato_al(cem.COD_PRO_ENTE_RICHIEDENTE,cem.COD_COM_ENTE_RICHIEDENTE,'','S','S',''), cem.richiedente) richiedente_lista
  from cercem cem
/
comment on table cercem_v is 'Certificazione - Certificati Emessi (view)'
/
