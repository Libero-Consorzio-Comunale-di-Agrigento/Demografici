--liquibase formatted sql
--changeset amonopoli:202501231600_5 runOnChange:true stripComments:false
insert into stats_order_by_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, TIPO_ORDINAMENTO, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       ss.id id_select,
       '0' sequenza,
       'ASC' tipo_ordinamento,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento
  from stats_campi_viste scv, stats_select ss
 where scv.nome = 'ANNO_NASCITA'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Totale Residenti per Anno di Nascita (ad oggi)'
   and not exists (select 1 from stats_order_by_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id
                      and b.sequenza       = '0')
/
insert into stats_order_by_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, TIPO_ORDINAMENTO, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       ss.id id_select,
       '0' sequenza,
       'ASC' tipo_ordinamento,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento
  from stats_campi_viste scv, stats_select ss
 where scv.nome = 'ANNO_NASCITA'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Totale Residenti per Anno di Nascita e Stato Civile (ad oggi)'
   and not exists (select 1 from stats_order_by_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id
                      and b.sequenza       = '0')
/
insert into stats_order_by_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, TIPO_ORDINAMENTO, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       ss.id id_select,
       '1' sequenza,
       'ASC' tipo_ordinamento,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento
  from stats_campi_viste scv, stats_select ss
 where scv.nome = 'DES_STATO_CIVILE'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Totale Residenti per Anno di Nascita e Stato Civile (ad oggi)'
   and not exists (select 1 from stats_order_by_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id
                      and b.sequenza       = '1')
/
insert into stats_order_by_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, TIPO_ORDINAMENTO, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       ss.id id_select,
       '1' sequenza,
       'ASC' tipo_ordinamento,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento
  from stats_campi_viste scv, stats_select ss
 where scv.nome = 'NUMERO_CIVICO'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Elenco Residenti con Recapiti (ad oggi)'
   and not exists (select 1 from stats_order_by_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id
                      and b.sequenza       = '1')
/
insert into stats_order_by_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, TIPO_ORDINAMENTO, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       ss.id id_select,
       '10' sequenza,
       'ASC' tipo_ordinamento,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento
  from stats_campi_viste scv, stats_select ss
 where scv.nome = 'CODICE_FAMIGLIA'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Elenco Residenti con Recapiti (ad oggi)'
   and not exists (select 1 from stats_order_by_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id
                      and b.sequenza       = '10')
/
insert into stats_order_by_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, TIPO_ORDINAMENTO, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       ss.id id_select,
       '11' sequenza,
       'ASC' tipo_ordinamento,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento
  from stats_campi_viste scv, stats_select ss
 where scv.nome = 'SEQUENZA_PAR'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Elenco Residenti con Recapiti (ad oggi)'
   and not exists (select 1 from stats_order_by_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id
                      and b.sequenza       = '11')
/
insert into stats_order_by_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, TIPO_ORDINAMENTO, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       ss.id id_select,
       '4' sequenza,
       'ASC' tipo_ordinamento,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento
  from stats_campi_viste scv, stats_select ss
 where scv.nome = 'SUB_INTERNO'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Elenco Residenti con Recapiti (ad oggi)'
   and not exists (select 1 from stats_order_by_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id
                      and b.sequenza       = '4')
/
insert into stats_order_by_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, TIPO_ORDINAMENTO, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       ss.id id_select,
       '3' sequenza,
       'ASC' tipo_ordinamento,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento
  from stats_campi_viste scv, stats_select ss
 where scv.nome = 'INTERNO'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Elenco Residenti con Recapiti (ad oggi)'
   and not exists (select 1 from stats_order_by_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id
                      and b.sequenza       = '3')
/
insert into stats_order_by_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, TIPO_ORDINAMENTO, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       ss.id id_select,
       '2' sequenza,
       'ASC' tipo_ordinamento,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento
  from stats_campi_viste scv, stats_select ss
 where scv.nome = 'SUFFISSO'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Elenco Residenti con Recapiti (ad oggi)'
   and not exists (select 1 from stats_order_by_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id
                      and b.sequenza       = '2')
/
insert into stats_order_by_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, TIPO_ORDINAMENTO, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       ss.id id_select,
       '0' sequenza,
       'ASC' tipo_ordinamento,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento
  from stats_campi_viste scv, stats_select ss
 where scv.nome = 'DENOMINAZIONE_VIA_ORDINAMENTO'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Elenco Residenti con Recapiti (ad oggi)'
   and not exists (select 1 from stats_order_by_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id
                      and b.sequenza       = '0')
/
insert into stats_order_by_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, TIPO_ORDINAMENTO, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       ss.id id_select,
       '1' sequenza,
       'ASC' tipo_ordinamento,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento
  from stats_campi_viste scv, stats_select ss
 where scv.nome = 'ANNO_NASCITA'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Totale Residenti per Anno di Nascita (storico)'
   and not exists (select 1 from stats_order_by_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id
                      and b.sequenza       = '1')
/
insert into stats_order_by_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, TIPO_ORDINAMENTO, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       ss.id id_select,
       '0' sequenza,
       'ASC' tipo_ordinamento,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento
  from stats_campi_viste scv, stats_select ss
 where scv.nome = 'DATA_RIF_EDIT'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Totale Residenti per Anno di Nascita (storico)'
   and not exists (select 1 from stats_order_by_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id
                      and b.sequenza       = '0')
