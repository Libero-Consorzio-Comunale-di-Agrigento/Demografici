--liquibase formatted sql
--changeset amonopoli:202304061145 runOnChange:true stripComments:false
create or replace view istmd3_v_DIZ
       (cod_archivio, des_archivio, codice_istat, descrizione, codice_ads, da_anno, a_anno, anno_rif)
as
-- 'GDI', 'Grado di istruzione'
  -- 2011
select 'GDI', 'Grado di istruzione'         , 1, 'Laurea o dottorato di ricerca'       , to_char(null), 1800, 2016, 2011 from dual UNION
select 'GDI', 'Grado di istruzione'         , 2, 'Diploma universitario o Laurea breve', to_char(null), 1800, 2016, 2011 from dual UNION
select 'GDI', 'Grado di istruzione'         , 3, 'Diploma di scuola media superiore'   , to_char(null), 1800, 2016, 2011 from dual UNION
select 'GDI', 'Grado di istruzione'         , 4, 'Licenza di scuola media inferiore'   , to_char(null), 1800, 2016, 2011 from dual UNION
select 'GDI', 'Grado di istruzione'         , 5, 'Licenza elementare o nessun titolo'  , to_char(null), 1800, 2016, 2011 from dual UNION
  -- 2022 (dal 2017)
select 'GDI', 'Grado di istruzione'         , 1, 'Nessun titolo/Licenza elementare'                                                         , to_char(null), 2017, 9999, 2017 from dual UNION
select 'GDI', 'Grado di istruzione'         , 2, 'Licenza media/Diploma di istruzione secondaria di I grado'                                , to_char(null), 2017, 9999, 2017 from dual UNION 
select 'GDI', 'Grado di istruzione'         , 3, 'Diploma di istruzione secondaria di II grado'                                             , to_char(null), 2017, 9999, 2017 from dual UNION 
select 'GDI', 'Grado di istruzione'         , 4, 'Diploma universitario/Laurea di primo livello'                                            , to_char(null), 2017, 9999, 2017 from dual UNION     
select 'GDI', 'Grado di istruzione'         , 5, 'Laurea specialistica/magistrale (biennale o a ciclo unico)/Laurea del vecchio ordinamento', to_char(null), 2017, 9999, 2017 from dual UNION
select 'GDI', 'Grado di istruzione'         , 6, 'Titolo post-laurea/Master universitario/Diploma di specializzazione/Dottore di ricerca'   , to_char(null), 2017, 9999, 2017 from dual UNION
-- 'PNP', 'Posizione nella professione'
  -- 2011
select 'PNP', 'Posizione nella professione' , 1, 'Imprenditore o libero professionista'       , to_char(null), 1800, 2016, 2011 from dual UNION 
select 'PNP', 'Posizione nella professione' , 2, 'Lavoratore in proprio o coadiuvante'        , to_char(null), 1800, 2016, 2011 from dual UNION
select 'PNP', 'Posizione nella professione' , 3, 'Altro'                                      , to_char(null), 1800, 2016, 2011 from dual UNION
select 'PNP', 'Posizione nella professione' , 4, 'Dirigente o direttivo'                      , to_char(null), 1800, 2016, 2011 from dual UNION
select 'PNP', 'Posizione nella professione' , 5, 'Impiegato o intermedio'                     , to_char(null), 1800, 2016, 2011 from dual UNION
select 'PNP', 'Posizione nella professione' , 6, 'Operaio o assimilato'                       , to_char(null), 1800, 2016, 2011 from dual UNION
select 'PNP', 'Posizione nella professione' , 7, 'Altro (apprendista, lav. a domicilio, etc.)', to_char(null), 1800, 2016, 2011 from dual UNION
  -- 2022 (dal 2017)
