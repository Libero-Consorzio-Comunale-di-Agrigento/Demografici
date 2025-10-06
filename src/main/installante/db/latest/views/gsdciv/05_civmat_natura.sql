--liquibase formatted sql
--changeset snocca:202301051707 runOnChange:true stripComments:false
create or replace view civmat_natura
(natura, sequenza, descrizione, natura_pr, tipo_atto, formula, flag_adiv, flag_scdv, flag_ist, cod_modello_ist, tipo_accordo_ist, sigla)
as
-- formule su atto di matrimonio
select 'C',  1, 'CESSAZIONE - TRIBUNALE',              'C', 4, '175-NO'     , 'S', 'S', '' , ''    , to_number(null), 'TRI' from dual UNION
select '1',  2, 'CESSAZIONE - AVVOCATI',               'C', 4, '175-SEXIES' , 'S', 'S', 'S', '6SD' , 2              , 'AVV' from dual UNION
select '2',  3, 'CESSAZIONE - UFFICIALE (ACCORDO)',    'C', 4, to_char(null), 'S', '' , '' , ''    , to_number(null), 'UAC' from dual UNION
select '3',  4, 'CESSAZIONE - UFFICIALE (CONFERMA)',   'C', 4, '175-SEPTIE' , 'S', 'S', 'S', '12SD', 2              , 'UCO' from dual UNION
select 'S',  5, 'SCIOGLIMENTO - TRIBUNALE',            'S', 4, '175-NO'     , 'S', 'S', '' , ''    , to_number(null), 'TRI' from dual UNION
select '4',  6, 'SCIOGLIMENTO - AVVOCATI',             'S', 4, '175-SEXIES' , 'S', 'S', 'S', '6SD' , 2              , 'AVV' from dual UNION
select '5',  7, 'SCIOGLIMENTO - UFFICIALE (ACCORDO)',  'S', 4, to_char(null), 'S', '' , '' , ''    , to_number(null), 'UAC' from dual UNION
select '6',  8, 'SCIOGLIMENTO - UFFICIALE (CONFERMA)', 'S', 4, '175-SEPTIE' , 'S', 'S', 'S', '12SD', 2              , 'UCO' from dual UNION
select 'X',  9, 'SEPARAZIONE - AVVOCATI',              'X', 4, '175-QUATER' , 'S', '' , 'S', '6SD' , 1              , 'AVV' from dual UNION
select '7', 10, 'SEPARAZIONE - UFFICIALE (ACCORDO)',   'X', 4, to_char(null), 'S', '' , '' , ''    , to_number(null), 'UAC' from dual UNION
select '8', 11, 'SEPARAZIONE - UFFICIALE (CONFERMA)',  'X', 4, '175-QUINQU' , 'S', '' , 'S', '12SD', 1              , 'UCO' from dual UNION
select 'D', 21, 'TRASCRIZIONE DALL''ESTERO',           'D', 4, '175-NO'     , 'S', 'S', '' , ''    , to_number(null), 'EST' from dual UNION
select 'M', 31, 'MANCATA CONFERMA ACCORDO',            'D', 4, to_char(null), 'S', '' , '' , ''    , to_number(null), 'UAL' from dual UNION
select 'A', 32, 'MODIFICA CONDIZIONI',                 'A', 4, '185-NO'     , 'S', '' , '' , ''    , to_number(null), 'UAL' from dual UNION
select 'A', 33, 'RICONCILIAZIONE',                     'A', 4, '175-TER-NO' , 'S', '' , '' , ''    , to_number(null), 'RCN' from dual UNION
-- formule su atto di nascita
select 'C',  1, 'CESSAZIONE - TRIBUNALE',              'C', 2, '138-NO'     , '' , '' , '' , ''    , to_number(null), 'TRI' from dual UNION
select '1',  2, 'CESSAZIONE - AVVOCATI',               'C', 2, '138-BIS'    , '' , '' , '' , ''    , to_number(null), 'AVV' from dual UNION
select '3',  4, 'CESSAZIONE - UFFICIALE (CONFERMA)',   'C', 2, '138-TER'    , '' , '' , '' , ''    , to_number(null), 'UCO' from dual UNION
select 'S',  5, 'SCIOGLIMENTO - TRIBUNALE',            'S', 2, '138-NO'     , '' , '' , '' , ''    , to_number(null), 'TRI' from dual UNION
select '4',  6, 'SCIOGLIMENTO - AVVOCATI',             'S', 2, '138-BIS'    , '' , '' , '' , ''    , to_number(null), 'AVV' from dual UNION
select '6',  8, 'SCIOGLIMENTO - UFFICIALE (CONFERMA)', 'S', 2, '138-TER'    , '' , '' , '' , ''    , to_number(null), 'UCO' from dual UNION
select 'D', 21, 'TRASCRIZIONE DALL''ESTERO',           'D', 2, '135-NO'     , '' , '' , '' , ''    , to_number(null), 'EST' from dual 
/

