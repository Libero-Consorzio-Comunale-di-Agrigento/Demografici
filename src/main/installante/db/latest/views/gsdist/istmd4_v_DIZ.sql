--liquibase formatted sql
--changeset amonopoli:202304061144_2 runOnChange:true stripComments:false
create or replace view istmd4_v_DIZ
       (cod_archivio, des_archivio, codice_istat, descrizione, codice_ads, da_anno, a_anno, anno_rif)
as
-- 'GDI', 'Grado di istruzione'
  -- 2005
select 'GDI', 'Grado di istruzione'         , 1, 'Laurea o dottorato di ricerca'       , to_char(null), 1800, 9999, 2005 from dual UNION
select 'GDI', 'Grado di istruzione'         , 2, 'Diploma universitario o Laurea breve', to_char(null), 1800, 9999, 2005 from dual UNION
select 'GDI', 'Grado di istruzione'         , 3, 'Diploma di scuola media superiore'   , to_char(null), 1800, 9999, 2005 from dual UNION
select 'GDI', 'Grado di istruzione'         , 4, 'Licenza di scuola media inferiore'   , to_char(null), 1800, 9999, 2005 from dual UNION
select 'GDI', 'Grado di istruzione'         , 5, 'Licenza elementare o nessun titolo'  , to_char(null), 1800, 9999, 2005 from dual UNION
-- 'PNP', 'Posizione nella professione'
  -- 2005
select 'PNP', 'Posizione nella professione' , 1, 'Imprenditore o libero professionista'       , to_char(null), 1800, 9999, 2005 from dual UNION
select 'PNP', 'Posizione nella professione' , 2, 'Lavoratore in proprio o coadiuvante'        , to_char(null), 1800, 9999, 2005 from dual UNION
select 'PNP', 'Posizione nella professione' , 3, 'Altro'                                      , to_char(null), 1800, 9999, 2005 from dual UNION
select 'PNP', 'Posizione nella professione' , 4, 'Dirigente o direttivo'                      , to_char(null), 1800, 9999, 2005 from dual UNION
select 'PNP', 'Posizione nella professione' , 5, 'Impiegato o intermedio'                     , to_char(null), 1800, 9999, 2005 from dual UNION
select 'PNP', 'Posizione nella professione' , 6, 'Operaio o assimilato'                       , to_char(null), 1800, 9999, 2005 from dual UNION
select 'PNP', 'Posizione nella professione' , 7, 'Altro (apprendista, lav. a domicilio, etc.)', to_char(null), 1800, 9999, 2005 from dual UNION
-- 'CNP', 'Condizione non professionale'
  -- 2005
select 'CNP', 'Condizione non professionale', 1, 'Occupato'                                             , to_char(null), 1800, 9999, 2005 from dual UNION
select 'CNP', 'Condizione non professionale', 2, 'Disoccupato'                                          , to_char(null), 1800, 9999, 2005 from dual UNION
select 'CNP', 'Condizione non professionale', 3, 'In cerca di prima occupazione'                        , to_char(null), 1800, 9999, 2005 from dual UNION
select 'CNP', 'Condizione non professionale', 4, 'Ritirato dal lavoro'                                  , to_char(null), 1800, 9999, 2005 from dual UNION
select 'CNP', 'Condizione non professionale', 5, 'Casalingo/a'                                          , to_char(null), 1800, 9999, 2005 from dual UNION
select 'CNP', 'Condizione non professionale', 6, 'Studente'                                             , to_char(null), 1800, 9999, 2005 from dual UNION
select 'CNP', 'Condizione non professionale', 7, 'Inabile al lavoro'                                    , to_char(null), 1800, 9999, 2005 from dual UNION
select 'CNP', 'Condizione non professionale', 8, 'Altro (compreso servizio di leva o servizio civile)'  , to_char(null), 1800, 9999, 2005 from dual UNION
-- 'RDA', 'Ramo di attivita'
  -- 2005
