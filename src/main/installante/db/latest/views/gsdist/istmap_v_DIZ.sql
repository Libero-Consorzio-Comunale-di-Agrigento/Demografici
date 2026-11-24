--liquibase formatted sql
--changeset amonopoli:202507311715 runOnChange:true stripComments:false
create or replace view istmap_v_DIZ
       (cod_archivio, des_archivio, codice_istat, descrizione, codice_ads, d_da_data, d_a_data, anno_rif, id)
as
-- 'GDI', 'Grado di istruzione'
  -- fino a 08/05/2012
select 'GDI', 'Grado di istruzione'         , 1, 'Nessun titolo'                                      , to_char(null), to_date('01/01/1800','dd/mm/yyyy'), to_date('08/05/2012','dd/mm/yyyy'), 2011, 'GDI-2011-1' from dual UNION
select 'GDI', 'Grado di istruzione'         , 2, 'Licenza elementare'                                 , to_char(null), to_date('01/01/1800','dd/mm/yyyy'), to_date('08/05/2012','dd/mm/yyyy'), 2011, 'GDI-2011-2' from dual UNION 
select 'GDI', 'Grado di istruzione'         , 3, 'Licenza media'                                      , to_char(null), to_date('01/01/1800','dd/mm/yyyy'), to_date('08/05/2012','dd/mm/yyyy'), 2011, 'GDI-2011-3' from dual UNION 
select 'GDI', 'Grado di istruzione'         , 4, 'Diploma che non consente l''accesso all''universita', to_char(null), to_date('01/01/1800','dd/mm/yyyy'), to_date('08/05/2012','dd/mm/yyyy'), 2011, 'GDI-2011-4' from dual UNION     
select 'GDI', 'Grado di istruzione'         , 5, 'Diploma che consente l''accesso all''universita'    , to_char(null), to_date('01/01/1800','dd/mm/yyyy'), to_date('08/05/2012','dd/mm/yyyy'), 2011, 'GDI-2011-5' from dual UNION
select 'GDI', 'Grado di istruzione'         , 6, 'Laurea'                                             , to_char(null), to_date('01/01/1800','dd/mm/yyyy'), to_date('08/05/2012','dd/mm/yyyy'), 2011, 'GDI-2011-6' from dual UNION
  -- da 09/05/2012
select 'GDI', 'Grado di istruzione'         , 1, 'Nessun titolo/Licenza elementare'                   , 'LE'         , to_date('09/05/2012','dd/mm/yyyy'), to_date('31/12/9999','dd/mm/yyyy'), 2012, 'GDI-2012-1' from dual UNION
select 'GDI', 'Grado di istruzione'         , 2, 'Licenza media'                                      , 'LM'         , to_date('09/05/2012','dd/mm/yyyy'), to_date('31/12/9999','dd/mm/yyyy'), 2012, 'GDI-2012-2' from dual UNION 
select 'GDI', 'Grado di istruzione'         , 3, 'Diploma'                                            , 'DP'         , to_date('09/05/2012','dd/mm/yyyy'), to_date('31/12/9999','dd/mm/yyyy'), 2012, 'GDI-2012-3' from dual UNION 
select 'GDI', 'Grado di istruzione'         , 4, 'Laurea triennale'                                   , to_char(null), to_date('09/05/2012','dd/mm/yyyy'), to_date('31/12/9999','dd/mm/yyyy'), 2012, 'GDI-2012-4' from dual UNION     
select 'GDI', 'Grado di istruzione'         , 5, 'Laurea'                                             , 'LR'         , to_date('09/05/2012','dd/mm/yyyy'), to_date('31/12/9999','dd/mm/yyyy'), 2012, 'GDI-2012-5' from dual UNION
select 'GDI', 'Grado di istruzione'         , 6, 'Dottorato'                                          , to_char(null), to_date('09/05/2012','dd/mm/yyyy'), to_date('31/12/9999','dd/mm/yyyy'), 2012, 'GDI-2012-6' from dual UNION
-- 'CNP', 'Condizione non professionale'
  -- fino 08/05/2012
select 'CNP', 'Condizione non professionale', 96, 'Casalingo/Casalinga'                               , to_char(null), to_date('01/01/1800','dd/mm/yyyy'), to_date('08/05/2012','dd/mm/yyyy'), 2011, 'CNP-2011-96' from dual UNION
select 'CNP', 'Condizione non professionale', 97, 'Studente/Studentessa'                              , to_char(null), to_date('01/01/1800','dd/mm/yyyy'), to_date('08/05/2012','dd/mm/yyyy'), 2011, 'CNP-2011-97' from dual UNION
select 'CNP', 'Condizione non professionale', 98, 'In attesa di occupazione'                          , to_char(null), to_date('01/01/1800','dd/mm/yyyy'), to_date('08/05/2012','dd/mm/yyyy'), 2011, 'CNP-2011-98' from dual UNION
select 'CNP', 'Condizione non professionale', 99, 'Altre condizioni non professionale'                , to_char(null), to_date('01/01/1800','dd/mm/yyyy'), to_date('08/05/2012','dd/mm/yyyy'), 2011, 'CNP-2011-99' from dual UNION
  -- da 09/05/2012
