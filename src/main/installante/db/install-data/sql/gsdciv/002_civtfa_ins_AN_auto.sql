--liquibase formatted sql
--changeset amonopoli:202410011120_2 runOnChange:true stripComments:false
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '132-AN', 1, null, '#1 ha contratto matrimonio con #2 il #3 nel Comune di #4 . L''atto fu iscritto nei registri di matrimonio del Comune di #6 #10 .  ', null
  from dual
 where not exists (select 1 from civtfa b
                    where formula = '132-AN')
/
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '135-AN', 1, null, 'Il matrimonio di #1 con #2 e'' stato sciolto con sentenza del #3 in data #4 #5 riconosciuta efficace in Italia e trascritta nei registri di matrimonio del Comune di #6 #10  ', null
  from dual
 where not exists (select 1 from civtfa b
                    where formula = '135-AN')
/
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '138-AN', 1, null, 'Con sentenza del #1 ,in data #2 , annotata nell''atto di matrimonio in data #9 , e'' #3 #4 #5 del matrimonio contratto da #6 con #7 di cui all''annotazione in data #8 .', null
  from dual
 where not exists (select 1 from civtfa b
                    where formula = '138-AN')
/
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '138-BIS-AN', 1, null, 'Con convenzione di negoziazione assistita dagli avvocati #1 e #2 conclusa in data #3 , trascritta nei registri di matrimonio dell''ufficio dello stato civile del Comune di #4 , al #5 , e'' stato concluso l''accordo di #8 del matrimonio di #9 con #10 di cui all''annotazione in data #11 .', null
  from dual
 where not exists (select 1 from civtfa b
                    where formula = '138-BIS-AN')
/
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '138-TER-AN', 1, null, 'Con accordo concluso innanzi all''ufficiale di stato civile del Comune di #1 in data #2 , di cui all''atto iscritto nei registri di matrimonio del predetto ufficio dello stato civile al #3 e confermato con dichiarazioni di cui all''atto iscritto nei predetti registri al #6 , #9 matrimonio annotato in data #10 .', null
  from dual
 where not exists (select 1 from civtfa b
                    where formula = '138-TER-AN')
/
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '139-BIS-AN', 1, null, '#1 ha costituito unione civile con #2 il #3 nel Comune di #4 . L''atto fu iscritto nei registri di unioni civili del Comune di #6 , #9', null
  from dual
 where not exists (select 1 from civtfa b
                    where formula = '139-BIS-AN')
/
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '139-NON-AN', 1, null, 'Con accordo ricevuto dall''ufficiale di stato civile del Comune di #1 , in data #2 , di cui all''atto iscritto nei registri di unioni civili del predetto ufficio dello stato civile, al #3 , e confermato con dichiarazioni di cui all''atto iscritto nei predetti registri, al #5 , e'' stata sciolta l''unione civile di #7 #8 con #9 #10 .', null
  from dual
 where not exists (select 1 from civtfa b
                    where formula = '139-NON-AN')
/
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '139-OCT-AN', 1, null, 'Con convenzione di negoziazione assistita dagli avvocati #1 #2 e #3 #4 , in data #5 , trascritta nei registri di unioni civili dell''ufficio dello stato civile del Comune di #6 , #9 , e'' stato concluso l''accordo di scioglimento dell''unione civile di #10 #11 con #12 #13 .', null
  from dual
 where not exists (select 1 from civtfa b
                    where formula = '139-OCT-AN')
/
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '139-QUI-AN', 1, null, 'L''unione civile di #1 #2 con #3 #4 e'' stata dichiarata nulla con sentenza del #5 #6 in data #7 , n. #8 annotata nei registri di unioni civili del Comune di #9 , #13 .', null
  from dual
 where not exists (select 1 from civtfa b
                    where formula = '139-QUI-AN')
/
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '139-SEX-AN', 1, null, 'Con sentenza del #1 #2 in data #3 , n. #4 , annotata nei registri di unioni civili del Comune di #5 , #9 , e'' stato pronunciato lo scioglimento dell''unione civile di #10 #11 con #12 #13', null
  from dual
 where not exists (select 1 from civtfa b
                    where formula = '139-SEX-AN')
