--liquibase formatted sql
--changeset amonopoli:202503211242_2 runOnChange:true stripComments:false
create or replace view ISTDAP_int
	(archivio, punto, des_punto)
AS
-- 1. Iscritti - da Altri Comuni
select 'AP4', 1, 'Iscritti - da Altri Comuni'
  from dual
UNION
-- 2. Iscritti - dall'Estero
select 'AP4', 2, 'Iscritti - dall''Estero'
  from dual
UNION
-- 3. Iscritti - per Ricomparsa
select 'AP4', 3, 'Iscritti - per Ricomparsa'
  from dual
UNION
-- 4. Iscritti - per Altri Motivi
select 'AP4', 4, 'Iscritti - per Altri Motivi'
  from dual
UNION
-- 1. Cancellati - per l'Estero
select 'CP4', 1, 'Cancellati - per l''Estero'
  from dual
UNION
-- 2. Cancellati - per Irreperibilita al Censimento
select 'CP4', 2, 'Cancellati - per Irreperibilita al Censimento'
  from dual
UNION
-- 3. Cancellati - per Irreperibilita Accertata
select 'CP4', 3, 'Cancellati - per Irreperibilita Accertata'
  from dual
UNION
-- 4. Cancellati - per Altri Motivi
select 'CP4', 4, 'Cancellati - per Altri Motivi'
  from dual
UNION
-- 5. Iscrizioni - per Ripristino Anagrafico
select 'CP4', 5, 'Iscrizioni - per Ripristino Anagrafico'
  from dual
/
comment on table ISTDAP_INT is 'ISTAT - Dati per Compilazione Modello APR/4 - Intestazioni (view)'
/
