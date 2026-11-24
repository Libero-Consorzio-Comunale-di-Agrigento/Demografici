--liquibase formatted sql
--changeset amonopoli:202606111020 runAlways:true runOnChange:true stripComments:false
create or replace view arcdnc_v
AS
select dnc.*
     , decode(dnc.elemento,
         'NUM_CIV',6,
         'FLAG_METRICO',1,
         'PROGR_SNC',10,
         'SUFFISSO',10,
         'FLAG_LETTERA',1,
         'FLAG_ESPONENTE',1,
         'SCALA_ESTERNA',10,
         'COLORE',10,
         'INTERNO',4,
         'FLAG_NUI',1,
         'SUB_INTERNO',10,
         'NUI',10,
         'SCALA',3,
         'PIANO',3,
         'CORTE',10,
         'INTERNO2',4,
         'SUB_INTERNO2',10,
         'SECONDARIO',10) width_elemento
  from arcdnc dnc
/
comment on table arcdnc_v is 'Anagrafe - Dizionario Numerazione Civica (view)'
/
