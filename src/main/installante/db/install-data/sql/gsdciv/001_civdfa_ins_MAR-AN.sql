--liquibase formatted sql
--changeset amonopoli:202402211720_1 runOnChange:true stripComments:false
insert into CIVDFA (TIPO_ATTO, FORMULA, TIPO_ANNOTAZIONE, DESCRIZIONE_1, DESCRIZIONE_2, DESCRIZIONE_3, FLAG_NUOVO_ORDINAMENTO, FLAG_PROVENIENZA, DESCRIZIONE, GENERE, FLAG_SECRETATO, FLAG_ISTAT)
select 4, 'MAT-TR1-AN', 'M', 'MARGINE - TRASCRIZIONE ATTO (SPOSO)', null, null, 'S', null, 'MARGINE - TRASCRIZIONE ATTO (SPOSO)', null, null, null
  from dual 
 where not exists (select 1 from civdfa
                    where formula = 'MAT-TR1-AN')
/
insert into CIVDFA (TIPO_ATTO, FORMULA, TIPO_ANNOTAZIONE, DESCRIZIONE_1, DESCRIZIONE_2, DESCRIZIONE_3, FLAG_NUOVO_ORDINAMENTO, FLAG_PROVENIENZA, DESCRIZIONE, GENERE, FLAG_SECRETATO, FLAG_ISTAT)
select 4, 'MAT-TR2-AN', 'M', 'MARGINE - TRASCRIZIONE ATTO (SPOSA)', null, null, 'S', null, 'MARGINE - TRASCRIZIONE ATTO (SPOSA)', null, null, null
  from dual 
 where not exists (select 1 from civdfa
                    where formula = 'MAT-TR2-AN')
/
insert into CIVDFA (TIPO_ATTO, FORMULA, TIPO_ANNOTAZIONE, DESCRIZIONE_1, DESCRIZIONE_2, DESCRIZIONE_3, FLAG_NUOVO_ORDINAMENTO, FLAG_PROVENIENZA, DESCRIZIONE, GENERE, FLAG_SECRETATO, FLAG_ISTAT)
select 2, 'NAS-TR1-AN', 'M', 'MARGINE - TRASCRIZIONE ATTO', null, null, 'S', null, 'MARGINE - TRASCRIZIONE ATTO', null, null, null
  from dual 
 where not exists (select 1 from civdfa
                    where formula = 'NAS-TR1-AN')
/
insert into CIVDFA (TIPO_ATTO, FORMULA, TIPO_ANNOTAZIONE, DESCRIZIONE_1, DESCRIZIONE_2, DESCRIZIONE_3, FLAG_NUOVO_ORDINAMENTO, FLAG_PROVENIENZA, DESCRIZIONE, GENERE, FLAG_SECRETATO, FLAG_ISTAT)
select 5, 'MOR-TR1-AN', 'M', 'MARGINE - TRASCRIZIONE ATTO', null, null, 'S', null, 'MARGINE - TRASCRIZIONE ATTO', null, null, null
  from dual 
 where not exists (select 1 from civdfa
                    where formula = 'MOR-TR1-AN')
/
