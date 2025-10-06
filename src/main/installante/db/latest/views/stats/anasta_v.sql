--liquibase formatted sql
--changeset amonopoli:202411191555_1 runOnChange:true stripComments:false
create or replace view anasta_v
AS
select 
--     sta.DATA data_j,
       to_date(sta.data,'j') data_rif,
       to_char(to_date(sta.data,'j'),'dd/mm/yyyy') data_rif_edit,
--       to_char(to_date(sta.data,'j'),'dd/mm/yyyy') des_data_edit,
       sta.ANNO_NASCITA,
       sta.STATO,
       dev.descrizione des_stato,
       sta.SESSO,
       sta.STATO_CIVILE,
       dsc.descrizione des_stato_civile,
       sta.NAZIONALITA,
       dci.descrizione des_nazionalita,
       sta.COD_FAM,
       sta.RAPPORTO_PAR,
       drp.descrizione des_rapporto_par,
       sta.COD_VIA codice_via,
       vie.denom_uff denominazione_via,
       sta.NUM_CIV numero_civico,
       sta.SUFFISSO,
       sta.TOTALE,
       sta.SUB_INTERNO
  from arcvie vie, anadev dev, anadsc dsc, anadci dci, anadrp drp, anasta sta
 where vie.cod_via (+) = sta.cod_via
   and dev.cod_ev  (+) = sta.stato
   and dsc.cod_sc  (+) = sta.stato_civile
   and dsc.sesso   (+) = sta.sesso
   and dci.cod_ci  (+) = sta.nazionalita
   and drp.cod_rp  (+) = sta.rapporto_par
   and drp.sesso   (+) = sta.sesso
/
comment on table anasta_v is 'Statistiche Anagrafe - Statistiche Storiche (view)'
/
