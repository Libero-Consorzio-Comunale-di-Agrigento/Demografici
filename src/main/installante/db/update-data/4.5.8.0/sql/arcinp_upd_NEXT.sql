--liquibase formatted sql
--changeset amonopoli:202501141640_2 runOnChange:true stripComments:false
update arcinp
   set GRUPPO        = 'WSP',
       NOTE          = 'Integrazione con WS Pagamenti (NEXTSTEP). Endpoint del web-service',
       FLAG_VISIBILE = 'S'
 where parametro = 'NEXT_URL'
/
update arcinp
   set GRUPPO        = 'WSP',
       NOTE          = 'Integrazione con WS Pagamenti (NEXTSTEP). Endpoint del web-service',
       FLAG_VISIBILE = 'S'
 where parametro = 'NEXT_CONF'
/
update arcinp
   set GRUPPO        = 'WSP',
       NOTE          = 'Integrazione con WS Pagamenti (NEXTSTEP). URL per la redirect nel caso di operazione andata a buon fine',
       FLAG_VISIBILE = 'S'
 where parametro = 'NEXT_URLOK'
/
update arcinp
   set GRUPPO        = 'WSP',
       NOTE          = 'Integrazione con WS Pagamenti (NEXTSTEP). URL per la redirect nel caso di operazione andata in errore',
       FLAG_VISIBILE = 'S'
 where parametro = 'NEXT_URLKO'
/
update arcinp
   set GRUPPO        = 'WSP',
       NOTE          = 'Integrazione con WS Pagamenti (NEXTSTEP). Codice del connettore messo a disposizione del partner tecnologico',
       FLAG_VISIBILE = 'S'
 where parametro = 'NEXT_CONN'
/
update arcinp
   set GRUPPO        = 'WSP',
       NOTE          = 'Integrazione con WS Pagamenti (NEXTSTEP). Codice dell''ente messo a disposizione del partner tecnologico',
       FLAG_VISIBILE = 'S'
 where parametro = 'NEXT_ENTE'
/
update arcinp
   set GRUPPO        = 'WSP',
       NOTE          = 'Integrazione con WS Pagamenti (NEXTSTEP). Identiicativo messo a disposizione del partner tecnologico',
       FLAG_VISIBILE = 'S'
 where parametro = 'NEXT_IDE'
/
update arcinp
   set GRUPPO        = 'WSP',
       NOTE          = 'Integrazione con WS Pagamenti (NEXTSTEP). Password dell''utente abilitato all''uso del web-service',
       FLAG_VISIBILE = 'S'
 where parametro = 'NEXT_PWD'
/
update arcinp
   set GRUPPO        = 'WSP',
       NOTE          = 'Integrazione con WS Pagamenti (NEXTSTEP). Codice dell''utente abilitato all''uso del web-service',
       FLAG_VISIBILE = 'S'
 where parametro = 'NEXT_USR'
/
update arcinp
   set GRUPPO        = 'WSP',
       NOTE          = 'Integrazione con WS Pagamenti (NEXTSTEP). Versione dell''applicazione messa a disposizione del partner tecnologico',
       FLAG_VISIBILE = 'S'
 where parametro = 'NEXT_VERS'
/
update arcinp
   set gruppo = '',
       flag_visibile = 'S'
 where parametro = 'WS_CLIENT'
/
