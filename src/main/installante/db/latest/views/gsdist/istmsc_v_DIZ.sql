--liquibase formatted sql
--changeset snocca:202202031353 runOnChange:true stripComments:false
create or replace view istmsc_v_DIZ
AS
select v.cod_archivio, v.des_archivio, v.codice_istat, v.descrizione, v.codice_ads, v.da_anno, v.a_anno, v.anno_rif
  from istmd3_v_DIZ v
UNION
-- 'SEX', 'Sesso'
select 'SEX', 'Sesso', 1, 'Maschio'             , '1', 1800, 9999, 2011 from dual UNION
select 'SEX', 'Sesso', 2, 'Femmina'             , '2', 1800, 9999, 2011 from dual
UNION
-- 'CSC', 'Condizione professionale per modello SC'
select 'CSC', 'Condizione professionale per modello SC', 1, 'Occupato/a'                                      , to_char(null), 2017, 9999, 2017 from dual UNION
select 'CSC', 'Condizione professionale per modello SC', 2, 'In cerca di nuova/prima occupazione'             , to_char(null), 2017, 9999, 2017 from dual UNION
select 'CSC', 'Condizione professionale per modello SC', 3, 'Casalingo/a'                                     , to_char(null), 2017, 9999, 2017 from dual UNION
select 'CSC', 'Condizione professionale per modello SC', 4, 'Studente/Studentessa'                            , to_char(null), 2017, 9999, 2017 from dual UNION
select 'CSC', 'Condizione professionale per modello SC', 5, 'Persona ritirata dal lavoro'                     , to_char(null), 2017, 9999, 2017 from dual UNION
select 'CSC', 'Condizione professionale per modello SC', 6, 'In altra condizione non professionale'           , to_char(null), 2017, 9999, 2017 from dual UNION
select 'CSC', 'Condizione professionale per modello SC', 9, 'Non conosciuta/non fornita'                      , to_char(null), 2017, 9999, 2017 from dual 
UNION
-- 'PSC', 'Posizione nella professione per modello SC'
select 'PSC', 'Posizione nella professione per modello SC', 1, 'Dirigente'                                                       , to_char(null), 2017, 9999, 2017 from dual UNION
select 'PSC', 'Posizione nella professione per modello SC', 2, 'Quadro/impiegato'                                                , to_char(null), 2017, 9999, 2017 from dual UNION
select 'PSC', 'Posizione nella professione per modello SC', 3, 'Operaio o assimilato'                                            , to_char(null), 2017, 9999, 2017 from dual UNION
select 'PSC', 'Posizione nella professione per modello SC', 4, 'Imprenditore, libero professionista'                             , to_char(null), 2017, 9999, 2017 from dual UNION
select 'PSC', 'Posizione nella professione per modello SC', 5, 'Lavoratore in proprio'                                           , to_char(null), 2017, 9999, 2017 from dual UNION
select 'PSC', 'Posizione nella professione per modello SC', 6, 'Coadiuvante familiare/socio coop.'                               , to_char(null), 2017, 9999, 2017 from dual UNION
select 'PSC', 'Posizione nella professione per modello SC', 7, 'Collaborazione coord-continuativa/Prestazione opera occasionale' , to_char(null), 2017, 9999, 2017 from dual UNION
select 'PSC', 'Posizione nella professione per modello SC', 9, 'Non conosciuta/non fornita'                                      , to_char(null), 2017, 9999, 2017 from dual 
UNION
-- 'TST', 'Titolo di studio'
select 'TST', 'Titolo di studio'         , 1, 'Nessun titolo di studio'                                                                                        , to_char(null), 1800, 9999, 2011 from dual UNION
select 'TST', 'Titolo di studio'         , 2, 'Licenza elementare e attestato di valutazione finale'                                                           , to_char(null), 1800, 9999, 2011 from dual UNION
select 'TST', 'Titolo di studio'         , 3, 'Licenza media o Diploma di istruzione secondaria di I grado o Avviamento professionale'                         , to_char(null), 1800, 9999, 2011 from dual UNION
select 'TST', 'Titolo di studio'         , 4, 'Diploma di istruzione secondaria di II grado, di qualifica professionale (corso di 3-4 anni), di IeFP, IFTS'    , to_char(null), 1800, 9999, 2011 from dual UNION
select 'TST', 'Titolo di studio'         , 5, 'Laurea, Diploma universitario, Diploma accademico, Dottorato di ricerca, Diploma ITS'                           , to_char(null), 1800, 9999, 2011 from dual UNION
select 'TST', 'Titolo di studio'         , 9, 'Non conosciuto/Non fornito'                                                                                     , to_char(null), 1800, 9999, 2011 from dual 
UNION
-- 'TAC', 'Tipo Accordo'
select 'TAC', 'Tipo Accordo'         , 1, 'Accordo di Separazione'                                    , to_char(null), 1800, 9999, 2011 from dual UNION
select 'TAC', 'Tipo Accordo'         , 2, 'Accordo di Divorzio'                                       , to_char(null), 1800, 9999, 2011 from dual 
UNION
-- 'SCN', 'Sostentamente Coniuge'
select 'SCN', 'Sostentamente Coniuge'         , 1, 'SI'                                       , to_char(null), 1800, 9999, 2011 from dual UNION
select 'SCN', 'Sostentamente Coniuge'         , 2, 'NO'                                       , to_char(null), 1800, 9999, 2011 from dual 
UNION
-- 'CCN', 'Sostentamente Coniuge (Chi)'
select 'CCN', 'Sostentamente Coniuge (Chi)'         , 1, 'Marito'                                       , to_char(null), 1800, 9999, 2011 from dual UNION
select 'CCN', 'Sostentamente Coniuge (Chi)'         , 2, 'Moglie'                                       , to_char(null), 1800, 9999, 2011 from dual 
UNION
-- 'CFG', 'Sostentamente Figli (Chi)'
select 'CFG', 'Sostentamente Figli (Chi)'         , 1,               'Padre'                                       , to_char(null), 1800, 9999, 2011 from dual UNION
select 'CFG', 'Sostentamente Figli (Chi)'         , 2,               'Madre'                                       , to_char(null), 1800, 9999, 2011 from dual 
UNION
-- 'ABI', 'Assegnamento Abitazione'
select 'ABI', 'Assegnamento Abitazione'         , 1, 'al marito'                                       , to_char(null), 1800, 9999, 2011 from dual UNION
select 'ABI', 'Assegnamento Abitazione'         , 2, 'alla moglie'                                     , to_char(null), 1800, 9999, 2011 from dual UNION
select 'ABI', 'Assegnamento Abitazione'         , 3, 'ad entrambi i coniugi'                           , to_char(null), 1800, 9999, 2011 from dual UNION
select 'ABI', 'Assegnamento Abitazione'         , 4, 'ai figli'                                        , to_char(null), 1800, 9999, 2011 from dual UNION
select 'ABI', 'Assegnamento Abitazione'         , 5, 'a nessuno'                                       , to_char(null), 1800, 9999, 2011 from dual 
UNION
-- 'PFG', 'Figli'
select 'PFG', 'Presenza Figli'         , 1, 'SI'                                       , to_char(null), 1800, 9999, 2011 from dual UNION
select 'PFG', 'Presenza Figli'         , 2, 'NO'                                       , to_char(null), 1800, 9999, 2011 from dual 
UNION
-- 'CDI', 'Causa scioglimento'
select 'CDI', 'Causa scioglimento'         , 1, 'Separazione Giudiziale  (presso il Tribunale)'                      , to_char(null), 1800, 9999, 2011 from dual UNION
select 'CDI', 'Causa scioglimento'         , 2, 'Separazione consensuale (presso il Tribunale)'                      , to_char(null), 1800, 9999, 2011 from dual UNION
select 'CDI', 'Causa scioglimento'         , 3, 'Separazione consensuale (davanti all''Ufficiale di Stato Civile)'   , to_char(null), 1800, 9999, 2011 from dual UNION
select 'CDI', 'Causa scioglimento'         , 4, 'Separazione consensuale (con negoziazione assistita da Avvocati)'   , to_char(null), 1800, 9999, 2011 from dual UNION
select 'CDI', 'Causa scioglimento'         , 5, 'Altro'                                                              , to_char(null), 1800, 9999, 2011 from dual 
UNION
-- 'TAF', 'Tipo affidamento'
select 'TAF', 'Tipo affidamento'         , 1, 'Esclusivo al padre'                                                           , to_char(null), 1800, 9999, 2011 from dual UNION
select 'TAF', 'Tipo affidamento'         , 2, 'Esclusivo alla madre'                                                         , to_char(null), 1800, 9999, 2011 from dual UNION
select 'TAF', 'Tipo affidamento'         , 3, 'Esclusivo a terzi'                                                            , to_char(null), 1800, 9999, 2011 from dual UNION
select 'TAF', 'Tipo affidamento'         , 4, 'Condiviso con padre prevalente'                                               , to_char(null), 1800, 9999, 2011 from dual UNION
select 'TAF', 'Tipo affidamento'         , 5, 'Condiviso con madre prevalente'                                               , to_char(null), 1800, 9999, 2011 from dual UNION
select 'TAF', 'Tipo affidamento'         , 6, 'Condiviso con frequentazione paritetica'                                      , to_char(null), 1800, 9999, 2011 from dual UNION
select 'TAF', 'Tipo affidamento'         , 7, 'Non previsto (figlio maggiorenne economicamente non autosufficiente)'         , to_char(null), 1800, 9999, 2011 from dual 
UNION
-- 'MFG', 'Mantenimento Figli'
  -- 2011
