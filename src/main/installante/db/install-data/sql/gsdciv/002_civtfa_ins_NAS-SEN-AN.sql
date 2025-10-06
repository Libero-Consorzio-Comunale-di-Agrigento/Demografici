--liquibase formatted sql
--changeset amonopoli:202406181655_2 runOnChange:true stripComments:false
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select 'NAS-SEN-AN', 1, null, 'Con sentenza del Tribunale di #1 in data #2 trascritta nei registri di nascita di questo Comune al N. #3, dell''anno #4 il presente atto è stato dichiarato #5 valido . #6', null
  from dual
 where not exists (select 1 from civtfa
                    where formula = 'NAS-SEN-AN')
/
