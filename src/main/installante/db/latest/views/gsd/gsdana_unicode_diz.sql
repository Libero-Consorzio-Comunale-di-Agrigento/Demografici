--liquibase formatted sql
--changeset amonopoli:202510071540_1 runOnChange:true stripComments:false
create or replace view gsdana_unicode_diz
	(codice, descrizione, modulo_rif, id)
AS
select 'COGNOME_NOME'   , 'Cognome e Nome Soggetto'            , 'ANA', 101 from dual UNION
--select 'COGNOME_NOME_CV', 'Cognome e Nome Convivente di Fatto' , 'ANA', 102 from dual UNION
select 'COGNOME_NOME_1' , 'Cognome e Nome Intestatario (1)'    , 'CIV', 201 from dual UNION
select 'COGNOME_NOME_2' , 'Cognome e Nome Intestatario (2)'    , 'CIV', 202 from dual UNION
--select 'COGNOME_NOME_T1', 'Cognome e Nome Testimone (1)'       , 'CIV', 203 from dual UNION
--select 'COGNOME_NOME_T2', 'Cognome e Nome Testimone (2)'       , 'CIV', 204 from dual UNION
--select 'COGNOME_NOME_T3', 'Cognome e Nome Testimone (3)'       , 'CIV', 205 from dual UNION
--select 'COGNOME_NOME_T4', 'Cognome e Nome Testimone (4)'       , 'CIV', 206 from dual UNION
--select 'COGNOME_NOME_AV1', 'Cognome e Nome Avvocato (1)'       , 'CIV', 207 from dual UNION
--select 'COGNOME_NOME_AV2', 'Cognome e Nome Avvocato (2)'       , 'CIV', 208 from dual UNION
select 'COGNOME_NOME_CN', 'Cognome e Nome Coniuge / Contraente', 'GSD', 901 from dual UNION
select 'COGNOME_NOME_PD', 'Cognome e Nome Padre'               , 'GSD', 902 from dual UNION
select 'COGNOME_NOME_MD', 'Cognome e Nome Madre'               , 'GSD', 903 from dual
/
comment on table gsdana_unicode_diz  is 'Servizi Demografici - Gestione Caratteri Unicode - Dizionario CAMPO_RIF (view)'
/
