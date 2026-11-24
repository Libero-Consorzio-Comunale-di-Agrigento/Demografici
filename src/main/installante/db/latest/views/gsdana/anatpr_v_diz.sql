--liquibase formatted sql
--changeset amonopoli:202512231120 runOnChange:true stripComments:false
create or replace view anatpr_v_diz
       (anagrafe, tipo_evento, cod_archivio, des_archivio, codice, descrizione, id, sequenza)
AS
select c1, c2, c3, c4, c5, c6, c1||'-'||c2||'-'||c3||'-'||nvl(c5,0), c7
  from (select 'RES' c1, 'I' c2, 'INI' c3, 'Iniziativa' c4, '1' c5, 'Istanza di parte'                         c6, 1 c7 from dual UNION
        select 'RES' c1, 'I' c2, 'INI' c3, 'Iniziativa' c4, '2' c5, 'Operazione d''Ufficio'                    c6, 2 c7 from dual UNION
        select 'AIR' c1, 'I' c2, 'INI' c3, 'Iniziativa' c4, '1' c5, 'Istanza di parte'                         c6, 3 c7 from dual UNION
        select 'AIR' c1, 'I' c2, 'INI' c3, 'Iniziativa' c4, '2' c5, 'Operazione d''Ufficio'                    c6, 4 c7 from dual UNION
        select 'AIR' c1, 'I' c2, 'INI' c3, 'Iniziativa' c4, '3' c5, 'Comunicazione di Ufficio di Stato Civile' c6, 5 c7 from dual UNION
        select 'AIR' c1, 'I' c2, 'INI' c3, 'Iniziativa' c4, '4' c5, 'Comunicazione di Ufficio Consolare'       c6, 6 c7 from dual UNION
        select 'AIR' c1, 'I' c2, 'INI' c3, 'Iniziativa' c4, ''  c5, 'Non indicata'                             c6, 7 c7 from dual UNION
        select 'RES' c1, 'E' c2, 'INI' c3, 'Iniziativa' c4, '1' c5, 'Istanza di parte'                         c6, 7 c7 from dual UNION
        select 'RES' c1, 'E' c2, 'INI' c3, 'Iniziativa' c4, '2' c5, 'Operazione d''Ufficio'                    c6, 7 c7 from dual UNION
        select 'RES' c1, 'R' c2, 'INI' c3, 'Iniziativa' c4, '1' c5, 'Istanza di parte'                         c6, 7 c7 from dual UNION
        select 'RES' c1, 'R' c2, 'INI' c3, 'Iniziativa' c4, '2' c5, 'Operazione d''Ufficio'                    c6, 7 c7 from dual) v
UNION
select c1, c2, c3, c4, c5, c6, c1||'-'||c2||'-'||c3||'-'||nvl(c5,0), c7
  from (select 'RES' c1, 'I' c2, 'RIC' c3, 'Richiesta' c4, '1' c5, 'Cancellazione dall''APR'                                    c6, 2 c7 from dual UNION
        select 'RES' c1, 'I' c2, 'RIC' c3, 'Richiesta' c4, '2' c5, 'Conferma dell''avvenuta cancellazione per Stato estero'     c6, 3 c7 from dual UNION
        select 'RES' c1, 'I' c2, 'RIC' c3, 'Richiesta' c4, '3' c5, 'Conferma dell''avvenuta cancellazione per irreperibilita''' c6, 4 c7 from dual UNION
        select 'RES' c1, 'I' c2, 'RIC' c3, 'Richiesta' c4, '4' c5, 'Cancellazione dall''AIRE'                                   c6, 5 c7 from dual UNION
        select 'RES' c1, 'I' c2, 'RIC' c3, 'Richiesta' c4, ''  c5, 'Nessuna'                                                    c6, 1 c7 from dual) v
UNION
select c1, c2, c3, c4, c5, c6, c1||'-'||c2||'-'||c3||'-'||nvl(c5,0), c7
  from (select 'RES' c1, 'I' c2, 'PRO' c3, 'Provvedimento' c4, '1' c5, 'Esito positivo degli accertamenti per l''iscrizione da altro Comune'                c6, 2 c7 from dual UNION
        select 'RES' c1, 'I' c2, 'PRO' c3, 'Provvedimento' c4, '2' c5, 'Esito positivo degli accertamenti per l''iscrizione dall''estero'                   c6, 3 c7 from dual UNION
        select 'RES' c1, 'I' c2, 'PRO' c3, 'Provvedimento' c4, '3' c5, 'Iscrizione a seguito di ricomparsa di persona gia'' cancellata per irreperibilta''' c6, 4 c7 from dual UNION
        select 'RES' c1, 'I' c2, 'PRO' c3, 'Provvedimento' c4, '4' c5, 'Iscrizione per altri motivi'                                                        c6, 5 c7 from dual UNION
        select 'RES' c1, 'I' c2, 'PRO' c3, 'Provvedimento' c4, ''  c5, 'Nessuno'                                                                            c6, 1 c7 from dual) v
UNION
select c1, c2, c3, c4, c5, c6, c1||'-'||c2||'-'||c3||'-'||nvl(c5,0), c7
  from (select 'AIR' c1, 'C' c2, 'MOT' c3, 'Motivo' c4, 'E01' c5, 'Rimpatrio'                   c6, 1 c7 from dual UNION
        select 'AIR' c1, 'C' c2, 'MOT' c3, 'Motivo' c4, 'E02' c5, 'Morte'                       c6, 2 c7 from dual UNION
        select 'AIR' c1, 'C' c2, 'MOT' c3, 'Motivo' c4, 'E03' c5, 'Trasferimento in altra AIRE' c6, 3 c7 from dual UNION
        select 'AIR' c1, 'C' c2, 'MOT' c3, 'Motivo' c4, 'E04' c5, 'Irreperibilita'' Presunta'   c6, 4 c7 from dual UNION
        select 'AIR' c1, 'C' c2, 'MOT' c3, 'Motivo' c4, 'E05' c5, 'Perdita Cittadinanza'        c6, 5 c7 from dual UNION
        select 'AIR' c1, 'C' c2, 'MOT' c3, 'Motivo' c4, ''    c5, 'Non indicata'                c6, 6 c7 from dual) v
/
comment on table anatpr_v_diz is 'Pratiche Anagrafe - Dizionario (view)'
/
