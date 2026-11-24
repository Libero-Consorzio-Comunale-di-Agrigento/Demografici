--liquibase formatted sql
--changeset amonopoli:202602031425_0 runOnChange:true stripComments:false
create or replace view cerdtd_v_pagamenti
AS
select codice, descrizione, rownum ID from (select distinct cod_diritto codice, descrizione descrizione from cerdtd dtd) v
union
select 41, 'Diversi 1 '||rtrim(f_valore_inp('CEXT_DIV1',1,100,'X','')), 100+rownum ID from arcinp where parametro = 'CEXT_DIV1'
union
select 42, 'Diversi 2 '||rtrim(f_valore_inp('CEXT_DIV2',1,100,'X','')), 200+rownum ID from arcinp where parametro = 'CEXT_DIV2'
/
comment on table cerdtd_v_pagamenti is 'Certificazione - Dizionario Tariffe e Diritti per Statistica Certificati Emessi (view)'
/
