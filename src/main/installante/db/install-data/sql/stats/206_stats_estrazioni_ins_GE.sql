--liquibase formatted sql
--changeset amonopoli:202501231600_6 runAlways:true stripComments:false
insert into stats_estrazioni
       (ID, VERSION, DATA_CREAZIONE, ENTE, DATA_AGGIORNAMENTO, NOME, NOME_FILE, ID_SELECT, 
        UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, VALIDO, TIPO)
select stats_hibernate_sequence.nextval id,
       0 version,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       'Totale Residenti per Anno di Nascita e Stato Civile (storico)' nome,
       'Totale Residenti per Anno di Nascita e Stato Civile (storico)' nome_file,
       ss.id id_select,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       'Y' valido,
       ss.tipo
  from stats_select ss
 where ss.nome = 'Totale Residenti per Anno di Nascita e Stato Civile (storico)'
   and not exists (select 1 from stats_estrazioni b
                    where b.id_select = ss.id)
/
insert into stats_estrazioni
       (ID, VERSION, DATA_CREAZIONE, ENTE, DATA_AGGIORNAMENTO, NOME, NOME_FILE, ID_SELECT, 
        UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, VALIDO, TIPO)
select stats_hibernate_sequence.nextval id,
       0 version,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       'Totale Residenti per Anno di Nascita e Stato Civile (ad oggi)' nome,
       'Totale Residenti per Anno di Nascita e Stato Civile (ad oggi)' nome_file,
       ss.id id_select,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       'Y' valido,
       ss.tipo
  from stats_select ss
 where ss.nome = 'Totale Residenti per Anno di Nascita e Stato Civile (ad oggi)'
   and not exists (select 1 from stats_estrazioni b
                    where b.id_select = ss.id)
/
insert into stats_estrazioni
       (ID, VERSION, DATA_CREAZIONE, ENTE, DATA_AGGIORNAMENTO, NOME, NOME_FILE, ID_SELECT, 
        UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, VALIDO, TIPO)
select stats_hibernate_sequence.nextval id,
       0 version,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       'Totale Residenti per Anno di Nascita (storico)' nome,
       'Totale Residenti per Anno di Nascita (storico)' nome_file,
       ss.id id_select,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       'Y' valido,
       ss.tipo
  from stats_select ss
 where ss.nome = 'Totale Residenti per Anno di Nascita (storico)'
   and not exists (select 1 from stats_estrazioni b
                    where b.id_select = ss.id)
/
insert into stats_estrazioni
       (ID, VERSION, DATA_CREAZIONE, ENTE, DATA_AGGIORNAMENTO, NOME, NOME_FILE, ID_SELECT, 
        UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, VALIDO, TIPO)
select stats_hibernate_sequence.nextval id,
       0 version,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       'Totale Residenti per Anno di Nascita (ad oggi)' nome,
       'Totale Residenti per Anno di Nascita (ad oggi)' nome_file,
       ss.id id_select,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       'Y' valido,
       ss.tipo
  from stats_select ss
 where ss.nome = 'Totale Residenti per Anno di Nascita (ad oggi)'
   and not exists (select 1 from stats_estrazioni b
                    where b.id_select = ss.id)
/
insert into stats_estrazioni
       (ID, VERSION, DATA_CREAZIONE, ENTE, DATA_AGGIORNAMENTO, NOME, NOME_FILE, ID_SELECT, 
        UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, VALIDO, TIPO)
select stats_hibernate_sequence.nextval id,
       0 version,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       'Elenco Residenti per Unita Territoriale ''1'' (ad oggi)' nome,
       'Elenco Residenti per Unita Territoriale ''1'' (ad oggi)' nome_file,
       ss.id id_select,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       'Y' valido,
       ss.tipo
  from stats_select ss
 where ss.nome = 'Elenco Residenti per Unita Territoriale ''1'' (ad oggi)'
   and not exists (select 1 from stats_estrazioni b
                    where b.id_select = ss.id)
/
insert into stats_estrazioni
       (ID, VERSION, DATA_CREAZIONE, ENTE, DATA_AGGIORNAMENTO, NOME, NOME_FILE, ID_SELECT, 
        UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, VALIDO, TIPO)
select stats_hibernate_sequence.nextval id,
       0 version,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       'Elenco Residenti con Recapiti (ad oggi)' nome,
       'Elenco Residenti con Recapiti (ad oggi)' nome_file,
       ss.id id_select,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       'Y' valido,
       ss.tipo
  from stats_select ss
 where ss.nome = 'Elenco Residenti con Recapiti (ad oggi)'
   and not exists (select 1 from stats_estrazioni b
                    where b.id_select = ss.id)
/
