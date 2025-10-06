--liquibase formatted sql
--changeset amonopoli:202501301145 runOnChange:true stripComments:false
insert into ARCINP (PARAMETRO, VALORE, DESCRIZIONE, GRUPPO, FLAG_VISIBILE)
select 'DOCAREA_UT', 'N', 'DOCAREA: UTENTE PROT', 'GSD', 'S'
  from dual
 where not exists (select 1 from arcinp b
                    where b.parametro = 'DOCAREA_UT')
/
update arcinp
   set note = 'Nell''ambito dell''integrazione con il protocollo, gestisce l''opzione che definisce se l''utente in sessione debba risultare anche l''utente protocollante.'||chr(10)||
                'Valorizzato a ''S'' indica che l''utente in sessione risultera'' anche come utente protocollante (purche'' appartenente all''Unita'' Organizzativa che protocolla).'||chr(10)||
                'Valorizzato a ''N'' indica che la protocollazione viene eseguita dall''utente generico abilitato per l''uso del web-service (es. AGSPRWS)'
 where parametro = 'DOCAREA_UT'
/
