--liquibase formatted sql
--changeset amonopoli:202305191005_2 runOnChange:true stripComments:false
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '1',
       'Attestazione di nascita',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '1'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '1'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '2',
       'Constatazione di avvenuto parto',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '2'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '2'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '3',
       'Dichiarazione di nascita sostitutiva resa da dichiarante',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '3'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '3'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '4',
       'Certificato medico attestante che il bambino e'' nato morto',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '4'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '4'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '5',
       'Certificato medico attestante che il bambino e'' nato vivo e poi deceduto',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '5'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '5'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '6',
       'Procura',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '6'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '6'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '7',
       'Atto notarile consenso',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '7'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '7'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '8',
       'Atto di pre-riconoscimento',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '8'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '8'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '9',
       'Copia dell''atto di riconoscimento effettuato dell''altro genitore',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '9'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '9'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '10',
       'Copia dell''atto di consenso dell''altro genitore',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '10'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '10'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '11',
       'Provvedimento di autorizzazione del giudice per figlio incestuoso',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '11'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '11'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '12',
       'Certificato medico attestante lo stato di gravidanza',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '12'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '12'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '13',
       'Copia integrale dell''atto di nascita del figlio che viene riconosciuto',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '13'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '13'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '14',
       'Copia dell''atto di assenso del figlio',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '14'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '14'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '15',
       'Sentenza del Tribunale che autorizza al riconoscimento senza il consenso dell''altro genitore',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '15'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '15'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '16',
       'Copia integrale dell''atto di nascita del dichiarante',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '16'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '16'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '17',
       'Copia integrale dell''atto di nascita dell''altro genitore',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '17'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '17'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '18',
       'Atto di riconoscimento',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '18'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '18'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '19',
       'Decreto del Tribunale',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '19'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '19'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '20',
       'Copia dell''atto di riconoscimento',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '20'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '20'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '21',
       'Atto cambiamento del cognome del genitore',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '21'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '21'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '22',
       'Comunicazione al Tribunale dei minorenni',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '22'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '22'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '23',
       'Attestazione di avvenuto parto',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '23'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '23'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '25',
       'Sentenza straniera',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '25'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '25'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '26',
       'Nota di trasmissione da parte dell''autorita'' consolare o diplomatica',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '26'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '26'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '27',
       'Atto estero di nascita originale o copia autentica',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '27'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '27'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '28',
       'Richiesta di trascrizione',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '28'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '28'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '29',
       'Copia integrale dell''atto di nascita dell''interessato',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '29'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '29'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '30',
       'Decreto Prefettizio / Sentenza',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '30'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '30'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '31',
       'Atto di riconoscimento materno',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '31'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '31'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '32',
       'Certificato necroscopico',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '32'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '32'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '33',
       'Atto di morte (in originale)',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '33'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '33'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '34',
       'Traduzione atto di morte',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '34'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '34'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '35',
       'Avviso di morte',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '35'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '35'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '36',
       'Nulla osta',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '36'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '36'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '37',
       'Certificazione sostitutiva della documentazione',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '37'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '37'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '38',
       'Traduzione sentenza straniera',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '38'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '38'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '39',
       'Dichiarazione di conformita''',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '39'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '39'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '40',
       'Sentenza di dichiarazione di morte presunta',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '40'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '40'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '41',
       'Sentenza di accertamento di morte',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '41'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '41'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '42',
       'Decreto del tribunale per autorizzazione omesse pubblicazioni',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '42'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '42'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '43',
       'Rigetto del Tribunale all''opposizione',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '43'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '43'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '44',
       'Ordinanza che dichiara estinto il giudizio di opposizione',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '44'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '44'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '45',
       'Decreto del tribunale per autorizzazione nonostante impedimento di eta''',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '45'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '45'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '46',
       'Decreto del tribunale per autorizzazione nonostante impedimento di affinita'' o affiliazione',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '46'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '46'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '47',
       'Decreto del tribunale per autorizzazione nonostante impedimento di divieto temporaneo di nuove nozze',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '47'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '47'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '48',
       'Atto di matrimonio',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '48'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '48'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '49',
       'Certificato di residenza',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '49'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '49'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '50',
       'Atto di matrimonio straniero, tradotto e legalizzato',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '50'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '50'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '51',
       'Certificazione come da articolo 5 del Decreto Legge n. 132/2014 convertito con Legge 10.11.2014 n.162',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '51'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '51'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '52',
       'Certificazione acquisita dall''avvocato dello sposo',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '52'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '52'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '53',
       'Certificazione acquisita dall''avvocato dello sposa',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '53'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '53'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '54',
       'Sentenza della Corte d''Appello',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '54'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '54'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '55',
       'Certificato di cui all''art.39 del Regolamento (CE) n. 2201/2003',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '55'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '55'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '56',
       'Verbale di richiesta dell''unione civile 1',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '56'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '56'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '57',
       'Verbale di richiesta dell''unione civile 2',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '57'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '57'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '58',
       'Atto di costituzione di unione civile',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '58'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '58'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '59',
       'Traduzione dell''atto di costituzione di unione civile',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '59'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '59'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '60',
       'Estratto dell''atto di unione civile',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '60'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '60'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '61',
       'Lettera raccomandata',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '61'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '61'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '62',
       'Atto di manifestazione di volonta'' di sciogliere l''unione civile',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '62'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '62'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '63',
       'Esito accertamento di cittadinanza',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '63'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '63'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '64',
       'Attestazione di acquisizione di cittadinanza',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '64'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '64'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '65',
       'Ricevuta pagamento contributo di 250,00',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '65'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '65'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '66',
       'Documentazione comprovante la prestazione del servizio militare',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '66'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '66'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '67',
       'Documentazione relativa all''assunzione pubblico impiego',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '67'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '67'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '68',
       'Documentazione attestante la residenza in Italia',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '68'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '68'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '69',
       'Certificazione di cittadinanza del genitore',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '69'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '69'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '70',
       'Copia integrale dell''atto di cittadinanza dell''interessato',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '70'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '70'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '71',
       'Attestazione di perdita di cittadinanza',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '71'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '71'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '72',
       'Documentazione che comprovi possesso di ulteriore cittadinanza',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '72'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '72'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '73',
       'Esito accertamento perdita di cittadinanza',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '73'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '73'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '74',
       'Decreto di naturalizzazione straniero',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '74'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '74'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '75',
       'Dichiarazione di riacquisto della cittadinanza italiana resa al Consolato italiano all''estero',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '75'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '75'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '76',
       'Documentazione attestatente l''abbandono del pubblico impiego o del servizio militare assunto',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '76'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '76'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '77',
       'Titolo di soggiorno per cittadini extraUE',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '77'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '77'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '78',
       'Decreto notificato con marca da bollo da euro 16',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '78'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '78'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '79',
       'Comunicazione prefettizia di concessione cittadinanza',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '79'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '79'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '80',
       'Documento d''identita''',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '80'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '80'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '81',
       'Documentazione comprovante l''incapacita'' di agire',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '81'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '81'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '82',
       'Documento di delega per il rappresentante',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '82'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '82'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '83',
       'Copia del decreto da trascrivere',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '83'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '83'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '84',
       'Copia integrale atto di nascita degli sposi',
       '2000-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '84'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '84'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '85',
       'Autocertificazione cumulativa stato libero, residenza, cittadinanza',
       '2000-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '85'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '85'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '86',
       'Certificato di eseguita pubblicazione',
       '2000-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '86'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '86'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '87',
       'Atto di pubblicazione',
       '2000-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '87'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '87'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '88',
       'Richiesta rilascio atto di delega',
       '2000-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '88'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '88'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '89',
       'Atto di delegazione',
       '2000-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '89'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '89'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '90',
       'Copia atto di matrimonio trascritto',
       '2000-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '90'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '90'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '91',
       'Certificato di stato di famiglia',
       '2000-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '91'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '91'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '92',
       'Certificato stesso di acquisto/riacquisto',
       '2000-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '92'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '92'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '93',
       'Autorizzazione del Tribunale',
       '2000-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '93'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '93'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '94',
       'Copia integrale dell''atto di nascita intestatario',
       '2000-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '94'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '94'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '95',
       'Sentenza del tribunale',
       '2000-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '95'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '95'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '96',
       'Atto di riconoscimento paterno',
       '2000-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '96'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '96'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '97',
       'Istanza verbale',
       '2000-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '97'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '97'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '98',
       'Atto scritto',
       '2000-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '98'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '98'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '99',
       'Attestazione di conformita''',
       '2000-10-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '99'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '99'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '100',
       'Atto di dichiarazione di nascita redatto dalla direzione sanitaria',
       '2000-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '100'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '100'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '101',
       'Processo verbale di dichiarazione di morte',
       '2000-10-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '100'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '101'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '102',
       'Provvedimento di rifiuto',
       '2024-05-29 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '102'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '102'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '103',
       'Nullaosta di cui all''art. 116 o documentazione equivalente',
       '2000-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '103'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '103'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '104',
       'Verbale di pubblicazione',
       '2000-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '104'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '104'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '105',
       'Processo Verbale (Redatto in luogo particolare da autorita'' incaricata)',
       '2000-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '105'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '105'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '106',
       'Documenti utilizzati per la pubblicazione',
       '2000-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '106'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '106'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '107',
       'Certificato medico',
       '2000-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '107'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '107'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '108',
       'Negoziazione assistita e nulla osta o autorizzazione',
       '2000-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '108'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '108'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '109',
       'Certificato di cui all''art.36 del Regolamento (UE) N. 2019/1111',
       '2000-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '109'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '109'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '998',
       'Allegato generico',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '998'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '998'
                  )
