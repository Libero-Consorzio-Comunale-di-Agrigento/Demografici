--liquibase formatted sql
--changeset amonopoli:202501291655 runOnChange:true stripComments:false
create or replace view anpe02 
  (CODICE, DESCRIZIONE, TIPO_LISTA_ADS, MOTIVO_ADS, DES_MOTIVO_ADS)
AS
/*
motivoCancellazioneEle
1 - Trasferimento residenza
2 - Irreperibilita
3 - Morte
4 - Motivi vari
5 - Canc. lista agg. UE comunali
6 - Canc. lista agg. UE parlamento europeo
7 - Canc. lista agg. comunali regionali
8 - Annullamento Lista generale
--
16/11/2023 - novità 
9 - Perdita del diritto elettorale e trasferimento residenza 
--
*/
select decode(cod_mo, 
         15, 1,
         11, 2, 
         12, 3,
             4),
       decode(cod_mo, 
         15, 'Trasferimento residenza',
         11, 'Irreperibilita', 
         12, 'Morte',
             'Motivi vari'),
       '',
       dmo.cod_mo,
       dmo.descrizione
  from eledmo dmo
 where dmo.tipo_movimento = 'C'
UNION
select decode(dtl.cod_tl,
         'C', 5,
         'E', 6,
              7),
       decode(dtl.cod_tl,
         'C', 'Canc. lista agg. UE comunali',
         'E', 'Canc. lista agg. UE parlamento europeo',
              'Canc. lista agg. comunali regionali'),
       dtl.cod_tl,
       dmo.cod_mo,
       dmo.descrizione
  from eledtl dtl, eledmo dmo
 where dmo.tipo_movimento ='C'
   and dtl.cod_tl         in ('C','E','B','T','V')
UNION
select 8, 'Annullamento lista generale', '', to_number(null), ''
  from dual
UNION
select 9, 'Perdita del diritto elettorale e trasferimento residenza', '', to_number(null), ''
  from dual
/
comment on table anpe02 is 'ANEL - Motivi di Cancellazione Elettorale'
/