/
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '139-TER-AN', 1, null, '#1 ha costituito unione civile con #2 il #3 a seguito di sentenza di rettificazione di attribuzione di sesso di #4 #5 , pronunciata dal #6 #7 , n. #8 , in data #9 . L''atto fu iscritto nei registri di unioni civili del Comune di #10 , #13 , in esecuzione dell''ordine di cui alla summenzionata sentenza.', null
  from dual
 where not exists (select 1 from civtfa b
                    where formula = '139-TER-AN')
/
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '140-AN', 1, null, 'A seguito di atto o provvedimento #1 , #2 , #3 , #4 ha #5 la cittadinanza italiana.  ', null
  from dual
 where not exists (select 1 from civtfa b
                    where formula = '140-AN')
/
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '140-BIS-AN', 1, null, '#1 in data #2 ha reso dinanzi a #3 dichiarazione con la quale #4 #5 #6 #7 #8 #9 #10 #11 #12 #13 #14 #15 #16 #17 #18 #19 #20  ', null
  from dual
 where not exists (select 1 from civtfa b
                    where formula = '140-BIS-AN')
/
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '140-QUA-AN', 1, null, 'A seguito di richiesta in data #1 , e'' stato verificato il possesso ininterrotto della cittadinanza italiana nei riguardi di #2 .  ', null
  from dual
 where not exists (select 1 from civtfa b
                    where formula = '140-QUA-AN')
/
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '140-QUI-AN', 1, null, 'Con atto del #1 in data #2 N. #3 e'' stato accertato che #4 #5 #6 cittadino italiano.  ', null
  from dual
 where not exists (select 1 from civtfa b
                    where formula = '140-QUI-AN')
/
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '140-SEX-AN', 1, null, 'Con atto del #1 in data #2 #3 ha attestato che #4 #5 #6 cittadino italiano. ', null
  from dual
 where not exists (select 1 from civtfa b
                    where formula = '140-SEX-AN')
/
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '164-AN', 1, null, '#1 e''  #2 in #3 il #4 (atto di morte del Comune di #5 #9 ).  ', null
  from dual
 where not exists (select 1 from civtfa b
                    where formula = '164-AN')
/
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '170-AN', 1, null, 'Con sentenza del #1 in data #2 N. #3 trascritta nei registri di matrimonio del Comune di #4 #8 e'' #9 #10 #11 del matrimonio  cui si riferisce l''atto controscritto.  ', null
  from dual
 where not exists (select 1 from civtfa b
                    where formula = '170-AN')
/
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '173-BIS-AN', 1, null, 'Le parti del matrimonio di cui all''atto controscritto hanno costituito unione civile tra persone dello stesso sesso a seguito di sentenza di rettificazione di attribuzione di sesso di #1 #2 , pronunciata dal #3 #4 , n. #5 , in data #6 . L''atto fu iscritto nei registri di unioni civili di questo Comune, #9 ,in esecuzione dell''ordine di cui alla summenzionata sentenza', null
  from dual
 where not exists (select 1 from civtfa b
                    where formula = '173-BIS-AN')
/
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '175-AN', 1, null, 'Con sentenza del #1 in data #2 e'' #3 #4 #5 del matrimonio cui si riferisce l''atto controscritto', null
  from dual
 where not exists (select 1 from civtfa b
                    where formula = '175-AN')
/
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '175-QUA-AN', 1, null, 'Con convenzione di negoziazione assistita dagli avvocati  #1 e #2 ,conclusa in data #3 , trascritta nei registri di matrimonio di questo ufficio dello stato civile, al #4 , e'' stato concluso l''accordo di separazione personale tra i coniugi #7 #8 #9 e #10 #11 #12 di cui all''atto di matrimonio controscritto.', null
  from dual
 where not exists (select 1 from civtfa b
                    where formula = '175-QUA-AN')