/
insert into stats_order_by_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, TIPO_ORDINAMENTO, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       ss.id id_select,
       '2' sequenza,
       'ASC' tipo_ordinamento,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento
  from stats_campi_viste scv, stats_select ss
 where scv.nome = 'DES_STATO_CIVILE'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Totale Residenti per Anno di Nascita e Stato Civile (storico)'
   and not exists (select 1 from stats_order_by_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id
                      and b.sequenza       = '2')
/
insert into stats_order_by_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, TIPO_ORDINAMENTO, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       ss.id id_select,
       '1' sequenza,
       'ASC' tipo_ordinamento,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento
  from stats_campi_viste scv, stats_select ss
 where scv.nome = 'ANNO_NASCITA'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Totale Residenti per Anno di Nascita e Stato Civile (storico)'
   and not exists (select 1 from stats_order_by_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id
                      and b.sequenza       = '1')
/
insert into stats_order_by_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, TIPO_ORDINAMENTO, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       ss.id id_select,
       '0' sequenza,
       'ASC' tipo_ordinamento,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento
  from stats_campi_viste scv, stats_select ss
 where scv.nome = 'DATA_RIF_EDIT'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Totale Residenti per Anno di Nascita e Stato Civile (storico)'
   and not exists (select 1 from stats_order_by_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id
                      and b.sequenza       = '0')
/
insert into stats_order_by_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, TIPO_ORDINAMENTO, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       ss.id id_select,
       '4' sequenza,
       'ASC' tipo_ordinamento,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento
  from stats_campi_viste scv, stats_select ss
 where scv.nome = 'INTERNO'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Elenco Residenti per Unita Territoriale ''1'' (ad oggi)'
   and not exists (select 1 from stats_order_by_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id
                      and b.sequenza       = '4')
/
insert into stats_order_by_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, TIPO_ORDINAMENTO, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       ss.id id_select,
       '2' sequenza,
       'ASC' tipo_ordinamento,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento
  from stats_campi_viste scv, stats_select ss
 where scv.nome = 'NUMERO_CIVICO'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Elenco Residenti per Unita Territoriale ''1'' (ad oggi)'
   and not exists (select 1 from stats_order_by_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id
                      and b.sequenza       = '2')
/
insert into stats_order_by_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, TIPO_ORDINAMENTO, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       ss.id id_select,
       '1' sequenza,
       'ASC' tipo_ordinamento,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento
  from stats_campi_viste scv, stats_select ss
 where scv.nome = 'DENOMINAZIONE_VIA_ORDINAMENTO'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Elenco Residenti per Unita Territoriale ''1'' (ad oggi)'
   and not exists (select 1 from stats_order_by_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id
                      and b.sequenza       = '1')
/
insert into stats_order_by_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, TIPO_ORDINAMENTO, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       ss.id id_select,
       '5' sequenza,
       'ASC' tipo_ordinamento,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento
  from stats_campi_viste scv, stats_select ss
 where scv.nome = 'CODICE_FAMIGLIA'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Elenco Residenti per Unita Territoriale ''1'' (ad oggi)'
   and not exists (select 1 from stats_order_by_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id
                      and b.sequenza       = '5')
/
insert into stats_order_by_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, TIPO_ORDINAMENTO, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       ss.id id_select,
       '0' sequenza,
       'ASC' tipo_ordinamento,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento
  from stats_campi_viste scv, stats_select ss
 where scv.nome = 'CODICE_SUDDIVISIONE_1'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Elenco Residenti per Unita Territoriale ''1'' (ad oggi)'
   and not exists (select 1 from stats_order_by_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id
                      and b.sequenza       = '0')
/
insert into stats_order_by_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, TIPO_ORDINAMENTO, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       ss.id id_select,
       '6' sequenza,
       'ASC' tipo_ordinamento,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento
  from stats_campi_viste scv, stats_select ss
 where scv.nome = 'SEQUENZA_PAR'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Elenco Residenti per Unita Territoriale ''1'' (ad oggi)'
   and not exists (select 1 from stats_order_by_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id
                      and b.sequenza       = '6')
/
insert into stats_order_by_select
       (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, DATA_AGGIORNAMENTO,
        ID_SELECT, SEQUENZA, TIPO_ORDINAMENTO, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO)
select stats_hibernate_sequence.nextval id,
       0 version,
       scv.id id_campo_vista,
       sysdate data_creazione,
       f_STATS_codice_ente() ente,
       sysdate data_aggiornamento,
       ss.id id_select,
       '3' sequenza,
       'ASC' tipo_ordinamento,
       'ADS' utente_creazione,
       'ADS' utente_aggiornamento
  from stats_campi_viste scv, stats_select ss
 where scv.nome = 'SUFFISSO'
   and scv.tipo_funzione = 'NO_OP'
   and scv.id_vista = ss.id_vista
   and ss.nome = 'Elenco Residenti per Unita Territoriale ''1'' (ad oggi)'
   and not exists (select 1 from stats_order_by_select b
                    where b.id_campo_vista = scv.id
                      and b.id_select      = ss.id
                      and b.sequenza       = '3')
/
