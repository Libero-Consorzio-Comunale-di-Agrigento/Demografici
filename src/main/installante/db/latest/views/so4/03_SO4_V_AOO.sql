--liquibase formatted sql
--changeset snocca:202210190903 runOnChange:true
CREATE OR REPLACE FORCE VIEW SO4_V_AOO
AS
select progr_aoo
     , codice_amministrazione 	amministrazione
     , codice_aoo 				codice
     , descrizione
     , des_abb 					abbreviazione
     , indirizzo
     , cap
     , provincia
     , comune
     , telefono
     , fax
     , utente_aggiornamento
     , data_aggiornamento
     , dal
     , al
  from SO4_AOO
/
