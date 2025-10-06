--liquibase formatted sql
--changeset amonopoli:202501231600_3 runOnChange:true stripComments:false
insert into stats_where_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, DATA_AGGIORNAMENTO,
        ID_SELECT, ID_SELECT_IN, TIPO_WHERE, 
        UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, ETICHETTA, SEQUENZA, 
        VALORE_DEFAULT_DATA, VALORE_DEFAULT_TESTO, VALORE_DEFAULT_NUMERO, PROMPT)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       ss.id id_select,
       ss_SQ.id id_select_in,
       'EQ' tipo_where,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       'Residente' etichetta,
       '0' sequenza,
       '' valore_default_data,
       'SI' valore_default_testo,
       '' valore_default_numero,
       'N' prompt
  from stats_select ss_sq, stats_campi_viste scv, stats_select ss
 where ss_SQ.nome (+) = ''
   and ss_SQ.tipo (+) = ss.tipo
   and scv.nome = 'FLAG_RESIDENTE'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Totale Residenti per Anno di Nascita (ad oggi)'
   and not exists (select 1 from stats_where_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id
                      and b.sequenza       = '0')
/
insert into stats_where_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, DATA_AGGIORNAMENTO,
        ID_SELECT, ID_SELECT_IN, TIPO_WHERE, 
        UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, ETICHETTA, SEQUENZA, 
        VALORE_DEFAULT_DATA, VALORE_DEFAULT_TESTO, VALORE_DEFAULT_NUMERO, PROMPT)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       ss.id id_select,
       ss_SQ.id id_select_in,
       'EQ' tipo_where,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       'Residente' etichetta,
       '0' sequenza,
       '' valore_default_data,
       'SI' valore_default_testo,
       '' valore_default_numero,
       'N' prompt
  from stats_select ss_sq, stats_campi_viste scv, stats_select ss
 where ss_SQ.nome (+) = ''
   and ss_SQ.tipo (+) = ss.tipo
   and scv.nome = 'FLAG_RESIDENTE'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Totale Residenti per Anno di Nascita e Stato Civile (ad oggi)'
   and not exists (select 1 from stats_where_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id
                      and b.sequenza       = '0')
/
insert into stats_where_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, DATA_AGGIORNAMENTO,
        ID_SELECT, ID_SELECT_IN, TIPO_WHERE, 
        UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, ETICHETTA, SEQUENZA, 
        VALORE_DEFAULT_DATA, VALORE_DEFAULT_TESTO, VALORE_DEFAULT_NUMERO, PROMPT)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       ss.id id_select,
       ss_SQ.id id_select_in,
       'EQ' tipo_where,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       'Reisdente' etichetta,
       '0' sequenza,
       '' valore_default_data,
       'SI' valore_default_testo,
       '' valore_default_numero,
       'N' prompt
  from stats_select ss_sq, stats_campi_viste scv, stats_select ss
 where ss_SQ.nome (+) = ''
   and ss_SQ.tipo (+) = ss.tipo
   and scv.nome = 'FLAG_RESIDENTE'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Elenco Residenti con Recapiti (ad oggi)'
   and not exists (select 1 from stats_where_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id
                      and b.sequenza       = '0')
/
insert into stats_where_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, DATA_AGGIORNAMENTO,
        ID_SELECT, ID_SELECT_IN, TIPO_WHERE, 
        UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, ETICHETTA, SEQUENZA, 
        VALORE_DEFAULT_DATA, VALORE_DEFAULT_TESTO, VALORE_DEFAULT_NUMERO, PROMPT)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       ss.id id_select,
       ss_SQ.id id_select_in,
       'IN' tipo_where,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       'Data di Riferimento' etichetta,
       '0' sequenza,
       '' valore_default_data,
       '' valore_default_testo,
       '' valore_default_numero,
       'Y' prompt
  from stats_select ss_sq, stats_campi_viste scv, stats_select ss
 where ss_SQ.nome (+) = 'Data Storico'
   and ss_SQ.tipo (+) = ss.tipo
   and scv.nome = 'DATA_RIF_EDIT'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Totale Residenti per Anno di Nascita (storico)'
   and not exists (select 1 from stats_where_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id
                      and b.sequenza       = '0')
/
insert into stats_where_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, DATA_AGGIORNAMENTO,
        ID_SELECT, ID_SELECT_IN, TIPO_WHERE, 
        UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, ETICHETTA, SEQUENZA, 
        VALORE_DEFAULT_DATA, VALORE_DEFAULT_TESTO, VALORE_DEFAULT_NUMERO, PROMPT)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       ss.id id_select,
       ss_SQ.id id_select_in,
       'IN' tipo_where,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       'Data di Riferimento' etichetta,
       '0' sequenza,
       '' valore_default_data,
       '' valore_default_testo,
       '' valore_default_numero,
       'Y' prompt
  from stats_select ss_sq, stats_campi_viste scv, stats_select ss
 where ss_SQ.nome (+) = 'Data Storico'
   and ss_SQ.tipo (+) = ss.tipo
   and scv.nome = 'DATA_RIF_EDIT'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Totale Residenti per Anno di Nascita e Stato Civile (storico)'
   and not exists (select 1 from stats_where_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id
                      and b.sequenza       = '0')
/
insert into stats_where_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, DATA_AGGIORNAMENTO,
        ID_SELECT, ID_SELECT_IN, TIPO_WHERE, 
        UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, ETICHETTA, SEQUENZA, 
        VALORE_DEFAULT_DATA, VALORE_DEFAULT_TESTO, VALORE_DEFAULT_NUMERO, PROMPT)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       ss.id id_select,
       ss_SQ.id id_select_in,
       'IS_NOT_NULL' tipo_where,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       'Esiste Unita Territoriale 1' etichetta,
       '0' sequenza,
       '' valore_default_data,
       '' valore_default_testo,
       '' valore_default_numero,
       'N' prompt
  from stats_select ss_sq, stats_campi_viste scv, stats_select ss
 where ss_SQ.nome (+) = ''
   and ss_SQ.tipo (+) = ss.tipo
   and scv.nome = 'DES_UNITA_TERRITORIALE_1'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Elenco Residenti per Unita Territoriale ''1'' (ad oggi)'
   and not exists (select 1 from stats_where_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id
                      and b.sequenza       = '0')
/
insert into stats_where_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, DATA_AGGIORNAMENTO,
        ID_SELECT, ID_SELECT_IN, TIPO_WHERE, 
        UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, ETICHETTA, SEQUENZA, 
        VALORE_DEFAULT_DATA, VALORE_DEFAULT_TESTO, VALORE_DEFAULT_NUMERO, PROMPT)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       ss.id id_select,
       ss_SQ.id id_select_in,
       'IN' tipo_where,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento,
       'Suddivisione' etichetta,
       '2' sequenza,
       '' valore_default_data,
       '' valore_default_testo,
       '' valore_default_numero,
       'Y' prompt
  from stats_select ss_sq, stats_campi_viste scv, stats_select ss
 where ss_SQ.nome (+) = 'Suddivisione per Unita Territoriale 1 (Descrizione)'
   and ss_SQ.tipo (+) = ss.tipo
   and scv.nome = 'DES_SUDDIVISIONE_1'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Elenco Residenti per Unita Territoriale ''1'' (ad oggi)'
   and not exists (select 1 from stats_where_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id
                      and b.sequenza       = '2')
/
