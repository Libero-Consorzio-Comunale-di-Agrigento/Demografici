--liquibase formatted sql
--changeset amonopoli:202606230935 runOnChange:true stripComments:false
INSERT INTO ANADTS (COD_TS, DESCRIZIONE, GRUPPO, TERMINALISTA, FLAG_DISMESSO) 
select 'AN', 'ANALFABETA', 'AN', 'ADS', 'S'
  from dual
 where not exists (select 1 from anadts b
                    where b.cod_ts = 'AN')
/
INSERT INTO ANADTS (COD_TS, DESCRIZIONE, GRUPPO, TERMINALISTA, FLAG_DISMESSO) 
select 'TE', 'TERZA ELEMENTARE', 'TE', 'ADS', 'S'
  from dual
 where not exists (select 1 from anadts b
                    where b.cod_ts = 'TE')
/
INSERT INTO ANADTS (COD_TS, DESCRIZIONE, GRUPPO, TERMINALISTA, FLAG_DISMESSO) 
select 'LE', 'LICENZA ELEMENTARE', 'LE', 'ADS', 'S'
  from dual
 where not exists (select 1 from anadts b
                    where b.cod_ts = 'LE')
/
INSERT INTO ANADTS (COD_TS, DESCRIZIONE, GRUPPO, TERMINALISTA, FLAG_DISMESSO) 
select 'LM', 'LICENZA MEDIA', 'LM', 'ADS', 'S'
  from dual
 where not exists (select 1 from anadts b
                    where b.cod_ts = 'LM')
/
INSERT INTO ANADTS (COD_TS, DESCRIZIONE, GRUPPO, TERMINALISTA, FLAG_DISMESSO) 
select 'DP', 'DIPLOMA', 'DP', 'ADS', 'S'
  from dual
 where not exists (select 1 from anadts b
                    where b.cod_ts = 'DP')
/
INSERT INTO ANADTS (COD_TS, DESCRIZIONE, GRUPPO, TERMINALISTA, FLAG_DISMESSO) 
select  'LR', 'LAUREA', 'LR', 'ADS', 'S'
  from dual
 where not exists (select 1 from anadts b
                    where b.cod_ts = 'LR')
/
