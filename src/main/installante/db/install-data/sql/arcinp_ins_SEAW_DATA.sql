--liquibase formatted sql
--changeset amonopoli:202301251525_3 runOnChange:true
insert into arcinp
       (parametro, valore, descrizione, gruppo, note, flag_visibile)
select 'SEAW_DATA'
     , 'S'
     , 'ETICHETTE:DATA/FIRMA'
     , 'CIV'
     , 'Valori consentiti: ''S'' - ''D'' - ''F''
Valorizzato a ''S'', abilita l''aggiunta di DATA e FIRMA in calce al testo dell''annoazione.
Valorizzato a ''D'', abilita la sola aggiunta della DATA.
Vlaorizzato a ''F'', abilita la sola aggiunta della FIRMA'
     , 'S'
  from dual
 where not exists (select 'x' from arcinp
                    where parametro = 'SEAW_DATA')
/
