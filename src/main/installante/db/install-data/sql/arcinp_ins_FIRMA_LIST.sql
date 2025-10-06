--liquibase formatted sql
--changeset vmigliore:202406251550 runOnChange:true
insert into arcinp
    (parametro, valore, descrizione, gruppo, note, flag_visibile)
select 'FIRMA_LIST'
     , ''
     , 'FIRMA: LISTA UTENTI'
     , ''
     , 'Se valorizzato a ''S'', mostra l''elenco di tutti gli utenti configurati correttamente (user e password) per la firma remota dei documenti in uscita.'||chr(10)||
         'Se non valorizzato, mostra - se configurato correttamente ai fini della firma remota - solo l''utente in sessione'
     , 'S'
from dual
where not exists (select 'x'
                  from arcinp
                  where parametro = 'FIRMA_LIST')

/
