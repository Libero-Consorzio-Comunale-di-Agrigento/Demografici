--liquibase formatted sql
--changeset amonopoli:202402211720_2 runOnChange:true stripComments:false
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select 'MAT-TR1-AN', 1, null, 'Il presente atto di matrimonio e'' stato altresi'' trascritto nei registri di Stato Civile del Comune di #1 al N. #2 P. II S. #4 Anno #5 come da comunicazione del #6 al N. #7 . #8', null
  from dual 
 where not exists (select 1 from civtfa
                    where formula = 'MAT-TR1-AN')
/
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select 'MAT-TR2-AN', 1, null, 'Il presente atto di matrimonio e'' stato altresi'' trascritto nei registri di Stato Civile del Comune di #1 al N. #2 P. II S. #4 Anno #5 come da comunicazione del #6 al N. #7. #8', null
  from dual 
 where not exists (select 1 from civtfa
                    where formula = 'MAT-TR2-AN')
/
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select 'MOR-TR1-AN', 1, null, 'Il presente atto di morte e'' stato trascritto nei registri di Stato Civile del Comune di #1 al N. #2 P. II S. #4 Anno #5 come da comunicazione del #6 . #7', null
  from dual 
 where not exists (select 1 from civtfa
                    where formula = 'MOR-TR1-AN')
/
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select 'NAS-TR1-AN', 1, null, 'Il presente atto di nascita e'' stato trascritto nei registri di Stato Civile del Comune di #1 al N. #2 P. II S. #4 Anno #5 come da comunicazione del #6 . #7', null
  from dual 
 where not exists (select 1 from civtfa
                    where formula = 'NAS-TR1-AN')
/