select 'CNP', 'Condizione non professionale', 1, 'Casalingo/Casalinga'                                , to_char(null), to_date('09/05/2012','dd/mm/yyyy'), to_date('31/12/9999','dd/mm/yyyy'), 2012, 'CNP-2012-1' from dual UNION
select 'CNP', 'Condizione non professionale', 2, 'Studente/Studentessa'                               , to_char(null), to_date('09/05/2012','dd/mm/yyyy'), to_date('31/12/9999','dd/mm/yyyy'), 2012, 'CNP-2012-2' from dual UNION
select 'CNP', 'Condizione non professionale', 3, 'Disoccupato/in cerca di prima occupazione'          , to_char(null), to_date('09/05/2012','dd/mm/yyyy'), to_date('31/12/9999','dd/mm/yyyy'), 2012, 'CNP-2012-3' from dual UNION
select 'CNP', 'Condizione non professionale', 4, 'Pensionato/ritirato dal lavoro'                     , to_char(null), to_date('09/05/2012','dd/mm/yyyy'), to_date('31/12/9999','dd/mm/yyyy'), 2012, 'CNP-2012-4' from dual UNION
select 'CNP', 'Condizione non professionale', 5, 'Altra condizione non professionale'                 , to_char(null), to_date('09/05/2012','dd/mm/yyyy'), to_date('31/12/9999','dd/mm/yyyy'), 2012, 'CNP-2012-5' from dual UNION
-- 'PNP', 'Posizione nella professione'
select 'PNP', 'Posizione nella professione' , 1, 'Imprenditore o libero professionista'               , to_char(null), to_date('01/01/1800','dd/mm/yyyy'), to_date('31/12/9999','dd/mm/yyyy'), 2012, 'PNP-2012-1' from dual UNION 
select 'PNP', 'Posizione nella professione' , 2, 'Dirigente o impiegato'                              , to_char(null), to_date('01/01/1800','dd/mm/yyyy'), to_date('31/12/9999','dd/mm/yyyy'), 2012, 'PNP-2012-2' from dual UNION
select 'PNP', 'Posizione nella professione' , 3, 'Lavoratore in proprio'                              , to_char(null), to_date('01/01/1800','dd/mm/yyyy'), to_date('31/12/9999','dd/mm/yyyy'), 2012, 'PNP-2012-3' from dual UNION
select 'PNP', 'Posizione nella professione' , 4, 'Operaio o assimilato'                               , to_char(null), to_date('01/01/1800','dd/mm/yyyy'), to_date('31/12/9999','dd/mm/yyyy'), 2012, 'PNP-2012-4' from dual UNION
select 'PNP', 'Posizione nella professione' , 5, 'Coadiuvante'                                        , to_char(null), to_date('01/01/1800','dd/mm/yyyy'), to_date('31/12/9999','dd/mm/yyyy'), 2012, 'PNP-2012-5' from dual UNION
-- 'RDA', 'Ramo di attivita'                              
select 'RDA', 'Ramo di attivita'' economica', 1, 'Agricoltura, caccia e pesca'                        , to_char(null), to_date('01/01/1800','dd/mm/yyyy'), to_date('31/12/9999','dd/mm/yyyy'), 2012, 'RDA-2012-1' from dual UNION
select 'RDA', 'Ramo di attivita'' economica', 2, 'Industria'                                          , to_char(null), to_date('01/01/1800','dd/mm/yyyy'), to_date('31/12/9999','dd/mm/yyyy'), 2012, 'RDA-2012-2' from dual UNION
select 'RDA', 'Ramo di attivita'' economica', 3, 'Pubblici esercizi'                                  , to_char(null), to_date('01/01/1800','dd/mm/yyyy'), to_date('31/12/9999','dd/mm/yyyy'), 2012, 'RDA-2012-3' from dual UNION 
select 'RDA', 'Ramo di attivita'' economica', 4, 'Servizi pubblici o privati'                         , to_char(null), to_date('01/01/1800','dd/mm/yyyy'), to_date('31/12/9999','dd/mm/yyyy'), 2012, 'RDA-2012-4' from dual 
/
comment on table istmap_v_DIZ is 'ISTAT - Modello APR/4 - Codifiche'
/
