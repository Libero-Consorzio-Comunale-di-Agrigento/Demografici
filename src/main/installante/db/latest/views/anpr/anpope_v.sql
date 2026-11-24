--liquibase formatted sql
--changeset amonopoli:202512181135 runOnChange:true stripComments:false
create or replace view anpope_v
as
select ope.*
     , to_date(f_ADS_data(ope.dataOraRichiesta),'j') d_dataOraRichiesta
     , to_date(f_ADS_data(ope.dataProtocolloComune),'j') d_dataProtocolloComune
     , to_date(f_ADS_data(ope.dataDecorrenza),'j') d_dataDecorrenza
     , to_date(f_ADS_data(ope.dataDefinizionePratica),'j') d_dataDefnizionePratica
     , tws.descrizione des_operazioneRichiesta
     , t44.descrizione des_statoLavorazione
     , ope.id_operazione||ope.idOperazioneComune||ope.idOperazioneAnpr id
  from anptws tws, anpt44 t44, anpope ope
 where tws.codice (+) = ope.operazioneRichiesta
   and t44.codice (+) = ope.statoLavorazione
/
comment on table anpope_v is 'ANPR - Elenco Operazioni del Soggetto (view)'
/