select 'PNP', 'Posizione nella professione' , 0, 'Non applicabile (es: condizione non professionale)'             , to_char(null), 2017, 9999, 2017 from dual UNION
select 'PNP', 'Posizione nella professione' , 1, 'Dirigente'                                                      , to_char(null), 2017, 9999, 2017 from dual UNION
select 'PNP', 'Posizione nella professione' , 2, 'Quadro/impiegato'                                               , to_char(null), 2017, 9999, 2017 from dual UNION
select 'PNP', 'Posizione nella professione' , 3, 'Operaio o assimilato'                                           , to_char(null), 2017, 9999, 2017 from dual UNION
select 'PNP', 'Posizione nella professione' , 4, 'Imprenditore, libero professionista'                            , to_char(null), 2017, 9999, 2017 from dual UNION
select 'PNP', 'Posizione nella professione' , 5, 'Lavoratore in proprio'                                          , to_char(null), 2017, 9999, 2017 from dual UNION
select 'PNP', 'Posizione nella professione' , 6, 'Coadiuvante familiare/socio coop.'                              , to_char(null), 2017, 9999, 2017 from dual UNION
select 'PNP', 'Posizione nella professione' , 7, 'Collaborazione coord-continuativa/Prestazione opera occasionale', to_char(null), 2017, 9999, 2017 from dual UNION
select 'PNP', 'Posizione nella professione' , 9, 'Non conosciuta/non fornita'                                     , to_char(null), 2017, 9999, 2017 from dual UNION
-- 'CNP', 'Condizione non professionale'
  -- 2011
select 'CNP', 'Condizione non professionale', 1, 'Occupato'                             , to_char(null), 1800, 2016, 2011 from dual UNION
select 'CNP', 'Condizione non professionale', 2, 'Disoccupato'                          , to_char(null), 1800, 2016, 2011 from dual UNION
select 'CNP', 'Condizione non professionale', 3, 'In cerca di prima occupazione'        , to_char(null), 1800, 2016, 2011 from dual UNION
select 'CNP', 'Condizione non professionale', 4, 'Ritirato dal lavoro'                  , to_char(null), 1800, 2016, 2011 from dual UNION
select 'CNP', 'Condizione non professionale', 6, 'Studente'                             , to_char(null), 1800, 2016, 2011 from dual UNION
select 'CNP', 'Condizione non professionale', 7, 'Inabile al lavoro'                    , to_char(null), 1800, 2016, 2011 from dual UNION
select 'CNP', 'Condizione non professionale', 8, 'In servizio di leva o servizio civile', to_char(null), 1800, 2016, 2011 from dual UNION
select 'CNP', 'Condizione non professionale', 9, 'Altro'                                , to_char(null), 1800, 2016, 2011 from dual UNION
  -- 2022 (dal 2017)
select 'CNP', 'Condizione non professionale', 1, 'Casalingo/Casalinga'                      , to_char(null), 2017, 9999, 2017 from dual UNION
select 'CNP', 'Condizione non professionale', 2, 'Studente'                                 , to_char(null), 2017, 9999, 2017 from dual UNION
select 'CNP', 'Condizione non professionale', 3, 'Disoccupato/in cerca di prima occupazione', to_char(null), 2017, 9999, 2017 from dual UNION
select 'CNP', 'Condizione non professionale', 4, 'Pensionato/ritirato dal lavoro'           , to_char(null), 2017, 9999, 2017 from dual UNION
select 'CNP', 'Condizione non professionale', 5, 'Altra condizione non professionale'       , to_char(null), 2017, 9999, 2017 from dual UNION
select 'CNP', 'Condizione non professionale', 6, 'Non conosciuta/non fornita'               , to_char(null), 2017, 9999, 2017 from dual UNION
-- 'RDA', 'Ramo di attivita'
  -- 2022 (dal 2011)