select 'MFG', 'Mantenimento Figli'         , 1, 'Mantenimento indiretto mediante assegno (ed eventuali spese straordinarie)'         , to_char(null), 1800, 2020, 2011 from dual UNION
select 'MFG', 'Mantenimento Figli'         , 2, 'Mantenimento diretto per capitoli di spesa'                                         , to_char(null), 1800, 2020, 2011 from dual UNION
select 'MFG', 'Mantenimento Figli'         , 3, 'Mantenimento diretto (con o senza capitoli di spesa) piu'' assegno perequativo'     , to_char(null), 1800, 2020, 2011 from dual UNION
select 'MFG', 'Mantenimento Figli'         , 4, 'Mantenimento diretto senza capitoli di spesa'                                       , to_char(null), 1800, 2020, 2011 from dual 
UNION
-- 'MFG', 'Mantenimento Figli'
    -- 2022 (dal 2021)
select 'MFG', 'Mantenimento Figli'         , 1, 'Mantenimento indiretto mediante assegno (ed eventuali spese straordinarie)'         , to_char(null), 2021, 9999, 2021 from dual UNION
select 'MFG', 'Mantenimento Figli'         , 3, 'Mantenimento diretto (con o senza capitoli di spesa) piu'' assegno perequativo'     , to_char(null), 2021, 9999, 2021 from dual UNION
select 'MFG', 'Mantenimento Figli'         , 4, 'Mantenimento diretto senza capitoli di spesa'                                       , to_char(null), 2021, 9999, 2021 from dual 
UNION
-- 'MFM', 'Mantenimento Figli Maggiorenni'
  -- 2011
select 'MFM', 'Mantenimento Figli Maggiorenni'    , 1, 'Importo corrisposto direttamente ai figli'         , to_char(null), 1800, 2020, 2011 from dual UNION
select 'MFM', 'Mantenimento Figli Maggiorenni'    , 2, 'Importo corrisposto all''altro genitore'           , to_char(null), 1800, 2020, 2011 from dual 
UNION
-- 'MFM', 'Mantenimento Figli Maggiorenni'
    -- 2022 (dal 2021)
select 'MFM', 'Mantenimento Figli Maggiorenni'    , 1, 'Importo corrisposto direttamente ai figli'                             , to_char(null), 2021, 9999, 2021 from dual UNION
select 'MFM', 'Mantenimento Figli Maggiorenni'    , 2, 'Importo corrisposto all''altro genitore'                               , to_char(null), 2021, 9999, 2021 from dual UNION
select 'MFM', 'Mantenimento Figli Maggiorenni'    , 3, 'Importo corrisposto in parte ai figli e in parte all''altro genitore'  , to_char(null), 2021, 9999, 2021 from dual 
/
comment on table istmsc_v_DIZ is 'ISTAT - Modello SC - Codifiche'
/
