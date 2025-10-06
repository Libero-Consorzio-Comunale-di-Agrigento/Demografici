--liquibase formatted sql
--changeset amonopoli:202303271005_2 runOnChange:true stripComments:false
insert into civdcd (COD_CD, DESCRIZIONE, FLAG_MOTIVAZIONE, CODICE_ANSC)
select '00', 'Nulla da segnalare', '', ''
  from dual
 where not exists (select 1 from civdcd
                    where cod_cd = '00')
/
insert into civdcd (COD_CD, DESCRIZIONE, FLAG_MOTIVAZIONE, CODICE_ANSC)
select 'E1', 'Sordomuto che sa leggere e scrivere', '', ''
  from dual
 where not exists (select 1 from civdcd
                    where cod_cd = 'E1')
/
insert into civdcd (COD_CD, DESCRIZIONE, FLAG_MOTIVAZIONE, CODICE_ANSC)
select 'E2', 'Sordomuto che sa leggere ma non sa scrivere', '', ''
  from dual
 where not exists (select 1 from civdcd
                    where cod_cd = 'E2')
/
insert into civdcd (COD_CD, DESCRIZIONE, FLAG_MOTIVAZIONE, CODICE_ANSC)
select 'E3', 'Sordomuto che sa leggere ma non può scrivere', 'S', ''
  from dual
 where not exists (select 1 from civdcd
                    where cod_cd = 'E3')
/
insert into civdcd (COD_CD, DESCRIZIONE, FLAG_MOTIVAZIONE, CODICE_ANSC)
select 'E4', 'Sordomuto che non sa né leggere né scrivere', '', ''
  from dual
 where not exists (select 1 from civdcd
                    where cod_cd = 'E4')
/
insert into civdcd (COD_CD, DESCRIZIONE, FLAG_MOTIVAZIONE, CODICE_ANSC)
select 'L1', 'Persona che non conosce la lingua italiana', '', ''
  from dual
 where not exists (select 1 from civdcd
                    where cod_cd = 'L1')
/
insert into civdcd (COD_CD, DESCRIZIONE, FLAG_MOTIVAZIONE, CODICE_ANSC)
select 'S1', 'Sordo ma non muto che sa leggere', '', ''
  from dual
 where not exists (select 1 from civdcd
                    where cod_cd = 'S1')
/
insert into civdcd (COD_CD, DESCRIZIONE, FLAG_MOTIVAZIONE, CODICE_ANSC)
select 'S4', 'Sordo ma non muto che non sa leggere', '', ''
  from dual
 where not exists (select 1 from civdcd
                    where cod_cd = 'S4')
/
insert into civdcd (COD_CD, DESCRIZIONE, FLAG_MOTIVAZIONE, CODICE_ANSC)
select 'M1', 'Muto ma non sordo che sa scrivere', '', ''
  from dual
 where not exists (select 1 from civdcd
                    where cod_cd = 'M1')
/
insert into civdcd (COD_CD, DESCRIZIONE, FLAG_MOTIVAZIONE, CODICE_ANSC)
select 'M2', 'Muto ma non sordo che non sa scrivere', '', ''
  from dual
 where not exists (select 1 from civdcd
                    where cod_cd = 'M2')
/
insert into civdcd (COD_CD, DESCRIZIONE, FLAG_MOTIVAZIONE, CODICE_ANSC)
select 'M3', 'Muto ma non sordo che non può scrivere', 'S', ''
  from dual
 where not exists (select 1 from civdcd
                    where cod_cd = 'M3')
/
-- aggiornamento campi
-- testo_formula_m
-- testo_formula_f
update civdcd 
   set testo_formula_m = 'muto ma non sordo che non può scrivere',
       testo_formula_f = 'muta ma non sorda che non può scrivere'
  where cod_cd = 'M3'
    and testo_formula_m||testo_formula_f is null
/
update civdcd 
   set testo_formula_m = 'muto ma non sordo che non sa scrivere',
       testo_formula_f = 'muta ma non sorda che non sa scrivere'
  where cod_cd = 'M2'
    and testo_formula_m||testo_formula_f is null
/
update civdcd 
   set testo_formula_m = 'muto ma non sordo che sa scrivere',
       testo_formula_f = 'muta ma non sorda che sa scrivere'
  where cod_cd = 'M1'
    and testo_formula_m||testo_formula_f is null
/
update civdcd 
   set testo_formula_m = 'persona che non conosce la lingua italiana',
       testo_formula_f = 'persona che non conosce la lingua italiana'
  where cod_cd = 'L1'
    and testo_formula_m||testo_formula_f is null
/
update civdcd 
   set testo_formula_m = 'sordo ma non muto che non sa leggere',
       testo_formula_f = 'sorda ma non muta che non sa leggere'
  where cod_cd = 'S4'
    and testo_formula_m||testo_formula_f is null
/
update civdcd 
   set testo_formula_m = 'sordo ma non muto che sa leggere',
       testo_formula_f = 'sorda ma non muta che sa leggere'
  where cod_cd = 'S1'
    and testo_formula_m||testo_formula_f is null
/
update civdcd 
   set testo_formula_m = 'sordomuto che non sa né leggere né scrivere',
       testo_formula_f = 'sordomuta che non sa né leggere né scrivere'
  where cod_cd = 'E4'
    and testo_formula_m||testo_formula_f is null
/
update civdcd 
   set testo_formula_m = 'sordomuto che sa leggere e scrivere',
       testo_formula_f = 'sordomuta che sa leggere e scrivere'
  where cod_cd = 'E1'
    and testo_formula_m||testo_formula_f is null
/
update civdcd 
   set testo_formula_m = 'sordomuto che sa leggere ma non può scrivere',
       testo_formula_f = 'sordomuta che sa leggere ma non può scrivere'
  where cod_cd = 'E3'
    and testo_formula_m||testo_formula_f is null
/
update civdcd 
   set testo_formula_m = 'sordomuto che sa leggere ma non sa scrivere',
       testo_formula_f = 'sordomuta che sa leggere ma non sa scrivere'
  where cod_cd = 'E2'
    and testo_formula_m||testo_formula_f is null
/
