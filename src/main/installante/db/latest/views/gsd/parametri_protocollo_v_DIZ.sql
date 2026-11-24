--liquibase formatted sql
--changeset amonopoli:202410281240_0 runOnChange:true stripComments:false
create or replace view parametri_protocollo_v_diz
(id, modulo, cod_fase, des_fase, cod_tipo_atto_civ, des_tipo_atto_civ, cod_fase_ana, des_fase_ana)
as
select 1,   'CIV', 'A', 'Stampa Atti',          'NAS', 'Atti di Nascita',          '',     ''                       from dual UNION
select 2,   'CIV', 'A', 'Stampa Atti',          'CIT', 'Atti di Cittadinanza',     '',     ''                       from dual UNION
select 3,   'CIV', 'A', 'Stampa Atti',          'DIV', 'Atti di Divorzio',         '',     ''                       from dual UNION
select 4,   'CIV', 'A', 'Stampa Atti',          'MAT', 'Atti di Matrimonio',       '',     ''                       from dual UNION
select 5,   'CIV', 'A', 'Stampa Atti',          'UCI', 'Atti di Unione Civile',    '',     ''                       from dual UNION
select 6,   'CIV', 'A', 'Stampa Atti',          'MOR', 'Atti di Morte',            '',     ''                       from dual UNION
select 7,   'CIV', 'A', 'Stampa Atti',          'VPB', 'Verbali di Pubblicazione', '',     ''                       from dual UNION
select 8,   'CIV', 'W', 'Stampa Comunicazioni', '-4',  'Atti di Unione Civile',    '',     ''                       from dual UNION
select 9,   'CIV', 'W', 'Stampa Comunicazioni', '0',   'Formule Annotazione',      '',     ''                       from dual UNION
select 10,  'CIV', 'W', 'Stampa Comunicazioni', '1',   'Atti di Cittadinanza',     '',     ''                       from dual UNION
select 11,  'CIV', 'W', 'Stampa Comunicazioni', '2',   'Atti di Nascita',          '',     ''                       from dual UNION
select 12,  'CIV', 'W', 'Stampa Comunicazioni', '3',   'Verbali di Pubblicazione', '',     ''                       from dual UNION
select 13,  'CIV', 'W', 'Stampa Comunicazioni', '4',   'Atti di Matrimonio',       '',     ''                       from dual UNION
select 15,  'CIV', 'W', 'Stampa Comunicazioni', '5',   'Atti di Morte',            '',     ''                       from dual UNION
-- modulo ANA
select 101, 'ANA', 'P', 'Stampa Adempimenti',   '',    '',                         'IAPR', 'Iscrizione APR'         from dual UNION
select 102, 'ANA', 'P', 'Stampa Adempimenti',   '',    '',                         'CABI', 'Cambio Abitazione APR'  from dual UNION
select 103, 'ANA', 'P', 'Stampa Adempimenti',   '',    '',                         'CAPR', 'Cancellazione APR'      from dual UNION
select 104, 'ANA', 'P', 'Stampa Adempimenti',   '',    '',                         'IAIR', 'Iscrizione AIRE'        from dual UNION
select 105, 'ANA', 'P', 'Stampa Adempimenti',   '',    '',                         'CABA', 'Cambio Abitazione AIRE' from dual UNION
select 106, 'ANA', 'P', 'Stampa Adempimenti',   '',    '',                         'KAIR', 'Cancellazione AIRE'     from dual UNION
select 111, 'ANA', 'C', 'Stampa Comunicazioni', '',    '',                         'SCAW', 'Stampa Comunicazioni'   from dual
/

