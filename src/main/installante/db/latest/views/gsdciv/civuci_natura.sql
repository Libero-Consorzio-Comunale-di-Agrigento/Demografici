--liquibase formatted sql
--changeset amonopoli:202305291340 runOnChange:true stripComments:false
create or replace view civuci_natura
      (natura, sequenza, descrizione, natura_pr, tipo_atto, formula, 
       flag_auci, flag_cambio_cognome, 
       flag_scuc, flag_mat, flag_div, flag_var,
       flag_ist, cod_modello_ist, 
       sigla)
as
-- processi verbali
select 'V',  1, 'PROCESSO VERBALE'                     , 'V',-4, ''            , 'S', '' , '' , '' , '' , '' , '' , ''    , ''      from dual UNION
-- dichiarazioni
select 'O', 11, 'UNIONE CIVILE'                        , 'O',-4, ''            , 'S', '' , 'S', 'S', '' , 'S', 'S', ''    , 'O1'    from dual UNION
select '1', 12, 'UNIONE CIVILE - CONIUGI'              , 'O',-4, ''            , 'S', '' , 'S', 'S', '' , 'S', 'S', ''    , 'UCN'   from dual UNION
-- trascrizioni
select 'T', 21, 'TRASCRIZIONE UNIONE CIVILE'           , 'T',-4, ''            , 'S', '' , 'S', 'S', '' , 'S', 'S', ''    , 'T2'    from dual UNION
-- cessazioni (e formule su atto di unione civile)
select 'D', 31, 'SCIOGLIMENTO - DICHIARAZIONE'         , 'D',-4, '187-QUATER'  , 'S', '' , 'S', '' , 'S', '' , '' , ''    , 'DVS'   from dual UNION
select '2', 32, 'SCIOGLIMENTO - UFFICIALE (ACCORDO)'   , 'D',-4, ''            , 'S', '' , '' , '' , '' , '' , '' , ''    , 'UAC'   from dual UNION
select '3', 33, 'SCIOGLIMENTO - UFFICIALE (CONFERMA)'  , 'D',-4, '187-OCTIES'  , 'S', '' , 'S', '' , 'S', '' , 'S', '12SU', 'UCO'   from dual UNION
select '4', 34, 'SCIOGLIMENTO - AVVOCATI'              , 'D',-4, '187-SEPTIE'  , 'S', '' , 'S', '' , 'S', '' , 'S', '6SU' , 'AVV'   from dual UNION
select '6', 35, 'SCIOGLIMENTO - SENTENZA ITALIANA'     , 'D',-4, '187-QUINQU'  , 'S', '' , 'S', '' , 'S', '' , '' , ''    , 'TRI'   from dual UNION
select '7', 36, 'SCIOGLIMENTO - SENTENZA STRANIERA'    , 'D',-4, '187-SEXIES'  , 'S', '' , 'S', '' , 'S', '' , '' , ''    , 'EST'   from dual UNION
select '8', 37, 'NULLITA'' - SENTENZA'                 , 'D',-4, ''            , 'S', '' , 'S', '' , 'S', '' , '' , ''    , 'ANN'   from dual UNION
select '5', 41, 'DICHIARAZIONE SCELTA COGNOME'         , 'D',-4, ''            , 'S', '' , '' , '' , '' , 'S', '' , ''    , 'SCC'   from dual UNION
-- formule su atto di nascita
select 'O', 11, 'UNIONE CIVILE'                        , 'O', 2, '139-BIS'     , '' , '' , '' , '' , '' , '' , '' , ''    , 'O1'    from dual UNION
select '1', 12, 'UNIONE CIVILE - CONIUGI'              , 'O', 2, '139-TER'     , '' , '' , '' , '' , '' , '' , '' , ''    , 'UCN'   from dual UNION
select 'F', 13, 'UNIONE CIVILE - FUORI CASA COMUNALE'  , 'O', 2, '139-BIS'     , '' , '' , '' , '' , '' , '' , '' , ''    , 'FCC'    from dual UNION
select 'P', 14, 'UNIONE CIVILE - PERICOLO DI VITA'     , 'O', 2, '139-BIS'     , '' , '' , '' , '' , '' , '' , '' , ''    , 'PDV'    from dual UNION
select 'G', 15, 'UNIONE CIVILE - PER DELEGA'           , 'O', 2, '139-BIS'     , '' , '' , '' , '' , '' , '' , '' , ''    , 'UPD'    from dual UNION
select 'L', 16, 'UNIONE CIVILE - TESTO LIBERO'         , 'O', 2, '139-BIS'     , '' , '' , '' , '' , '' , '' , '' , ''    , 'ATL'    from dual UNION
select 'T', 21, 'TRASCRIZIONE UNIONE CIVILE'           , 'T', 2, '139-BIS'     , '' , '' , '' , '' , '' , '' , '' , ''    , 'T2'    from dual UNION
select '3', 32, 'SCIOGLIMENTO - UFFICIALE (CONFERMA)'  , 'D', 2, '139-NONIES'  , '' , '' , '' , '' , '' , '' , '' , ''    , 'UCO'   from dual UNION
select '4', 33, 'SCIOGLIMENTO - AVVOCATI'              , 'D', 2, '139-OCTIES'  , '' , '' , '' , '' , '' , '' , '' , ''    , 'AVV'   from dual UNION
select '6', 35, 'SCIOGLIMENTO - SENTENZA ITALIANA'     , 'D', 2, '139-SEXIES'  , '' , '' , '' , '' , '' , '' , '' , ''    , 'TRI'   from dual UNION
select '7', 36, 'SCIOGLIMENTO - SENTENZA STRANIERA'    , 'D', 2, '139-SEPTIE'  , '' , '' , '' , '' , '' , '' , '' , ''    , 'STR'   from dual UNION
select '8', 37, 'NULLITA'' - SENTENZA'                 , 'D', 2, '139-QUINQU'  , '' , '' , '' , '' , '' , '' , '' , ''    , 'ANN'   from dual UNION
-- formule su atti di matrimonio
select '1', 12, 'UNIONE CIVILE - CONIUGI'              , 'O', 4, '173-BIS'     , '' , '' , '' , '' , '' , '' , '' , ''    , 'UCN'   from dual 
/
comment on table civuci_natura is 'Unioni Civili - Codifica del campo NATURA'
/
comment on column civuci_natura.flag_auci is 'Attiva la possibilita di vedere il codice nella lista di AUCI'
/
comment on column civuci_natura.flag_cambio_cognome is 'Individua una tipologia di atto che produce il cambiamento di cognome'
/
comment on column civuci_natura.flag_scuc is 'Abilita il passaggio dell''atto nella fase SCUC (ECIV)'
/
comment on column civuci_natura.flag_mat is 'Identifica l''atto che nell''aggiornamento dei dati di anagrafe, valorizza i dati di matrimonio'
/
comment on column civuci_natura.flag_div is 'Identifica l''atto che nell''aggiornamento dei dati di anagrafe, valorizza i dati di divorzio'
/
comment on column civuci_natura.flag_var is 'Identifica l''atto che produce rettifica di anagrafe a motivo del cambio di cognome'
/
comment on column civuci_natura.flag_ist is '(non usato) Individua una tipologia di atto di interessa per ISI-ISTATEL'
/
comment on column civuci_natura.cod_modello_ist is '(non usato) Identifica il codice del modello richiesto per le estrazioni di ISI-ISTATEL'
/

