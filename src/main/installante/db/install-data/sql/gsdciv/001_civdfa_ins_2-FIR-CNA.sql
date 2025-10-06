--liquibase formatted sql
--changeset amonopoli:202305230915_1 runOnChange:true stripComments:false
insert into CIVDFA (TIPO_ATTO, FORMULA, TIPO_ANNOTAZIONE, DESCRIZIONE_1, DESCRIZIONE_2, DESCRIZIONE_3, FLAG_NUOVO_ORDINAMENTO, FLAG_PROVENIENZA, DESCRIZIONE)
select 2, '2-FIR-CNA1', 'W', 'FIRME NASCITA (CENTRO NASCITA)', '(DICHIARANTE PADRE)', null, null, 'M', 'FIRME NASCITA (CENTRO NASCITA) (DICHIARANTE PADRE)'
  from dual
 where not exists (select 1 from civdfa b
                    where b.formula = '2-FIR-CNA1')
/
insert into CIVDFA (TIPO_ATTO, FORMULA, TIPO_ANNOTAZIONE, DESCRIZIONE_1, DESCRIZIONE_2, DESCRIZIONE_3, FLAG_NUOVO_ORDINAMENTO, FLAG_PROVENIENZA, DESCRIZIONE)
select 2, '2-FIR-CNA2', 'W', 'FIRME NASCITA (CENTRO NASCITA)', '(DUE DICHIARANTI)', null, null, 'M', 'FIRME NASCITA (CENTRO NASCITA) (DUE DICHIARANTI)'
  from dual
 where not exists (select 1 from civdfa b
                    where b.formula = '2-FIR-CNA2')
/
insert into CIVDFA (TIPO_ATTO, FORMULA, TIPO_ANNOTAZIONE, DESCRIZIONE_1, DESCRIZIONE_2, DESCRIZIONE_3, FLAG_NUOVO_ORDINAMENTO, FLAG_PROVENIENZA, DESCRIZIONE)
select 2, '2-FIR-CNA3', 'W', 'FIRME NASCITA (CENTRO NASCITA)', '(DICHIARANTE MADRE)', null, null, 'M', 'FIRME NASCITA (CENTRO NASCITA) (DICHIARANTE MADRE)'
  from dual
 where not exists (select 1 from civdfa b
                    where b.formula = '2-FIR-CNA3')
/
insert into CIVDFA (TIPO_ATTO, FORMULA, TIPO_ANNOTAZIONE, DESCRIZIONE_1, DESCRIZIONE_2, DESCRIZIONE_3, FLAG_NUOVO_ORDINAMENTO, FLAG_PROVENIENZA, DESCRIZIONE)
select 2, '2-FIR-CNA4', 'W', 'FIRME NASCITA (CENTRO NASCITA)', '(DICHIARANTE ALTRO)', null, null, 'M', 'FIRME NASCITA (CENTRO NASCITA) (DICHIARANTE ALTRO)'
  from dual
 where not exists (select 1 from civdfa b
                    where b.formula = '2-FIR-CNA4')
/
update CIVDFA 
   set DESCRIZIONE_2 = '(DICHIARANTE PADRE)' 
 where formula = '2-FIR-CNA1'
/
update CIVDFA 
   set DESCRIZIONE_2 = '(DUE DICHIARANTI)' 
 where formula = '2-FIR-CNA2'
/
update CIVDFA 
   set DESCRIZIONE_2 = '(DICHIARANTE MADRE)'
 where formula = '2-FIR-CNA3'
/
update CIVDFA 
   set DESCRIZIONE_2 = '(DICHIARANTE ALTRO)'
 where formula = '2-FIR-CNA4'
/
