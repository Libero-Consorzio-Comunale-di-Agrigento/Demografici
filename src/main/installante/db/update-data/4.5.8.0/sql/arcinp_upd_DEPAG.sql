--liquibase formatted sql
--changeset amonopoli:202501141640_1 runOnChange:true stripComments:false
update arcinp
   set GRUPPO        = 'WSP',
       NOTE          = 'Integrazione con WS Pagamenti (DEPAG). Endpoint del web-service',
       FLAG_VISIBILE = 'S'
 where parametro = 'DEPAG_URL'
/
update arcinp
   set GRUPPO        = 'WSP',
       NOTE          = 'Integrazione con WS Pagamenti (DEPAG). URL della pagina di pagamento tramite POS',
       FLAG_VISIBILE = 'S'
 where parametro = 'DEPAG_POS'
/
update arcinp
   set GRUPPO        = 'WSP',
       NOTE          = 'Integrazione con WS Pagamenti (DEPAG). Codice Ente',
       FLAG_VISIBILE = 'S'
 where parametro = 'DEPAG_ENTE'
/
update arcinp
   set GRUPPO        = 'WSP',
       NOTE          = 'Integrazione con WS Pagamenti (DEPAG). Password dell''utente abilitato all''uso del web-service',
       FLAG_VISIBILE = 'S'
 where parametro = 'DEPAG_PWD'
/
update arcinp
   set GRUPPO        = 'WSP',
       NOTE          = 'Integrazione con WS Pagamenti (DEPAG). Codice dell''utente abilitato all''uso del web-service',
       FLAG_VISIBILE = 'S'
 where parametro = 'DEPAG_USR'
/
update arcinp
   set GRUPPO        = 'WSP',
       NOTE          = 'Integrazione con WS Pagamenti (DEPAG). Valorizzato ad ''S'' attiva l''opzione di aprire la pagina di pagamento su un browser diverso da quello dal quale si e'' invocato il web-service',
       FLAG_VISIBILE = 'S'
 where parametro = 'DEPAG_BROW'
/
update arcinp
   set gruppo = '',
       flag_visibile = 'S'
 where parametro = 'WS_CLIENT'
/
