--liquibase formatted sql
--changeset amonopoli:202402201625 runOnChange:true stripComments:false
create or replace view civfir_v_DIZ
       (cod_archivio, des_archivio, codice, descrizione)
as
-- 'RUO', 'Ruoli Firmatari'
select 'RUO', 'Ruolo Firmatario', 'AS', 'Ascendente' from dual UNION
select 'RUO', 'Ruolo Firmatario', 'IN', 'Interessato' from dual UNION
select 'RUO', 'Ruolo Firmatario', 'MD', 'Madre' from dual UNION
select 'RUO', 'Ruolo Firmatario', 'PD', 'Padre' from dual UNION
select 'RUO', 'Ruolo Firmatario', 'DE', 'Delegato' from dual UNION
select 'RUO', 'Ruolo Firmatario', 'IT', 'Interprete' from dual UNION
select 'RUO', 'Ruolo Firmatario', 'AD', 'Altro Dichiarante' from dual UNION
select 'RUO', 'Ruolo Firmatario', 'SO', 'Sposo' from dual UNION
select 'RUO', 'Ruolo Firmatario', 'SA', 'Sposa' from dual UNION
select 'RUO', 'Ruolo Firmatario', 'OF', 'Officiante' from dual UNION
select 'RUO', 'Ruolo Firmatario', 'SC', 'Segretario Comunale' from dual UNION
select 'RUO', 'Ruolo Firmatario', 'UF', 'Ufficiale Stato Civile' from dual UNION
select 'RUO', 'Ruolo Firmatario', 'T1', 'Testimone 1' from dual UNION
select 'RUO', 'Ruolo Firmatario', 'T2', 'Testimone 2' from dual UNION
select 'RUO', 'Ruolo Firmatario', 'T3', 'Testimone 3' from dual UNION
select 'RUO', 'Ruolo Firmatario', 'T4', 'Testimone 4' from dual UNION
select 'RUO', 'Ruolo Firmatario', 'AO', 'Avvocato Sposo' from dual UNION
select 'RUO', 'Ruolo Firmatario', 'AA', 'Avvocato Sposa' from dual UNION
select 'RUO', 'Ruolo Firmatario', 'C1', 'Contraente 1' from dual UNION
select 'RUO', 'Ruolo Firmatario', 'C2', 'Contraente 2' from dual UNION
select 'RUO', 'Ruolo Firmatario', 'A1', 'Avvocato Contraente 1' from dual UNION
select 'RUO', 'Ruolo Firmatario', 'A2', 'Avvocato Contraente 2' from dual UNION
select 'RUO', 'Ruolo Firmatario', 'CO', 'Comparente' from dual UNION
-- 'TFI', 'Tipi Firma'
select 'TFI', 'Tipi Firma', 'CA', 'Cartacea' from dual UNION
select 'TFI', 'Tipi Firma', 'EL', 'Elettronica' from dual 
/
comment on table civfir_v_DIZ is 'Stato Civile - Firmatari Atto - Dizionario'
/
 
