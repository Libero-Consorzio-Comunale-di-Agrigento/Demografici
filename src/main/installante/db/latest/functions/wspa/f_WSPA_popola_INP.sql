--liquibase formatted sql
--changeset amonopoli:202501141655 runOnChange:true stripComments:false
create or replace function f_WSPA_popola_INP
(a_parametro	IN	varchar2)

return number

IS

w_return	number;

begin
  begin
    INSERT INTO cerdtp ( COD_TP, DESCRIZIONE, FLAG_WSPA) 
    SELECT 1, 'CONTANTI', ''
      FROM DUAL 
     WHERE NOT EXISTS (SELECT 1 FROM cerdtp WHERE COD_TP=1)
    UNION
    SELECT 2, 'POS Pagobancomat', ''
      FROM DUAL 
     WHERE NOT EXISTS (SELECT 1 FROM cerdtp WHERE COD_TP=2)
    UNION
    SELECT 3, 'POS PagoPA', ''
      FROM DUAL 
     WHERE NOT EXISTS (SELECT 1 FROM cerdtp WHERE COD_TP=3)
    UNION
    SELECT 4, 'VISA Mastercard', ''
      FROM DUAL 
     WHERE NOT EXISTS (SELECT 1 FROM cerdtp WHERE COD_TP=4)
    UNION
    SELECT 8, 'DIFFERITO', ''
      FROM DUAL 
     WHERE NOT EXISTS (SELECT 1 FROM cerdtp WHERE COD_TP=8)
    UNION
    SELECT 9, 'ALTRO', ''
      FROM DUAL 
     WHERE NOT EXISTS (SELECT 1 FROM cerdtp WHERE COD_TP=9)
    ;
  exception
    when others then
         w_return := -1;
         goto fine;
  end;

  if nvl(a_parametro,' ') = 'DEPAG' then
     begin  
       insert into arcinp (PARAMETRO, VALORE, DESCRIZIONE, NOTE, FLAG_VISIBILE, GRUPPO)
       select 'DEPAG_URL', 'N', 'INTEGR. DEPAG', 
              'Integrazione con WS Pagamenti (DEPAG). Endpoint del web-service', 
              'S', 'WSP'
         from dual
        where not exists (select 'x' from arcinp b
                           where b.parametro = 'DEPAG_URL')
       UNION
       select 'DEPAG_POS', 'N', 'DEPAG: URL PAGAMENTO', 
              'Integrazione con WS Pagamenti (DEPAG). URL della pagina di pagamento tramite POS', 
              'S', 'WSP'
         from dual
        where not exists (select 'x' from arcinp b
                           where b.parametro = 'DEPAG_POS')
       UNION
       select 'DEPAG_ENTE', '00000000000', 'DEPAG: ENTE', 
              'Integrazione con WS Pagamenti (DEPAG). Codice Ente', 
              'S', 'WSP'
         from dual
        where not exists (select 'x' from arcinp b
                           where b.parametro = 'DEPAG_ENTE')
       UNION
       select 'DEPAG_PWD', 'password', 'DEPAG: PASSWORD', 
              'Integrazione con WS Pagamenti (DEPAG). Password dell''utente abilitato all''uso del web-service', 
              'S', 'WSP'
         from dual
        where not exists (select 'x' from arcinp b
                           where b.parametro = 'DEPAG_PWD')
       UNION
       select 'DEPAG_USR', 'user', 'DEPAG: USER', 
              'Integrazione con WS Pagamenti (DEPAG). Codice dell''utente abilitato all''uso del web-service', 
              'S', 'WSP'
         from dual
        where not exists (select 'x' from arcinp b
                           where b.parametro = 'DEPAG_USR')
       UNION
       select 'DEPAG_BROW', 'N', 'DEPAG: BROWSER ALT.', 
              'Integrazione con WS Pagamenti (DEPAG). Valorizzato ad ''S'' attiva l''opzione di aprire la pagina di pagamento su un browser diverso da quello dal quale si e'' invocato il web-service', 
              'S', 'WSP'
         from dual
        where not exists (select 'x' from arcinp b
                           where b.parametro = 'DEPAG_BROW')
       UNION
       select 'WS_CLIENT', 'http://<ip_server_tomcat>/sa4WSclientV2', 'WS: CLIENT BRIDGE', 
              '', 'S', ''
         from dual
        where not exists (select 'x' from arcinp where parametro = 'WS_CLIENT')
       ;
       if sql%found then
          w_return := 1;
       else
          w_return := 0;
       end if;
     exception
       when others then
            w_return := -1;
     end;

     begin
       update cerdtp
          set flag_wspa = ''
       ;
       update cerdtp
          set flag_wspa = 'S'
        where cod_tp in (3)
       ;
     exception
       when others then
            w_return := -1;
     end;

  elsif nvl(a_parametro,' ') = 'NEXT' then
     begin
       insert into arcinp (PARAMETRO, VALORE, DESCRIZIONE, NOTE, FLAG_VISIBILE, GRUPPO)
       select 'NEXT_URL', 'N', 'INTEGR. NEXTSTEP',
              'Integrazione con WS Pagamenti (NEXTSTEP). Endpoint del web-service',
              'S', 'WSP'
         from dual
        where not exists (select 'x' from arcinp where parametro = 'NEXT_URL')
       UNION
       select 'NEXT_CONF', 'S', 'NEXTSTEP: CONFERMA',
              'Integrazione con WS Pagamenti (NEXTSTEP). Endpoint del web-service',
              'S', 'WSP'
         from dual
        where not exists (select 'x' from arcinp where parametro = 'NEXT_CONF')
       UNION
       select 'NEXT_URLOK', 'http://<ip_server_11ias>/nextstep_ok.html', 'NEXTSTEP: URL OK',
              'Integrazione con WS Pagamenti (NEXTSTEP). URL per la redirect nel caso di operazione andata a buon fine',
              'S', 'WSP'
         from dual
        where not exists (select 'x' from arcinp where parametro = 'NEXT_URLOK')
       UNION
       select 'NEXT_URLKO', 'http://<ip_server_11ias>/nextstep_ko.html', 'NEXTSTEP: URL ERROR',
              'Integrazione con WS Pagamenti (NEXTSTEP). URL per la redirect nel caso di operazione andata in errore',
              'S', 'WSP'
         from dual
        where not exists (select 'x' from arcinp where parametro = 'NEXT_URLKO')
       UNION
       select 'NEXT_CONN', 'ADS_LinkNext', 'NEXTSTEP: CONNETTORE',
              'Integrazione con WS Pagamenti (NEXTSTEP). Codice del connettore messo a disposizione del partner tecnologico',
              'S', 'WSP'
         from dual
        where not exists (select 'x' from arcinp where parametro = 'NEXT_CONN')
       UNION
       select 'NEXT_ENTE', '00000000000', 'NEXTSTEP: ENTE',
              'Integrazione con WS Pagamenti (NEXTSTEP). Codice dell''ente messo a disposizione del partner tecnologico',
              'S', 'WSP'
         from dual
        where not exists (select 'x' from arcinp where parametro = 'NEXT_ENTE')
       UNION
       select 'NEXT_IDE', 'X000', 'NEXTSTEP: IDENTIF.',
              'Integrazione con WS Pagamenti (NEXTSTEP). Identiicativo messo a disposizione del partner tecnologico',
              'S', 'WSP'
         from dual
        where not exists (select 'x' from arcinp where parametro = 'NEXT_IDE')
       UNION
       select 'NEXT_PWD', '2bce6bda537d08562c3d2d5651c75ca6', 'NEXTSTEP: PASSWORD',
              'Integrazione con WS Pagamenti (NEXTSTEP). Password dell''utente abilitato all''uso del web-service',
              'S', 'WSP'
         from dual
        where not exists (select 'x' from arcinp where parametro = 'NEXT_PWD')
       UNION
       select 'NEXT_USR', 'ads', 'NEXTSTEP: USER',
              'Integrazione con WS Pagamenti (NEXTSTEP). Codice dell''utente abilitato all''uso del web-service',
              'S', 'WSP'
         from dual
        where not exists (select 'x' from arcinp where parametro = 'NEXT_USR')
       UNION
       select 'NEXT_VERS', '1.6.9', 'NEXTSTEP: VERSIONE',
              'Integrazione con WS Pagamenti (NEXTSTEP). Versione dell''applicazione messa a disposizione del partner tecnologico',
              'S', 'WSP'
         from dual
        where not exists (select 'x' from arcinp where parametro = 'NEXT_VERS')
       UNION
       select 'WS_CLIENT', 'http://<ip_server_tomcat>/sa4WSclientV2', 'WS: CLIENT BRIDGE',
              '',
              'S', ''
         from dual
        where not exists (select 'x' from arcinp where parametro = 'WS_CLIENT')
       ;
       if sql%found then
          w_return := 1;
       else
          w_return := 0;
       end if;
     exception
       when others then
            w_return := -1;
     end;

     begin
       update cerdtp
          set flag_wspa = ''
       ;
       update cerdtp
          set flag_wspa = 'S'
        where cod_tp in (1,2,3,4,9)
       ;
     exception
       when others then
            w_return := -1;
     end;

  else
     w_return := 0;
  end if;

<< fine >>
  return w_return;

end;
/
