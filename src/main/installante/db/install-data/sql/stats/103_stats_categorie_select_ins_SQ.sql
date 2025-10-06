--liquibase formatted sql
--changeset amonopoli:202411210820_2 runOnChange:true stripComments:false
insert into stats_categorie_select 
       (ID, VERSION, ID_CATEGORIA, DATA_CREAZIONE, ENTE, DATA_AGGIORNAMENTO, ID_SELECT, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO)
select stats_hibernate_sequence.nextval id
     , 0 version
     , c.id
     , sysdate data_creazione
     , f_STATS_codice_ente() ente
     , sysdate data_aggiornamento
     , s.id id_select
     , 'ADS' utente_creazione
     , 'ADS' utete_aggiornamento
  from stats_categorie c
     , stats_select s
 where s.tipo_select = 'SQ'
   and c.nome = 'SubQuery'
   and not exists (select 1 from stats_categorie_select
                    where id_categoria = c.id
                      and id_select    = s.id)
/
