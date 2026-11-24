--liquibase formatted sql
--changeset amonopoli:202410281240_2 runOnChange:true stripComments:false
create or replace view PARAMETRI_PROTOCOLLO_V_ana
as
select v.*       
  from parametri_protocollo_V v
 where modulo   = 'ANA'
   and cod_fase is not null
/
comment on table PARAMETRI_PROTOCOLLO_V_ANA is 'Integrazioni - Parametri per Protocollo / Invio Albo (ANA)'
/
