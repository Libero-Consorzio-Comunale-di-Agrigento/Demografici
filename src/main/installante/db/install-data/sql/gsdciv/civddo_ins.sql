--liquibase formatted sql
--changeset amonopoli:202303060955_7 runOnChange:true stripComments:false
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       -4,
       'PU',
       'DICHIARAZIONE FIRMATA',
       '',
       '',
       'S',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = -4
                      and b.cod_do    = 'PU'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '01',
       'ATTESTAZIONE DI NASCITA',
       '',
       '',
       'S',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '01'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       'ST',
       'SENTENZA TRIBUNALE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = 'ST'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       5,
       'TS',
       'RICHIESTA PER TRASPORTO SALMA, TUMULAZIONE O CREMAZIONE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 5
                      and b.cod_do    = 'TS'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       'AL',
       'ALTRO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = 'AL'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '03',
       'DICHIARAZIONE DI NASCITA SOSTITUTIVA RESA DA DICHIARANTE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '03'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       'ST',
       'SENTENZA TRIBUNALE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = 'ST'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       'ST',
       'SENTENZA TRIBUNALE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = 'ST'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       5,
       'ST',
       'SENTENZA TRIBUNALE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 5
                      and b.cod_do    = 'ST'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       -4,
       'ST',
       'SENTENZA TRIBUNALE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = -4
                      and b.cod_do    = 'ST'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       'AL',
       'ALTRO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = 'AL'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       'AL',
       'ALTRO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = 'AL'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       5,
       'AL',
       'ALTRO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 5
                      and b.cod_do    = 'AL'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       -4,
       'AL',
       'ALTRO',
       '',
       'S',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = -4
                      and b.cod_do    = 'AL'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       'P4',
       'DICHIARAZIONE FIRMATA',
       '',
       '',
       'S',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = 'P4'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       'AT',
       'ATTO DA FIRMARE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = 'AT'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       'AT',
       'ATTO DA FIRMARE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = 'AT'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       'AT',
       'ATTO DA FIRMARE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = 'AT'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       5,
       'AT',
       'ATTO DA FIRMARE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 5
                      and b.cod_do    = 'AT'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       -4,
       'AT',
       'ATTO DA FIRMARE',
       '',
       'S',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = -4
                      and b.cod_do    = 'AT'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       'CO',
       'COMUNICAZIONE GENERICA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = 'CO'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       'CO',
       'COMUNICAZIONE GENERICA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = 'CO'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       'CO',
       'COMUNICAZIONE GENERICA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = 'CO'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       5,
       'CO',
       'COMUNICAZIONE GENERICA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 5
                      and b.cod_do    = 'CO'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       -4,
       'CO',
       'COMUNICAZIONE GENERICA',
       '',
       'S',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = -4
                      and b.cod_do    = 'CO'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       'EA',
       'ESEGUITA ANNOTAZIONE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = 'EA'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       'EA',
       'ESEGUITA ANNOTAZIONE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = 'EA'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       'EA',
       'ESEGUITA ANNOTAZIONE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = 'EA'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       5,
       'EA',
       'ESEGUITA ANNOTAZIONE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 5
                      and b.cod_do    = 'EA'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       -4,
       'EA',
       'ESEGUITA ANNOTAZIONE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = -4
                      and b.cod_do    = 'EA'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       'RA',
       'RICHIESTA ANNOTAZIONE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = 'RA'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       'RA',
       'RICHIESTA ANNOTAZIONE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = 'RA'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       'RA',
       'RICHIESTA ANNOTAZIONE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = 'RA'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       5,
       'RA',
       'RICHIESTA ANNOTAZIONE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 5
                      and b.cod_do    = 'RA'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       -4,
       'RA',
       'RICHIESTA ANNOTAZIONE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = -4
                      and b.cod_do    = 'RA'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       3,
       'AT',
       'ATTO DA FIRMARE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 3
                      and b.cod_do    = 'AT'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       'AF',
       'ATTO FIRMATO ',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = 'AF'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       'AF',
       'ATTO FIRMATO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = 'AF'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       'AF',
       'ATTO FIRMATO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = 'AF'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       5,
       'AF',
       'ATTO FIRMATO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 5
                      and b.cod_do    = 'AF'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       -4,
       'AF',
       'ATTO FIRMATO',
       '',
       'S',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = -4
                      and b.cod_do    = 'AF'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       3,
       'AF',
       'ATTO FIRMATO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 3
                      and b.cod_do    = 'AF'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '02',
       'CONSTATAZIONE DI AVVENUTO PARTO',
       '',
       '',
       'S',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '02'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '04',
       'CERTIFICATO MEDICO ATTESTANTE CHE IL BAMBINO È NATO MORTO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '04'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '05',
       'CERTIFICATO MEDICO ATTESTANTE CHE IL BAMBINO È NATO VIVO E POI DECEDUTO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '05'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '06',
       'PROCURA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '06'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '07',
       'ATTO NOTARILE CONSENSO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '07'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '08',
       'ATTO DI PRE-RICONOSCIMENTO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '08'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '09',
       'COPIA DELL''ATTO DI RICONOSCIMENTO EFFETTUATO DELL''ALTRO GENITORE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '09'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '10',
       'COPIA DELL''ATTO DI CONSENSO DELL''ALTRO GENITORE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '10'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '11',
       'PROVVEDIMENTO DI AUTORIZZAZIONE DEL GIUDICO PER FIGLIO INCESTUOSO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '11'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '12',
       'CERTIFICATO MEDICO ATTESTANTE LO STATO DI GRAVIDANZA ',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '12'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '13',
       'COPIA INTEGRALE DELL''ATTO DI NASCITA DEL FIGLIO CHE VIENE RICONOSCIUTO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '13'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '14',
       'COPIA DELL''ATTO DI ASSENSO DEL FIGLIO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '14'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '15',
       'SENTENZA DEL TRIBUNALE CHE AUTORIZZA AL RICONOSCIMENTO SENZA IL CONSENSO DELL''ALTRO GENITORE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '15'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '16',
       'COPIA INTEGRALE DELL''ATTO DI NASCITA DEL DICHIARANTE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '16'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '17',
       'COPIA INTEGRALE DELL''ATTO DI NASCITA DELL''ALTRO GENITORE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '17'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '18',
       'ATTO DI RICONOSCIMENTO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '18'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       5,
       '19',
       'DECRETO DEL TRIBUNALE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 5
                      and b.cod_do    = '19'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '20',
       'COPIA DELL''ATTO DI RICONOSCIMENTO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '20'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '21',
       'ATTO CAMBIAMENTO DEL COGNOME DEL GENITORE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '21'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '22',
       'COMUNICAZIONE AL TRIBUNALE DEI MINORENNI',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '22'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '23',
       'ATTESTAZIONE DI AVVENUTO PARTO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '23'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '25',
       'SENTENZA STRANIERA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '25'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       5,
       '26',
       'NOTA DI TRASMISSIONE DA PARTE DELL''AUTORITA'' CONSOLARE O DIPLOMATICA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 5
                      and b.cod_do    = '26'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '27',
       'ATTO ESTERO DI NASCITA ORIGINALE O COPIA AUTENTICA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '27'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       5,
       '28',
       'RICHIESTA DI TRASCRIZIONE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 5
                      and b.cod_do    = '28'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '29',
       'COPIA INTEGRALE DELL''ATTO DI NASCITA DELL''INTERESSATO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '29'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '30',
       'DECRETO PREFETTIZIO / SENTENZA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '30'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '31',
       'ATTO DI RICONOSCIMENTO MATERNO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '31'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       5,
       '32',
       'CERTIFICATO NECROSCOPICO',
       '',
       '',
       'S',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 5
                      and b.cod_do    = '32'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       5,
       '33',
       'ATTO DI MORTE (IN ORIGINALE)',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 5
                      and b.cod_do    = '33'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       5,
       '34',
       'TRADUZIONE ATTO DI MORTE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 5
                      and b.cod_do    = '34'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       5,
       '35',
       'AVVISO DI MORTE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 5
                      and b.cod_do    = '35'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '36',
       'NULLA OSTA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '36'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       5,
       '37',
       'CERTIFICAZIONE SOSTITUTIVA DELLA DOCUMENTAZIONE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 5
                      and b.cod_do    = '37'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '38',
       'TRADUZIONE SENTENZA STRANIERA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '38'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       5,
       '39',
       'DICHIARAZIONE DI CONFORMITÀ',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 5
                      and b.cod_do    = '39'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       5,
       '40',
       'SENTENZA DI DICHIARAZIONE DI MORTE PRESUNTA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 5
                      and b.cod_do    = '40'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       5,
       '41',
       'SENTENZA DI ACCERTAMENTO DI MORTE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 5
                      and b.cod_do    = '41'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '42',
       'DECRETO DEL TRIBUNALE PER AUTORIZZAZIONE OMESSE PUBBLICAZIONI',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '42'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '43',
       'RIGETTO DEL TRIBUNALE ALL''OPPOSIZIONE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '43'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '44',
       'ORDINANZA CHE DICHIARA ESTINTO IL GIUDIZIO DI OPPOSIZIONE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '44'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '45',
       'DECRETO DEL TRIBUNALE PER AUTORIZZAZIONE NONOSTANTE IMPEDIMENTO DI ETÀ',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '45'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '46',
       'DECRETO DEL TRIBUNALE PER AUTORIZZAZIONE NONOSTANTE IMPEDIMENTO DI AFFINITÀ O AFFILIAZIONE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '46'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '47',
       'DECRETO DEL TRIBUNALE PER AUTORIZZAZIONE NONOSTANTE IMPEDIMENTO DI DIVIETO TEMPORANEO DI NUOVE NOZZE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '47'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '48',
       'ATTO DI MATRIMONIO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '48'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '49',
       'CERTIFICATO DI RESIDENZA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '49'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '50',
       'ATTO DI MATRIMONIO STRANIERO, TRADOTTO E LEGALIZZATO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '50'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '51',
       'CERTIFICAZIONE COME DA ARTICOLO 5 DEL DECRETO LEGGE N. 132/2014 CONVERTITO CON LEGGE 10.11.2014 N.162',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '51'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '52',
       'CERTIFICAZIONE ACQUISITA DALL''AVVOCATO DELLO SPOSO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '52'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '53',
       'CERTIFICAZIONE ACQUISITA DALL''AVVOCATO DELLO SPOSA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '53'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       5,
       '54',
       'SENTENZA DELLA CORTE D''APPELLO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 5
                      and b.cod_do    = '54'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '55',
       'CERTIFICATO DI CUI ALL''ART.39 DEL REGOLAMENTO (CE) N. 2201/2003',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '55'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       -4,
       '56',
       'CERTIFICATO DELLA RICHIESTA DI COSTITUZIONE 1',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = -4
                      and b.cod_do    = '56'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       -4,
       '57',
       'CERTIFICATO DELLA RICHIESTA DI COSTITUZIONE 2',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = -4
                      and b.cod_do    = '57'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       -4,
       '58',
       'ATTO DI COSTITUZIONE DI UNIONE CIVILE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = -4
                      and b.cod_do    = '58'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       -4,
       '59',
       'TRADUZIONE DELL''ATTO DI COSTITUZIONE DI UNIONE CIVILE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = -4
                      and b.cod_do    = '59'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       -4,
       '60',
       'ESTRATTO DELL''ATTO DI UNIONE CIVILE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = -4
                      and b.cod_do    = '60'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       5,
       '61',
       'LETTERA RACCOMANDATA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 5
                      and b.cod_do    = '61'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       -4,
       '62',
       'ATTO DI MANIFESTAZIONE DI VOLONTÀ DI SCIOGLIERE L''UNIONE CIVILE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = -4
                      and b.cod_do    = '62'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '63',
       'ESITO ACCERTAMENTO DI CITTADINANZA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '63'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '64',
       'ATTESTAZIONE DI ACQUISIZIONE DI CITTADINANZA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '64'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '65',
       'RICEVUTA PAGAMENTO CONTRIBUTO DI 250,00',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '65'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '66',
       'DOCUMENTAZIONE COMPROVANTE LA PRESTAZIONE DEL SERVIZIO MILITARE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '66'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '67',
       'DOCUMENTAZIONE RELATIVA ALL''ASSUNZIONE PUBBLICO IMPIEGO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '67'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '68',
       'DOCUMENTAZIONE ATTESTANTE LA RESIDENZA IN ITALIA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '68'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '69',
       'CERTIFICAZIONE DI CITTADINANZA DEL GENITORE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '69'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '70',
       'COPIA INTEGRALE DELL''ATTO DI CITTADINANZA DELL''INTERESSATO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '70'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '71',
       'ATTESTAZIONE DI PERDITA DI CITTADINANZA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '71'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '72',
       'DOCUMENTAZIONE CHE COMPROVI POSSESSO DI ULTERIORE CITTADINANZA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '72'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '73',
       'ESITO ACCERTAMENTO PERDITA DI CITTADINANZA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '73'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '74',
       'DECRETO DI NATURALIZZAZIONE STRANIERO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '74'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '75',
       'DICHIARAZIONE DI RIACQUISTO DELLA CITTADINANZA ITALIANA RESA AL CONSOLATO ITALIANO ALL''ESTERO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '75'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '76',
       'DOCUMENTAZIONE ATTESTATENTE L''ABBANDONO DEL PUBBLICO IMPIEGO O DEL SERVIZIO MILITARE ASSUNTO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '76'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       5,
       '77',
       'TITOLO DI SOGGIORNO PER CITTADINI EXTRAUE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 5
                      and b.cod_do    = '77'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       5,
       '78',
       'DECRETO NOTIFICATO CON MARCA DA BOLLO DA € 16',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 5
                      and b.cod_do    = '78'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '79',
       'COMUNICAZIONE PREFETTIZIA DI CONCESSIONE CITTADINANZA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '79'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       5,
       '80',
       'DOCUMENTO D''IDENTITÀ',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 5
                      and b.cod_do    = '80'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '81',
       'DOCUMENTAZIONE COMPROVANTE L''INCAPACITÀ DI AGIRE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '81'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '82',
       'DOCUMENTO DI DELEGA PER IL RAPPRESENTANTE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '82'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '83',
       'COPIA DEL DECRETO DA TRASCRIVERE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '83'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       5,
       '99',
       'ALLEGATO PER CASO D''USO LIBERO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 5
                      and b.cod_do    = '99'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       -4,
       '99',
       'ALLEGATO PER CASO D''USO LIBERO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = -4
                      and b.cod_do    = '99'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '99',
       'ALLEGATO PER CASO D''USO LIBERO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '99'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '99',
       'ALLEGATO PER CASO D''USO LIBERO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '99'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '99',
       'ALLEGATO PER CASO D''USO LIBERO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '99'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '55',
       'CERTIFICATO DI CUI ALL''ART.39 DEL REGOLAMENTO (CE) N. 2201/2003',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '55'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       -4,
       '37',
       'CERTIFICAZIONE SOSTITUTIVA DELLA DOCUMENTAZIONE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = -4
                      and b.cod_do    = '37'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '37',
       'CERTIFICAZIONE SOSTITUTIVA DELLA DOCUMENTAZIONE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '37'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '37',
       'CERTIFICAZIONE SOSTITUTIVA DELLA DOCUMENTAZIONE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '37'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '37',
       'CERTIFICAZIONE SOSTITUTIVA DELLA DOCUMENTAZIONE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '37'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       -4,
       '19',
       'DECRETO DEL TRIBUNALE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = -4
                      and b.cod_do    = '19'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '19',
       'DECRETO DEL TRIBUNALE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '19'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '19',
       'DECRETO DEL TRIBUNALE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '19'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '19',
       'DECRETO DEL TRIBUNALE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '19'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       -4,
       '78',
       'DECRETO NOTIFICATO CON MARCA DA BOLLO DA € 16',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = -4
                      and b.cod_do    = '78'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '78',
       'DECRETO NOTIFICATO CON MARCA DA BOLLO DA € 16',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '78'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '78',
       'DECRETO NOTIFICATO CON MARCA DA BOLLO DA € 16',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '78'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '78',
       'DECRETO NOTIFICATO CON MARCA DA BOLLO DA € 16',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '78'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       -4,
       '39',
       'DICHIARAZIONE DI CONFORMITÀ',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = -4
                      and b.cod_do    = '39'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '39',
       'DICHIARAZIONE DI CONFORMITÀ',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '39'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '39',
       'DICHIARAZIONE DI CONFORMITÀ',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '39'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '39',
       'DICHIARAZIONE DI CONFORMITÀ',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '39'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       -4,
       '80',
       'DOCUMENTO D''IDENTITÀ',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = -4
                      and b.cod_do    = '80'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '80',
       'DOCUMENTO D''IDENTITÀ',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '80'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '80',
       'DOCUMENTO D''IDENTITÀ',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '80'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '80',
       'DOCUMENTO D''IDENTITÀ',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '80'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       -4,
       '61',
       'LETTERA RACCOMANDATA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = -4
                      and b.cod_do    = '61'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '61',
       'LETTERA RACCOMANDATA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '61'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '61',
       'LETTERA RACCOMANDATA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '61'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '61',
       'LETTERA RACCOMANDATA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '61'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       -4,
       '26',
       'NOTA DI TRASMISSIONE DA PARTE DELL''AUTORITA'' CONSOLARE O DIPLOMATICA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = -4
                      and b.cod_do    = '26'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '26',
       'NOTA DI TRASMISSIONE DA PARTE DELL''AUTORITA'' CONSOLARE O DIPLOMATICA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '26'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '26',
       'NOTA DI TRASMISSIONE DA PARTE DELL''AUTORITA'' CONSOLARE O DIPLOMATICA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '26'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '26',
       'NOTA DI TRASMISSIONE DA PARTE DELL''AUTORITA'' CONSOLARE O DIPLOMATICA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '26'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       -4,
       '36',
       'NULLA OSTA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = -4
                      and b.cod_do    = '36'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       -4,
       '28',
       'RICHIESTA DI TRASCRIZIONE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = -4
                      and b.cod_do    = '28'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '28',
       'RICHIESTA DI TRASCRIZIONE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '28'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '28',
       'RICHIESTA DI TRASCRIZIONE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '28'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '28',
       'RICHIESTA DI TRASCRIZIONE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '28'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       -4,
       '77',
       'TITOLO DI SOGGIORNO PER CITTADINI EXTRAUE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = -4
                      and b.cod_do    = '77'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '77',
       'TITOLO DI SOGGIORNO PER CITTADINI EXTRAUE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '77'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '77',
       'TITOLO DI SOGGIORNO PER CITTADINI EXTRAUE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '77'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '77',
       'TITOLO DI SOGGIORNO PER CITTADINI EXTRAUE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '77'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       0,
       'EA',
       'ESEGUITA ANNOTAZIONE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 0
                      and b.cod_do    = 'EA'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       0,
       'RA',
       'RICHIESTA ANNOTAZIONE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 0
                      and b.cod_do    = 'RA'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       0,
       'CO',
       'COMUNICAZIONE GENERICA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 0
                      and b.cod_do    = 'CO'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       3,
       'CO',
       'COMUNICAZIONE GENERICA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 3
                      and b.cod_do    = 'CO'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       3,
       'AL',
       'ALTRO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 3
                      and b.cod_do    = 'AL'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       'CI',
       'COPIA INTEGRALE ATTO',
       '',
       '',
       'S',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = 'CI'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       'CI',
       'COPIA INTEGRALE ATTO',
       '',
       '',
       'S',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = 'CI'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       'CI',
       'COPIA INTEGRALE ATTO',
       '',
       '',
       'S',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = 'CI'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       -4,
       'CI',
       'COPIA INTEGRALE ATTO',
       '',
       '',
       'S',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = -4
                      and b.cod_do    = 'CI'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       5,
       'CI',
       'COPIA INTEGRALE ATTO',
       '',
       '',
       'S',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 5
                      and b.cod_do    = 'CI'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       'P2',
       'DICHIARAZIONE FIRMATA',
       '',
       '',
       'S',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = 'P2'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       'P1',
       'DICHIARAZIONE FIRMATA',
       '',
       '',
       'S',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = 'P1'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       5,
       'P5',
       'DICHIARAZIONE FIRMATA',
       '',
       '',
       'S',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 5
                      and b.cod_do    = 'P5'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       5,
       '36',
       'NULLA OSTA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 5
                      and b.cod_do    = '36'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '49',
       'CERTIFICATO DI RESIDENZA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '49'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '65',
       'RICEVUTA PAGAMENTO CONTRIBUTO DI 250,00',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '65'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '20',
       'COPIA DELL''ATTO DI RICONOSCIMENTO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '20'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '06',
       'PROCURA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '06'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '91',
       'CERTIFICATO DI STATO DI FAMIGLIA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '91'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '92',
       'CERTIFICATO STESSO DI ACQUISTO/RIACQUISTO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '92'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       'AO',
       'COPIA ATTO ORIGINALE (PER TRASCRIZIONE)',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = 'AO'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       'AO',
       'COPIA ATTO ORIGINALE (PER TRASCRIZIONE)',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = 'AO'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       -4,
       'AO',
       'COPIA ATTO ORIGINALE (PER TRASCRIZIONE)',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = -4
                      and b.cod_do    = 'AO'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       5,
       'AO',
       'COPIA ATTO ORIGINALE (PER TRASCRIZIONE)',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 5
                      and b.cod_do    = 'AO'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       'EP',
       'CERTIFICATO DI ESEGUITA PUBBLICAZIONE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = 'EP'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '100',
       'ATTO DI DICHIARAZIONE DI NASCITA REDATTO DALLA DIREZIONE SANITARIA',
       '',
       '',
       'S',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '100'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '103',
       'NULLAOSTA DI CUI ALL''ART. 116 O DOCUMENTAZIONE EQUIVALENTE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '103'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '90',
       'COPIA ATTO DI MATRIMONIO TRASCRITTO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '90'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '84',
       'COPIA INTEGRALE ATTO DI NASCITA DEGLI SPOSI',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '84'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '85',
       'AUTOCERTIFICAZIONE CUMULATIVA STATO LIBERO, RESIDENZA, CITTADINANZA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '85'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '87',
       'ATTO DI PUBBLICAZIONE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '87'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '88',
       'RICHIESTA RILASCIO ATTO DI DELEGA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '88'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '89',
       'ATTO DI DELEGAZIONE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '89'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '93',
       'AUTORIZZAZIONE DEL TRIBUNALE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '93'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '94',
       'COPIA INTEGRALE DELL''ATTO DI NASCITA INTESTATARIO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '94'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '96',
       'ATTO DI RICONOSCIMENTO PATERNO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '96'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '97',
       'ISTANZA VERBALE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '97'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '98',
       'ATTO SCRITTO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '98'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       5,
       '101',
       'PROCESSO VERBALE DI DICHIARAZIONE DI MORTE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 5
                      and b.cod_do    = '101'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '104',
       'VERBALE DI PUBBLICAZIONE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '104'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '97',
       'ISTANZA VERBALE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '97'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '98',
       'ATTO SCRITTO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '98'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '97',
       'ISTANZA VERBALE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '97'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '98',
       'ATTO SCRITTO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '98'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       -4,
       '97',
       'ISTANZA VERBALE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = -4
                      and b.cod_do    = '97'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       -4,
       '98',
       'ATTO SCRITTO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = -4
                      and b.cod_do    = '98'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       5,
       '97',
       'ISTANZA VERBALE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 5
                      and b.cod_do    = '97'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       5,
       '98',
       'ATTO SCRITTO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 5
                      and b.cod_do    = '98'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '13',
       'COPIA INTEGRALE DELL''ATTO DI NASCITA DEL FIGLIO CHE VIENE RICONOSCIUTO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '13'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       -4,
       '25',
       'SENTENZA STRANIERA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = -4
                      and b.cod_do    = '25'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '25',
       'SENTENZA STRANIERA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '25'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '25',
       'SENTENZA STRANIERA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '25'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       5,
       '25',
       'SENTENZA STRANIERA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 5
                      and b.cod_do    = '25'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '29',
       'COPIA INTEGRALE DELL''ATTO DI NASCITA DELL''INTERESSATO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '29'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '27',
       'ATTO ESTERO DI NASCITA ORIGINALE O COPIA AUTENTICA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '27'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '82',
       'DOCUMENTO DI DELEGA PER IL RAPPRESENTANTE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '82'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '54',
       'SENTENZA DELLA CORTE D''APPELLO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '54'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '48',
       'ATTO DI MATRIMONIO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '48'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       -4,
       '43',
       'RIGETTO DEL TRIBUNALE ALL''OPPOSIZIONE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = -4
                      and b.cod_do    = '43'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       -4,
       '44',
       'ORDINANZA CHE DICHIARA ESTINTO IL GIUDIZIO DI OPPOSIZIONE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = -4
                      and b.cod_do    = '44'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       -4,
       '45',
       'DECRETO DEL TRIBUNALE PER AUTORIZZAZIONE NONOSTANTE IMPEDIMENTO DI ETÀ',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = -4
                      and b.cod_do    = '45'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       -4,
       '46',
       'DECRETO DEL TRIBUNALE PER AUTORIZZAZIONE NONOSTANTE IMPEDIMENTO DI AFFINITÀ O AFFILIAZIONE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = -4
                      and b.cod_do    = '46'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       5,
       '38',
       'TRADUZIONE SENTENZA STRANIERA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 5
                      and b.cod_do    = '38'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       -4,
       '38',
       'TRADUZIONE SENTENZA STRANIERA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = -4
                      and b.cod_do    = '38'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       1,
       '38',
       'TRADUZIONE SENTENZA STRANIERA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 1
                      and b.cod_do    = '38'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '38',
       'TRADUZIONE SENTENZA STRANIERA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '38'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '30',
       'DECRETO PREFETTIZIO / SENTENZA',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '30'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       2,
       '105',
       'PROCESSO VERBALE (REDATTO IN LUOGO PARTICOLARE DA AUTORITA'' INCARICATA)',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 2
                      and b.cod_do    = '105'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '106',
       'DOCUMENTI UTILIZZATI PER LA PUBBLICAZIONE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '106'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '107',
       'CERTIFICATO MEDICO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '107'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       -4,
       '107',
       'CERTIFICATO MEDICO',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = -4
                      and b.cod_do    = '107'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '108',
       'NEGOZIAZIONE ASSISTITA E NULLA OSTA O AUTORIZZAZIONE',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '108'
                  )
/
insert into civddo
       (ID, TIPO_ATTO, COD_DO, DESCRIZIONE,
        SEQUENZA, FLAG_PVU, FLAG_RICORRENTE,
        CODICE_ANSC, VERSION)
select to_number(null),
       4,
       '109',
       'CERTIFICATO DI CUI ALL''ART.36 DEL REGOLAMENTO (UE) N. 2019/1111',
       '',
       '',
       '',
        '',
       0
  from dual
 where not exists (select 1 from civddo b
                    where b.tipo_atto = 4
                      and b.cod_do    = '109'
                  )
/