select 'RDA', 'Ramo di attivita'' economica', 1, 'Agricoltura, caccia e pesca'                , to_char(null), 1800, 9999, 2011 from dual UNION
select 'RDA', 'Ramo di attivita'' economica', 2, 'Industria'                                  , to_char(null), 1800, 9999, 2011 from dual UNION
select 'RDA', 'Ramo di attivita'' economica', 3, 'Commercio, pubblici servizi, alberghi'      , to_char(null), 1800, 9999, 2011 from dual UNION 
select 'RDA', 'Ramo di attivita'' economica', 4, 'Pubblica Amministrazione e servizi pubblici', to_char(null), 1800, 9999, 2011 from dual UNION
select 'RDA', 'Ramo di attivita'' economica', 5, 'Altri servizi privati'                      , to_char(null), 1800, 9999, 2011 from dual UNION
-- 'RDM', 'Rito del matrimonio'
select 'RDM', 'Rito del matrimonio'         , 1, 'Religioso', to_char(null), 1800, 9999, 2011 from dual UNION
select 'RDM', 'Rito del matrimonio'         , 2, 'Civile'   , to_char(null), 1800, 9999, 2011 from dual  UNION
-- 'RPA', 'Regime Patrimoniale'
select 'RPA', 'Regime Patrimoniale'         , 1, 'Comunione dei beni'     , to_char(null), 1800, 9999, 2011 from dual UNION
select 'RPA', 'Regime Patrimoniale'         , 2, 'Separazione dei beni'   , to_char(null), 1800, 9999, 2011 from dual UNION
-- 'TCI', 'Tipo Cittadinanza'
select 'TCI', 'Tipo Cittadinanza'         , 1, 'Per Nascita'     , to_char(null), 1800, 9999, 2011 from dual UNION
select 'TCI', 'Tipo Cittadinanza'         , 2, 'Acquisita'       , to_char(null), 1800, 9999, 2011 from dual UNION
select 'TCI', 'Tipo Cittadinanza'         , 3, 'Straniera'       , to_char(null), 1800, 9999, 2011 from dual UNION
-- 'SCM', 'Stato civile M'
  -- 2011
select 'SCM', 'Stato civile'         , 1, 'Celibe'                          , 'CE', 1800, 2016, 2011 from dual UNION
select 'SCM', 'Stato civile'         , 2, 'Vedovo'                          , 'VE', 1800, 2016, 2011 from dual UNION
select 'SCM', 'Stato civile'         , 3, 'Divorziato'                      , 'DV', 1800, 2016, 2011 from dual UNION
select 'SCM', 'Stato civile'         , 3, 'Gia'' coniugato'                 , 'GC', 1800, 2016, 2011 from dual UNION
  -- 2022
select 'SCM', 'Stato civile'         , 1, 'Celibe'                                             , 'CE', 2017, 9999, 2017 from dual UNION
select 'SCM', 'Stato civile'         , 3, 'Vedovo'                                             , 'VE', 2017, 9999, 2017 from dual UNION
select 'SCM', 'Stato civile'         , 4, 'Divorziato'                                         , 'DV', 2017, 9999, 2017 from dual UNION
select 'SCM', 'Stato civile'         , 7, 'Gia'' in unione civile (per decesso del partner)'   , 'VU', 2017, 9999, 2017 from dual UNION
select 'SCM', 'Stato civile'         , 8, 'Gia'' in unione civile (per scioglimento unione)'   , 'GU', 2017, 9999, 2017 from dual UNION
-- 'SCF', 'Stato civile F'
  -- 2011
select 'SCF', 'Stato civile'         , 1, 'Nubile'                          , 'NU', 1800, 2016, 2011 from dual UNION
select 'SCF', 'Stato civile'         , 2, 'Vedova'                          , 'VE', 1800, 2016, 2011 from dual UNION
select 'SCF', 'Stato civile'         , 3, 'Divorziata'                      , 'DV', 1800, 2016, 2011 from dual UNION
select 'SCF', 'Stato civile'         , 3, 'Gia'' coniugata'                 , 'GC', 1800, 2016, 2011 from dual UNION
  -- 2022
select 'SCF', 'Stato civile'         , 1, 'Nubile'                                             , 'NU', 2017, 9999, 2017 from dual UNION
select 'SCF', 'Stato civile'         , 3, 'Vedova'                                             , 'VE', 2017, 9999, 2017 from dual UNION
select 'SCF', 'Stato civile'         , 4, 'Divorziata'                                         , 'DV', 2017, 9999, 2017 from dual UNION
select 'SCF', 'Stato civile'         , 7, 'Gia'' in unione civile (per decesso del partner)'   , 'VU', 2017, 9999, 2017 from dual UNION
select 'SCF', 'Stato civile'         , 8, 'Gia'' in unione civile (per scioglimento unione)'   , 'GU', 2017, 9999, 2017 from dual
/
comment on table istmd3_v_DIZ is 'ISTAT - Modello D.3 - Codifiche'
/
