--liquibase formatted sql
--changeset amonopoli:202501231600_2 runOnChange:true stripComments:false
insert into stats_campi_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, ETICHETTA, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, DISPLAY, LABEL_SIZE)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       'Anno Nascita' etichetta,
       sysdate data_aggiornamento,
       ss.id id_select,
       0 sequenza,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       '' display,
       '' label_size
  from stats_campi_viste scv, stats_select ss
 where scv.id_vista  = ss.id_vista
   and scv.nome = 'ANNO_NASCITA'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Totale Residenti per Anno di Nascita (ad oggi)'
   and not exists (select 1 from stats_campi_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id)
/
insert into stats_campi_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, ETICHETTA, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, DISPLAY, LABEL_SIZE)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       'Flag Iscritto Preliminare (SI/NO)' etichetta,
       sysdate data_aggiornamento,
       ss.id id_select,
       1 sequenza,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       '' display,
       '' label_size
  from stats_campi_viste scv, stats_select ss
 where scv.id_vista  = ss.id_vista
   and scv.nome = 'FLAG_ISCRITTO_PRELIMINARE'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Totale Residenti per Anno di Nascita (ad oggi)'
   and not exists (select 1 from stats_campi_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id)
/
insert into stats_campi_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, ETICHETTA, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, DISPLAY, LABEL_SIZE)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       'Flag Residente (SI/NO)' etichetta,
       sysdate data_aggiornamento,
       ss.id id_select,
       2 sequenza,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       '' display,
       '' label_size
  from stats_campi_viste scv, stats_select ss
 where scv.id_vista  = ss.id_vista
   and scv.nome = 'FLAG_RESIDENTE'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Totale Residenti per Anno di Nascita (ad oggi)'
   and not exists (select 1 from stats_campi_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id)
/
insert into stats_campi_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, ETICHETTA, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, DISPLAY, LABEL_SIZE)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       'Totale' etichetta,
       sysdate data_aggiornamento,
       ss.id id_select,
       3 sequenza,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       '' display,
       '' label_size
  from stats_campi_viste scv, stats_select ss
 where scv.id_vista  = ss.id_vista
   and scv.nome = 'MATRICOLA'
   and scv.tipo_funzione = 'COUNT'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Totale Residenti per Anno di Nascita (ad oggi)'
   and not exists (select 1 from stats_campi_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id)
/
insert into stats_campi_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, ETICHETTA, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, DISPLAY, LABEL_SIZE)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       'Anno Nascita' etichetta,
       sysdate data_aggiornamento,
       ss.id id_select,
       0 sequenza,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       '' display,
       '' label_size
  from stats_campi_viste scv, stats_select ss
 where scv.id_vista  = ss.id_vista
   and scv.nome = 'ANNO_NASCITA'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Totale Residenti per Anno di Nascita e Stato Civile (ad oggi)'
   and not exists (select 1 from stats_campi_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id)
/
insert into stats_campi_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, ETICHETTA, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, DISPLAY, LABEL_SIZE)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       'Descrizione Stato Civile' etichetta,
       sysdate data_aggiornamento,
       ss.id id_select,
       1 sequenza,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       '' display,
       '' label_size
  from stats_campi_viste scv, stats_select ss
 where scv.id_vista  = ss.id_vista
   and scv.nome = 'DES_STATO_CIVILE'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Totale Residenti per Anno di Nascita e Stato Civile (ad oggi)'
   and not exists (select 1 from stats_campi_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id)
/
insert into stats_campi_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, ETICHETTA, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, DISPLAY, LABEL_SIZE)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       'Totale' etichetta,
       sysdate data_aggiornamento,
       ss.id id_select,
       2 sequenza,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       '' display,
       '' label_size
  from stats_campi_viste scv, stats_select ss
 where scv.id_vista  = ss.id_vista
   and scv.nome = 'MATRICOLA'
   and scv.tipo_funzione = 'COUNT'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Totale Residenti per Anno di Nascita e Stato Civile (ad oggi)'
   and not exists (select 1 from stats_campi_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id)
/
insert into stats_campi_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, ETICHETTA, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, DISPLAY, LABEL_SIZE)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       'Cognome' etichetta,
       sysdate data_aggiornamento,
       ss.id id_select,
       0 sequenza,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       '' display,
       'F2' label_size
  from stats_campi_viste scv, stats_select ss
 where scv.id_vista  = ss.id_vista
   and scv.nome = 'COGNOME'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Elenco Residenti con Recapiti (ad oggi)'
   and not exists (select 1 from stats_campi_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id)
/
insert into stats_campi_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, ETICHETTA, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, DISPLAY, LABEL_SIZE)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       'Nome' etichetta,
       sysdate data_aggiornamento,
       ss.id id_select,
       1 sequenza,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       '' display,
       'F2' label_size
  from stats_campi_viste scv, stats_select ss
 where scv.id_vista  = ss.id_vista
   and scv.nome = 'NOME'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Elenco Residenti con Recapiti (ad oggi)'
   and not exists (select 1 from stats_campi_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id)