select 'RDA', 'Ramo di attivita'' economica', 1, 'Agricoltura, caccia e pesca'                , to_char(null), 1800, 9999, 2005 from dual UNION
select 'RDA', 'Ramo di attivita'' economica', 2, 'Industria'                                  , to_char(null), 1800, 9999, 2005 from dual UNION
select 'RDA', 'Ramo di attivita'' economica', 3, 'Commercio, pubblici servizi, alberghi'      , to_char(null), 1800, 9999, 2005 from dual UNION 
select 'RDA', 'Ramo di attivita'' economica', 4, 'Pubblica Amministrazione e servizi pubblici', to_char(null), 1800, 9999, 2005 from dual UNION
select 'RDA', 'Ramo di attivita'' economica', 5, 'Altri servizi privati'                      , to_char(null), 1800, 9999, 2005 from dual UNION
-- 'TCI', 'Tipo Cittadinanza'
select 'TCI', 'Tipo Cittadinanza'         , 1, 'Per Nascita'     , to_char(null), 1800, 9999, 2005 from dual UNION
select 'TCI', 'Tipo Cittadinanza'         , 2, 'Acquisita'       , to_char(null), 1800, 9999, 2005 from dual UNION
select 'TCI', 'Tipo Cittadinanza'         , 3, 'Straniera'       , to_char(null), 1800, 9999, 2005 from dual UNION
select 'TCI', 'Tipo Cittadinanza'         , 9, 'Non conosciuta'  , to_char(null), 1800, 9999, 2005 from dual UNION
-- 'LDE', 'Luogo decesso'
select 'LDE', 'Luogo decesso'         , 1, 'Abitazione'                     , to_char(null), 1800, 9999, 2005 from dual UNION
select 'LDE', 'Luogo decesso'         , 2, 'Istituto di cura pubblico'      , to_char(null), 1800, 9999, 2005 from dual UNION
select 'LDE', 'Luogo decesso'         , 3, 'Casa di cura privata'           , to_char(null), 1800, 9999, 2005 from dual UNION
select 'LDE', 'Luogo decesso'         , 4, 'Altro'                          , to_char(null), 1800, 9999, 2005 from dual UNION
-- 'LPA', 'Luogo del parto'
select 'LPA', 'Luogo del parto'         , 1, 'Abitazione'                     , to_char(null), 1800, 9999, 2005 from dual UNION
select 'LPA', 'Luogo del parto'         , 2, 'Istituto di cura pubblico'      , to_char(null), 1800, 9999, 2005 from dual UNION
select 'LPA', 'Luogo del parto'         , 3, 'Casa di cura privata'           , to_char(null), 1800, 9999, 2005 from dual UNION
select 'LPA', 'Luogo del parto'         , 4, 'Altro'                          , to_char(null), 1800, 9999, 2005 from dual UNION
-- 'TPA', 'Tipo di parto'
select 'TPA', 'Tipo di parto'         , 1, 'Spontaneo'                                , to_char(null), 1800, 9999, 2005 from dual UNION
select 'TPA', 'Tipo di parto'         , 2, 'Pilotato o indotto con mezzi medici'      , to_char(null), 1800, 9999, 2005 from dual UNION
select 'TPA', 'Tipo di parto'         , 3, 'Indotto con Amniorexis'                   , to_char(null), 1800, 9999, 2005 from dual UNION
select 'TPA', 'Tipo di parto'         , 4, 'Indotto con impiego di ventosa'           , to_char(null), 1800, 9999, 2005 from dual UNION
select 'TPA', 'Tipo di parto'         , 5, 'Indotto con impiego di forcipe'           , to_char(null), 1800, 9999, 2005 from dual UNION
select 'TPA', 'Tipo di parto'         , 6, 'Con taglio cesareo'                       , to_char(null), 1800, 9999, 2005 from dual UNION
select 'TPA', 'Tipo di parto'         , 7, 'Con altri interventi'                     , to_char(null), 1800, 9999, 2005 from dual UNION
-- 'TFI', 'Tipo di filiazione'
select 'TFI', 'Tipo di filiazione'         , 1, 'Legittimo'                                            , to_char(null), 1800, 9999, 2005 from dual UNION
select 'TFI', 'Tipo di filiazione'         , 2, 'Naturale riconosciuto solo dalla madre'               , to_char(null), 1800, 9999, 2005 from dual UNION
select 'TFI', 'Tipo di filiazione'         , 3, 'Naturale riconosciuto solo dal padre'                 , to_char(null), 1800, 9999, 2005 from dual UNION
select 'TFI', 'Tipo di filiazione'         , 4, 'Naturale riconosciuto solo da entrambi i genitori'    , to_char(null), 1800, 9999, 2005 from dual UNION
select 'TFI', 'Tipo di filiazione'         , 5, 'Naturale non riconosciuto o di filiazione ignota'     , to_char(null), 1800, 9999, 2005 from dual UNION
-- 'PRE', 'Presentazione'
select 'PRE', 'Presentazione'         , 1, 'Vertice'               , to_char(null), 1800, 9999, 2005 from dual UNION
select 'PRE', 'Presentazione'         , 2, 'Podice'                , to_char(null), 1800, 9999, 2005 from dual UNION
select 'PRE', 'Presentazione'         , 3, 'Spalla'                , to_char(null), 1800, 9999, 2005 from dual UNION
select 'PRE', 'Presentazione'         , 4, 'Faccia'                , to_char(null), 1800, 9999, 2005 from dual UNION
select 'PRE', 'Presentazione'         , 5, 'Fronte'                , to_char(null), 1800, 9999, 2005 from dual UNION
select 'PRE', 'Presentazione'         , 6, 'Bregma'                , to_char(null), 1800, 9999, 2005 from dual UNION
select 'PRE', 'Presentazione'         , 7, 'Altra'                 , to_char(null), 1800, 9999, 2005 from dual UNION
-- 'GPA', 'Genere del parto'
select 'GPA', 'Genere del parto'         , 1, 'Semplice'               , to_char(null), 1800, 9999, 2005 from dual UNION
select 'GPA', 'Genere del parto'         , 2, 'Plurimo'                , to_char(null), 1800, 9999, 2005 from dual UNION
-- 'CON', 'Consanguineita'''
select 'CON', 'Consanguineita'''         , 1, 'SI'                , to_char(null), 1800, 9999, 2005 from dual UNION
select 'CON', 'Consanguineita'''         , 2, 'NO'                , to_char(null), 1800, 9999, 2005 from dual UNION
select 'CON', 'Consanguineita'''         , 3, 'Non so'            , to_char(null), 1800, 9999, 2005 from dual UNION
-- 'SCM', 'Stato civile M'
select 'SCM', 'Stato civile'         , 1, 'Celibe'                                             , 'CE', 1800, 9999, 2005 from dual UNION
select 'SCM', 'Stato civile'         , 2, 'Coniugato'                                          , 'CN', 1800, 9999, 2005 from dual UNION
select 'SCM', 'Stato civile'         , 3, 'Vedovo'                                             , 'VE', 1800, 9999, 2005 from dual UNION
select 'SCM', 'Stato civile'         , 4, 'Divorziato'                                         , 'DV', 1800, 9999, 2005 from dual UNION
select 'SCM', 'Stato civile'         , 4, 'Gia'' coniugato'                                    , 'GC', 1800, 9999, 2005 from dual UNION
select 'SCM', 'Stato civile'         , 5, 'Unito civilmente'                                   , 'UC', 1800, 9999, 2005 from dual UNION
select 'SCM', 'Stato civile'         , 6, 'Vedovo da Unione civile'                            , 'VU', 1800, 9999, 2005 from dual UNION
select 'SCM', 'Stato civile'         , 7, 'Gia'' unito civilmente'                             , 'GU', 1800, 9999, 2005 from dual UNION
-- 'SCF', 'Stato civile F'
select 'SCF', 'Stato civile'         , 1, 'Nubile'                                             , 'NU', 1800, 9999, 2005 from dual UNION
select 'SCF', 'Stato civile'         , 2, 'Coniugata'                                          , 'CN', 1800, 9999, 2005 from dual UNION
select 'SCF', 'Stato civile'         , 3, 'Vedova'                                             , 'VE', 1800, 9999, 2005 from dual UNION
select 'SCF', 'Stato civile'         , 4, 'Divorziata'                                         , 'DV', 1800, 9999, 2005 from dual UNION
select 'SCF', 'Stato civile'         , 4, 'Gia'' coniugata'                                    , 'GC', 1800, 9999, 2005 from dual UNION
select 'SCF', 'Stato civile'         , 5, 'Unita civilmente'                                   , 'UC', 1800, 9999, 2005 from dual UNION
select 'SCF', 'Stato civile'         , 6, 'Vedova da Unione civile'                            , 'VU', 1800, 9999, 2005 from dual UNION
select 'SCF', 'Stato civile'         , 7, 'Gia'' unito civilmente'                             , 'GU', 1800, 9999, 2005 from dual 
/
comment on table istmd4_v_DIZ is 'ISTAT - Modello D.4 - Codifiche'
/