/
insert into anst09
       (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA,ORDINAMENTO)
select '999',
       'Processo verbale',
       '1900-01-01 00:00:00.0',
       '9999-12-31 00:00:00.0',
       '999'
  from dual
 where not exists (select 1 from anst09 b
                    where b.id = '999'
                  )
/
update anst09
   set descrizione = 'Attestazione di nascita'
 where id = '1'
/
update anst09
   set descrizione = 'Constatazione di avvenuto parto'
 where id = '2'
/
update anst09
   set descrizione = 'Dichiarazione di nascita sostitutiva resa da dichiarante'
 where id = '3'
/
update anst09
   set descrizione = 'Certificato medico attestante che il bambino e'' nato morto'
 where id = '4'
/
update anst09
   set descrizione = 'Certificato medico attestante che il bambino e'' nato vivo e poi deceduto'
 where id = '5'
/
update anst09
   set descrizione = 'Procura'
 where id = '6'
/
update anst09
   set descrizione = 'Atto notarile consenso'
 where id = '7'
/
update anst09
   set descrizione = 'Atto di pre-riconoscimento'
 where id = '8'
/
update anst09
   set descrizione = 'Copia dell''atto di riconoscimento effettuato dell''altro genitore'
 where id = '9'
/
update anst09
   set descrizione = 'Copia dell''atto di consenso dell''altro genitore'
 where id = '10'
