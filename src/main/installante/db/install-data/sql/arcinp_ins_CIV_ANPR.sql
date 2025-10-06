--liquibase formatted sql
--changeset amonopoli:202301251525_1 runOnChange:true
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
