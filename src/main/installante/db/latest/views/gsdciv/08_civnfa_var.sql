--liquibase formatted sql
--changeset amonopoli:202302171637 runOnChange:true
create or replace view civnfa_var
       (tipo_atto, variabile, variabile_auto, sequenza)
as
select 1, '<'||cname||'>', to_char(null), colno
  from col
 where tname ='CIVWCI_TOTALE'
UNION
select 2, '<'||cname||'>', to_char(null), colno
  from col
 where tname ='CIVWNA_TOTALE'
UNION
select 4, '<'||cname||'>', to_char(null), colno
  from col
 where tname ='CIVWMA_TOTALE'
UNION
select -4, '<'||cname||'>', to_char(null), colno
  from col
 where tname ='CIVWUC_TOTALE'
UNION
select 5, '<'||cname||'>', to_char(null), colno
  from col
 where tname ='CIVWMO_TOTALE'
UNION
select dfa_v.tipo_atto, to_char(null), v.variabile_auto, rownum
  from (select distinct tipo_atto from civdfa where tipo_annotazione in ('M','C')) dfa_v,
       (select '<ISCRITTO-TRASCRITTO>' variabile_auto from dual UNION
        select '<ACQUISTATO-PERDUTO>' variabile_auto from dual UNION
        select '<ANNO_ATTO>' variabile_auto from dual UNION
        select '<NUMERO_ATTO>' variabile_auto from dual UNION
        select '<PARTE_ATTO>' variabile_auto from dual UNION
        select '<SERIE_ATTO>' variabile_auto from dual UNION
        select '<SERIE_E_ANNO_ATTO>' variabile_auto from dual UNION
        select '<DATA_EVENTO>' variabile_auto from dual UNION
        select '<DATA_E_NUM_SENTENZA_DIVORZIO>' variabile_auto from dual UNION
        select '<COMUNE_EVENTO>' variabile_auto from dual UNION
        select '<COGNOME_NOME_1>' variabile_auto from dual UNION
        select '<COGNOME_NOME_2>' variabile_auto from dual UNION
        select '<MORTO-MORTA>' variabile_auto from dual UNION
        select '<DATA_ACCORDO_DIVORZIO>' variabile_auto from dual UNION
        select '<ANNO_ACCORDO_DIVORZIO>' variabile_auto from dual UNION
        select '<PARTE_ACCORDO_DIVORZIO>' variabile_auto from dual UNION
        select '<SERIE_ACCORDO_DIVORZIO>' variabile_auto from dual UNION
        select '<SERIE_E_ANNO_ACCORDO_DIVORZIO>' variabile_auto from dual UNION
        select '<ATTO_ACCORDO_DIVORZIO>' variabile_auto from dual UNION
        select '<AVVOCATO_1_DIVORZIO>' variabile_auto from dual UNION
        select '<AVVOCATO_2_DIVORZIO>' variabile_auto from dual UNION
        select '<NUMERO_SENTENZA_DIVORZIO>' variabile_auto from dual UNION
        select '<TRIBUNALE_SENTENZA_UCI_CONIUGE>' variabile_auto from dual UNION
        select '<NUMERO_SENTENZA_UCI_CONIUGE>' variabile_auto from dual UNION
        select '<DATA_SENTENZA_UCI_CONIUGE>' variabile_auto from dual UNION
        select '<SCIOGLIMENTO-CESSAZIONE>' variabile_auto from dual UNION
        select '<LO_SCIOGLIMENTO-LA_CESSAZIONE>' variabile_auto from dual UNION
        select '<STATO_PRONUNZIATO-STATA_PRONUNZIATA>' variabile_auto from dual UNION
        select '<STATO_SCIOLTO-SONO_CESSATI>' variabile_auto from dual UNION
        select '<STATO_DICHIARATO-STATA_DICHIARATA>' variabile_auto from dual UNION
        select '<COMUNE_UTENTE>' variabile_auto from dual UNION
        select '<DATA_OGGI>' variabile_auto from dual UNION
        select '<NON>' variabile_auto from dual) v
/
comment on table civnfa_var is 'Stato Civile - Variabili per composizione Annotazioni a Margine / in Calce'
/
