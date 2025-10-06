--liquibase formatted sql
--changeset amonopoli:202501091115 runOnChange:true
insert into arcinp
       (parametro, valore, descrizione, gruppo, note, flag_visibile)
select 'CERDDC_CTC'
     , 'N'
     , 'DIRITTI PER ARCHIVIO'
     , ''
     , 'Se valorizzato a ''S'', attiva la gestione di Tariffe / Diritti associati alla Categoria, invece che al singolo Certificato.'||chr(10)||
         'Se valorizzato a ''N'', mantiene la gestione di Tariffe / Diritti associati al Certificato'
     , 'S'
from dual
where not exists (select 'x'
                  from arcinp
                  where parametro = 'CERDDC_CTC')

/
