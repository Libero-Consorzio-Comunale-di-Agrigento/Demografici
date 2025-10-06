--liquibase formatted sql
--changeset amonopoli:202503211252_1 runOnChange:true stripComments:false
create or replace view istmp4_v
AS
select mp4.*
     , f_IST_get_campo_MP4(mp4.matricola,'INTESTATARIO') intestatario
     , f_IST_get_campo_MP4(mp4.matricola,'COGNOME_INTESTATARIO') cognome_intestatario
     , f_IST_get_campo_MP4(mp4.matricola,'NOME_INTESTATARIO') nome_intestatario
     , f_IST_get_campo_MP4(mp4.matricola,'INDIRIZZO') indirizzo
     , ltrim(f_IST_get_campo_MP4(mp4.matricola,'SEZIONE_CENS'),'0') sezione_cens_default
     , to_date(f_IST_get_campo_MP4(mp4.matricola,'DATA_REG_J'),'j') d_data_iscrizione
  from istmp4 mp4
/
comment on table ISTMP4_V is 'ISTAT - Dati per Compilazione Modello P.4 (view)'
/
