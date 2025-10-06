--liquibase formatted sql
--changeset snocca:202312191353 runOnChange:true stripComments:false
create or replace view istmsdsu_v_DIZ
        (cod_archivio, des_archivio, codice_istat, descrizione, codice_ads, da_anno, a_anno, anno_rif)
as
-- 'RDM', 'Rito del matrimonio'
select 'RDM', 'Rito del matrimonio'         , 1, 'Religioso', to_char(null), 1800, 9999, 2023 from dual UNION
select 'RDM', 'Rito del matrimonio'         , 2, 'Civile'   , to_char(null), 1800, 9999, 2023 from dual
UNION
-- 'RPA', 'Regime Patrimoniale'
select 'RPA', 'Regime Patrimoniale'         , 1, 'Comunione dei beni'     , to_char(null), 1800, 9999, 2023 from dual UNION
select 'RPA', 'Regime Patrimoniale'         , 2, 'Separazione dei beni'   , to_char(null), 1800, 9999, 2023 from dual
UNION
-- 'CDI', 'Causa divorzio'
select 'CDI', 'Causa divorzio'         , 1, 'Separazione giudiziale (presso il Tribunale o la Corte d’appello)'                       , to_char(null), 1800, 9999, 2023 from dual UNION
select 'CDI', 'Causa divorzio'         , 2, 'Separazione consensuale presso il Tribunale'                                             , to_char(null), 1800, 9999, 2023 from dual UNION
select 'CDI', 'Causa divorzio'         , 3, 'Separazione consensuale davanti all''Ufficiale di Stato Civile (art. 12 D. L.132/2014)'  , to_char(null), 1800, 9999, 2023 from dual UNION
select 'CDI', 'Causa divorzio'         , 4, 'Separazione consensuale con convenzione di negoziazione assistita da uno o più avvocati (art. 6 D. L. 132/2014)'   , to_char(null), 1800, 9999, 2023 from dual UNION
select 'CDI', 'Causa divorzio'         , 5, 'Altro'                                                                                   , to_char(null), 1800, 9999, 2023 from dual
UNION
-- 'TCI', 'Tipo Cittadinanza'
select 'TCI', 'Tipo Cittadinanza'         , 1, 'Per Nascita'     , to_char(null), 1800, 9999, 2023 from dual UNION
select 'TCI', 'Tipo Cittadinanza'         , 2, 'Acquisita'       , to_char(null), 1800, 9999, 2023 from dual UNION
select 'TCI', 'Tipo Cittadinanza'         , 3, 'Straniera'       , to_char(null), 1800, 9999, 2023 from dual
UNION
-- 'SCM', 'Stato civile M'
select 'SCM', 'Stato civile'         , 1, 'Celibe'                                             , 'CE', 2017, 9999, 2023 from dual UNION
select 'SCM', 'Stato civile'         , 3, 'Vedovo'                                             , 'VE', 2017, 9999, 2023 from dual UNION
select 'SCM', 'Stato civile'         , 4, 'Divorziato'                                         , 'DV', 2017, 9999, 2023 from dual UNION
select 'SCM', 'Stato civile'         , 7, 'Gia'' in unione civile (per decesso del partner)'   , 'VU', 2017, 9999, 2023 from dual UNION
select 'SCM', 'Stato civile'         , 8, 'Gia'' in unione civile (per scioglimento unione)'   , 'GU', 2017, 9999, 2023 from dual
UNION
-- 'SCF', 'Stato civile F'
select 'SCF', 'Stato civile'         , 1, 'Nubile'                                             , 'NU', 2017, 9999, 2023 from dual UNION
select 'SCF', 'Stato civile'         , 3, 'Vedova'                                             , 'VE', 2017, 9999, 2023 from dual UNION
select 'SCF', 'Stato civile'         , 4, 'Divorziata'                                         , 'DV', 2017, 9999, 2023 from dual UNION
select 'SCF', 'Stato civile'         , 7, 'Gia'' in unione civile (per decesso del partner)'   , 'VU', 2017, 9999, 2023 from dual UNION
select 'SCF', 'Stato civile'         , 8, 'Gia'' in unione civile (per scioglimento unione)'   , 'GU', 2017, 9999, 2023 from dual
UNION
-- 'TAC', 'Tipo di accordo extragiudiziale - divorzio/separazione'
select 'TAC', 'Tipo Accordo'         , 1, 'Accordo extragiudiziale di separazione'                                    , to_char(null), 1800, 9999, 2023 from dual UNION
select 'TAC', 'Tipo Accordo'         , 2, 'Accordo extragiudiziale di divorzio'                                       , to_char(null), 1800, 9999, 2023 from dual
UNION
-- 'TAS', 'Tipo di accordo extragiudiziale - scioglimento UCI'
select 'TAS', 'Tipo Accordo'         , 3, 'Scioglimento dell’unione civile'                                           , to_char(null), 1800, 9999, 2023 from dual
UNION
-- 'TPR', 'Tipo procedura'
select 'TPR', 'Tipo procedura'         , 3, 'Provvedimento presso il Tribunale'                                       , to_char(null), 1800, 9999, 2023 from dual UNION
select 'TPR', 'Tipo procedura'         , 4, 'Provvedimento presso la Corte d’appello'                                 , to_char(null), 1800, 9999, 2023 from dual
UNION
-- 'PRO', 'Tipo di provvedimento emesso dal Tribunale o Corte d’Appello - divorzio'
select 'PRO', 'Tipo di provvedimento emesso dal Tribunale o Corte d’Appello'         , 1, 'Separazione consensuale presso il Tribunale'   , to_char(null), 1800, 9999, 2023 from dual UNION
select 'PRO', 'Tipo di provvedimento emesso dal Tribunale o Corte d’Appello'         , 2, 'Separazione giudiziale presso il Tribunale'    , to_char(null), 1800, 9999, 2023 from dual UNION
select 'PRO', 'Tipo di provvedimento emesso dal Tribunale o Corte d’Appello'         , 3, 'Divorzio consensuale presso il Tribunale'      , to_char(null), 1800, 9999, 2023 from dual UNION
select 'PRO', 'Tipo di provvedimento emesso dal Tribunale o Corte d’Appello'         , 4, 'Divorzio giudiziale presso il Tribunale'       , to_char(null), 1800, 9999, 2023 from dual UNION
select 'PRO', 'Tipo di provvedimento emesso dal Tribunale o Corte d’Appello'         , 6, 'Sentenza di nullità ecclesiastica (Sacra Rota)', to_char(null), 1800, 9999, 2023 from dual
UNION
-- 'PRS', 'Tipo di provvedimento emesso dal Tribunale o Corte d’Appello - scioglimento UCI'
select 'PRS', 'Tipo di provvedimento emesso dal Tribunale o Corte d’Appello'         , 5, 'Scioglimento di unione civile'                 , to_char(null), 1800, 9999, 2023 from dual
/
comment on table istmsdsu_v_DIZ is 'ISTAT - Modello SDSU - Codifiche'
/
