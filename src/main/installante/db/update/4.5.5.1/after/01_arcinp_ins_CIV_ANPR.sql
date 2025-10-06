--liquibase formatted sql
--changeset snocca:202211151242
insert into arcinp
       (parametro, valore, descrizione, gruppo, note, flag_visibile)
select 'CIV_ANPR'
     , 'S'
     , 'INTEGR. ANPR-ST.CIV'
     , 'CIV'
     , 'Valori previsti: ''S'' - ''N''.
Valorizzato a ''S'' attiva l''integrazione con ANPR nelle funzioni di ricerca soggetti'
     , 'S'
  from dual
 where not exists (select 'x' from arcinp
                    where parametro = 'CIV_ANPR')
/
