--liquibase formatted sql
--changeset amonopoli:202306211055_1 runOnChange:true stripComments:false
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '175-SEXIES', 1, null, 'Con convenzione di negoziazione assistita dagli avvocati #1 e #2 conclusa in data #3 , trascritta nei registri di matrimonio di questo ufficio dello stato civile, al n. #4 parte #5 serie #6 anno #8 , e'' stato concluso l''accordo di #7 del matrimonio controscritto', null
  from dual
 where not exists (select 1 from civtfa b
                    where b.formula = '175-SEXIES')
/
update civtfa
   set testo_4000 = 'Con convenzione di negoziazione assistita dagli avvocati #1 e #2 conclusa in data #3 , trascritta nei registri di matrimonio di questo ufficio dello stato civile, al n. #4 parte #5 serie #6 anno #8 , e'' stato concluso l''accordo di #7 del matrimonio controscritto'
 where testo_4000 in ('Con convenzione di negoziazione assistita dagli avvocati #1 e #2 conclusa in data #3 , trascritta nei registri di matrimonio di questo ufficio dello stato civile, al n. #4 parte #5 serie #6 , e'' stato concluso l''accordo di #7 del matrimonio controscritto',
                      'Con convenzione di negoziazione assistita dagli avvocati #1 e #2 conclusa in data #3 , trascritta nei registri di matrimonio di questo ufficio dello stato civile, al n. #4 parte #5 serie #6 , e'' stato concluso l''accordo di #7 del matrimonio controscritto.',
                      'Con convenzione di negoziazione assistita dagli avvocati #1 #2 conclusa in data #3 , trascritta nei registri di matrimonio di questo ufficio dello stato civile, al n. #4 parte #5 serie #6 , e'' stato concluso l''accordo di #7 del matrimonio controscritto.')
   and formula = '175-SEXIES'
/