/
insert into stats_campi_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, ETICHETTA, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, DISPLAY, LABEL_SIZE)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       'Indirizzo (con Interno)' etichetta,
       sysdate data_aggiornamento,
       ss.id id_select,
       2 sequenza,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       '' display,
       'F3' label_size
  from stats_campi_viste scv, stats_select ss
 where scv.id_vista  = ss.id_vista
   and scv.nome = 'INDIRIZZO_INT'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Elenco Residenti con Recapiti (ad oggi)'
   and not exists (select 1 from stats_campi_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id)
/
insert into stats_campi_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, ETICHETTA, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, DISPLAY, LABEL_SIZE)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       'Codice Famiglia' etichetta,
       sysdate data_aggiornamento,
       ss.id id_select,
       3 sequenza,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       '' display,
       'F1' label_size
  from stats_campi_viste scv, stats_select ss
 where scv.id_vista  = ss.id_vista
   and scv.nome = 'CODICE_FAMIGLIA'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Elenco Residenti con Recapiti (ad oggi)'
   and not exists (select 1 from stats_campi_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id)
/
insert into stats_campi_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, ETICHETTA, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, DISPLAY, LABEL_SIZE)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       'Descrizione Rapporto Parentela' etichetta,
       sysdate data_aggiornamento,
       ss.id id_select,
       4 sequenza,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       '' display,
       'F2' label_size
  from stats_campi_viste scv, stats_select ss
 where scv.id_vista  = ss.id_vista
   and scv.nome = 'DES_RAPPORTO_PAR'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Elenco Residenti con Recapiti (ad oggi)'
   and not exists (select 1 from stats_campi_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id)
/
insert into stats_campi_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, ETICHETTA, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, DISPLAY, LABEL_SIZE)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       'Recapito Cellulare' etichetta,
       sysdate data_aggiornamento,
       ss.id id_select,
       5 sequenza,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       '' display,
       'F2' label_size
  from stats_campi_viste scv, stats_select ss
 where scv.id_vista  = ss.id_vista
   and scv.nome = 'RECAPITO_CELLULARE'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Elenco Residenti con Recapiti (ad oggi)'
   and not exists (select 1 from stats_campi_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id)
/
insert into stats_campi_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, ETICHETTA, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, DISPLAY, LABEL_SIZE)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       'Recapito Telefono Fisso' etichetta,
       sysdate data_aggiornamento,
       ss.id id_select,
       6 sequenza,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       '' display,
       'F2' label_size
  from stats_campi_viste scv, stats_select ss
 where scv.id_vista  = ss.id_vista
   and scv.nome = 'RECAPITO_TELEFONO_FISSO'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Elenco Residenti con Recapiti (ad oggi)'
   and not exists (select 1 from stats_campi_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id)
/
insert into stats_campi_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, ETICHETTA, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, DISPLAY, LABEL_SIZE)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       'Data di Riferimento' etichetta,
       sysdate data_aggiornamento,
       ss.id id_select,
       0 sequenza,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       '' display,
       '' label_size
  from stats_campi_viste scv, stats_select ss
 where scv.id_vista  = ss.id_vista
   and scv.nome = 'DATA_RIF_EDIT'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Totale Residenti per Anno di Nascita (storico)'
   and not exists (select 1 from stats_campi_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id)
/
insert into stats_campi_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, ETICHETTA, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, DISPLAY, LABEL_SIZE)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       'Anno Nascita' etichetta,
       sysdate data_aggiornamento,
       ss.id id_select,
       1 sequenza,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       '' display,
       '' label_size
  from stats_campi_viste scv, stats_select ss
 where scv.id_vista  = ss.id_vista
   and scv.nome = 'ANNO_NASCITA'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Totale Residenti per Anno di Nascita (storico)'
   and not exists (select 1 from stats_campi_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id)
/
insert into stats_campi_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, ETICHETTA, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, DISPLAY, LABEL_SIZE)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       'Somma Totale' etichetta,
       sysdate data_aggiornamento,
       ss.id id_select,
       2 sequenza,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       '' display,
       '' label_size
  from stats_campi_viste scv, stats_select ss
 where scv.id_vista  = ss.id_vista
   and scv.nome = 'TOTALE'
   and scv.tipo_funzione = 'SUM'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Totale Residenti per Anno di Nascita (storico)'
   and not exists (select 1 from stats_campi_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id)
/
insert into stats_campi_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, ETICHETTA, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, DISPLAY, LABEL_SIZE)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       'Data di Riferimento (gg/mm/aaaa)' etichetta,
       sysdate data_aggiornamento,
       ss.id id_select,
       0 sequenza,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       '' display,
       '' label_size
  from stats_campi_viste scv, stats_select ss
 where scv.id_vista  = ss.id_vista
   and scv.nome = 'DATA_RIF_EDIT'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Totale Residenti per Anno di Nascita e Stato Civile (storico)'
   and not exists (select 1 from stats_campi_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id)
