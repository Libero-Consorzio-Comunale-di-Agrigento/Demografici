--liquibase formatted sql
--changeset amonopoli:202411210820_1 runAlways:true stripComments:false
insert into STATS_CATEGORIE 
       (ID, VERSION, AREA, DATA_CREAZIONE, DESCRIZIONE, ENTE, DATA_AGGIORNAMENTO, NOME, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO)
select stats_hibernate_sequence.nextval
     , 0
     , 'DE'
     , sysdate
     , 'ANAGRAFE - Estrazioni Varie'
     , f_STATS_codice_ente()
     , sysdate
     , 'Anagrafe'
     , 'ADS'
     , 'ADS'
  from dual
 where not exists (select 1 from stats_categorie
                    where nome = 'Anagrafe')
/
insert into STATS_CATEGORIE 
       (ID, VERSION, AREA, DATA_CREAZIONE, DESCRIZIONE, ENTE, DATA_AGGIORNAMENTO, NOME, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO)
select stats_hibernate_sequence.nextval
     , 0
     , 'DE'
     , sysdate
     , 'ELETTORALE - Estrazioni Varie'
     , f_STATS_codice_ente()
     , sysdate
     , 'Elettorale'
     , 'ADS'
     , 'ADS'
  from dual
 where not exists (select 1 from stats_categorie
                    where nome = 'Elettorale')
/
insert into STATS_CATEGORIE 
       (ID, VERSION, AREA, DATA_CREAZIONE, DESCRIZIONE, ENTE, DATA_AGGIORNAMENTO, NOME, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO)
select stats_hibernate_sequence.nextval
     , 0
     , 'DE'
     , sysdate
     , 'STATISTICHE - Estrazioni Varie'
     , f_STATS_codice_ente()
     , sysdate
     , 'Statistiche'
     , 'ADS'
     , 'ADS'
  from dual
 where not exists (select 1 from stats_categorie
                    where nome = 'Statistiche')
/
insert into STATS_CATEGORIE 
       (ID, VERSION, AREA, DATA_CREAZIONE, DESCRIZIONE, ENTE, DATA_AGGIORNAMENTO, NOME, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO)
select stats_hibernate_sequence.nextval
     , 0
     , 'DE'
     , sysdate
     , 'SubQuery'
     , f_STATS_codice_ente()
     , sysdate
     , 'SubQuery'
     , 'ADS'
     , 'ADS'
  from dual
 where not exists (select 1 from stats_categorie
                    where nome = 'SubQuery')
/
