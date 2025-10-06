--liquibase formatted sql
--changeset amonopoli:202503121545_2 runOnChange:true stripComments:false
update civtfa
   set formula = '170-NO-AN'
 where formula = '170-AN'
   and not exists (select 1 from civtfa where formula = '170-NO-AN')
/
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '170-AN', 1, null, 
       'Con sentenza del #1 in data #2 N. #3 trascritta nei registri di matrimonio del Comune di #4 Anno #5 Parte #6 Serie #7 N. #8 e'' #9 #10 #11 del matrimonio  cui si riferisce l''atto controscritto.', 
       null
  from dual
 where not exists (select 1 from civtfa b
                    where formula = '170-AN')
/