/
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '175-QUI-AN', 1, null, 'Con accordo concluso innanzi all''ufficiale di stato civile del Comune di #1 in data #2 , di cui all''atto iscritto nei registri di matrimonio del predetto ufficio dello stato civile, al #3 e confermato con dichiarazioni di cui all''atto iscritto nei predetti registri, al #6 , i coniugi #9 #10 #11 #12 , di cui al matrimonio controscritto si sono separati.', null
  from dual
 where not exists (select 1 from civtfa b
                    where formula = '175-QUI-AN')
/
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '175-SEP-AN', 1, null, 'Con accordo concluso innanzi all''ufficiale di stato civile del Comune di #1 in data #2 , di cui all''atto iscritto nei registri di matrimonio del predetto ufficio dello stato civile al #3  e confermato con dichiarazioni di cui all''atto iscritto nei predetti registri, al #6 , #9 matrimonio controscritto.', null
  from dual
 where not exists (select 1 from civtfa b
                    where formula = '175-SEP-AN')
/
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '175-SEX-AN', 1, null, 'Con convenzione di negoziazione assistita dagli avvocati #1 e #2 conclusa in data #3 , trascritta nei registri di matrimonio di questo ufficio dello stato civile, al #4 , e'' stato concluso l''accordo di #7 del matrimonio controscritto', null
  from dual
 where not exists (select 1 from civtfa b
                    where formula = '175-SEX-AN')
/
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '175-TER-AN', 1, null, 'Con dichiarazione resa dinanzi a #1 in data #2 iscritta nei registri di matrimonio del Comune di #3 #7 i coniugi separati  hanno manifestato di essersi riconciliati in data #8 .  ', null
  from dual
 where not exists (select 1 from civtfa b
                    where formula = '175-TER-AN')
/
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '185-AN', 1, null, '"Le convenzioni matrimoniali sono state modificate con atto in data #1 a rogito del notaio #2 del distretto notarile di #3 " #4 #5 #6 #7 #8 #9 #10  ', null
  from dual
 where not exists (select 1 from civtfa b
                    where formula = '185-AN')
/
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '187-OCT-AN', 1, null, 'Con accordo ricevuto dall''ufficiale di stato civile del Comune di #1 , in data #2 , di cui all''atto iscritto nei registri di unione civile del predetto ufficio dello stato civile, al #3 , e confermato con dichiarazioni di cui all''atto iscritto nei predetti registri, al #5 , e'' stata sciolta l''unione civile tra persone dello stesso sesso di cui all''atto controscritto.', null
  from dual
 where not exists (select 1 from civtfa b
                    where formula = '187-OCT-AN')
/
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '187-QUA-AN', 1, null, 'Con dichiarazione resa avanti all''ufficio dello stato civile del Comune di #1 , in data #2 , e'' stata manifestata la volonta'' di scioglimento dell''unione civile tra persone dello stesso sesso.', null
  from dual
 where not exists (select 1 from civtfa b
                    where formula = '187-QUA-AN')
/
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '187-QUI-AN', 1, null, 'Con sentenza del #1 #2 n. #3 , in data #4 , e'' stato pronunciato lo scioglimento dell''unione civile tra persone dello stesso sesso di cui all''atto controscritto.', null
  from dual
 where not exists (select 1 from civtfa b
                    where formula = '187-QUI-AN')
/
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '187-SEP-AN', 1, null, 'Con convenzione di negoziazione assistita dagli avvocati #1 #2 e #3 #4 , in data #5 , trascritta nei registri di unione civile dell''ufficio dello stato civile del Comune di #6 , #9 , e'' stato concluso l''accordo di scioglimento dell''unione civile tra persone dello stesso sesso di cui all''atto controscritto.', null
  from dual
 where not exists (select 1 from civtfa b
                    where formula = '187-SEP-AN')
/
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '187-SEX-AN', 1, null, 'Con sentenza del #1 #2 n. #3 , in data #4 , e'' stata dichiarata efficace nello Stato la pronuncia straniera di #5 #6 , n. #7 , in data #8 di #9  dell''unione civile tra persone dello stesso sesso di cui all''atto controscritto.', null
  from dual
 where not exists (select 1 from civtfa b
                    where formula = '187-SEX-AN')
/