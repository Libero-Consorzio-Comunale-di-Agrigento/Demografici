--liquibase formatted sql
--changeset amonopoli:202501231600_1 runOnChange:true stripComments:false
insert into stats_select
       (ID, VERSION, DATA_CREAZIONE, DESCRIZIONE, ENTE, DATA_AGGIORNAMENTO, NOME, NOTE, TIPO_SELECT,
        UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, VALIDO, ID_VISTA, VALORI_DISTINTI, TIPO)
select stats_hibernate_sequence.nextval id,
       0 version,
       sysdate data_creazione,
       'Totale Residenti per Anno di Nascita e Stato Civile (storico)' descrizione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       'Totale Residenti per Anno di Nascita e Stato Civile (storico)' nome,
       to_char(null) note,
       'GE' tipo_select,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       'Y' valido,
       sv.id id_vista,
       to_char(null) valori_distinti,
       sv.tipo
  from stats_viste sv
 where sv.nome in ('GSD_STATISTICHE_ANA','GSD_STATISTICHE_ANA_P')
   and not exists (select 1 from stats_select b
                    where b.nome = 'Totale Residenti per Anno di Nascita e Stato Civile (storico)'
                      and b.tipo = sv.tipo)
/
insert into stats_select
       (ID, VERSION, DATA_CREAZIONE, DESCRIZIONE, ENTE, DATA_AGGIORNAMENTO, NOME, NOTE, TIPO_SELECT,
        UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, VALIDO, ID_VISTA, VALORI_DISTINTI, TIPO)
select stats_hibernate_sequence.nextval id,
       0 version,
       sysdate data_creazione,
       'Totale Residenti per Anno di Nascita e Stato Civile (ad oggi)' descrizione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       'Totale Residenti per Anno di Nascita e Stato Civile (ad oggi)' nome,
       to_char(null) note,
       'GE' tipo_select,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       'Y' valido,
       sv.id id_vista,
       to_char(null) valori_distinti,
       sv.tipo
  from stats_viste sv
 where sv.nome in ('GSD_INDIVIDUI_ANA','GSD_INDIVIDUI_ANA_P')
   and not exists (select 1 from stats_select b
                    where b.nome = 'Totale Residenti per Anno di Nascita e Stato Civile (ad oggi)'
                      and b.tipo = sv.tipo)
/
insert into stats_select
       (ID, VERSION, DATA_CREAZIONE, DESCRIZIONE, ENTE, DATA_AGGIORNAMENTO, NOME, NOTE, TIPO_SELECT,
        UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, VALIDO, ID_VISTA, VALORI_DISTINTI, TIPO)
select stats_hibernate_sequence.nextval id,
       0 version,
       sysdate data_creazione,
       'Totale Residenti per Anno di Nascita (storico)' descrizione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       'Totale Residenti per Anno di Nascita (storico)' nome,
       to_char(null) note,
       'GE' tipo_select,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       'Y' valido,
       sv.id id_vista,
       to_char(null) valori_distinti,
       sv.tipo
  from stats_viste sv
 where sv.nome in ('GSD_STATISTICHE_ANA','GSD_STATISTICHE_ANA_P')
   and not exists (select 1 from stats_select b
                    where b.nome = 'Totale Residenti per Anno di Nascita (storico)'
                      and b.tipo = sv.tipo)
/
insert into stats_select
       (ID, VERSION, DATA_CREAZIONE, DESCRIZIONE, ENTE, DATA_AGGIORNAMENTO, NOME, NOTE, TIPO_SELECT,
        UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, VALIDO, ID_VISTA, VALORI_DISTINTI, TIPO)
select stats_hibernate_sequence.nextval id,
       0 version,
       sysdate data_creazione,
       'Totale Residenti per Anno di Nascita (ad oggi)' descrizione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       'Totale Residenti per Anno di Nascita (ad oggi)' nome,
       to_char(null) note,
       'GE' tipo_select,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       'Y' valido,
       sv.id id_vista,
       to_char(null) valori_distinti,
       sv.tipo
  from stats_viste sv
 where sv.nome in ('GSD_INDIVIDUI_ANA','GSD_INDIVIDUI_ANA_P')
   and not exists (select 1 from stats_select b
                    where b.nome = 'Totale Residenti per Anno di Nascita (ad oggi)'
                      and b.tipo = sv.tipo)
/
insert into stats_select
       (ID, VERSION, DATA_CREAZIONE, DESCRIZIONE, ENTE, DATA_AGGIORNAMENTO, NOME, NOTE, TIPO_SELECT,
        UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, VALIDO, ID_VISTA, VALORI_DISTINTI, TIPO)
select stats_hibernate_sequence.nextval id,
       0 version,
       sysdate data_creazione,
       'Elenco Residenti per Unita Territoriale ''1'' (ad oggi)' descrizione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       'Elenco Residenti per Unita Territoriale ''1'' (ad oggi)' nome,
       to_char(null) note,
       'GE' tipo_select,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       'Y' valido,
       sv.id id_vista,
       to_char(null) valori_distinti,
       sv.tipo
  from stats_viste sv
 where sv.nome in ('GSD_INDIVIDUI_ANA','GSD_INDIVIDUI_ANA_P')
   and not exists (select 1 from stats_select b
                    where b.nome = 'Elenco Residenti per Unita Territoriale ''1'' (ad oggi)'
                      and b.tipo = sv.tipo)
/
insert into stats_select
       (ID, VERSION, DATA_CREAZIONE, DESCRIZIONE, ENTE, DATA_AGGIORNAMENTO, NOME, NOTE, TIPO_SELECT,
        UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, VALIDO, ID_VISTA, VALORI_DISTINTI, TIPO)
select stats_hibernate_sequence.nextval id,
       0 version,
       sysdate data_creazione,
       'Elenco Residenti con Recapiti (ad oggi)' descrizione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       'Elenco Residenti con Recapiti (ad oggi)' nome,
       to_char(null) note,
       'GE' tipo_select,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       'Y' valido,
       sv.id id_vista,
       to_char(null) valori_distinti,
       sv.tipo
  from stats_viste sv
 where sv.nome in ('GSD_INDIVIDUI_ANA','GSD_INDIVIDUI_ANA_P')
   and not exists (select 1 from stats_select b
                    where b.nome = 'Elenco Residenti con Recapiti (ad oggi)'
                      and b.tipo = sv.tipo)
/