/
insert into stats_campi_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, ETICHETTA, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, DISPLAY, LABEL_SIZE)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       'Anno Nascita' etichetta,
       sysdate data_aggiornamento,
       ss.id id_select,
       1 sequenza,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       '' display,
       '' label_size
  from stats_campi_viste scv, stats_select ss
 where scv.id_vista  = ss.id_vista
   and scv.nome = 'ANNO_NASCITA'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Totale Residenti per Anno di Nascita e Stato Civile (storico)'
   and not exists (select 1 from stats_campi_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id)
/
insert into stats_campi_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, ETICHETTA, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, DISPLAY, LABEL_SIZE)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       'Descrizione Stato Civile' etichetta,
       sysdate data_aggiornamento,
       ss.id id_select,
       2 sequenza,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       '' display,
       '' label_size
  from stats_campi_viste scv, stats_select ss
 where scv.id_vista  = ss.id_vista
   and scv.nome = 'DES_STATO_CIVILE'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Totale Residenti per Anno di Nascita e Stato Civile (storico)'
   and not exists (select 1 from stats_campi_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id)
/
insert into stats_campi_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, ETICHETTA, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, DISPLAY, LABEL_SIZE)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       'Somma Totale' etichetta,
       sysdate data_aggiornamento,
       ss.id id_select,
       3 sequenza,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       '' display,
       '' label_size
  from stats_campi_viste scv, stats_select ss
 where scv.id_vista  = ss.id_vista
   and scv.nome = 'TOTALE'
   and scv.tipo_funzione = 'SUM'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Totale Residenti per Anno di Nascita e Stato Civile (storico)'
   and not exists (select 1 from stats_campi_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id)
/
insert into stats_campi_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, ETICHETTA, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, DISPLAY, LABEL_SIZE)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       'Cognome' etichetta,
       sysdate data_aggiornamento,
       ss.id id_select,
       0 sequenza,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       '' display,
       'F2' label_size
  from stats_campi_viste scv, stats_select ss
 where scv.id_vista  = ss.id_vista
   and scv.nome = 'COGNOME'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Elenco Residenti per Unita Territoriale ''1'' (ad oggi)'
   and not exists (select 1 from stats_campi_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id)
/
insert into stats_campi_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, ETICHETTA, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, DISPLAY, LABEL_SIZE)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       'Nome' etichetta,
       sysdate data_aggiornamento,
       ss.id id_select,
       1 sequenza,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       '' display,
       'F2' label_size
  from stats_campi_viste scv, stats_select ss
 where scv.id_vista  = ss.id_vista
   and scv.nome = 'NOME'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Elenco Residenti per Unita Territoriale ''1'' (ad oggi)'
   and not exists (select 1 from stats_campi_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id)
/
insert into stats_campi_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, ETICHETTA, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, DISPLAY, LABEL_SIZE)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       'Sesso' etichetta,
       sysdate data_aggiornamento,
       ss.id id_select,
       2 sequenza,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       '' display,
       'F1' label_size
  from stats_campi_viste scv, stats_select ss
 where scv.id_vista  = ss.id_vista
   and scv.nome = 'SESSO'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Elenco Residenti per Unita Territoriale ''1'' (ad oggi)'
   and not exists (select 1 from stats_campi_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id)
/
insert into stats_campi_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, ETICHETTA, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, DISPLAY, LABEL_SIZE)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       'Data Nascita (gg/mm/aaaa)' etichetta,
       sysdate data_aggiornamento,
       ss.id id_select,
       3 sequenza,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       '' display,
       'F1' label_size
  from stats_campi_viste scv, stats_select ss
 where scv.id_vista  = ss.id_vista
   and scv.nome = 'DATA_NASCITA_EDIT'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Elenco Residenti per Unita Territoriale ''1'' (ad oggi)'
   and not exists (select 1 from stats_campi_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id)
/
insert into stats_campi_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, ETICHETTA, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, DISPLAY, LABEL_SIZE)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       'Indirizzo (con Interno)' etichetta,
       sysdate data_aggiornamento,
       ss.id id_select,
       4 sequenza,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       '' display,
       'F3' label_size
  from stats_campi_viste scv, stats_select ss
 where scv.id_vista  = ss.id_vista
   and scv.nome = 'INDIRIZZO_INT'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Elenco Residenti per Unita Territoriale ''1'' (ad oggi)'
   and not exists (select 1 from stats_campi_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id)
/
insert into stats_campi_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, ETICHETTA, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, DISPLAY, LABEL_SIZE)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       'Descrizione Suddivisione per Unita Territoriale 1' etichetta,
       sysdate data_aggiornamento,
       ss.id id_select,
       5 sequenza,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       '' display,
       'F2' label_size
  from stats_campi_viste scv, stats_select ss
 where scv.id_vista  = ss.id_vista
   and scv.nome = 'DES_SUDDIVISIONE_1'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Elenco Residenti per Unita Territoriale ''1'' (ad oggi)'
   and not exists (select 1 from stats_campi_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id)
/
