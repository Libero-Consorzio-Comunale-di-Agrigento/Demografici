--liquibase formatted sql
--changeset amonopoli:202303231755_5 runOnChange:true stripComments:false
create or replace view civfaa_var
	(tipo_atto, tipo_formula, variabile, sequenza)
AS
-- NAS
select 2, 'CIA', '<'||v.campo||'>', rownum 
  from (select 'COMUNE' campo from dual UNION
        select 'DATA' campo from dual UNION
        select 'PROVINCIA' campo from dual UNION
        select 'ANNO' campo from dual UNION
        select 'ATTO' campo from dual UNION
        select 'DES_TIPO_ATTO' campo from dual UNION
        select 'PARTE_SERIE' campo from dual UNION
        select 'TERMINALISTA' campo from dual UNION
        select 'UFFICIO' campo from dual UNION
        select 'FIRME_CHIUSURA' campo from dual UNION
        select 'COMUNE_FIRMA' campo from dual) v
UNION
-- MAT
select 4, 'CIA', '<'||v.campo||'>', rownum
  from (select 'COMUNE' campo from dual UNION
        select 'DATA' campo from dual UNION
        select 'PROVINCIA' campo from dual UNION
        select 'ANNO' campo from dual UNION
        select 'ATTO' campo from dual UNION
        select 'DES_TIPO_ATTO' campo from dual UNION
        select 'PARTE_SERIE' campo from dual UNION
        select 'TERMINALISTA' campo from dual UNION
        select 'UFFICIO' campo from dual UNION
        select 'FIRME_CHIUSURA' campo from dual UNION
        select 'COMUNE_FIRMA' campo from dual) v
UNION
-- UCI
select -4, 'CIA', '<'||v.campo||'>', rownum
  from (select 'COMUNE' campo from dual UNION
        select 'DATA' campo from dual UNION
        select 'PROVINCIA' campo from dual UNION
        select 'ANNO' campo from dual UNION
        select 'ATTO' campo from dual UNION
        select 'DES_TIPO_ATTO' campo from dual UNION
        select 'PARTE_SERIE' campo from dual UNION
        select 'TERMINALISTA' campo from dual UNION
        select 'UFFICIO' campo from dual UNION
        select 'FIRME_CHIUSURA' campo from dual UNION
        select 'COMUNE_FIRMA' campo from dual) v
UNION
-- MOR
select 5, 'CIA', '<'||v.campo||'>', rownum
  from (select 'COMUNE' campo from dual UNION
        select 'DATA' campo from dual UNION
        select 'PROVINCIA' campo from dual UNION
        select 'ANNO' campo from dual UNION
        select 'ATTO' campo from dual UNION
        select 'DES_TIPO_ATTO' campo from dual UNION
        select 'PARTE_SERIE' campo from dual UNION
        select 'TERMINALISTA' campo from dual UNION
        select 'UFFICIO' campo from dual UNION
        select 'FIRME_CHIUSURA' campo from dual UNION
        select 'COMUNE_FIRMA' campo from dual) v
UNION
-- CIT
select 1, 'CIA', '<'||v.campo||'>', rownum
  from (select 'COMUNE' campo from dual UNION
        select 'DATA' campo from dual UNION
        select 'PROVINCIA' campo from dual UNION
        select 'ANNO' campo from dual UNION
        select 'ATTO' campo from dual UNION
        select 'DES_TIPO_ATTO' campo from dual UNION
        select 'TERMINALISTA' campo from dual UNION
        select 'UFFICIO' campo from dual UNION
        select 'FIRME_CHIUSURA' campo from dual UNION
        select 'COMUNE_FIRMA' campo from dual) v
/
comment on table civfaa_var is 'Stato Civile - Variabili per Formule Aggiuntive Atto (view)'
/
