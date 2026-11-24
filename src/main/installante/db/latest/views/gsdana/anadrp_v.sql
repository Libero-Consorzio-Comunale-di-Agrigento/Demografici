--liquibase formatted sql
--changeset amonopoli:202602251210 runAlways:true runOnChange:true stripComments:false
create or replace view anadrp_v as
select drp.*,
       drp.sesso||drp.cod_rp id
  from anadrp drp
/
comment on table ANADRP_V is 'Anagrafe - Dizionario codici di Rapporto Parentela (view)'
/

