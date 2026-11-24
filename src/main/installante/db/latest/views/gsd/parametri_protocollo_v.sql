--liquibase formatted sql
--changeset amonopoli:202410281240 runOnChange:true stripComments:false
create or replace view PARAMETRI_PROTOCOLLO_V
as
select pp.*,
       decode(substr(pp.destinatario,1,4),'AODI','S',to_char(null)) flag_archiviazione,
       f_PAR_modulo(pp.fase) modulo,
       f_PAR_fase(pp.fase,'COD',pp.funzione) cod_fase,
       f_PAR_fase(pp.fase,'DES',pp.funzione) des_fase,
       f_PAR_tipo_atto_civ(pp.fase,pp.funzione,'COD') cod_tipo_atto_civ,
       f_PAR_tipo_atto_civ(pp.fase,pp.funzione,'DES') des_tipo_atto_civ,
       f_PAR_codice_co_civ(pp.fase,pp.funzione) codice_co_civ,
       f_PAR_cod_certificato_cer(pp.fase,pp.funzione) cod_certificato_cer,
       f_PAR_fase_ana(pp.fase,pp.funzione,'COD') cod_fase_ana,
       f_PAR_fase_ana(pp.fase,pp.funzione,'DES') des_fase_ana,
       f_PAR_id_anamod_ana(pp.fase,pp.funzione) id_anamod_ana,
       f_PAR_modello_gdm(pp.fase,pp.destinatario) modello_gdm,
       f_PAR_chiave_gdm(pp.fase,pp.destinatario) chiave_gdm
  from parametri_protocollo pp
/
comment on table PARAMETRI_PROTOCOLLO_V is 'Integrazioni - Parametri per Protocollo / Invio Albo'
/