/
update anst09
   set descrizione = 'Provvedimento di autorizzazione del giudice per figlio incestuoso'
 where id = '11'
/
update anst09
   set descrizione = 'Certificato medico attestante lo stato di gravidanza'
 where id = '12'
/
update anst09
   set descrizione = 'Copia integrale dell''atto di nascita del figlio che viene riconosciuto'
 where id = '13'
/
update anst09
   set descrizione = 'Copia dell''atto di assenso del figlio'
 where id = '14'
/
update anst09
   set descrizione = 'Sentenza del Tribunale che autorizza al riconoscimento senza il consenso dell''altro genitore'
 where id = '15'
/
update anst09
   set descrizione = 'Copia integrale dell''atto di nascita del dichiarante'
 where id = '16'
/
update anst09
   set descrizione = 'Copia integrale dell''atto di nascita dell''altro genitore'
 where id = '17'
/
update anst09
   set descrizione = 'Atto di riconoscimento'
 where id = '18'
/
update anst09
   set descrizione = 'Decreto del Tribunale'
 where id = '19'
/
update anst09
   set descrizione = 'Copia dell''atto di riconoscimento'
 where id = '20'
/
update anst09
   set descrizione = 'Atto cambiamento del cognome del genitore'
 where id = '21'
/
update anst09
   set descrizione = 'Comunicazione al Tribunale dei minorenni'
 where id = '22'
/
update anst09
   set descrizione = 'Attestazione di avvenuto parto'
 where id = '23'
/
update anst09
   set descrizione = 'Sentenza straniera'
 where id = '25'
/
update anst09
   set descrizione = 'Nota di trasmissione da parte dell''autorita'' consolare o diplomatica'
 where id = '26'
/
update anst09
   set descrizione = 'Atto estero di nascita originale o copia autentica'
 where id = '27'
/
update anst09
   set descrizione = 'Richiesta di trascrizione'
 where id = '28'
/
update anst09
   set descrizione = 'Copia integrale dell''atto di nascita dell''interessato'
 where id = '29'
/
update anst09
   set descrizione = 'Decreto Prefettizio / Sentenza'
 where id = '30'
