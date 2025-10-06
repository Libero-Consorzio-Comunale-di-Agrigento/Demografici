--liquibase formatted sql
--changeset snocca:202302061220 runOnChange:true
insert into arcinp
       (parametro, valore, descrizione, gruppo, note, flag_visibile)
select 'RANN_ATTO'
     , 'S'
     , 'RANN:STAMPA ATTO'
     , 'CIV'
     , 'Valori consentiti: ''S'' - ''N''
Valorizzato a ''S'', inserisce automaticamente la spunta sul flag ''Stampa su Atto'' in fase di inserimento di una nuova annotazione.
Valorizzato a ''N'', non valorizza automaticamente il flag.
ATTENZIONE: il parametro non viene considerato nell''inserimento di annotazioni generate in fase di consolidamento da altri atti (es. matrimonio / divorzio); per tali annotazioni il flag ''Stampa su Atto'' viene attivato sempre, indipendentemente dal valore del parametro'
     , 'S'
  from dual
 where not exists (select 'x' from arcinp
                    where parametro = 'RANN_ATTO')
/
