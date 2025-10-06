--liquibase formatted sql
--changeset amonopoli:202501221200 runOnChange:true
insert into stats_registro 
       (ID, VERSION, CHIAVE, COMMENTO, DATA_CREAZIONE, DATA_AGGIORNAMENTO, STRINGA, 
        UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, VALORE, ENTE)
select (select nvl(max(id),0)+1 from stats_registro)
     , 0
     , '/CONFIG/STATS/'||f_stats_codice_ente()
     , null
     , sysdate
     , sysdate
     , 'LICENZA_ATTIVA'
     , 'GSD'
     , 'GSD'
     , 'S'
     , f_stats_codice_ente()
  from dual
 where not exists (select 1 from stats_registro
                    where chiave  = '/CONFIG/STATS/'||f_stats_codice_ente()
                      and stringa = 'LICENZA_ATTIVA')
/
