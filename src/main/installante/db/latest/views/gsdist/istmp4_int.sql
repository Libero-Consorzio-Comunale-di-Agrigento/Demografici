--liquibase formatted sql
--changeset amonopoli:202503211252_2 runOnChange:true stripComments:false
create or replace view istmp4_int (cod_modello, riga)
AS
select 'P4',
       'PROGRESSIVO_QUEST'||';'||
         'MESE_RIFERIMENTO'||';'||
         'ANNO_RIFERIMENTO'||';'||
         'COGNOME_INTESTATARIO'||';'||
         'NOME_INTESTATARIO'||';'||
         'NR_COMPONENTI_FAMIGLIA'||';'||
         'NR_COMPONENTI_MINORENNI'||';'||
         'INDIRIZZO'||';'||
         'NR_CIVICO'||';'||
         'CAP'||';'||
         'NR_SEZIONE_CENSIMENTO'||';'||
         'COGNOME_NATO'||';'||
         'NOME_NATO'||';'||
         'PROV_NASCITA_NATO'||';'||
         'COM_NASCITA_NATO'||';'||
         'EST_NASCITA_NATO'||';'||
         'DATA_NASCITA'||';'||
         'SESSO_NATO'||';'||
         'CITTAD_NATO'||';'||
         'CITTAD_EST_NATO'||';'||
         'DATA_ISCRIZ_NASCITA'||';'||
         'COGNOME_MADRE'||';'||
         'NOME_MADRE'||';'||
         'DATA_NASCITA_MADRE'||';'||
         'STATO_CIVILE_MADRE'||';'||
         'CITTAD_MADRE'||';'||
         'CITTAD_EST_MADRE'||';'||
         'COD_FISC_MADRE'||';'||
         'COGNOME_PADRE'||';'||
         'NOME_PADRE'||';'||
         'DATA_NASCITA_PADRE'||';'||
         'STATO_CIVILE_PADRE'||';'||
         'CITTAD_PADRE'||';'||
         'CITTAD_EST_PADRE'||';'||
         'COD_FISC_PADRE'||';'||
         'TIPO_RESIDENZA'||';'||
         'CODICE_FAMIGLIA'||';'||
         'CODICE_CONVIVENZA'
  from dual
/
comment on table ISTMP4_INT is 'ISTAT - Dati per Compilazione Modello P.4 - Intestazioni (view)'
/