/
update anst09
   set descrizione = 'Atto di riconoscimento materno'
 where id = '31'
/
update anst09
   set descrizione = 'Certificato necroscopico'
 where id = '32'
/
update anst09
   set descrizione = 'Atto di morte (in originale)'
 where id = '33'
/
update anst09
   set descrizione = 'Traduzione atto di morte'
 where id = '34'
/
update anst09
   set descrizione = 'Avviso di morte'
 where id = '35'
/
update anst09
   set descrizione = 'Nulla osta'
 where id = '36'
/
update anst09
   set descrizione = 'Certificazione sostitutiva della documentazione'
 where id = '37'
/
update anst09
   set descrizione = 'Traduzione sentenza straniera'
 where id = '38'
/
update anst09
   set descrizione = 'Dichiarazione di conformita'''
 where id = '39'
/
update anst09
   set descrizione = 'Sentenza di dichiarazione di morte presunta'
 where id = '40'
/
update anst09
   set descrizione = 'Sentenza di accertamento di morte'
 where id = '41'
/
update anst09
   set descrizione = 'Decreto del tribunale per autorizzazione omesse pubblicazioni'
 where id = '42'
/
update anst09
   set descrizione = 'Rigetto del Tribunale all''opposizione'
 where id = '43'
/
update anst09
   set descrizione = 'Ordinanza che dichiara estinto il giudizio di opposizione'
 where id = '44'
/
update anst09
   set descrizione = 'Decreto del tribunale per autorizzazione nonostante impedimento di eta'''
 where id = '45'
/
update anst09
   set descrizione = 'Decreto del tribunale per autorizzazione nonostante impedimento di affinita'' o affiliazione'
 where id = '46'
/
update anst09
   set descrizione = 'Decreto del tribunale per autorizzazione nonostante impedimento di divieto temporaneo di nuove nozze'
 where id = '47'
/
update anst09
   set descrizione = 'Atto di matrimonio'
 where id = '48'
/
update anst09
   set descrizione = 'Certificato di residenza'
 where id = '49'
/
update anst09
   set descrizione = 'Atto di matrimonio straniero, tradotto e legalizzato'
 where id = '50'
/
update anst09
   set descrizione = 'Certificazione come da articolo 5 del Decreto Legge n. 132/2014 convertito con Legge 10.11.2014 n.162'
 where id = '51'
/
update anst09
   set descrizione = 'Certificazione acquisita dall''avvocato dello sposo'
 where id = '52'
/
update anst09
   set descrizione = 'Certificazione acquisita dall''avvocato dello sposa'
 where id = '53'
/
update anst09
   set descrizione = 'Sentenza della Corte d''Appello'
 where id = '54'
/
update anst09
   set descrizione = 'Certificato di cui all''art.39 del Regolamento (CE) n. 2201/2003'
 where id = '55'
/
update anst09
   set descrizione = 'Verbale di richiesta dell''unione civile 1'
 where id = '56'
/
update anst09
   set descrizione = 'Verbale di richiesta dell''unione civile 2'
 where id = '57'
/
update anst09
   set descrizione = 'Atto di costituzione di unione civile'
 where id = '58'
/
update anst09
   set descrizione = 'Traduzione dell''atto di costituzione di unione civile'
 where id = '59'
/
update anst09
   set descrizione = 'Estratto dell''atto di unione civile'
 where id = '60'
/
update anst09
   set descrizione = 'Lettera raccomandata'
 where id = '61'
/
update anst09
   set descrizione = 'Atto di manifestazione di volonta'' di sciogliere l''unione civile'
 where id = '62'
/
update anst09
   set descrizione = 'Esito accertamento di cittadinanza'
 where id = '63'
/
update anst09
   set descrizione = 'Attestazione di acquisizione di cittadinanza'
 where id = '64'
/
update anst09
   set descrizione = 'Ricevuta pagamento contributo di 250,00'
 where id = '65'
/
update anst09
   set descrizione = 'Documentazione comprovante la prestazione del servizio militare'
 where id = '66'
/
update anst09
   set descrizione = 'Documentazione relativa all''assunzione pubblico impiego'
 where id = '67'
/
update anst09
   set descrizione = 'Documentazione attestante la residenza in Italia'
 where id = '68'
/
update anst09
   set descrizione = 'Certificazione di cittadinanza del genitore'
 where id = '69'
/
update anst09
   set descrizione = 'Copia integrale dell''atto di cittadinanza dell''interessato'
 where id = '70'
