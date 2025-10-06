--liquibase formatted sql
--changeset snocca:202302171726 runOnChange:true
insert into arcinp
       (parametro, valore, descrizione, gruppo, note, flag_visibile)
select 'TANN_AUTO'
     , 'N'
     , 'ANNOTAZ AUTO:TESTO'
     , 'CIV'
     , 'Valori consentiti: ''S'' - ''N''
Valorizzato a ''S'', attiva la gestione avanzata del testo delle annotazioni automatiche.'
     , 'S'
  from dual
 where not exists (select 'x' from arcinp
                    where parametro = 'TANN_AUTO')
/
