--liquibase formatted sql
--changeset snocca:202302061320 runOnChange:true
insert into arcinp
       (parametro, valore, descrizione, gruppo, note, flag_visibile)
select 'RANN_ESTR'
     , 'S'
     , 'RANN:STAMPA ESTRATTO'
     , 'CIV'
     , 'Valori consentiti: ''S'' - ''N''
Valorizzato a ''S'', inserisce automaticamente la spunta sul flag ''Stampa su Estratto'' in fase di inserimento di una nuova annotazione.
Valorizzato a ''N'', non valorizza automaticamente il flag.
ATTENZIONE: il parametro non viene considerato nell''inserimento di annotazioni generate in fase di consolidamento da altri atti (es. matrimonio / divorzio); per tali annotazioni il flag ''Stampa su Estratto'' viene attivato sempre, indipendentemente dal valore del parametro'
     , 'S'
  from dual
 where not exists (select 'x' from arcinp
                    where parametro = 'RANN_ESTR')
/