/
update anst09
   set descrizione = 'Attestazione di perdita di cittadinanza'
 where id = '71'
/
update anst09
   set descrizione = 'Documentazione che comprovi possesso di ulteriore cittadinanza'
 where id = '72'
/
update anst09
   set descrizione = 'Esito accertamento perdita di cittadinanza'
 where id = '73'
/
update anst09
   set descrizione = 'Decreto di naturalizzazione straniero'
 where id = '74'
/
update anst09
   set descrizione = 'Dichiarazione di riacquisto della cittadinanza italiana resa al Consolato italiano all''estero'
 where id = '75'
/
update anst09
   set descrizione = 'Documentazione attestatente l''abbandono del pubblico impiego o del servizio militare assunto'
 where id = '76'
/
update anst09
   set descrizione = 'Titolo di soggiorno per cittadini extraUE'
 where id = '77'
/
update anst09
   set descrizione = 'Decreto notificato con marca da bollo da euro 16'
 where id = '78'
/
update anst09
   set descrizione = 'Comunicazione prefettizia di concessione cittadinanza'
 where id = '79'
/
update anst09
   set descrizione = 'Documento d''identita'''
 where id = '80'
/
update anst09
   set descrizione = 'Documentazione comprovante l''incapacita'' di agire'
 where id = '81'
/
update anst09
   set descrizione = 'Documento di delega per il rappresentante'
 where id = '82'
/
update anst09
   set descrizione = 'Copia del decreto da trascrivere'
 where id = '83'
/
update anst09
   set descrizione = 'Copia integrale atto di nascita degli sposi'
 where id = '84'
/
update anst09
   set descrizione = 'Autocertificazione cumulativa stato libero, residenza, cittadinanza'
 where id = '85'
/
update anst09
   set descrizione = 'Certificato di eseguita pubblicazione'
 where id = '86'
/
update anst09
   set descrizione = 'Atto di pubblicazione'
 where id = '87'
/
update anst09
   set descrizione = 'Richiesta rilascio atto di delega'
 where id = '88'
/
update anst09
   set descrizione = 'Atto di delegazione'
 where id = '89'
/
update anst09
   set descrizione = 'Copia atto di matrimonio trascritto'
 where id = '90'
/
update anst09
   set descrizione = 'Certificato di stato di famiglia'
 where id = '91'
/
update anst09
   set descrizione = 'Certificato stesso di acquisto/riacquisto'
 where id = '92'
/
update anst09
   set descrizione = 'Autorizzazione del Tribunale'
 where id = '93'
/
update anst09
   set descrizione = 'Copia integrale dell''atto di nascita intestatario'
 where id = '94'
/
update anst09
   set descrizione = 'Sentenza del tribunale'
 where id = '95'
/
update anst09
   set descrizione = 'Atto di riconoscimento paterno'
 where id = '96'
/
update anst09
   set descrizione = 'Istanza verbale'
 where id = '97'
/
update anst09
   set descrizione = 'Atto scritto'
 where id = '98'
/
update anst09
   set descrizione = 'Attestazione di conformita'''
 where id = '99'
/
update anst09
   set descrizione = 'Atto di dichiarazione di nascita redatto dalla direzione sanitaria'
 where id = '100'
/
update anst09
   set descrizione = 'Processo verbale di dichiarazione di morte'
 where id = '101'
/
update anst09
   set descrizione = 'Provvedimento di rifiuto'
 where id = '102'
/
update anst09
   set descrizione = 'Nullaosta di cui all''art. 116 o documentazione equivalente'
 where id = '103'
/
update anst09
   set descrizione = 'Verbale di pubblicazione'
 where id = '104'
/
update anst09
   set descrizione = 'Processo Verbale (Redatto in luogo particolare da autorita'' incaricata)'
 where id = '105'
/
update anst09
   set descrizione = 'Documenti utilizzati per la pubblicazione'
 where id = '106'
/
update anst09
   set descrizione = 'Certificato medico'
 where id = '107'
/
update anst09
   set descrizione = 'Negoziazione assistita e nulla osta o autorizzazione'
 where id = '108'
/
update anst09
   set descrizione = 'Certificato di cui all''art.36 del Regolamento (UE) N. 2019/1111'
 where id = '109'
/
update anst09
   set descrizione = 'Allegato generico'
 where id = '998'
/
update anst09
   set descrizione = 'Processo verbale'
 where id = '999'
/
