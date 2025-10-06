--liquibase formatted sql
--changeset amonopoli:202305181215_2 runOnChange:true stripComments:false
create or replace package body ANSC_PKG
is

function versione

return varchar2

IS

w_versione 		varchar2(255);

begin
--
-- Versione   Data         Autore   Note
-- V1.0       15/05/2023   AM       .prima emissione
-- V1.1       27/05/2023   AM       .R005: recupero idSoggettoAnsc
-- V1.2       31/05/2023   AM       .R002: certificazione
-- V1.3       09/06/2023   AM       .ORA-31167: 64k size limit for XML node (rif. Valeggio)
-- V1.3.1     01/08/2023   AM       .ORA-31011: Analisi XML non riuscita (indirizzoPostaAutorit%)
-- V1.3.2     25/09/2023   AM       .R011: annullamento id_atto_ansc / id_evento_ansc / id_allegato_ansc / hash_allegato_ansc
-- V1.3.3     28/09/2023   AM       .ins_log: gestito campo id_atto
-- V1.3.4     02/10/2023   AM       .R011: valorizzazione ansciu.flag_annullato
-- V1.3.5     06/10/2023   AM       .R005: modelEventoDTO.getClobVal()
-- V1.3.6     17/10/2023   AM       .ctr_risposta: caso di ora-31167 (rif. Valeggio)
-- V1.3.7     19/10/2023   SN       .R008_R: ricerca notifiche
-- V1.3.8     06/11/2023   SN       .R005_S: consultazione soggetto notifica
-- V1.3.9     07/11/2023   AM       .R013: rettifica validazione (test servizio)
--                                  .R003: comunicazioni (test servizio)
-- V1.4.0     22/11/2023   AM       .R009_A: validazione annotazione 
-- V1.4.1     28/11/2023   AM       .R013: aggiornamento dati _ansc su civann
-- V1.4.2     01/12/2023   SN       .R008_R: salvataggio descrizione notifica
-- V1.4.3     06/12/2023   AM       .ctr_risposta: gestione warnings e info
-- V1.4.4     21/02/2024   SN       .R012_I: invio link
-- V1.4.5     07/03/2024   AM       .ctr_risposta: gestione tag <esito> nella response (rif. R012_A)
-- V1.4.6     12/03/2024   SN       .R008_R: salvataggio canale comunicazione notifica
-- V1.4.7     29/04/2024   SN       .R010_C: attestazione di conformità
-- V1.4.8     31/08/2024   AM       .ctr_risposta: gestione errori http
-- V1.4.9     26/11/2024   AM       .ctr_risposta: gestione datiPaginazione
--                                  .R005_G: consultazione evento generico
-- V1.5.0     23/04/2025   AM       .R017: rettifica annotazione (+ R010_RA - R007_RA)
-- V1.5.1     30/05/2025   AM       .R006: acquisizione idAllegato e hashAllegato
-- V1.5.2     02/07/2025   AM       .R008_R: svuotamento campo composizioneAnnotazione
-- V1.5.3     07/07/2025   AM       .R005: recupero idSoggettoAnsc anche nel caso di multi-intestatari
-- V1.5.4     28/07/2025   AM       .R008_E: recupero dettagli notifiche ANSC (consultazione per evento)
-- V1.5.5     01/10/2025   AM       .R008_A: recupero dettagli notifiche ANPR (consultazione per evento)
--
  w_versione := 'V1.5.5 del 01/10/2025';

  return w_versione;
end;

procedure dati_cliente
is

w_servizio_log		varchar2(255);
w_operazione_log	varchar2(255) := 'dati_cliente';

w_errore		varchar2(4000);
errore			exception;

begin

  begin
    select m.cod_provincia
         , m.cod_Comune
         , lpad(m.cod_provincia,3,'0')||lpad(m.cod_Comune,3,'0')
         , m.descrizione
         , m.sigla_provincia
         , lpad(m.cap,5,'0')
         , f_ANSC_valore_inp('ID_COMUNE',1,10,'9','')
      into w_cod_pro_cliente
         , w_cod_com_cliente
         , w_codice_cliente
         , w_des_com_cliente
         , w_sigla_pro_cliente
         , w_cap_cliente
         , w_id_cliente
      from arccom m
     where (m.cod_provincia, m.cod_comune) = (select pro_cliente, com_cliente from menuditta)
    ;
  exception
    when others then
         w_errore := 'errore in dati_cliente ('||SQLERRM||')';
         raise errore;
  end;

  begin
    select MAX(versione)
      into w_versione_applicativo
      from ad4_istanze
     where progetto = 'DE4GSD'
       AND USER_ORACLE = USER
       and rownum  = 1
    ;
    w_versione_applicativo := f_ANSC_stringa(w_versione_applicativo||' - '||ANSC_PKG.versione,'/');
  exception
    when others then
         w_errore := 'errore in ad4_istanze ('||SQLERRM||')';
         raise errore;
  end;


exception
  when errore then
       ANSC_PKG.ins_log(w_servizio_log, w_operazione_log, w_errore);
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANSC_PKG.ins_log(w_servizio_log, w_operazione_log, w_errore);
end dati_cliente;

procedure ins_log
(a_servizio 	varchar2
,a_operazione   varchar2
,a_note 	varchar2
,a_campo_clob 	clob		default null
,a_id_atto 	varchar2	default null
)

is

w_id			number;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'ins_log';
w_id_atto_log		varchar2(255) := a_id_atto;

w_errore		varchar2(4000);
errore			exception;

begin

  begin
    insert into ANSC_LOG (id, data_ora, servizio, operazione, note, campo_clob, id_atto)
    values (w_id, sysdate, w_servizio_log, a_operazione, a_note, a_campo_clob, w_id_atto_log)
    ;
--COMMIT;
  exception
    when others then
         raise errore;
  end;
<< fine >>
null;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       begin
         insert into ANSC_LOG (id, data_ora, servizio, operazione, note, campo_clob, id_atto)
         values (w_id, sysdate, w_servizio_log, w_operazione_log, a_note, a_campo_clob, w_id_atto_log)
         ;
       end;
end ins_log;

procedure attivazione_ws
(a_servizio		varchar2
,a_id_operazione	number
,a_archivio_rif		varchar2
,a_id_rif		varchar2
,a_archivio_civ		varchar2
,a_id_civ		number
,a_id_usecase		number
,a_terminalista		varchar2
,a_otp			varchar2
,a_id_atto		varchar2
,w_json_request		OUT	clob
,w_json_response 	OUT	clob
)

IS

w_servizio		varchar2(255) := upper(a_servizio);
w_servizio_prec		varchar2(255);
w_id_operazione		varchar2(255) := a_id_operazione;
w_archivio_rif		varchar2(255) := upper(a_archivio_rif);
w_archivio_rif_prec	varchar2(255);
w_id_rif		varchar2(255) := a_id_rif;
w_id_rif_prec		varchar2(255);
w_archivio_civ		varchar2(255) := upper(a_archivio_civ);
w_id_civ		number := a_id_civ;
w_id_usecase		number := a_id_usecase;

w_tipo_atto		number := f_UTIL_get_tipo_atto(a_archivio_rif);

w_operatore 		varchar2(255) := a_terminalista;
w_otp			varchar2(255) := a_otp;

w_request_clob		clob;
w_response_clob		clob;

w_response_xml		varchar2(32000);
w_ws_client    		varchar2(255);

w_service_url		varchar2(32000);
w_service_name		varchar2(255);
w_service_ns		varchar2(255);

w_id_operazione_ANSC 	number;
w_esito_ANSC 		varchar2(255);
w_flag_errore 		varchar2(255);
w_flag_anomalia 	varchar2(255);
w_flag_invio_ws 	varchar2(255);
w_note_ws		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'attivazione_ws';
w_id_atto_log		varchar2(255) := f_UTIL_get_id_atto(a_archivio_rif,a_id_rif);

w_errore		varchar2(32000);
errore			exception;

begin
  ANSC_pkg.dati_cliente;

  w_request_clob := f_JSON_testataRichiesta(a_servizio,a_id_operazione);

  w_ws_client    := f_ANSC_valore_inp('WS_CLIENT',1,255,'X','');
--  w_otp          := '123456'; --f_ANSC_get_otp_servizio(a_terminalista,to_char(sysdate,'j'));

--@RequestParam("tipoArchivioComunicazione") String tipoArchivioComunicazione,
--@RequestParam("idServizio") String idServizio,
--@RequestParam("tipoArchivioComunicazionePrec") String tipoArchivioComunicazionePrec,
--@RequestParam("idServizioPrec") String idServizioPrec,
--@RequestParam("idRifPrec") Long idRifPrec,
--@RequestParam("idUseCase") Long idUseCase,
--@RequestParam("tipoAtto")String tipoAtto,
--@RequestParam("pkAtto") Long pkAtto,
--@RequestParam("idRif") Long idRif,
--@RequestParam("operatore") String operatore,
--@RequestParam("otp") String otp,
--@RequestParam("idOperazione") Long idOperazione)
  w_service_url := w_ws_client||'?'||
                   'tipoArchivioComunicazione='||w_archivio_rif||
                   '&idServizio='||w_servizio||
                   '&tipoArchivioComunicazionePrec='||w_archivio_rif_prec||
                   '&idServizioPrec='||w_servizio_prec||
                   '&idRifPrec='||w_id_rif_prec||
                   '&idUseCase='||w_id_usecase||
                   '&tipoAtto='||w_archivio_civ||
                   '&pkAtto='||w_id_civ||
                   '&idRif='||w_id_rif||
                   '&operatore='||w_operatore||
                   '&otp='||w_otp||
                   '&idOperazione='||w_id_operazione;

--  ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'request', w_request_clob);
  begin
    w_response_clob := ANSC_pkg.WS_REQUEST(a_servizio, w_service_url, w_service_name, w_service_ns, '', w_request_clob);
--    ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'response', w_response_clob, w_id_atto_log);
  exception
    when others then
         ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'exception', sqlerrm, w_id_atto_log);

  end;

  goto fine;

  w_response_xml := lower(nvl(f_ANSC_valore_inp('RESP_XML',1,10,'X',''),'false'));
  if w_response_clob is not null then
     ansc_pkg.ctr_risposta(a_servizio,a_id_operazione,a_archivio_rif,a_id_rif,a_id_atto,w_response_clob,w_id_operazione_ANSC,w_esito_ANSC,w_flag_errore,w_flag_anomalia,w_flag_invio_ws,w_note_ws);
  end if;

<< fine >>
null;
  w_json_request   := w_request_clob;
  w_json_response  := w_response_clob;

exception
  when errore then
       ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_id_atto_log);
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_id_atto_log);
end attivazione_ws;

function WS_REQUEST
(a_servizio		varchar2
,a_service_url 		varchar2
,a_service_name 	varchar2
,a_service_ns       	varchar2
,a_json_header		clob
,a_json_request		clob
,a_service_timeout  	number default 600
)

return CLOB

IS

w_json_request		clob	:= a_json_request;
w_service_timeout  	number	:= a_service_timeout;

rest_request		varchar2(30000);
rest_respond		clob;
http_request		utl_http.req;
http_response		utl_http.resp;

soap_response_30000	varchar2(30000);
soap_response		clob;
soap_response_5000	clob;
soap_response_line	varchar2(32000);

i                	number := 0;

out_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'ws_request';

w_step          	number;
w_errore		varchar2(4000);
errore			exception;

begin
--  ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'url', a_service_url);
--  ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'request', a_json_request);

w_step := 1;
  utl_http.set_transfer_timeout(w_service_timeout);

w_step := 2;
  http_request:= utl_http.begin_request
                 ( a_service_url
                 , 'POST'
                 , 'HTTP/1.1'
                 );

w_step := 3;
  utl_http.set_persistent_conn_support(http_request, true);

w_step := 4;
  utl_http.set_header(http_request, 'accept', 'application/json');
  utl_http.set_header(http_request, 'Content-Type', 'application/json');
w_step := 5;
  if a_json_header is not null then
     utl_http.set_header(http_request, 'Authorization', 'Bearer '||a_json_header);
  end if;

  utl_http.set_header(http_request, 'Content-Length', length(w_json_request));
--  utl_http.set_header(http_request, 'SOAPAction', a_service_ns||'/'||a_service_name);

w_step := 6;
  utl_http.write_text(http_request,w_json_request);

w_step := 7;
  http_response := utl_http.get_response(http_request);

dbms_output.Put_Line ( 'Status code: ' || http_response.status_code );
Dbms_Output.Put_Line ( 'Reason phrase: ' || http_response.reason_phrase );

  begin
w_step := 8;
    LOOP
      UTL_HTTP.read_text(http_response, soap_response_30000, 30000);
      soap_response := soap_response||soap_response_30000;
    END LOOP;
w_step := 9;
    UTL_HTTP.end_response(http_response);
  exception
    when UTL_HTTP.end_of_body THEN
         UTL_HTTP.end_response(http_response);
    when others then
         dbms_output.put_line('errore: '||sqlerrm);
  end;

  w_step := 10;
--  soap_response	:= decode_utf8_clob(soap_response);

--  ANSC_PKG.ins_log(w_servizio_log, w_operazione_log, 'response', soap_response);
w_step := 11.5;
--  out_xml:= xmltype(soap_response);
w_step := 12;
--  out_xml_clob	:= xmltype.getclobval(out_xml);

  return soap_response;
exception
  when others then
       w_errore := 'exception ('||SQLERRM||')';
       ANSC_PKG.ins_log(w_servizio_log, a_service_url, w_step||'. '||w_errore);
end WS_REQUEST;

function f_JSON_tag
(a_servizio 	varchar2
,a_livello	number
,a_tag 		varchar2
,a_tipo_tag	varchar2
,a_is_array	varchar2)

return clob

is

w_indent		varchar2(255);
w_json_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'json_tag';
w_errore		varchar2(255);
errore			exception;


begin
  if nvl(a_livello,0) = 0 then
w_indent := '';
  else
w_indent := rpad(' ',a_livello*2,' ');
  end if;

  if upper(nvl(a_tipo_tag,'I')) = 'I' then
     if a_tag is not null then
w_json_clob := w_indent||'"'||a_tag||'": ';
     end if;

     if nvl(a_is_array,'N') = 'S' then
w_json_clob := nvl(w_json_clob,w_indent)||'['||chr(10);
w_json_clob := w_json_clob||w_indent||'{';
     else
w_json_clob := nvl(w_json_clob,w_indent)||'{';
     end if;

  elsif upper(nvl(a_tipo_tag,'I')) = 'F' then
w_json_clob := w_indent||'}';

     if nvl(a_is_array,'N') = 'S' then
w_json_clob := w_json_clob||chr(10)||w_indent||']';
     end if;

     if a_tag is not null then
w_json_clob := w_json_clob||',';
     end if;
  end if;

w_json_clob := w_json_clob||chr(10);

  return w_json_clob;
end f_JSON_tag;

function f_JSON_elemento
(a_servizio 	varchar2
,a_livello	number
,a_valore 	clob
,a_tag 		varchar2
,a_is_array	varchar2
,a_is_ultimo	varchar2
,a_check_null	varchar2 default NULL)

return clob

is

w_json_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'json_elemento';
w_errore		varchar2(255);
errore			exception;

begin
  if upper(nvl(a_check_null,'N')) = 'S' and a_valore is null then
     goto fine;
  end if;

  if nvl(a_livello,0) = 0 then
w_json_clob := '';
  else
w_json_clob := rpad(' ',a_livello*2,' ');
  end if;

w_json_clob := w_json_clob||'"'||a_tag||'": ';

  if nvl(a_is_array,'N') = 'S' then
w_json_clob := w_json_clob||'[';
  end if;

w_json_clob := w_json_clob||'"'||a_valore||'"';

  if nvl(a_is_array,'N') = 'S' then
w_json_clob := w_json_clob||']';
  end if;

  if nvl(a_is_ultimo,'N') = 'N' then
w_json_clob := w_json_clob||',';
  end if;

w_json_clob := w_json_clob||chr(10);

<< fine >>
null;

  return w_json_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, w_errore, w_json_clob);
       return w_json_clob;
end f_JSON_elemento;

function f_JSON_testataRichiesta
(a_servizio		IN	varchar2
,a_id_operazione	IN	varchar2
)

return CLOB

IS

w_idComune		varchar2(255);
w_idOperazioneComune	varchar2(255);
w_dataOraRichiesta      varchar2(255);
w_nomeApplicativo	varchar2(255);
w_versioneApplicativo	varchar2(255);
w_fornitoreApplicativo	varchar2(255);

w_json_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'testataRichiesta';

w_errore		varchar2(4000);
errore			exception;

begin
  dati_cliente;
  w_idComune		 := w_id_cliente;
  w_idOperazioneComune	 := a_id_operazione;
  w_dataOraRichiesta     := to_char(sysdate,'yyyy-mm-dd')||'T'||to_char(sysdate,'hh24:mi:ss');
  w_nomeApplicativo	 := w_nome_applicativo;
  w_versioneApplicativo	 := w_versione_applicativo;
  w_fornitoreApplicativo := w_fornitore_applicativo;

w_json_clob := w_json_clob||f_JSON_tag(a_servizio,1,'testataRichiesta','I','');
w_json_clob := w_json_clob||f_JSON_elemento(a_servizio,2,w_idComune,'idComune','','','');
w_json_clob := w_json_clob||f_JSON_elemento(a_servizio,2,w_idOperazioneComune,'idOperazioneComune','','','');
w_json_clob := w_json_clob||f_JSON_elemento(a_servizio,2,w_dataOraRichiesta,'dataOraRichiesta','','','');
w_json_clob := w_json_clob||f_JSON_elemento(a_servizio,2,w_nomeApplicativo,'nomeApplicativo','','','');
w_json_clob := w_json_clob||f_JSON_elemento(a_servizio,2,w_versioneApplicativo,'versioneApplicativo','','','');
w_json_clob := w_json_clob||f_JSON_elemento(a_servizio,2,w_fornitoreApplicativo,'fornitoreApplicativo','','S','');
w_json_clob := w_json_clob||f_JSON_tag(a_servizio,1,'testataRichiesta','F','');

  return w_json_clob;

end f_JSON_testataRichiesta;

function f_JSON_body
(a_servizio		IN	varchar2
,a_id_operazione	IN	varchar2
,a_tipo_atto		IN	number
,a_id_rif		IN	varchar2
)

return CLOB

IS

cursor sel_s is
select * From ansjsn_sezioni
 where servizio  = a_servizio
   and tipo_atto = a_tipo_atto
 order by livello, sequenza
;
cursor sel_c (w_id_sezione in number) is
select * from ansjsn_campi
 where id_sezione = w_id_sezione
 order by sequenza
;

w_sql			varchar2(32000);
w_valore_campo		clob;

w_json_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'f_json_body';

w_errore		varchar2(4000);
errore			exception;

begin

w_json_clob := f_JSON_tag(a_servizio,0,'','I','');

  for rec_s in sel_s loop
w_json_clob := w_json_clob||f_JSON_tag(a_servizio,rec_s.livello,rec_s.sezione,'I',rec_s.flag_array);

      if rec_s.vista_db is null then
         w_valore_campo := '';
      else
         for rec_c in sel_c (rec_s.id) loop
             w_sql := 'select '||nvl(rec_c.campo_db,rec_c.campo)||' from '||rec_s.vista_db||' where 1 = 1';
             if rec_s.parametro_vista_db = 'idRif' then
                w_sql := w_sql||' and id = '||a_id_rif;
             end if;
             if rec_s.parametro_vista_db = 'idOperazione' then
                w_sql := w_sql||' and id = '||a_id_operazione;
             end if;
             begin
               execute immediate w_sql into w_valore_campo;
             exception
               when others then
                    w_errore := 'errore ('||sqlerrm||')';
                    ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, rec_c.id_sezione||'.'||rec_c.id||'-'||rec_s.vista_db||'.'||nvl(rec_c.campo_db,rec_c.campo), w_errore);
             end;
w_json_clob := w_json_clob||f_JSON_elemento(a_servizio,rec_s.livello,w_valore_campo,rec_c.campo,'','','');
         end loop;
      end if;
w_json_clob := w_json_clob||f_JSON_tag(a_servizio,rec_s.livello,rec_s.sezione,'F',rec_s.flag_array);

  end loop;
w_json_clob := w_json_clob||f_JSON_tag(a_servizio,0,'','F','');

<< fine >>
null;

  return w_json_clob;

end f_JSON_body;

procedure ctr_risposta
(a_servizio 		IN	varchar2
,a_id_operazione 	IN	varchar2
,a_archivio_rif 	IN	varchar2
,a_id_rif	 	IN	varchar2
,a_id_atto	 	IN	varchar2
,a_campo_clob 		IN	clob
,w_id_operazione_ANSC 	OUT 	number
,w_esito_ANSC 		OUT 	varchar2
,w_flag_errore 		OUT 	varchar2
,w_flag_anomalia 	OUT 	varchar2
,w_flag_invio_ws 	OUT 	varchar2
,w_note_ws 		OUT 	clob
)

IS

w_response_xml		varchar2(255) := rtrim(f_ANSC_valore_inp('RESP_XML',1,20,'X','S'));

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'ctr_risposta';
w_id_atto_log		varchar2(255) := f_UTIL_get_id_atto(a_archivio_rif,a_id_rif);

w_errore		varchar2(4000);
errore			exception;

begin
  dati_cliente;

  if a_campo_clob is not null then
     if nvl(w_response_xml,'N') in ('S','TRUE') then
        ansc_pkg.ctr_risposta_XML(a_servizio,a_id_operazione,a_archivio_rif,a_id_rif,a_id_atto,a_campo_clob,w_id_operazione_ANSC,w_esito_ANSC,w_flag_errore,w_flag_anomalia,w_flag_invio_ws,w_note_ws);
     else
        ansc_pkg.ctr_risposta_JSON(a_servizio,a_id_operazione,a_archivio_rif,a_id_rif,a_id_atto,a_campo_clob,w_id_operazione_ANSC,w_esito_ANSC,w_flag_errore,w_flag_anomalia);
     end if;
--     ANSC_pkg.ins_log(w_servizio_log, w_operazione_log,'w_id_operazione_ANSC',to_char(w_id_operazione_ANSC), w_id_atto_log);
--     ANSC_pkg.ins_log(w_servizio_log, w_operazione_log,'w_esito_ANSC',w_esito_ANSC, w_id_atto_log);
--     ANSC_pkg.ins_log(w_servizio_log, w_operazione_log,'w_flag_errore',w_flag_errore, w_id_atto_log);
--     ANSC_pkg.ins_log(w_servizio_log, w_operazione_log,'w_flag_anomalia',w_flag_anomalia, w_id_atto_log);
  end if;

end ctr_risposta;

procedure ctr_risposta_JSON
(a_servizio 		IN	varchar2
,a_id_operazione 	IN	varchar2
,a_archivio_rif 	IN	varchar2
,a_id_rif	 	IN	varchar2
,a_id_atto	 	IN	varchar2
,a_campo_clob 		IN	clob
,w_id_operazione_ANSC 	OUT 	number
,w_esito_ANSC 		OUT 	varchar2
,w_flag_errore 		OUT 	varchar2
,w_flag_anomalia 	OUT 	varchar2
)

IS

w_campo_clob		clob;
w_error_clob		clob;

w_codice		varchar2(255);
w_tipo			varchar2(255);
w_testo			varchar2(4000);
w_sequenza		number;

w_id_atto_ansc		varchar2(255);
w_id_evento_ansc	varchar2(255);

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'ctr_risposta_json';
w_id_atto_log		varchar2(255) := f_UTIL_get_id_atto(a_archivio_rif,a_id_rif);

w_errore		varchar2(4000);
errore			exception;

begin
--dbms_output.put_line('dentro ctr_risposta');
  if a_campo_clob is not null then
     w_esito_ansc := f_UTIL_leggi_campo_jsn(a_servizio,a_campo_clob,'idEsito');
--dbms_output.put_line('dopo w_esito');
     if w_esito_ansc is null then
--dbms_output.put_line('w_esito null');
        null;
     else
--dbms_output.put_line('w_esito not null');
        w_id_operazione_ansc := f_UTIL_leggi_campo_jsn_number(a_servizio,a_campo_clob,'idOperazione');
        if w_esito_ansc = '1' then
           w_campo_clob := f_UTIL_leggi_campo_jsn(a_servizio,a_campo_clob,'errors');
--dbms_output.put_line('w_campo_clob '||substr(w_campo_clob,1,100));
--dbms_output.put_line('w_campo_clob '||substr(w_campo_clob,101,100));
--dbms_output.put_line('w_campo_clob '||substr(w_campo_clob,201,100));
--dbms_output.put_line('w_campo_clob '||substr(w_campo_clob,301,100));
           w_sequenza := 0;
           while w_campo_clob like '%{%}%' loop
--dbms_output.put_line('prima di w_error_clob');
               w_error_clob := substr(w_campo_clob,instr(w_campo_clob,'{
')+1);
               w_error_clob := substr(w_error_clob,1,instr(w_error_clob,'}
'));
--dbms_output.put_line('w_error_clob '||substr(w_error_clob,1,100));
--dbms_output.put_line('w_error_clob '||substr(w_error_clob,101,100));
--dbms_output.put_line('w_error_clob '||substr(w_error_clob,201,100));
--dbms_output.put_line('w_error_clob '||substr(w_error_clob,301,100));
--dbms_output.put_line('prima di w_codice');
               w_codice     := f_UTIL_leggi_campo_jsn(a_servizio,w_error_clob,'code');
--dbms_output.put_line('prima di w_tipo');
               w_tipo       := f_UTIL_leggi_campo_jsn(a_servizio,w_error_clob,'severity');
--dbms_output.put_line('prima di w_testo');
               w_testo      := f_UTIL_leggi_campo_jsn(a_servizio,w_error_clob,'text');
               w_sequenza   := w_sequenza + 1;
--dbms_output.put_line('w_sequenza '||w_sequenza);
--dbms_output.put_line('w_codice '||w_codice);
--dbms_output.put_line('w_tipo '||w_tipo);
--dbms_output.put_line('w_testo '||substr(w_testo,1,100));
/*
               begin
                 insert into anserr (id_operazione, data_ora, sequenza, codice_errore, tipo_errore, testo_errore, flag_anomalia)
                 values (a_id_operazione, sysdate, w_sequenza, w_codice, w_tipo, w_testo, '')
                 ;
--dbms_output.put_line('dopo insert');
               exception
                 when others then
--dbms_output.put_line('error '||sqlerrm);
                      null;
               end;
*/
               w_campo_clob := substr(w_campo_clob,instr(w_campo_clob,'}')+1);
               w_flag_errore   := 'S';
               w_flag_anomalia := 'S';
           end loop;

        elsif w_esito_ansc = '0' then
           w_id_atto_ansc   := f_UTIL_leggi_campo_jsn(a_servizio,a_campo_clob,'idAnsc');
           w_id_evento_ansc := f_UTIL_leggi_campo_jsn(a_servizio,a_campo_clob,'idEvento');
--dbms_output.put_line('id_atto_ansc '||w_id_atto_ansc);
--dbms_output.put_line('id_evento_ansc '||w_id_evento_ansc);
/*
           begin
             update ansads
                set id_atto_ansc = w_id_atto_ansc,
                    id_evento_ansc = w_id_evento_ansc
              where w_id_atto_ansc like anno_ads||'-%-'||numero_comunale_ads||'-'||w_codice_cliente
             ;
             if sql%notfound then
dbms_output.put_line('upd_ansads - non trovato');
             end if;
           end;
*/
           w_flag_errore   := '';
           w_flag_anomalia := '';
        end if;
     end if;
  end if;
end ctr_risposta_JSON;

procedure ctr_risposta_XML
(a_servizio 		IN	varchar2
,a_id_operazione 	IN	varchar2
,a_archivio_rif 	IN	varchar2
,a_id_rif	 	IN	varchar2
,a_id_atto	 	IN	varchar2
,a_campo_clob 		IN	clob
,w_id_operazione_ANSC 	OUT 	number
,w_esito_ANSC 		OUT 	varchar2
,w_flag_errore 		OUT 	varchar2
,w_flag_anomalia 	OUT 	varchar2
,w_flag_invio_ws	OUT	varchar2
,w_note_ws		OUT	clob
)

IS

w_id_atto		varchar2(255) := a_id_atto;

w_risposta_clob		clob;
w_risposta_64k		clob;
w_risposta_64k_1	clob;
w_risposta_64k_2	clob;
w_risposta_temp		clob;
w_risposta_xml		xmltype;

w_count_temp		number;

w_numRecordTotali	varchar2(255);
w_numRecordPagina	varchar2(255);
w_numPagina		varchar2(255);

w_errori_clob		clob;
w_errori_xml		xmltype;
w_warning_clob		clob;
w_warning_xml		xmltype;
w_info_clob		clob;
w_info_xml		xmltype;
w_lista_errori		clob;
w_lista_warning		clob;
w_lista_info		clob;
w_lista_ads		clob;

w_codice_errore		varchar2(255);
w_tipo_errore		varchar2(255);
w_testo_errore		varchar2(4000);
w_sequenza		number;

w_modelEventoDTO_clob	clob;
w_modelEventoDTO_xml	xmltype;
w_intestatari_clob	clob;
w_intestatari_xml	xmltype;
w_notifiche_clob	clob;
w_notifiche_xml	xmltype;

w_id_operazione_ADS	varchar2(255);

w_id_soggetto_ansc_1		varchar2(255);
w_id_soggetto_ansc_2		varchar2(255);
w_id_soggetto_ansc_r005		varchar2(255);
w_cognome_r005			varchar2(255);
w_nome_r005			varchar2(255);
w_codice_fiscale_r005		varchar2(255);

w_id_atto_ads		varchar2(255);

--R001_U
w_hash_allegato_ansc	varchar2(255);
--R001_V
w_stato_allegato_ansc	varchar2(255);
w_id_documentum_ansc	varchar2(255);

--R005
w_stato_ansc			varchar2(255);
w_id_tipo_evento_ansc		varchar2(255);
w_des_tipo_evento_ansc		varchar2(255);
w_id_tipo_contenuto_ansc	varchar2(255);
w_des_tipo_contenuto_ansc	varchar2(255);
w_id_usecase_ansc		varchar2(255);
w_numero_atto			varchar2(255);

--R008_R / R008_E
w_id_notifica			number;
w_stato_notifica		number;
w_genere_notifica		number;
w_descrizione_notifica		varchar2(500);
w_contenuto_notifica		number;
w_id_ansc			varchar2(255);
w_id_soggetto_ansc_notifica	varchar2(255);
w_dal_notifica              	date;
w_al_notifica               	date;
w_id_comune_competente		number;
w_id_comune_formazione		number;
w_canale_notifica		number;
--
w_tipo_contenuto_notifica	number;
w_des_stato_notifica		varchar2(255);
w_des_genere_notifica		varchar2(255);
w_des_contenuto_notifica	varchar2(255);
w_des_comune_competente		varchar2(255);
w_des_canale_notifica		varchar2(255);
w_des_soggetto_notifica		varchar2(255);

--R008_A
w_id_notifica_anpr		number;
w_id_tipo_notifica_anpr		varchar2(255);
w_id_comune_mittente_anpr	number;
w_id_comune_destinatario_anpr	number;
w_data_ins_anpr 		varchar2(255);
--
w_des_tipo_notifica_anpr	varchar2(255);
w_des_comune_mittente_anpr	varchar2(255);
w_des_comune_destinatario_anpr	varchar2(255);

--R009
--R013
--R017
w_id_atto_ansc		varchar2(255);
w_id_evento_ansc	varchar2(255);
w_id_allegato_ansc	varchar2(255);

--R010
w_nome_file_ansc	varchar2(255);
w_tipo_file_ansc	varchar(10);
w_contenuto_clob	clob;
w_contenuto_blob	blob;

--R012_I
w_id_presa_visione	number;
--R012_V
w_stato_presa_visione	number;
--R012_A
w_descrizione_esito	varchar2(4000);
w_codice_esito		varchar2(4000);

w_des_errore_WS		varchar2(4000);
w_cod_errore_WS		varchar2(4000);

w_info_ws		clob;

cursor sel_risposta (w_root varchar2) is
select extractValue(value(rowdata),w_root||'/testataRisposta/idComune') idComune
     , extractValue(value(rowdata),w_root||'/testataRisposta/idOperazioneComune') idOperazioneComune
     , extractValue(value(rowdata),w_root||'/testataRisposta/idOperazione') idOperazione
     , extractValue(value(rowdata),w_root||'/testataRisposta/idEsito') idEsito
--
-- datiPaginazione
     , extractValue(value(rowdata),w_root||'/datiPaginazione/numRecordTotali') numRecordTotali
     , extractValue(value(rowdata),w_root||'/datiPaginazione/numRecordPagina') numRecordPagina
     , extractValue(value(rowdata),w_root||'/datiPaginazione/numPagina') numPagina
--
-- dati da servizio R001 (allegati - upload / verifica)
     , extractValue(value(rowdata),w_root||'/allegatoOutput/idAllegato') idAllegato
     , extractValue(value(rowdata),w_root||'/allegatoOutput/statoAllegato') statoAllegato
     , extractValue(value(rowdata),w_root||'/allegatoOutput/idDocumentum') idDocumentum
     , extractValue(value(rowdata),w_root||'/allegatoOutput/hash') hash
--
-- dati da servizio R006 (dichiarazione firmata - upload)
     , extractValue(value(rowdata),w_root||'/firmaDichiaranteOutput/idAllegato') idAllegato_R006
     , extractValue(value(rowdata),w_root||'/firmaDichiaranteOutput/statoAllegato') statoAllegato_R006
     , extractValue(value(rowdata),w_root||'/firmaDichiaranteOutputOutput/idDocumentum') idDocumentum_R006
     , extractValue(value(rowdata),w_root||'/firmaDichiaranteOutput/hash') hash_R006
--
-- dati da servizio R003 (comunicazioni)
     , extractValue(value(rowdata),w_root||'/comunicazioni/nomeDocumento') nomeFile_r003
     , extractValue(value(rowdata),w_root||'/comunicazioni/formatoDocumento') tipoFile_r003
--
-- dati da servizio R005 (consultazione - evento)
     , extract(value(rowdata),w_root||'/modelEventoDTO').getClobVal() modelEventoDTO
--
-- dati da servizio R008_R (notifica - ricerca)
     , extract(value(rowdata),w_root||'/notifiche').getClobVal() notifiche
--
-- dati da servizio R009 (validazione - evento)
     , extractValue(value(rowdata),w_root||'/idTipoEvento') idTipoEvento
     , extractValue(value(rowdata),w_root||'/idAnsc') idAnsc
     , extractValue(value(rowdata),w_root||'/idEvento') idEvento

-- dati da servizio R012_I
     , extractValue(value(rowdata),w_root||'/idPresaVisione') idPresaVisione

-- dati da servizio R012_V
     , extractValue(value(rowdata),w_root||'/idState') idState

-- dati da servizio R012_A
     , extractValue(value(rowdata),w_root||'/esito/descrizione') descrizioneEsito_r012
     , extractValue(value(rowdata),w_root||'/esito/codice') codiceEsito_r012

--
-- dati da servizio R013 (rettifica validazione)
     , extractValue(value(rowdata),w_root||'/evento/idAnsc') idAnsc_r013
     , extractValue(value(rowdata),w_root||'/evento/id') idEvento_r013
--
-- dati da servizio R010 (anteprima - evento)
     , extractValue(value(rowdata),w_root||'/eventoOutput/nomeFile') nomeFile_r010
     , extractValue(value(rowdata),w_root||'/eventoOutput/tipoFile') tipoFile_r010
--     , extract(value(rowdata),w_root||'/eventoOutput/contenuto').getClobVal() contenuto_r010
--
-- dati da servizio R010_C (attestzione - conformità)
     , extractValue(value(rowdata),w_root||'/allegatoOutput/nomeFile') nomeFile_r010_C
     , extractValue(value(rowdata),w_root||'/allegatoOutput/tipoFile') tipoFile_r010_C
-- dati da servizio R002 (certificazione)
--
     , extractValue(value(rowdata),w_root||'/nomeFile') nomeFile_r002
     , extractValue(value(rowdata),w_root||'/tipoFile') tipoFile_r002
--     , extract(value(rowdata),w_root||'/contenuto').getClobVal() contenuto_r002
-- errori
     , extract(value(rowdata),w_root||'/errors').getClobVal() errori
     , extract(value(rowdata),w_root||'/warnings').getClobVal() warning
     , extract(value(rowdata),w_root||'/infos').getClobVal() info
     , extractValue(value(rowdata),w_root||'/error_description') des_errore_WS
     , extractValue(value(rowdata),w_root||'/error') cod_errore_WS
  from table(XMLSequence(w_risposta_xml)) rowdata
;

cursor sel_errori (w_root varchar2) is
select extractValue(value(rowdata),w_root||'/code') code
     , extractValue(value(rowdata),w_root||'/severity') severity
     , extractValue(value(rowdata),w_root||'/text') text
  from table(XMLSequence(w_errori_xml)) rowdata
;

cursor sel_warning (w_root varchar2) is
select extractValue(value(rowdata),w_root||'/code') code
     , extractValue(value(rowdata),w_root||'/severity') severity
     , extractValue(value(rowdata),w_root||'/text') text
  from table(XMLSequence(w_warning_xml)) rowdata
;

cursor sel_info (w_root varchar2) is
select extractValue(value(rowdata),w_root||'/code') code
     , extractValue(value(rowdata),w_root||'/severity') severity
     , extractValue(value(rowdata),w_root||'/text') text
  from table(XMLSequence(w_info_xml)) rowdata
;

cursor sel_modelEventoDTO (w_root varchar2) is
select extractValue(value(rowdata),w_root||'/stato') stato
     , extractValue(value(rowdata),w_root||'/id') id_r005
     , extractValue(value(rowdata),w_root||'/idAnsc') idAnsc_r005
     , extractValue(value(rowdata),w_root||'/numeroatto') numeroAtto_r005
     , extractValue(value(rowdata),w_root||'/idTipoEvento') idTipoEvento_r005
     , extractValue(value(rowdata),w_root||'/idtipocontenuto') idTipoContenuto_r005
     , extract(value(rowdata),w_root||'/intestatari').getClobVal() intestatari
     , extractValue(value(rowdata),w_root||'/idUsecase') idUsecase_r005
  from table(XMLSequence(w_modelEventoDTO_xml)) rowdata
;

cursor sel_intestatari (w_root varchar2) is
select extractValue(value(rowdata),w_root||'/id') id
     , extractValue(value(rowdata),w_root||'/cognome') cognome
     , extractValue(value(rowdata),w_root||'/nome') nome
     , extractValue(value(rowdata),w_root||'/codiceFiscale') codiceFiscale
  from table(XMLSequence(w_intestatari_xml)) rowdata
;

cursor sel_notifiche (w_root varchar2) is
select extractValue(value(rowdata),w_root||'/id') id
     , extractValue(value(rowdata),w_root||'/idSoggettoRif') idSoggettoRif
     , extractValue(value(rowdata),w_root||'/idStatoFlussoNotifiche') idStatoFlussoNotifiche
     , extractValue(value(rowdata),w_root||'/idGenereNotifiche') idGenereNotifiche
     , extractValue(value(rowdata),w_root||'/descrizione') descrizione
     , extractValue(value(rowdata),w_root||'/idAnsc') idAnsc
     , extractValue(value(rowdata),w_root||'/idComuneCompetente') idComuneCompetente
     , extractValue(value(rowdata),w_root||'/dataInizioValidita') dataInizioValidita
     , extractValue(value(rowdata),w_root||'/dataFineValidita') dataFineValidita
     , extractValue(value(rowdata),w_root||'/idComuneFormazione') idComuneFormazione
     , extractValue(value(rowdata),w_root||'/idcanalenotifica') idcanalenotifica
  from table(XMLSequence(w_notifiche_xml)) rowdata
;

cursor sel_notifiche_E (w_root varchar2) is
select extractValue(value(rowdata),w_root||'/id') id
     , extractValue(value(rowdata),w_root||'/idtipocontenuto') idTipoContenuto
     , extractValue(value(rowdata),w_root||'/idsoggettorif') idSoggettoRif
     , extractValue(value(rowdata),w_root||'/idstatoflussonotifiche') idStatoFlussoNotifiche
     , extractValue(value(rowdata),w_root||'/idgenerenotifiche') idGenereNotifiche
     , extractValue(value(rowdata),w_root||'/descrizione') descrizione
     , extractValue(value(rowdata),w_root||'/idansc') idAnsc
     , extractValue(value(rowdata),w_root||'/idcomunecompetente') idComuneCompetente
     , extractValue(value(rowdata),w_root||'/datainiziovalidita') dataInizioValidita
     , extractValue(value(rowdata),w_root||'/datafinevalidita') dataFineValidita
     , extractValue(value(rowdata),w_root||'/idfomuneformazione') idComuneFormazione
     , extractValue(value(rowdata),w_root||'/idcanalenotifica') idcanalenotifica
     , extractValue(value(rowdata),w_root||'/descsoggettointestatario') descSoggettoIntestatario
  from table(XMLSequence(w_notifiche_xml)) rowdata
;

cursor sel_notifiche_A (w_root varchar2) is
select extractValue(value(rowdata),w_root||'/id') id
     , extractValue(value(rowdata),w_root||'/idTipoNotifica') idTipoNotifica
     , extractValue(value(rowdata),w_root||'/idComuneMittente') idComuneMittente
     , extractValue(value(rowdata),w_root||'/idComuneDestinatario') idComuneDestinatario
     , extractValue(value(rowdata),w_root||'/dataIns') dataIns
  from table(XMLSequence(w_notifiche_xml)) rowdata
;

w_ctr_return		number;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'ctr_risposta_xml';
w_note_log		varchar2(4000);
w_id_atto_log		varchar2(255) := f_UTIL_get_id_atto(a_archivio_rif,a_id_rif);

w_errore		varchar2(4000);
errore			exception;

begin
  dati_cliente;

  if a_campo_clob is not null then
     w_risposta_64k  := '';
     w_risposta_clob := a_campo_clob;
     begin
       if w_risposta_clob like '%<contenuto>%</contenuto>%' then
--          ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'ctr contenuto (64k)', w_id_atto_log);
          w_risposta_64k := substr(w_risposta_clob,1,instr(w_risposta_clob,'<contenuto>')+10);
          w_risposta_64k := w_risposta_64k||substr(w_risposta_clob,instr(w_risposta_clob,'</contenuto>'));
          ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'w_rispostsa_64k', w_risposta_64k, w_id_atto_log);
       elsif a_servizio = 'R008_R' and w_risposta_clob like '%<composizioneAnnotazione>%</composizioneAnnotazione>%' then
          w_risposta_temp := w_risposta_clob;
          w_risposta_64k  := w_risposta_clob;
          w_count_temp    := 0;
          while instr(w_risposta_temp,'<composizioneAnnotazione>') > 0 loop
                w_count_temp := w_count_temp + 1;
                w_risposta_64k  := substr(w_risposta_temp,1,instr(w_risposta_temp,'<composizioneAnnotazione>')-1);
                w_risposta_64k  := w_risposta_64k||substr(w_risposta_temp,instr(w_risposta_temp,'</composizioneAnnotazione>')+26);
                w_risposta_temp := w_risposta_64k;
--                ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'w_rispostsa_64k', w_risposta_64k, w_id_atto_log);
--                if w_count_temp > 10 then
--                   exit;
--                end if;
          end loop;
          ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'w_rispostsa_64k', w_risposta_64k, w_id_atto_log);
       else
          w_risposta_64k := w_risposta_clob;
       end if;

--       if w_risposta_clob like '%<indirizzoPostaAutorit%>%</indirizzoPostaAutorit%>%' then
--          ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'ctr indirizzoPosta (64k)', w_id_atto_log);
--          w_risposta_64k_1 := substr(w_risposta_clob,1,instr(w_risposta_clob,'<indirizzoPostaAutorit')-1);
--          w_risposta_64k_2 := substr(w_risposta_clob,instr(w_risposta_clob,'</indirizzoPostaAutorit'));
--          w_risposta_64k_2 := substr(w_risposta_64k_2,instr(w_risposta_64k_2,'>')+1);
--          w_risposta_64k   := w_risposta_64k_1||w_risposta_64k_2;
--       else
--          w_risposta_64k := w_risposta_clob;
--       end if;

       w_risposta_xml 	:= xmltype(w_risposta_64k);
     exception
       when others then
            ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'testata_xml - errore', sqlerrm, w_id_atto_log);
     end;

<< risposta >>
     for rec in sel_risposta ('root') loop
--
-- campi testataRisposta
         w_id_operazione_ADS   := rec.idOperazioneComune;
         w_id_operazione_ANSC  := rec.idOperazione;
         w_esito_ANSC          := rec.idEsito;
--         ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'idOperazioneComune', to_char(w_id_operazione_ADS), w_id_atto_log);
--         ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'idOperazione', to_char(w_id_operazione_ANSC), w_id_atto_log);
--         ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'idesito', w_esito_ANSC, w_id_atto_log);

--
-- campi datiPaginazione
         w_numRecordTotali := rec.numRecordTotali;
         w_numRecordPagina := rec.numRecordPagina;
         w_numPagina       := rec.numPagina;

--
-- campi R009 (validazione)
-- campi R013 (rettifica validazione)
-- campi R017 (rettifica annotazione)
-- campi R012_I
         if a_servizio like 'R013%' or a_servizio like 'R017%' then
            w_id_atto_ANSC        := rec.idAnsc_r013;
            w_id_evento_ANSC      := rec.idEvento_r013;
         elsif a_servizio like 'R012_I' then
            w_id_presa_visione    := rec.idPresaVisione;
         elsif a_servizio like 'R012_V' then
            w_stato_presa_visione := rec.idState;
         elsif a_servizio like 'R012_A' then
            w_descrizione_esito   := rec.descrizioneEsito_r012;
            w_codice_esito        := rec.codiceEsito_r012;
         else
            w_id_atto_ANSC        := rec.idAnsc;
            w_id_evento_ANSC      := rec.idEvento;
         end if;
--         ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'idAnsc', w_id_atto_ANSC, w_id_atto_log);
--         ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'idEvento', w_id_evento_ANSC, w_id_atto_log);
--
-- campi R005 (consultazione)
         w_modelEventoDTO_clob    := rec.modelEventoDTO;
--
-- campi R008_R (notifiche)
         w_notifiche_clob         := rec.notifiche;
--
-- campi R001 (allegati - upload / verifica)
         if a_servizio like 'R006%' then
            w_id_allegato_ANSC    := rec.idAllegato_R006;
            w_hash_allegato_ANSC  := rec.hash_R006;
            w_stato_allegato_ANSC := rec.statoAllegato_R006;
            w_id_documentum_ANSC  := rec.idDocumentum_R006;
         else
            w_id_allegato_ANSC    := rec.idAllegato;
            w_hash_allegato_ANSC  := rec.hash;
            w_stato_allegato_ANSC := rec.statoAllegato;
            w_id_documentum_ANSC  := rec.idDocumentum;
         end if;
--         ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'idAllegato', w_id_allegato_ANSC, w_id_atto_log);
--         ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'hash', w_hash_allegato_ANSC, w_id_atto_log);
--         ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'statoAllegato', w_stato_allegato_ANSC, w_id_atto_log);
--         ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'idDocumentum', w_id_documentum_ANSC, w_id_atto_log);
--
-- campi R010 (anteprima - evento)
-- campi R002 (certificazione)
-- campi R003 (comunicazioni)
         w_nome_file_ansc := '';
         w_tipo_file_ansc := '';
         w_contenuto_clob := '';
         if a_servizio like 'R010%' then
            if a_servizio like 'R010_C' then
                w_nome_file_ansc      := rec.nomeFile_r010_C;
                w_tipo_file_ansc      := rec.tipoFile_r010_C;
            else
                w_nome_file_ansc      := rec.nomeFile_r010;
                w_tipo_file_ansc      := rec.tipoFile_r010;
            end if;
--            w_contenuto_clob      := rec.contenuto_r010;
         elsif a_servizio like 'R002%' then
            w_nome_file_ansc      := rec.nomeFile_r002;
            w_tipo_file_ansc      := rec.tipoFile_r002;
--            w_contenuto_clob      := rec.contenuto_r002;
         elsif a_servizio like 'R003%' then
            w_nome_file_ansc      := rec.nomeFile_r003||'.'||rec.tipoFile_r003;
            w_tipo_file_ansc      := upper(rec.tipoFile_r003);
         end if;
         w_contenuto_clob      := f_UTIL_leggi_campo_xml(a_servizio,w_risposta_clob,'contenuto');
--         ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'w_nome_file_ansc', w_nome_file_ANSC, w_id_atto_log);
--         ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'w_tipo_file_ansc', w_tipo_file_ANSC, w_id_atto_log);
--         ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'w_contenuto_clob', w_contenuto_clob, w_id_atto_log);
--
         w_des_errore_ws       := rec.des_errore_ws;
         w_cod_errore_ws       := rec.cod_errore_ws;
         w_errori_clob         := rec.errori;
         w_warning_clob        := rec.warning;
         w_info_clob           := rec.info;
     end loop;

     begin
       delete anserr
        where id_operazione        = a_id_operazione
          and nvl(tipo_errore,'E') = 'W'
       ;
     end;

     w_lista_warning := '';
     if w_warning_clob is not null then
        w_warning_clob := '<root>'||w_warning_clob||'</root>';
--        ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'warning_clob', w_warning_clob, w_id_atto_log);
        w_warning_xml := xmltype(w_warning_clob);
        w_warning_xml := w_warning_xml.extract('/root/warnings','');

        w_sequenza      := 0;
        w_codice_errore := '';
        w_tipo_errore   := '';
        w_testo_errore  := '';
        for rec in sel_warning ('warnings') loop
            if w_sequenza = 0 then
               w_lista_warning := 'Lista warning:';
            end if;
            w_sequenza      := w_sequenza + 1;
            w_codice_errore := rec.code;
            w_tipo_errore   := rec.severity;
            w_testo_errore  := rec.text;
            begin
              insert into anserr
                     (id_operazione, data_ora, sequenza, codice_errore, tipo_errore, testo_errore)
              values (a_id_operazione, sysdate, w_sequenza, w_codice_errore, w_tipo_errore, w_testo_errore)
              ;
            exception
              when others then
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'errore in ins ANSERR', SQLERRM, w_id_atto_log);
            end;
--            ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'listaWarning', w_codice_errore||' - '||w_tipo_errore||' - '||w_testo_errore, w_id_atto_log);
  
            w_testo_errore := f_UTIL_errore_decode(w_codice_errore,w_testo_errore);
            w_lista_warning   := w_lista_warning||chr(10)||
                                 w_sequenza||'. '||w_testo_errore;
        end loop;
        ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'listaWarning', w_lista_warning, w_id_atto_log);
     end if; --if w_warning_clob is not null then
  
     begin
       delete anserr
        where id_operazione        = a_id_operazione
          and nvl(tipo_errore,'E') = 'I'
       ;
     end;

     w_lista_info := '';
     if w_info_clob is not null then
        w_info_clob := '<root>'||w_info_clob||'</root>';
--        ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'info_clob', w_info_clob, w_id_atto_log);
        w_info_xml := xmltype(w_info_clob);
        w_info_xml := w_info_xml.extract('/root/infos','');

        w_sequenza      := 0;
        w_codice_errore := '';
        w_tipo_errore   := '';
        w_testo_errore  := '';
        for rec in sel_info ('infos') loop
            if w_sequenza = 0 then
               w_lista_info := 'Lista info:';
            end if;
            w_sequenza      := w_sequenza + 1;
            w_codice_errore := rec.code;
            w_tipo_errore   := rec.severity;
            w_testo_errore  := rec.text;
            begin
              insert into anserr
                     (id_operazione, data_ora, sequenza, codice_errore, tipo_errore, testo_errore)
              values (a_id_operazione, sysdate, w_sequenza, w_codice_errore, w_tipo_errore, w_testo_errore)
              ;
            exception
              when others then
                ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'errore in ins ANSERR', SQLERRM, w_id_atto_log);
            end;
--            ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'listaInfo', w_codice_errore||' - '||w_tipo_errore||' - '||w_testo_errore, w_id_atto_log);
 
            w_testo_errore := f_UTIL_errore_decode(w_codice_errore,w_testo_errore);
            w_lista_info   := w_lista_info||chr(10)||
                              w_sequenza||'. '||w_testo_errore;
        end loop;
        ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'listaInfo', w_lista_info, w_id_atto_log);
     end if; --if w_info_clob is not null then

     w_info_ws := '';
     if nvl(w_esito_ANSC,'X') = '0' 
        or (a_servizio in ('R013', 'R010_C','R017') and w_esito_ansc is null and w_id_operazione_ansc is not null and w_errori_clob is null)
     then
        if a_servizio like 'R001_U%' or a_servizio like 'R006%' then
           if a_archivio_rif = 'ALL' then
              begin
                update civfas_alle
                   set id_allegato_ansc   = w_id_allegato_ANSC,
                       hash_allegato_ansc = w_hash_allegato_ANSC
                 where id = a_id_rif
                ;
                if sql%found then
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civfas_alle OK', '', w_id_atto_log);
                else
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civfas_alle KO', '', w_id_atto_log);
                end if;
              exception
                when others then
                     ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civfas_alle - errore', sqlerrm, w_id_atto_log);
              end;
           end if;

        elsif a_servizio like 'R001_V%' then
           w_info_ws := f_ANSC_stato_allegato(w_stato_allegato_ansc);
           if w_info_ws is not null then
              w_info_ws := 'Stato Allegato: '||w_info_ws;
           end if;
--           ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'w_info_ws', w_info_ws, w_id_atto_log);

        elsif a_servizio like 'R005%' then
           w_modelEventoDTO_clob := '<root>'||w_modelEventoDTO_clob||'</root>';
--           ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'modelEventoDTO_clob', w_modelEventoDTO_clob, w_id_atto_log);
           w_modelEventoDTO_xml  := xmltype(w_modelEventoDTO_clob);
           w_modelEventoDTO_xml  := w_modelEventoDTO_xml.extract('/root/modelEventoDTO','');

           for rec_dto in sel_modelEventoDTO ('modelEventoDTO') loop
               w_intestatari_clob    := rec_dto.intestatari;

               if a_servizio like 'R005_G%' then
                  w_stato_ANSC              := rec_dto.stato;
                  w_id_atto_ANSC            := rec_dto.idAnsc_R005;
                  w_id_evento_ANSC          := rec_dto.id_R005;
                  w_id_tipo_evento_ANSC     := rec_dto.idTipoEvento_R005;
                  w_id_tipo_contenuto_ANSC  := rec_dto.idTipoContenuto_R005;
                  w_id_usecase_ANSC         := rec_dto.idUsecase_R005;
                  w_numero_atto             := rec_dto.numeroAtto_R005;

                  w_note_log := 'w_stato_ANSC: '||rec_dto.stato||' - '||
                                   'w_id_atto_ANSC: '||rec_dto.idAnsc_R005||' - '||
                                   'w_id_evento_ANSC: '||rec_dto.id_R005||' - '||
                                   'w_id_tipo_evento_ANSC: '||rec_dto.idTipoEvento_R005||' - '||
                                   'w_id_tipo_contenuto_ANSC: '||rec_dto.idTipoContenuto_R005||' - '||
                                   'w_id_usecase_ANSC: '||rec_dto.idUsecase_R005||' - '||
                                   'w_numero_atto: '||rec_dto.numeroAtto_R005;
                                  
                  ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'rec_dto', w_note_log, w_id_atto_log);
 
                 if w_id_atto_ANSC like '%'||w_codice_cliente then
--     , idTipoEvento    (anst01) 1 - NASCITA / 2 - MORTE / 3 - MATRIMONIO / 4 - UNIONE CIVILE / 5 - CITTADINANZA 
                    if w_id_tipo_evento_ansc = '1' then
                       w_des_tipo_evento_ansc := '1 - NASCITA';
                    elsif w_id_tipo_evento_ansc = '2' then
                       w_des_tipo_evento_ansc := '2 - MORTE';
                    elsif w_id_tipo_evento_ansc = '3' then
                       w_des_tipo_evento_ansc := '3 - MATRIMONIO';
                    elsif w_id_tipo_evento_ansc = '4' then
                       w_des_tipo_evento_ansc := '4 - UNIONE CIVILE';
                    elsif w_id_tipo_evento_ansc = '5' then
                       w_des_tipo_evento_ansc := '5 - CITTADINANZA';
                    end if;
--     , idTipoContenuto (anst02) 1 - ATTO / 2 - ANNOTAZIONE / 3 - TRASCRIZIONE / 4 - ANNOTAZIONE AUTO
                    if w_id_tipo_contenuto_ansc = '1' then
                       w_des_tipo_contenuto_ansc := '1 - ATTO';
                    elsif w_id_tipo_contenuto_ansc = '2' then
                       w_des_tipo_contenuto_ansc := '2 - ANNOTAZIONE';
                    elsif w_id_tipo_contenuto_ansc = '3' then
                       w_des_tipo_contenuto_ansc := '3 - TRASCRIZIONE';
                    elsif w_id_tipo_contenuto_ansc = '4' then
                       w_des_tipo_contenuto_ansc := '4 - ANNOTAZIONE AUTO';
                    end if;

                     if w_id_tipo_contenuto_ANSC in ('1','3') then 
                        if w_id_tipo_evento_ANSC = '1' and a_archivio_rif = 'NAS' then
                           begin
                             update civnas
                                set id_atto_ansc    = w_id_atto_ansc,
                                    id_evento_ansc  = w_id_evento_ansc,
                                    id_usecase_ansc = w_id_usecase_ansc,
                                    numero_unico    = w_numero_atto
                              where id_atto_ansc is null
                                and id           = a_id_rif
                             ;
                             if sql%found then
                                ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civnas (id) OK', '', w_id_atto_log);
                                w_ctr_return := f_UTIL_ansciu_ins_x_stato(a_servizio,a_archivio_rif,a_id_rif,w_stato_ansc);
                             else
                                ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civnas (id) KO', '', w_id_atto_log);
                             end if;
                           exception
                             when others then
                               ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civnas (id) - errore', sqlerrm, w_id_atto_log);
                           end;

                        elsif w_id_tipo_evento_ANSC = '2' and a_archivio_rif = 'MOR' then
                           begin
                             update civmor
                                set id_atto_ansc    = w_id_atto_ansc,
                                    id_evento_ansc  = w_id_evento_ansc,
                                    id_usecase_ansc = w_id_usecase_ansc,
                                    numero_unico    = w_numero_atto
                              where id_atto_ansc is null
                                and id           = a_id_rif
                             ;
                             if sql%found then
                                ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civmor (id) OK', '', w_id_atto_log);
                                w_ctr_return := f_UTIL_ansciu_ins_x_stato(a_servizio,a_archivio_rif,a_id_rif,w_stato_ansc);
                             else
                                ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civmor (id) KO', '', w_id_atto_log);
                             end if;
                           exception
                             when others then
                               ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civmor (id) - errore', sqlerrm, w_id_atto_log);
                           end;

                        elsif w_id_tipo_evento_ANSC = '3' and a_archivio_rif = 'MAT' then
                           begin
                             update civmat
                                set id_atto_ansc    = w_id_atto_ansc,
                                    id_evento_ansc  = w_id_evento_ansc,
                                    id_usecase_ansc = w_id_usecase_ansc,
                                    numero_unico    = w_numero_atto
                              where id_atto_ansc is null
                                and id           = a_id_rif
                             ;
                             if sql%found then
                                ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civmat (id) OK', '', w_id_atto_log);
                                w_ctr_return := f_UTIL_ansciu_ins_x_stato(a_servizio,a_archivio_rif,a_id_rif,w_stato_ansc);
                             else
                                ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civmat (id) KO', '', w_id_atto_log);
                             end if;
                           exception
                             when others then
                               ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civmat (id) - errore', sqlerrm, w_id_atto_log);
                           end;

                        elsif w_id_tipo_evento_ANSC = '4' and a_archivio_rif = 'UCI' then
                           begin
                             update civuci
                                set id_atto_ansc    = w_id_atto_ansc,
                                    id_evento_ansc  = w_id_evento_ansc,
                                    id_usecase_ansc = w_id_usecase_ansc,
                                    numero_unico    = w_numero_atto
                              where id_atto_ansc is null
                                and id           = a_id_rif
                             ;
                             if sql%found then
                                ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civuci (id) OK', '', w_id_atto_log);
                                w_ctr_return := f_UTIL_ansciu_ins_x_stato(a_servizio,a_archivio_rif,a_id_rif,w_stato_ansc);
                             else
                                ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civuci (id) KO', '', w_id_atto_log);
                             end if;
                           exception
                             when others then
                               ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civuci (id) - errore', sqlerrm, w_id_atto_log);
                           end;

                        elsif w_id_tipo_evento_ANSC = '5' and a_archivio_rif = 'CIT' then
                           begin
                             update civcit
                                set id_atto_ansc    = w_id_atto_ansc,
                                    id_evento_ansc  = w_id_evento_ansc,
                                    id_usecase_ansc = w_id_usecase_ansc,
                                    numero_unico    = w_numero_atto
                              where id_atto_ansc is null
                                and id           = a_id_rif
                             ;
                             if sql%found then
                                ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civcit (id) OK', '', w_id_atto_log);
                                w_ctr_return := f_UTIL_ansciu_ins_x_stato(a_servizio,a_archivio_rif,a_id_rif,w_stato_ansc);
                             else
                                ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civcit (id) KO', '', w_id_atto_log);
                             end if;
                           exception
                             when others then
                               ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civcit (id) - errore', sqlerrm, w_id_atto_log);
                           end;

                        else
                           w_esito_ANSC := 1;
                           w_note_ws    := 'Aggiornamento non consentito: Tipo Evento non coerente ('||w_des_tipo_evento_ansc||')';
                           w_info_ws    := '';
                           w_ctr_return := f_UTIL_ansciu_upd_R005_G(a_servizio,a_id_operazione,w_id_operazione_ansc,w_esito_ansc,w_note_ws,w_info_ws);
                       
                           goto fine;
                        end if;

                     elsif w_id_tipo_contenuto_ANSC in ('2') and a_archivio_rif = 'ANN' then 
                        begin
                          update civann
                             set id_atto_ansc    = w_id_atto_ansc,
                                 id_evento_ansc  = w_id_evento_ansc,
                                 id_usecase_ansc = w_id_usecase_ansc,
                                 numero_unico    = w_numero_atto
                           where id_atto_ansc is null
                             and id           = a_id_rif
                          ;
                          if sql%found then
                             ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civann (id) OK', '', w_id_atto_log);
                             w_ctr_return := f_UTIL_ansciu_ins_x_stato(a_servizio,a_archivio_rif,a_id_rif,w_stato_ansc);
                          else
                             ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civann (id) KO', '', w_id_atto_log);
                          end if;
                        exception
                          when others then
                            ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civann (id) - errore', sqlerrm, w_id_atto_log);
                        end;

                     else
                        w_esito_ANSC := 1;
                        w_note_ws    := 'Aggiornamento non consentito: Tipo Contenuto non coerente ('||w_des_tipo_contenuto_ansc||')';
                        w_info_ws    := '';
                        w_ctr_return := f_UTIL_ansciu_upd_R005_G(a_servizio,a_id_operazione,w_id_operazione_ansc,w_esito_ansc,w_note_ws,w_info_ws);
                     
                        goto fine;
                     end if;

                  elsif w_id_atto_ANSC not like '%'||w_codice_cliente then
                     w_esito_ANSC := 1;
                     w_note_ws    := 'Aggiornamento non consentito: ID Atto Ansc di altro comune';
                     w_info_ws    := '';
                     w_ctr_return := f_UTIL_ansciu_upd_R005_G(a_servizio,a_id_operazione,w_id_operazione_ansc,w_esito_ansc,w_note_ws,w_info_ws);
                 
                     goto fine;
                  end if;

               elsif a_servizio like 'R005_E%' then
                  w_stato_ANSC       := rec_dto.stato;
--                  ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'stato', w_stato_ANSC, w_id_atto_log);

                  w_info_ws          := 'Stato: '||w_stato_ansc;
                  w_ctr_return       := f_UTIL_ansciu_ins_x_stato(a_servizio,a_archivio_rif,a_id_rif,w_stato_ansc);

               elsif a_servizio like 'R005_1%' or a_servizio like 'R005_2%' or a_servizio like 'R005_S%' then
                  w_info_ws          := '';

               elsif a_servizio like 'R008_E%' then
                  w_info_ws          := '';

               elsif a_servizio like 'R008_A%' then
                  w_info_ws          := '';

               end if;

               if w_intestatari_clob is not null then
                  w_intestatari_clob := '<root>'||w_intestatari_clob||'</root>';
--                  ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'intestatari_clob', w_intestatari_clob, w_id_atto_log);
                  w_intestatari_xml := xmltype(w_intestatari_clob);
                  w_intestatari_xml := w_intestatari_xml.extract('/root/intestatari','');

                  w_sequenza              := 0;
                  w_id_soggetto_ansc_r005 := '';
                  w_cognome_r005          := '';
                  w_nome_r005             := '';
                  w_codice_fiscale_r005   := '';
                  for rec_int in sel_intestatari ('intestatari') loop
                      w_sequenza            := w_sequenza + 1;

                      w_id_soggetto_ansc_r005 := rec_int.id;
                      w_cognome_r005          := rec_int.cognome;
                      w_nome_r005             := rec_int.nome;
                      w_codice_fiscale_r005   := rec_int.codiceFiscale;
                      if a_servizio like 'R005_1%' or a_servizio like 'R005_2%' or a_servizio like 'R005_S%' then
                         if w_id_soggetto_ansc_r005 is not null then
                            w_info_ws := ltrim(w_info_ws||chr(10)||'idSoggettoAnsc: '||w_id_soggetto_ansc_r005||' (cognome: '||w_cognome_r005||' - nome: '||w_nome_r005||')',chr(10));
                         end if;
                      end if; -- if a_servizio like 'R005_1%' or a_servizio like 'R005_2%' or a_servizio like 'R005_S%' then

                     if w_id_soggetto_ansc_r005 is not null then
                        if a_archivio_rif = 'NOT' then
                           begin
                             update ansnot
                                set cognome_soggetto_ansc = w_cognome_r005,
                                    nome_soggetto_ansc    = w_nome_r005
                              where id               = a_id_rif
                                and id_soggetto_ansc = w_id_soggetto_ansc_r005
                             ;
                             if sql%found then
                                ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_ansnot (1) OK', '', w_id_atto_log);
                             else
                                ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_ansnot (1) KO', '', w_id_atto_log);
                             end if;
                           exception
                             when others then
                                  ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_ansnot (1) - errore', sqlerrm, w_id_atto_log);
                           end;

                        elsif a_archivio_rif = 'NAS' then
                           begin
                             update civnas
                                set id_soggetto_ansc = w_id_soggetto_ansc_r005
                              where id_atto          = w_id_atto
                                and cognome          = w_cognome_r005
                                and nome             = w_nome_r005
                                and id_soggetto_ansc is null
                             ;
                             if sql%found then
                                ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civnas (1) OK', '', w_id_atto_log);
                             else
                                ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civnas (1) KO', '', w_id_atto_log);
                             end if;
                           exception
                             when others then
                                  ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civnas (1) - errore', sqlerrm, w_id_atto_log);
                           end;

                        elsif a_archivio_rif = 'MOR' then
                           begin
                             update civmor
                                set id_soggetto_ansc = w_id_soggetto_ansc_r005
                              where id_atto          = w_id_atto
                                and cognome          = w_cognome_r005
                                and nome             = w_nome_r005
                                and id_soggetto_ansc is null
                             ;
                             if sql%found then
                                ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civmor (1) OK', '', w_id_atto_log);
                             else
                                ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civmor (1) KO', '', w_id_atto_log);
                             end if;
                           exception
                             when others then
                                  ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civmor (1) - errore', sqlerrm, w_id_atto_log);
                           end;

                        elsif a_archivio_rif = 'MAT' then
                           begin
                             update civmat
                                set id_soggetto_ansc_m = w_id_soggetto_ansc_r005
                              where id_atto            = w_id_atto
                                and cognome_m          = w_cognome_r005
                                and nome_m             = w_nome_r005
                                and id_soggetto_ansc_m is null
                             ;
                             if sql%found then
                                ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civmat_m (1) OK', '', w_id_atto_log);
                             else
                                ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civmat_m (1) KO', '', w_id_atto_log);
                             end if;
                           exception
                             when others then
                                  ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civmat_m (1) - errore', sqlerrm, w_id_atto_log);
                           end;

                           begin
                             update civmat
                                set id_soggetto_ansc_f = w_id_soggetto_ansc_r005
                              where id_atto            = w_id_atto
                                and cognome_f          = w_cognome_r005
                                and nome_f             = w_nome_r005
                                and id_soggetto_ansc_f is null
                             ;
                             if sql%found then
                                ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civmat_f (1) OK', '', w_id_atto_log);
                             else
                                ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civmat_f (1) KO', '', w_id_atto_log);
                             end if;
                           exception
                             when others then
                                  ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civmat_f (1) - errore', sqlerrm, w_id_atto_log);
                           end;

                        elsif a_archivio_rif = 'UCI' then
                           begin
                             update civuci
                                set id_soggetto_ansc_m = w_id_soggetto_ansc_r005
                              where id_atto            = w_id_atto
                                and cognome_m          = w_cognome_r005
                                and nome_m             = w_nome_r005
                               and id_soggetto_ansc_m is null
                             ;
                             if sql%found then
                                ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civuci_1 (1) OK', '', w_id_atto_log);
                             else
                                ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civuci_1 (1) KO', '', w_id_atto_log);
                             end if;
                           exception
                             when others then
                                  ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civuci_1 (1) - errore', sqlerrm, w_id_atto_log);
                           end;

                           begin
                             update civuci
                                set id_soggetto_ansc_f = w_id_soggetto_ansc_r005
                              where id_atto            = w_id_atto
                                and cognome_f          = w_cognome_r005
                                and nome_f             = w_nome_r005
                                and id_soggetto_ansc_f is null
                             ;
                             if sql%found then
                                ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civuci_2 (1) OK', '', w_id_atto_log);
                             else
                                ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civuci_2 (1) KO', '', w_id_atto_log);
                             end if;
                           exception
                             when others then
                                  ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civuci_2 (1) - errore', sqlerrm, w_id_atto_log);
                           end;

                        elsif a_archivio_rif = 'CIT' then
                           begin
                             update civcit
                                set id_soggetto_ansc = w_id_soggetto_ansc_r005
                              where id_atto            = w_id_atto
                                and cognome          = w_cognome_r005
                                and nome             = w_nome_r005
                                and id_soggetto_ansc is null
                             ;
                             if sql%found then
                                ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civcit (1) OK', '', w_id_atto_log);
                             else
                                ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civcit (1) KO', '', w_id_atto_log);
                             end if;
                           exception
                             when others then
                                  ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civcit (1) - errore', sqlerrm, w_id_atto_log);
                           end;
                        end if; -- if a_archivio_rif = 'xxx' then
                     end if;
                  end loop; -- for rec_int in sel_intestatari ('intestatari') loop
               end if; -- if w_intestatari_clob is not null then
           end loop;

        elsif a_servizio like 'R008_R' or a_servizio like 'R008_E' or a_servizio like 'R008_A' then
           w_notifiche_clob := '<root>'||w_notifiche_clob||'</root>';
--           ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'notifiche_clob', w_notifiche_clob);
           w_notifiche_xml := xmltype(w_notifiche_clob);
           w_notifiche_xml := w_notifiche_xml.extract('/root/notifiche','');

           if a_servizio like 'R008_R' then
              if w_numRecordTotali is not null then
                 w_info_ws := 'numRecordTotali: '||w_numRecordTotali||' - '||
                                 'numRecordPagina: '||w_numRecordPagina||' - '||
                                 'numPagina: '||w_numPagina;
              end if;

              begin
                delete ansnot
                ;
              exception
                when others then 
                     ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'del_ansnot - errore', sqlerrm, w_id_atto_log);
              end;
   
              for rec_not in sel_notifiche ('notifiche') loop
                  w_id_notifica               := rec_not.id;
                  w_id_soggetto_ansc_notifica := rec_not.idSoggettoRif;
                  w_stato_notifica            := rec_not.idStatoFlussoNotifiche;
                  w_genere_notifica           := rec_not.idGenereNotifiche;
                  w_descrizione_notifica      := rec_not.descrizione;
                  w_id_ansc                   := rec_not.idAnsc;
                  w_dal_notifica              := to_date(substr(rec_not.dataInizioValidita,1,10),'yyyy-mm-dd');
                  w_al_notifica               := to_date(substr(rec_not.dataFineValidita,1,10),'yyyy-mm-dd');
                  w_id_comune_competente      := rec_not.idComuneCompetente;
                  w_id_comune_formazione      := rec_not.idComuneFormazione;
                  w_canale_notifica           := rec_not.idcanalenotifica;

                  begin
                    insert into ansnot
                          (id, id_soggetto_ansc, id_ansc, stato, genere, valido_dal, valido_al, id_comune_competente, id_comune_formazione, descrizione, canale_comunicazione_ansc)
                    select w_id_notifica, w_id_soggetto_ansc_notifica, w_id_ansc, w_stato_notifica, w_genere_notifica, 
                           w_dal_notifica, w_al_notifica, w_id_Comune_competente, w_id_comune_formazione, w_descrizione_notifica, w_canale_notifica
                      from dual
                     where not exists (select 1 from ansnot b
                                        where b.id = w_id_notifica)
                    ;
                  exception
                    when others then 
                         ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'ins_ansnot - errore', sqlerrm, w_id_atto_log);
                  end;
              end loop; --sel_notifiche

           elsif a_servizio like 'R008_E' then
              for rec_not in sel_notifiche_E ('notifiche') loop
                  w_id_notifica               := rec_not.id;
                  w_id_soggetto_ansc_notifica := rec_not.idSoggettoRif;
                  w_tipo_contenuto_notifica   := rec_not.idTipoContenuto;
                  w_stato_notifica            := rec_not.idStatoFlussoNotifiche; -- anst102
                  w_genere_notifica           := rec_not.idGenereNotifiche; -- anst101
                  w_descrizione_notifica      := rec_not.descrizione;
                  w_id_ansc                   := rec_not.idAnsc;
                  w_dal_notifica              := to_date(substr(rec_not.dataInizioValidita,1,10),'yyyy-mm-dd');
                  w_al_notifica               := to_date(substr(rec_not.dataFineValidita,1,10),'yyyy-mm-dd');
                  w_id_comune_competente      := rec_not.idComuneCompetente; -- anpt03
                  w_id_comune_formazione      := rec_not.idComuneFormazione; -- anpt03
                  w_canale_notifica           := rec_not.idcanalenotifica; -- anpt105
                  w_des_soggetto_notifica     := rec_not.descSoggettoIntestatario;

                  w_des_stato_notifica     := f_ANSC_get_descrizione_TAB('ANST102',w_stato_notifica);
                  w_des_genere_notifica    := f_ANSC_get_descrizione_TAB('ANST101',w_genere_notifica);
                  w_des_contenuto_notifica := f_ANSC_get_descrizione_TAB('ANST02',w_tipo_contenuto_notifica);
                  w_des_comune_competente  := f_ANSC_get_descrizione_TAB('ANPT03',w_id_comune_competente,'','CODICE');
                  w_des_canale_notifica    := f_ANSC_get_descrizione_TAB('ANST105',w_canale_notifica);

                  w_info_ws := ltrim(w_info_ws||chr(10)||'idNotificaAnsc: '||w_id_notifica||
                                                        ' - comuneCompetente: '||w_des_comune_competente||
                                                        ' - genere: '||w_des_genere_notifica||
                                                        ' - stato: '||w_des_stato_notifica||
                                                        ' - canale: '||w_des_canale_notifica||
                                                        ' - descrizione: '||w_descrizione_notifica||
                                                        ' - soggetto: '||w_des_soggetto_notifica
                                ,chr(10));
              end loop;

           elsif a_servizio like 'R008_A' then

              for rec_not in sel_notifiche_A ('notifiche') loop
                  w_id_notifica_anpr             := rec_not.id;
                  w_id_tipo_notifica_anpr        := rec_not.idTipoNotifica; -- anpt00
                  w_id_comune_mittente_anpr      := rec_not.idComuneMittente; -- anpt03
                  w_id_comune_destinatario_anpr  := rec_not.idComuneDestinatario; -- anpt03
                  w_data_ins_anpr                := rec_not.dataIns;

                  w_des_tipo_notifica_anpr       := f_ANSC_get_descrizione_TAB('ANPT00',w_id_tipo_notifica_anpr,'','CODICE');
                  w_des_comune_mittente_anpr     := f_ANSC_get_descrizione_TAB('ANPT03',w_id_comune_mittente_anpr,'','CODICE');
                  w_des_comune_destinatario_anpr := f_ANSC_get_descrizione_TAB('ANPT03',w_id_comune_destinatario_anpr,'','CODICE');

                  w_info_ws := ltrim(w_info_ws||chr(10)||'idNotificaAnpr: '||w_id_notifica_anpr||
                                                        ' - comuneMittente: '||w_des_comune_mittente_anpr||
                                                        ' - comuneDestinatario: '||w_des_comune_destinatario_anpr||
                                                        ' - tipo: '||w_id_tipo_notifica_anpr||' - '||w_des_tipo_notifica_anpr
                                ,chr(10));
              end loop;
           end if;

        elsif a_servizio like 'R009_V%' then
           if a_archivio_rif = 'NAS' then
              begin
                update civnas
                   set id_atto_ansc = w_id_atto_ANSC,
                       id_evento_ansc = w_id_evento_ANSC
                 where id = a_id_rif
                ;
                if sql%found then
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civnas OK', '', w_id_atto_log);
                else
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civnas KO', '', w_id_atto_log);
                end if;
              exception
                when others then
                     ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civnas - errore', sqlerrm, w_id_atto_log);
              end;

           elsif a_archivio_rif = 'MOR' then
              begin
                update civmor
                   set id_atto_ansc = w_id_atto_ANSC,
                       id_evento_ansc = w_id_evento_ANSC
                 where id = a_id_rif
                ;
                if sql%found then
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civmor OK', '', w_id_atto_log);
                else
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civmor KO', '', w_id_atto_log);
                end if;
              exception
                when others then
                     ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civmor - errore', sqlerrm, w_id_atto_log);
              end;

           elsif a_archivio_rif = 'CIT' then
              begin
                update civcit
                   set id_atto_ansc = w_id_atto_ANSC,
                       id_evento_ansc = w_id_evento_ANSC
                 where id = a_id_rif
                ;
                if sql%found then
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civcit OK', '', w_id_atto_log);
                else
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civcit KO', '', w_id_atto_log);
                end if;
              exception
                when others then
                     ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civcit - errore', sqlerrm, w_id_atto_log);
              end;

           elsif a_archivio_rif = 'MAT' then
              begin
                update civmat
                   set id_atto_ansc = w_id_atto_ANSC,
                       id_evento_ansc = w_id_evento_ANSC
                 where id = a_id_rif
                ;
                if sql%found then
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civmat OK', '', w_id_atto_log);
                else
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civmat KO', '', w_id_atto_log);
                end if;
              exception
                when others then
                     ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civmat - errore', sqlerrm, w_id_atto_log);
              end;

           elsif a_archivio_rif = 'UCI' then
              begin
                update civuci
                   set id_atto_ansc = w_id_atto_ANSC,
                       id_evento_ansc = w_id_evento_ANSC
                 where id = a_id_rif
                ;
                if sql%found then
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civuci OK', '', w_id_atto_log);
                else
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civuci KO', '', w_id_atto_log);
                end if;
              exception
                when others then
                     ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civuci - errore', sqlerrm, w_id_atto_log);
              end;
           end if;

        elsif a_servizio like 'R009_A%' or a_servizio like 'R013%' or a_servizio like 'R017%' then
-- 06/12/2023 (AM): in caso di servizio R013 l'esito non è presente nella risposta quindi viene valorizzato a '0'
           w_esito_ANSC := nvl(w_esito_ANSC,0);
           begin
             update civann
                set id_atto_ansc = w_id_atto_ANSC,
                    id_evento_ansc = w_id_evento_ANSC
              where id = a_id_rif
             ;
             if sql%found then
                ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civann OK', '', w_id_atto_log);
             else
                ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civann KO', '', w_id_atto_log);
             end if;
           exception
             when others then
                  ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civnas - errore', sqlerrm, w_id_atto_log);
           end;

        elsif a_servizio like 'R010%' or a_servizio like 'R002%' or a_servizio like 'R003%' then

           if a_servizio like 'R010_C%' then
              -- 29/04/2024 (SN): in caso di servizio R010_C l'esito non è presente nella risposta quindi viene valorizzato a '0'
              w_esito_ANSC := nvl(w_esito_ANSC,0);
           end if;

           if w_contenuto_clob is not null then
-- 31/05/2023 (AM): precedente gestione che leggeva il clob con la getClobVal del cursore principale
--              w_contenuto_clob := replace(w_contenuto_clob,'<contenuto>','');
--              w_contenuto_clob := replace(w_contenuto_clob,'</contenuto>','');
--              w_contenuto_clob := replace(w_contenuto_clob,chr(10),'');

              begin
                w_contenuto_blob := f_UTIL_base64_decode(w_contenuto_clob);
              exception
                when others then
                     ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'clob2blob', 'errore: '||sqlerrm, w_id_atto_log);
              end;

              begin
                delete ansc_allegati
                 where id_operazione = a_id_operazione
                ;
              exception
                when others then
                     ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'del_ansc_allegati', 'errore: '||sqlerrm, w_id_atto_log);
              end;

              if w_tipo_file_ansc in ('1','2','3','4','5','6','7','8','9') then
                 w_tipo_file_ansc := f_ANSC_des_tipo_file(w_tipo_file_ansc);
              end if;
              begin
                insert into ansc_allegati (id_operazione, nome_file, tipo_file, allegato_clob, allegato_blob)
                values (a_id_operazione, w_nome_file_ansc, w_tipo_file_ansc, w_contenuto_clob, w_contenuto_blob)
                ;
--                update ansc_allegati
--                   set allegato_blob = w_contenuto_blob
--                 where id_operazione = a_id_operazione
--                ;
              exception
                when others then
                     ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'ins_ansc_allegati', 'errore: '||sqlerrm, w_id_atto_log);
              end;
           end if;

        elsif a_servizio like 'R011%' then
           w_id_atto_ANSC       := '';
           w_id_evento_ANSC     := '';
           w_id_soggetto_ANSC_1 := '';
           w_id_soggetto_ANSC_2 := '';
           if a_archivio_rif = 'NAS' then
              begin
                update civnas
                   set id_atto_ansc     = w_id_atto_ANSC,
                       id_evento_ansc   = w_id_evento_ANSC,
                       id_soggetto_ansc = w_id_soggetto_ANSC_1
                 where id = a_id_rif
                ;
                if sql%found then
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civnas OK', '', w_id_atto_log);
                else
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civnas KO', '', w_id_atto_log);
                end if;
              exception
                when others then
                     ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civnas - errore', sqlerrm, w_id_atto_log);
              end;
              begin
                update civfas_alle fas_a
                   set id_allegato_ansc   = '',
                       hash_allegato_ansc = ''
                 where exists (select 'x' from civfas fas, civnas nas
                                where fas.id      = fas_a.id_civfas
                                  and fas.id_atto = nas.id_atto
                                  and nas.id      = a_id_rif)
                ;
                if sql%found then
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civfas_alle OK', '', w_id_atto_log);
                else
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civfas_alle KO', '', w_id_atto_log);
                end if;
              exception
                when others then
                     ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civfas_alle - errore', sqlerrm, w_id_atto_log);
              end;

           elsif a_archivio_rif = 'MOR' then
              begin
                update civmor
                   set id_atto_ansc     = w_id_atto_ANSC,
                       id_evento_ansc   = w_id_evento_ANSC,
                       id_soggetto_ansc = w_id_soggetto_ANSC_1
                 where id = a_id_rif
                ;
                if sql%found then
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civmor OK', '', w_id_atto_log);
                else
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civmor KO', '', w_id_atto_log);
                end if;
              exception
                when others then
                     ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civmor - errore', sqlerrm, w_id_atto_log);
              end;
              begin
                update civfas_alle fas_a
                   set id_allegato_ansc   = '',
                       hash_allegato_ansc = ''
                 where exists (select 'x' from civfas fas, civmor mor
                                where fas.id      = fas_a.id_civfas
                                  and fas.id_atto = mor.id_atto
                                  and mor.id      = a_id_rif)
                ;
                if sql%found then
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civfas_alle OK', '', w_id_atto_log);
                else
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civfas_alle KO', '', w_id_atto_log);
                end if;
              exception
                when others then
                     ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civfas_alle - errore', sqlerrm, w_id_atto_log);
              end;

           elsif a_archivio_rif = 'CIT' then
              begin
                update civcit
                   set id_atto_ansc     = w_id_atto_ANSC,
                       id_evento_ansc   = w_id_evento_ANSC,
                       id_soggetto_ansc = w_id_soggetto_ANSC_1
                 where id = a_id_rif
                ;
                if sql%found then
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civcit OK', '', w_id_atto_log);
                else
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civcit KO', '', w_id_atto_log);
                end if;
              exception
                when others then
                     ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civcit - errore', sqlerrm, w_id_atto_log);
              end;
              begin
                update civfas_alle fas_a
                   set id_allegato_ansc   = '',
                       hash_allegato_ansc = ''
                 where exists (select 'x' from civfas fas, civcit cit
                                where fas.id      = fas_a.id_civfas
                                  and fas.id_atto = cit.id_atto
                                  and cit.id      = a_id_rif)
                ;
                if sql%found then
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civfas_alle OK', '', w_id_atto_log);
                else
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civfas_alle KO', '', w_id_atto_log);
                end if;
              exception
                when others then
                     ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civfas_alle - errore', sqlerrm, w_id_atto_log);
              end;

           elsif a_archivio_rif = 'MAT' then
              begin
                update civmat
                   set id_atto_ansc       = w_id_atto_ANSC,
                       id_evento_ansc     = w_id_evento_ANSC,
                       id_soggetto_ansc_m = w_id_soggetto_ANSC_1,
                       id_soggetto_ansc_f = w_id_soggetto_ANSC_2
                 where id = a_id_rif
                ;
                if sql%found then
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civmat OK', '', w_id_atto_log);
                else
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civmat KO', '', w_id_atto_log);
                end if;
              exception
                when others then
                     ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civmat - errore', sqlerrm, w_id_atto_log);
              end;
              begin
                update civfas_alle fas_a
                   set id_allegato_ansc   = '',
                       hash_allegato_ansc = ''
                 where exists (select 'x' from civfas fas, civmat mat
                                where fas.id      = fas_a.id_civfas
                                  and fas.id_atto = mat.id_atto
                                  and mat.id      = a_id_rif)
                ;
                if sql%found then
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civfas_alle OK', '', w_id_atto_log);
                else
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civfas_alle KO', '', w_id_atto_log);
                end if;
              exception
                when others then
                     ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civfas_alle - errore', sqlerrm, w_id_atto_log);
              end;

           elsif a_archivio_rif = 'UCI' then
              begin
                update civuci
                   set id_atto_ansc       = w_id_atto_ANSC,
                       id_evento_ansc     = w_id_evento_ANSC,
                       id_soggetto_ansc_m = w_id_soggetto_ANSC_1,
                       id_soggetto_ansc_f = w_id_soggetto_ANSC_2
                 where id = a_id_rif
                ;
                if sql%found then
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civuci OK', '', w_id_atto_log);
                else
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civuci KO', '', w_id_atto_log);
                end if;
              exception
                when others then
                     ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civuci - errore', sqlerrm, w_id_atto_log);
              end;
              begin
                update civfas_alle fas_a
                   set id_allegato_ansc   = '',
                       hash_allegato_ansc = ''
                 where exists (select 'x' from civfas fas, civuci uci
                                where fas.id      = fas_a.id_civfas
                                  and fas.id_atto = uci.id_atto
                                  and uci.id      = a_id_rif)
                ;
                if sql%found then
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civfas_alle OK', '', w_id_atto_log);
                else
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civfas_alle KO', '', w_id_atto_log);
                end if;
              exception
                when others then
                     ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civfas_alle - errore', sqlerrm, w_id_atto_log);
              end;
           end if;

           if w_id_atto is not null then
              begin
                update ansciu
                   set flag_annullato = 'S'
                 where id_atto = w_id_atto
                   and servizio not like 'R011%'
                ;
                if sql%found then
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_ansciu OK', '', w_id_atto_log);
                else
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_ansciu KO', '', w_id_atto_log);
                end if;
              exception
                when others then
                     ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_ansciu - errore', sqlerrm, w_id_atto_log);
              end;
           end if; 	-- if w_id_atto is not null then
        elsif a_servizio like 'R012_%'then
           begin
             if a_servizio = 'R012_I' then
                 update civfir
                    set id_presa_visione_ansc = w_id_presa_visione,
                        stato_presa_visione_ansc = ''
                  where id = a_id_rif
                 ;
             elsif a_servizio = 'R012_V' then
                 update civfir
                    set stato_presa_visione_ansc = w_stato_presa_visione
                  where id = a_id_rif
                 ;
             elsif a_servizio = 'R012_A' then
                 update civfir
                    set stato_presa_visione_ansc = ''
                  where id = a_id_rif
                 ;
             end if;
             if sql%found then
                ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civfir OK', '', w_id_atto_log);
             else
                ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civfir KO', '', w_id_atto_log);
             end if;
           exception
             when others then
                  ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civfir - errore', sqlerrm, w_id_atto_log);
           end;
        end if;

        if w_lista_warning is not null then
           if w_info_ws is not null then
              w_info_ws := w_info_ws||chr(10)||chr(10)||w_lista_warning;
           else
              w_info_ws := w_lista_warning;
           end if;
        end if;
        
        if w_lista_info is not null then
           if w_info_ws is not null then
              w_info_ws := w_info_ws||chr(10)||chr(10)||w_lista_info;
           else
              w_info_ws := w_lista_info;
           end if;
        end if;

        begin
          update ansciu
             set flag_invio_ws      = 'S',
                 d_data_invio_ws    = sysdate,
                 id_operazione_ansc = w_id_operazione_ANSC,
                 esito_ansc         = w_esito_ANSC,
                 note_ws            = '',
                 info_ws            = w_info_ws
           where id_operazione  = a_id_operazione
          ;
          if sql%found then
             w_flag_invio_ws := 'S';
             w_note_ws       := '';
             ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_ansciu OK', '', w_id_atto_log);
          else
             w_flag_invio_ws := '';
             w_note_ws       := 'Comunicazione non trovata';
             ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_ansciu KO', '', w_id_atto_log);
          end if;
        exception
          when others then
               w_flag_invio_ws := '';
               w_note_ws       := 'Errore nell''aggiornamento della comunicazione';
               ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_ansciu - errore', sqlerrm, w_id_atto_log);
        end;

     else	-- if nvl(w_esito_ANSC,'X') = '0' then
        w_flag_invio_ws := '';
        w_note_ws       := 'Errore';
--        ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'risposta', 'errori', w_id_atto_log);
<< listaErrori >>
        w_lista_errori  := '';
        if w_des_errore_ws||w_cod_errore_ws is not null or w_descrizione_esito||w_codice_esito is not null then
           begin
             delete anserr
              where id_operazione = a_id_operazione
                and nvl(tipo_errore,'E') in ('E','F','H')
             ;
           end;

           w_sequenza := 1;
           w_tipo_errore   := '';

           if w_des_errore_ws||w_cod_errore_ws is not null then
              w_codice_errore := w_cod_errore_ws;
              w_testo_errore  := w_des_errore_ws;
           elsif w_descrizione_esito||w_codice_esito is not null then
              w_codice_errore := w_codice_esito;
              w_testo_errore  := w_descrizione_esito;
           end if;

           begin
             insert into anserr
                    (id_operazione, data_ora, sequenza, codice_errore, tipo_errore, testo_errore)
             values (a_id_operazione, sysdate, w_sequenza, w_codice_errore, w_tipo_errore, w_testo_errore)
             ;
           exception
             when others then
                  ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'errore in ins ANSERR', SQLERRM, w_id_atto_log);
           end;
           ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'listaErrori (1)', w_codice_errore||' - '||w_tipo_errore||' - '||w_testo_errore, w_id_atto_log);

           w_flag_errore  := 'S';
           w_testo_errore := f_UTIL_errore_decode(w_codice_errore,w_testo_errore);
           w_note_ws      := w_testo_errore;

        elsif w_errori_clob is not null then
           w_errori_clob := '<root>'||w_errori_clob||'</root>';
--           ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'errori_clob', w_errori_clob, w_id_atto_log);
           w_errori_xml := xmltype(w_errori_clob);
           w_errori_xml := w_errori_xml.extract('/root/errors','');

           begin
             delete anserr
              where id_operazione        = a_id_operazione
                and nvl(tipo_errore,'E') in ('E','F','H')
             ;
           end;

           w_sequenza      := 0;
           w_codice_errore := '';
           w_tipo_errore   := '';
           w_testo_errore  := '';
           for rec in sel_errori ('errors') loop
               if w_sequenza = 0 then
                  w_lista_errori := 'Lista errori:';
               end if;
               w_sequenza      := w_sequenza + 1;
               w_codice_errore := rec.code;
               w_tipo_errore   := rec.severity;
               if nvl(w_tipo_errore,'F') in ('F','H') then
                  w_testo_errore  := 'Risposta non ricevuta: '||rec.text;
               else
                  w_testo_errore  := rec.text;
               end if;
               begin
                 insert into anserr
                        (id_operazione, data_ora, sequenza, codice_errore, tipo_errore, testo_errore)
                 values (a_id_operazione, sysdate, w_sequenza, w_codice_errore, w_tipo_errore, w_testo_errore)
                 ;
               exception
                 when others then
                      ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'errore in ins ANSERR', SQLERRM, w_id_atto_log);
               end;
--               ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'listaErrori', w_codice_errore||' - '||w_tipo_errore||' - '||w_testo_errore, w_id_atto_log);

               w_flag_errore  := 'S';
               w_testo_errore := f_UTIL_errore_decode(w_codice_errore,w_testo_errore);
               w_lista_errori := w_lista_errori||chr(10)||
                                 w_sequenza||'. '||w_testo_errore;

               w_lista_ads := '';
               if rec.severity in ('F','H') then
                  w_lista_ads := 'Messaggi ADS:';
                  if a_servizio like 'R009%' then
                     w_lista_ads := w_lista_ads||chr(10)|| 
                                    '1. Verificare che sia stato assegnato l''id Atto ANSC'||chr(10)|| 
                                    '2. Nel caso sia gia'' stato assegnato: procedere con la ripetizione dell''invio tramite apposita funzione'||chr(10)|| 
                                    '3. Nel caso NON sia stato assegnato: procedere con la consultazione da web-app e contattare ADS';

                  elsif a_servizio like 'R006%' or a_servizio like 'R007%' then
                     w_lista_ads := w_lista_ads||chr(10)||
                                    '1. Verificare lo stato dell''atto mediante servizio di Consultazione Evento'||chr(10)||
                                    '2. Se lo stato e'' coerente con la comunicazione inviata: procedere con l''invio del servizio successivo'||chr(10)||
                                    '3. Se lo stato NON e'' stato aggiornato: procedere con la ripetizione dell''invio con apposita funzione';
                  elsif a_servizio like 'R002%' then
                     w_lista_ads := w_lista_ads||chr(10)||
                                    '1. Procedere con nuova emissione';
                  else
                     w_lista_ads := w_lista_ads||chr(10)||
                                    '1. Procedere alla ripetizione dell''invio con specifica funzione';
                  end if;
               end if;
           end loop;
           ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'listaErrori (2)', w_lista_errori, w_id_atto_log);
           w_note_ws := w_lista_errori;
        end if; --if w_errori_clob is not null then

        if w_lista_warning is not null then
           if w_note_ws is not null then
              w_note_ws := w_note_ws||chr(10)||chr(10)||w_lista_warning;
           else
              w_note_ws := w_lista_warning;
           end if;
        end if;
        
        if w_lista_info is not null then
           if w_note_ws is not null then
              w_note_ws := w_note_ws||chr(10)||chr(10)||w_lista_info;
           else
              w_note_ws := w_lista_info;
           end if;
        end if;

        if w_lista_ads is not null then
           if w_note_ws is not null then
              w_note_ws := w_note_ws||chr(10)||chr(10)||w_lista_ads;
           else
              w_note_ws := w_lista_ads;
           end if;
        end if;

        begin
          update ansciu
             set flag_invio_ws      = '',
                 d_data_invio_ws    = sysdate,
                 id_operazione_ansc = w_id_operazione_ANSC,
                 esito_ansc         = w_esito_ANSC,
                 note_ws            = w_note_ws,
                 info_ws            = w_info_ws
           where id_operazione  = a_id_operazione
          ;
          if sql%found then
             ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_ansciu OK', '', w_id_atto_log);
          else
             ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_ansciu KO', '', w_id_atto_log);
          end if;
        exception
          when others then
               ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_ansciu - errore', sqlerrm, w_id_atto_log);
        end;

     end if; --if nvl(w_esito_ANSC,'X') = '0' then
  end if; --if a_campo_clob is not null then

<< fine >>
null;

end ctr_risposta_XML;

function f_UTIL_ansciu_ins_x_stato
(a_servizio		IN	varchar2
,a_archivio_rif		IN	varchar2
,a_id_rif		IN	varchar2
,a_stato_ansc		IN	varchar2
)

return number

IS

w_new_id_operazione	number;
w_info_ws		varchar2(255) := 'Inserito automaticamente da ADS, in seguito a collegamento manuale con evento ANSC';
w_terminalista		varchar2(255) := 'ADS';
w_servizio_ins		varchar2(255);

w_id_atto		varchar2(255);

w_ctr_civfir		number;
w_ctr_civfir_EL		number;
w_ctr_civfir_CA		number;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'ansciu_ins';

w_return		number := 0;

cursor sel_servizio_ins is
-- CONFERMATO
-- x a_archivio_rif = 'ANN' (annotazioni), il servizio potrebbe essere 'R009_A' oppure 'R013' in base al tipo di annotazione 
-- (teniamo traccia, ma non gestiamo perchè non vincola gestioni trasversali)
-- x a_archivio_rif != 'ANN' (atti), valorizzo perchè sempre 'R009_V'
select 1 w_ord, decode(a_archivio_rif, 'ANN', to_char(null), 'R009_V') servizio_ins
  from dual
 where upper(a_stato_ansc) in ('CONFERMATO','FIRMATO DAL DICHIARANTE','FIRMATO PER CONFORMITA','FIRMATO DA USC')
UNION
-- FIRMATO DAL DICHIARANTE
-- 'R006'   (firma cartacea)   : archivio_rif / id_rif devono essere riferiti all'allegato caricato nel fascicolo (civfas_alle - ALL)
-- 'R012_V' (firma elettronica): archivio_rif / id_rif devono essere riferiti ai firmatari EL (civfir - FIR)
--                               + deve essere aggiornato il campo STATO_PRESA_VISIONE_ANSC (da impostare a '1')
-- (teniamo traccia, ma non gestiamo perchè non vincola gestioni trasversali)
select 2 w_ord, to_char(null) servizio_ins	-- 'R006'
  from civfir
 where nvl(tipo_firma,'CA') = 'CA'
   and id_atto              = w_id_atto
   and upper(a_stato_ansc)  = 'FIRMATO DAL DICHIARANTE'
   and rownum = 1
UNION
select 3 w_ord, to_char(null) servizio_ins	-- 'R012_V'
  from civfir
 where nvl(tipo_firma,'CA') = 'EL'
   and id_atto              = w_id_atto
   and upper(a_stato_ansc)  = 'FIRMATO DAL DICHIARANTE'
   and rownum = 1
UNION
-- FIRMATO PER CONFORMITA
select 4 w_ord, 'R007_C' servizio_ins
  from dual
 where upper(a_stato_ansc) = 'FIRMATO PER CONFORMITA'
UNION
-- FIRMATO DA USC
select 5 w_ord, decode(a_archivio_rif, 'ANN', 'R007_A', 'R007') servizio_ins
  from dual
 where upper(a_stato_ansc) = 'FIRMATO DA USC'
order by 1
;

begin

  begin
    select v.id_atto
      into w_id_atto
      from (select id_atto from civnas where id = a_id_rif and a_archivio_rif = 'NAS' 
            UNION select id_atto from civmor where id = a_id_rif and a_archivio_rif = 'MOR'
            UNION select id_atto from civmat where id = a_id_rif and a_archivio_rif = 'MAT'
            UNION select id_atto from civuci where id = a_id_rif and a_archivio_rif = 'UCI'
            UNION select id_atto from civcit where id = a_id_rif and a_archivio_rif = 'CIT'
            UNION select id_atto from civann where id = a_id_rif and a_archivio_rif = 'ANN') v
     where rownum = 1
    ;
  exception
    when others then
         w_id_atto := '';
  end;

  if w_id_atto is null then
     ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'idAtto non valorizzato', 'archivio_rif: '||a_archivio_rif||' - id_rif: '||a_id_rif, '');
     goto fine;
  end if;

  if a_stato_ansc is not null then
     for rec in sel_servizio_ins loop
         if rec.servizio_ins is not null then
            begin
              w_new_id_operazione := f_ansciu_nr('');
            end;

            if w_new_id_operazione is null then
               ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'idOperazione non valorizzato', '', '');
               goto fine;
            end if;

            w_servizio_ins := rec.servizio_ins;
            begin
              insert into ansciu
                     (id_operazione, servizio, archivio_rif, id_rif, note, terminalista, d_data_reg,
                      flag_invio_ws, d_data_invio_ws, note_ws, id_operazione_ansc, esito_ansc, info_ws, id_atto, flag_annullato)
              select w_new_id_operazione,
                     w_servizio_ins, 
                     a_archivio_rif, -- archivio 
                     a_id_rif, -- primary key dell'atto 
                     '',
                     w_terminalista,
                     SYSDATE,
                     'S', -- importante
                     SYSDATE,
                     '',
                     '',
                     '0',
                     w_info_ws,
                     w_id_atto, -- impostare id_atto
                     null
                from dual
               where not exists (select 'x' from ansciu b
                                  where b.archivio_rif  = a_archivio_rif
                                    and b.id_rif        = a_id_rif
                                    and b.servizio      = w_servizio_ins
                                    and b.flag_invio_ws = 'S')
              ;
              if sql%found then
                 ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'ins_ansciu OK', '', '');
                 w_return := 1;
              end if;
            exception
              when others then
                 ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'ins_ansciu KO', sqlerrm, '');
            end;
         end if;
     end loop;
  end if;

<< fine >>
null;
 
  return w_return;

end f_UTIL_ansciu_ins_x_stato;

function f_UTIL_ansciu_upd_R005_G
(a_servizio		IN	varchar2
,a_id_operazione	IN	number
,a_id_operazione_ansc	IN	number
,a_esito_ansc		IN	number
,a_note_ws		IN	clob
,a_info_ws		IN	clob
)

return number

IS

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'ansciu_upd';

w_return		number := 0;

begin
  begin
    update ansciu
       set flag_invio_ws      = '',
           d_data_invio_ws    = sysdate,
           id_operazione_ansc = a_id_operazione_ANSC,
           esito_ansc         = a_esito_ANSC,
           note_ws            = a_note_ws,
           info_ws            = a_info_ws
     where id_operazione  = a_id_operazione
    ;
    if sql%found then
       ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_ansciu OK', '', '');
       w_return := 1;
    else
       ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_ansciu KO', '', '');
    end if;
  exception
    when others then
         ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_ansciu - errore', sqlerrm, '');
  end;

<< fine >>
null;

  return w_return;

end f_UTIL_ansciu_upd_R005_G;

function f_UTIL_errore_decode
(a_codice_errore 	IN      varchar2
,a_testo_errore 	IN      varchar2
)

return varchar2

IS

w_testo_errore		varchar2(4000);

begin
  if a_testo_errore is not null then
     if a_testo_errore like 'Impossibile richiedere un certificato per un''evento che non%in stato Firmato da USC' then
        w_testo_errore := 'Impossibile richiedere un certificato per un''evento che non e'' in stato Firmato da USC';
     end if;
  end if;

  return nvl(w_testo_errore,a_testo_errore);

end f_UTIL_errore_decode;

function f_UTIL_get_tipo_atto
(a_archivio_rif 	IN      varchar2
)

return number

IS

w_archivio_rif		varchar2(255) := upper(a_archivio_rif);
w_tipo_atto		number;

begin
  if w_archivio_rif = 'NAS' then
     w_tipo_atto := 2;
  elsif w_archivio_rif = 'MAT' then
     w_tipo_atto := 4;
  elsif w_archivio_rif = 'UCI' then
     w_tipo_atto := -4;
  elsif w_archivio_rif = 'MOR' then
     w_tipo_atto := 5;
  elsif w_archivio_rif = 'CIT' then
     w_tipo_atto := 1;
  end if;

  return w_tipo_atto;

end f_UTIL_get_tipo_atto;

function f_UTIL_get_id_atto
(a_archivio_rif 	IN      varchar2
,a_id_rif 		IN      varchar2
)

return varchar2

IS

w_archivio_rif		varchar2(255) := upper(a_archivio_rif);
w_id_rif		varchar2(255) := a_id_rif;

w_id_atto		varchar2(255);

begin
  if a_archivio_rif is not null and a_id_rif is not null then
     if w_archivio_rif = 'NAS' then
        begin
          select nas.id_atto
            into w_id_atto
            from civnas nas
           where nas.id      = w_id_rif
          ;
        exception
          when others then
               w_id_atto := '';
        end;

     elsif w_archivio_rif = 'MAT' then
        begin
          select mat.id_atto
            into w_id_atto
            from civmat mat
           where mat.id      = w_id_rif
          ;
        exception
          when others then
               w_id_atto := '';
        end;

     elsif w_archivio_rif = 'UCI' then
        begin
          select uci.id_atto
            into w_id_atto
            from civuci uci
           where uci.id      = w_id_rif
          ;
        exception
          when others then
               w_id_atto := '';
        end;

     elsif w_archivio_rif = 'MOR' then
        begin
          select mor.id_atto
            into w_id_atto
            from civmor mor
           where mor.id      = w_id_rif
          ;
        exception
          when others then
               w_id_atto := '';
        end;

     elsif w_archivio_rif = 'CIT' then
        begin
          select cit.id_atto
            into w_id_atto
            from civcit cit
           where cit.id      = w_id_rif
          ;
        exception
          when others then
               w_id_atto := '';
        end;

     elsif w_archivio_rif = 'ALL' then
        begin
          select fas.id_atto
            into w_id_atto
            from civfas fas, civfas_alle fas_alle
           where fas.id      = fas_alle.id_civfas
             and fas_alle.id = w_id_rif
          ;
        exception
          when others then
               w_id_atto := '';
        end;

     elsif w_archivio_rif = 'ANN' then
        begin
          select ann.id_atto
            into w_id_atto
            from civann ann
           where ann.id      = w_id_rif
          ;
        exception
          when others then
               w_id_atto := '';
        end;

     elsif w_archivio_rif = 'NOT' then
        begin
          select 'NOT_'||n.id
            into w_id_atto
            from ansnot n
           where n.id      = w_id_rif
          ;
        exception
          when others then
               w_id_atto := '';
        end;

     elsif w_archivio_rif = 'FIR' then
        begin
          select 'FIR_'||n.id
            into w_id_atto
            from civfir n
           where n.id      = w_id_rif
          ;
        exception
          when others then
               w_id_atto := '';
        end;

     elsif w_archivio_rif = 'CER' then
        begin
          select f_CIV_get_id_atto(dce.tipo_archivio,inc.ufficio,inc.anno,inc.parte,inc.serie,inc.atto)
            into w_id_atto
            from cerdce dce, cercem cem, cerinc inc
           where dce.cod_certificato = cem.cod_certificato
             and cem.anno_emissione  = inc.anno_emissione
             and cem.progr_emissione = inc.progr_emissione
             and inc.anno_emissione  = substr(w_id_rif,1,4)
             and inc.progr_emissione = ltrim(substr(w_id_rif,5),'0')
          ;
        exception
          when others then
               w_id_atto := '';
        end;

     end if;
  end if;

  return w_id_atto;

end f_UTIL_get_id_atto;

function f_UTIL_leggi_campo_jsn_number
(a_servizio   	IN      varchar2
,a_campo_clob	IN	clob
,a_tag_ricerca	IN	varchar2
)

return number
IS

w_campo_clob		clob;
w_campo_number		number;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'leggi_campo_jsn_number';

w_errore		varchar2(4000);
errore			exception;

begin
  w_campo_clob   := f_UTIL_leggi_campo_jsn(a_servizio,a_campo_clob,a_tag_ricerca);
--dbms_output.put_line('prima di to_number');
  w_campo_number := to_number(w_campo_clob);
--dbms_output.put_line('dopo to_number');

  return w_campo_number;

end f_UTIL_leggi_campo_jsn_number;

function f_UTIL_leggi_campo_jsn_char
(a_servizio   	IN      varchar2
,a_campo_clob	IN	clob
,a_tag_ricerca	IN	varchar2
)

return varchar2

IS

w_campo_clob		clob;
w_campo_char		varchar2(255);

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'leggi_campo_jsn_char';

w_errore		varchar2(4000);
errore			exception;

begin
  w_campo_clob := f_UTIL_leggi_campo_jsn(a_servizio,a_campo_clob,a_tag_ricerca);
  w_campo_char := to_char(w_campo_clob);

  return w_campo_char;

end f_UTIL_leggi_campo_jsn_char;

function f_UTIL_leggi_campo_jsn
(a_servizio   	IN      varchar2
,a_campo_clob	IN	clob
,a_tag_ricerca	IN	varchar2
)

return clob

IS

w_tag_ricerca		varchar2(255);
w_len_tag		number;
w_pos_tag		number;
w_campo_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'leggi_campo_jsn';

w_errore		varchar2(4000);
errore			exception;

begin
  if a_campo_clob is not null and a_tag_ricerca is not null then
     w_tag_ricerca := '"'||a_tag_ricerca||'":';
     w_len_tag     := length(w_tag_ricerca);
     w_pos_tag     := instr(a_campo_clob,w_tag_ricerca);
     if w_pos_tag > 0 then
        w_campo_clob := substr(a_campo_clob,w_pos_tag+w_len_tag);
        w_campo_clob := ltrim(w_campo_clob);
        if w_campo_clob like '[%' then
--dbms_output.put_line('[%');
           w_campo_clob := substr(w_campo_clob,instr(w_campo_clob,'[
'));
           w_campo_clob := substr(w_campo_clob,1,instr(w_campo_clob,']
'));
        elsif w_campo_clob like '{%' then
--dbms_output.put_line('{%');
           w_campo_clob := substr(w_campo_clob,instr(w_campo_clob,'{
'));
           w_campo_clob := substr(w_campo_clob,1,instr(w_campo_clob,'}
'));
        elsif w_campo_clob like '"%' then
--dbms_output.put_line('"%');
           w_campo_clob := substr(w_campo_clob,instr(w_campo_clob,'"')+1);
           w_campo_clob := substr(w_campo_clob,1,instr(w_campo_clob,'"')-1);
        elsif instr(w_campo_clob,chr(10)) > 0 then
--dbms_output.put_line('chr(10)');
           w_campo_clob := substr(w_campo_clob,1,instr(w_campo_clob,chr(10))-1);
           if instr(w_campo_clob,',') > 0 then
--dbms_output.put_line(',');
              w_campo_clob := substr(w_campo_clob,1,instr(w_campo_clob,',')-1);
           end if;
        end if;
     else
        w_campo_clob := '';
     end if;
  end if;

  return w_campo_clob;

end f_UTIL_leggi_campo_jsn;

function f_UTIL_leggi_campo_xml
(a_servizio   	IN      varchar2
,a_campo_clob	IN	clob
,a_tag_ricerca	IN	varchar2
)

return clob

IS

w_tag_in		varchar2(255);
w_tag_fi		varchar2(255);
w_len_tag_in		number;
w_pos_tag		number;
w_campo_clob		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'leggi_campo_xml';

w_errore		varchar2(4000);
errore			exception;

begin
  if a_campo_clob is not null and a_tag_ricerca is not null then
     w_campo_clob := a_campo_clob;
     w_tag_in     := '<'||a_tag_ricerca||'>';
     w_tag_fi     := '</'||a_tag_ricerca||'>';
     w_len_tag_in := length(w_tag_in);
     w_campo_clob := substr(w_campo_clob,instr(w_campo_clob,w_tag_in)+w_len_tag_in);
     w_campo_clob := substr(w_campo_clob,1,instr(w_campo_clob,w_tag_fi)-1);
     w_campo_clob := replace(w_campo_clob,chr(10),'');
  end if;

  return w_campo_clob;

end f_UTIL_leggi_campo_xml;

function f_UTIL_date2millisec
(a_data   IN      date)

return number

AS
w_millisec number;

begin
  if a_data is not null then
     w_millisec := to_number(a_data - to_date('01/01/1970 00:00:00','dd/mm/yyyy hh24:mi:ss'))*24*60*60*1000;
  end if;
  return w_millisec;
end f_UTIL_date2millisec;

function f_UTIL_date2sec
(a_data   IN      date)

return number

AS
w_sec number;

begin
  if a_data is not null then
     w_sec := to_number(a_data - to_date('01/01/1970 00:00:00','dd/mm/yyyy hh24:mi:ss'))*24*60*60;
  end if;
  return w_sec;
end f_UTIL_date2sec;

function f_UTIL_millisec2date
(a_millisec   IN      number)

return date

AS

w_data date;

begin
  if a_millisec is not null then
     w_data := TIMESTAMP '1970-01-01 00:00:00.000 UTC' + NUMTODSINTERVAL( a_millisec / 1000, 'SECOND' );
  end if;
  return w_data;
end f_UTIL_millisec2date;

function f_UTIL_sec2date
(a_sec   IN      number)

return date

AS

w_data date;

begin
  if a_sec is not null then
     w_data := TIMESTAMP '1970-01-01 00:00:00.000 UTC' + NUMTODSINTERVAL( a_sec , 'SECOND' );
  end if;
  return w_data;
end f_UTIL_sec2date;

function f_UTIL_base64_decode
(a_clob_in          IN    clob)

return BLOB

IS
v_blob          blob;
v_result          blob;
v_offset          integer;
v_buffer_size       binary_integer := 48;
v_buffer_varchar       varchar2(48);
v_buffer_raw       raw(48);
w_errore         varchar2(4000);
errore         exception;
w_nome_log         varchar2(255) := 'decode B64';
w_step         number;
begin
w_step := 1;
  if a_clob_in is null then
     return null;
  end if;
  dbms_lob.createtemporary(v_blob, true);
w_step := 2;
  v_offset := 1;
--dbms_output.put_line('ceil... '||ceil(dbms_lob.getlength(a_clob_in) / v_buffer_size));
  for i in 1 .. ceil(dbms_lob.getlength(a_clob_in) / v_buffer_size) loop
w_step := 1000000.1 + i;
--dbms_output.put_line(i||') v_buf_size '||v_buffer_size||' - v_off '||v_offset||' - v_buf_chr '||v_buffer_varchar);
      dbms_lob.read(a_clob_in, v_buffer_size, v_offset, v_buffer_varchar);
w_step := 1000000.2 + i;
      v_buffer_raw := utl_raw.cast_to_raw(v_buffer_varchar);
w_step := 1000000.3 + i;
      v_buffer_raw := utl_encode.base64_decode(v_buffer_raw);
w_step := 1000000.4 + i;
--dbms_output.put_line(i||') len '||utl_raw.length(v_buffer_raw)||' - v_buf '||v_buffer_raw);
      dbms_lob.writeappend(v_blob, utl_raw.length(v_buffer_raw), v_buffer_raw);
w_step := 1000000.5 + i;
      v_offset := v_offset + v_buffer_size;
w_step := 1000000.6 + i;
  end loop;
w_step := 3;
  v_result := v_blob;
w_step := 4;
  dbms_lob.freetemporary(v_blob);
w_step := 5;
  return v_result;
exception
  when others then
       w_errore := '('||w_step||') exception '||SQLERRM||')';
       ANSC_PKG.INS_LOG('',w_nome_log, w_errore);
end f_UTIL_base64_decode;

function f_UTIL_base64_encode
(a_blob_in          IN    blob)

return CLOB

IS
v_clob          clob;
v_result          clob;
v_offset          integer;
v_chunk_size       binary_integer := (48 / 4) * 3;
v_buffer_varchar       varchar2(48);
v_buffer_raw       raw(48);
w_errore         varchar2(4000);
errore         exception;
w_nome_log         varchar2(255) := 'encode B64';
w_step         number;
begin
w_step := 1;
  if a_blob_in is null then
     return null;
  end if;
  dbms_lob.createtemporary(v_clob, true);
w_step := 2;
  v_offset := 1;
  for i in 1 .. ceil(dbms_lob.getlength(a_blob_in) / v_chunk_size) loop
w_step := 1000000.1 + i;
      dbms_lob.read(a_blob_in, v_chunk_size, v_offset, v_buffer_raw);
w_step := 1000000.2 + i;
      v_buffer_raw := utl_encode.base64_encode(v_buffer_raw);
w_step := 1000000.3 + i;
      v_buffer_varchar := utl_raw.cast_to_varchar2(v_buffer_raw);
w_step := 1000000.4 + i;
      dbms_lob.writeappend(v_clob, length(v_buffer_varchar), v_buffer_varchar);
w_step := 1000000.5 + i;
      v_offset := v_offset + v_chunk_size;
w_step := 1000000.6 + i;
  end loop;
w_step := 3;
  v_result := v_clob;
w_step := 4;
  dbms_lob.freetemporary(v_clob);
w_step := 5;
  return v_result;
exception
  when others then
       w_errore := '('||w_step||') exception '||SQLERRM||')';
       ANSC_PKG.INS_LOG('',w_nome_log, w_errore);
end f_UTIL_base64_encode;

function f_UTIL_clob2blob
(a_clob_in          IN    clob)

return BLOB

IS
v_blob            blob;
v_result          blob;
v_offset          integer;
v_buffer_size     binary_integer := 48;
v_buffer_varchar  varchar2(48);
v_buffer_raw      raw(48);

w_errore          varchar2(4000);
errore            exception;

w_nome_log        varchar2(255) := 'clob_to_blob';
w_step            number;

begin
w_step := 1;
  if a_clob_in is null then
     return null;
  end if;
  dbms_lob.createtemporary(v_blob, true);
w_step := 2;
  v_offset := 1;

  for i in 1 .. ceil(dbms_lob.getlength(a_clob_in) / v_buffer_size) loop
w_step := 1000000.1 + i;
      dbms_lob.read(a_clob_in, v_buffer_size, v_offset, v_buffer_varchar);
w_step := 1000000.2 + i;
      v_buffer_raw := utl_raw.cast_to_raw(v_buffer_varchar);
w_step := 1000000.3 + i;
      dbms_lob.writeappend(v_blob, utl_raw.length(v_buffer_raw), v_buffer_raw);
w_step := 1000000.5 + i;
      v_offset := v_offset + v_buffer_size;
w_step := 1000000.6 + i;
  end loop;
w_step := 3;
  v_result := v_blob;
w_step := 4;
  dbms_lob.freetemporary(v_blob);
w_step := 5;
  return v_result;
exception
  when others then
       w_errore := '('||w_step||') exception '||SQLERRM||')';
       ANSC_PKG.INS_LOG('',w_nome_log, w_errore);
end f_UTIL_clob2blob;

function f_UTIL_blob2clob
(a_blob_in          IN    blob)

return CLOB

IS

w_documento_blob           blob := a_blob_in;
w_documento_clob           clob;

w_number_temp              number;
dest_offset                number := 1;
src_offset                 number := 1;
amount                     integer := DBMS_LOB.lobmaxsize;
blob_csid                  number := DBMS_LOB.default_csid;
lang_ctx                   integer := DBMS_LOB.default_lang_ctx;
warning                    integer;

w_errore          varchar2(4000);
errore            exception;

w_nome_log        varchar2(255) := 'blob_to_clob';
w_step            number;

begin
-- Verifica dimensione file caricato
w_step := 1;
  w_number_temp        := DBMS_LOB.getlength (w_documento_blob);
  if nvl (w_number_temp, 0) = 0 then
     w_errore := 'Attenzione File caricato Vuoto - Verificare Client Oracle';
     raise errore;
  end if;

w_step := 2;
-- Trasformazione in CLOB
  begin
    DBMS_LOB.createtemporary (lob_loc =>   w_documento_clob
                             ,cache =>     true
                             ,dur =>       DBMS_LOB.session
                             );
w_step := 3;
    DBMS_LOB.converttoclob (w_documento_clob
                           ,w_documento_blob
                           ,amount
                           ,dest_offset
                           ,src_offset
                           ,blob_csid
                           ,lang_ctx
                           ,warning
                           );
  exception
    when others then
         w_errore := 'Errore in trasformazione Blob in Clob  (' || sqlerrm || ')';
         raise errore;
  end;

  return w_documento_clob;
exception
  when errore then
       ANSC_PKG.INS_LOG('',w_nome_log, w_errore);
  when others then
       w_errore := '('||w_step||') exception '||SQLERRM||')';
       ANSC_PKG.INS_LOG('',w_nome_log, w_errore);
end f_UTIL_blob2clob;

function f_TEST_header
(a_servizio	IN	varchar2)

return CLOB

IS

w_x5c_pem	clob := 'MIIFmTCCA4GgAwIBAgIIFdq7V1oSLdowDQYJKoZIhvcNAQELBQAwWjEbMBkGA1UE'||
'AwwSQ0EgUG9zdGF6aW9uaSBTdmlsMQ0wCwYDVQQLDARBTlBSMR8wHQYDVQQKDBZN'||
'aW5pc3Rlcm8gZGVsbCdJbnRlcm5vMQswCQYDVQQGEwJJVDAeFw0xNTEwMDUxMTA5'||
'MjRaFw0yNTEwMDUxMTA5MjRaMFoxGzAZBgNVBAMMEkNBIFBvc3RhemlvbmkgU3Zp'||
'bDENMAsGA1UECwwEQU5QUjEfMB0GA1UECgwWTWluaXN0ZXJvIGRlbGwnSW50ZXJu'||
'bzELMAkGA1UEBhMCSVQwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDV'||
'XC3eN5SJi2KLea2GapdJwdtwwPVYf8zKF1g4/O/QAXTKo98nHbjjfwbGpisQFlQ/'||
'DrNckukT4ZLQ6/qyEO53yMHRRssvF4m7ohIpnIFChDG25wPGfEwJ3Gz/fE0kSzro'||
'qAwzV/Zva3Eq274vrDWTmvE8ZVfbFxTOK77YuvLOiX1XVy71ldcJykQ3bnaeaOU1'||
'ZR/N/AqVWna0sLfKp67Im+n8O0Fy2Yxp00VUGop9C4B1EiecmqPbjo9VX2b/bgTR'||
'svJ3osMsbR6vxamx9Wa8Pw+Fr7slkS58L0+pQWNzbxnNvgvmtCCJz3lAEkJxefMb'||
'PRE/80ByrK+Qm9cITJJ7PKzBZmNsFhHECzZafUfTCN8z4ReW9wzu1iaTbSZXEgRg'||
'E6nAlUvng4UB6OKAcS49GfxH+7iFsyG1YoR9gbkSH8+sEwD0+sLJbUJkgOq7eWi5'||
'VhTRsdE6CjZM/ulUbY2oPC/C3Y/fkKBwILc1xApJSy5SkJ/4V2AQTwFXWzy8kz/k'||
'Imc8yN7F0Qc89IuniRNXP0wV/q4Uj4gbrLITd1Hn0NCsZ+H1VGlk0GeK6qMTZRbw'||
'T++zkuJYtIJ+Rd+2BaMMeZl381+n3DZs1nt5/LK2l4OJdKND6rqFpz88rPy+Dd/D'||
'HK6kSh3qdylUvHufID2kefy8kUOLoL9FATzDp3LvxQIDAQABo2MwYTAdBgNVHQ4E'||
'FgQUBgufyqHXma3UIu6zi7EUk8hXm34wDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSME'||
'GDAWgBQGC5/KodeZrdQi7rOLsRSTyFebfjAOBgNVHQ8BAf8EBAMCAYYwDQYJKoZI'||
'hvcNAQELBQADggIBAEufKnKtD+9nAHKe2gGUGMd5bfLIiKpgD+ASZ9VZ8ntEeqMk'||
'nQSBCA/6FEKxCS6rwW3V7GlsgoUzQe3mkF+Mit1zlyFu5z+hyfmTdwwK5QpoUEn3'||
'kj7mgoyH4ylFnM90mW6anZrKNDa8zdPyLDeRD3zTuMqGTTEekvWHzjuf8zILJXGc'||
'VojDKTKwcaXhzhWDYh4hS7be/2LsWh9vOvnQdQ7UKqxsHIZiT0OQ6ZtKUCIe2kk6'||
'v/aQ9YPfiLPF89emYHwszQX9ZAgrcqWV04T20LHYVTwakVw+T1Y7s55kGOb845Zm'||
'sf20+hGg5RIs+rPXMmR5yQW7kHqGnKkkLmfj3qLVnFdLCqtL2HIRn2M2DbQlaHou'||
'aYxNsNertRtjofZN4lQ0EkdOBj5Qv8cD1SfePU6S2bbXBN26bSl6udSDGzmykabv'||
'tM+x8DrWv4yhLjKRYOj56rbJvl/AvKV/uZ6DCwzPQVyIJ5Z//RfCzTs7TQPbCJEe'||
'L7lo4ilur7MYpq8esjtyFObgPk2yKsVZfIJFr11EsmQzab0nfg0gU/BUW9VRV7jx'||
'n7GLhHMm6GEZqOU/QSto1tklF461vUAVsPCkBOeD2u+Ax22Tc6vBcQCtzI1Exq+3'||
'q9gxcF9HhlwycI9ql3B/hGYpGyNOg9JEc44SX0jCA5hTL+ssRnk2EDZ9vBt9';

w_x5c_cer	clob := 'MIIE6zCCAtOgAwIBAgIIYsnSUtDOWmcwDQYJKoZIhvcNAQELBQAwWjEbMBkGA1UE'||
'AwwSQ0EgUG9zdGF6aW9uaSBTdmlsMQ0wCwYDVQQLDARBTlBSMR8wHQYDVQQKDBZN'||
'aW5pc3Rlcm8gZGVsbCdJbnRlcm5vMQswCQYDVQQGEwJJVDAeFw0yMjA4MDMxMzA0'||
'MTlaFw0yNTEwMDUxMTA5MjRaMIGZMRcwFQYDVQQDDA4wMzkwMTAtUEMtMDAwMTEd'||
'MBsGA1UECwwUUG9zdGF6aW9uaSBkaSBsYXZvcm8xMTAvBgNVBAsMKEFuYWdyYWZl'||
'IE5hemlvbmFsZSBQb3BvbGF6aW9uZSBSZXNpZGVudGUxHzAdBgNVBAoMFk1pbmlz'||
'dGVybyBkZWxsJ0ludGVybm8xCzAJBgNVBAYTAklUMIIBIjANBgkqhkiG9w0BAQEF'||
'AAOCAQ8AMIIBCgKCAQEArFUU78IDEzi7wgvBMrIR60nWmoF6Nj7CGAO2vlb//wBy'||
'6nNwUKK2G1TSOj9WVMUWi8nyeAD4M+lln1OEhl73Wxbx3XZc3BJXQME9Wjeu3JWn'||
'daAru7iYb/4U7JljoaXMS7OEm+gsNaK4bEwM09rG1FGdcRL7Evv2NaNWnIrxpMPs'||
'+eLt9U5X1P+CyBx4FjPsqbPxWgFyfBz1OLxPlrRu6GuKye6sdax+ANVp+ieyeFT1'||
'FKsksLiE245wKN2DlD14tEeTL9slVHxajhvClYgvYS4eZAPJOREWVqWEZw+cterD'||
'2nsTKh5wAfPejyouh4V4t+08hJ5EZ7CQ9VuRTsQMbQIDAQABo3UwczAMBgNVHRMB'||
'Af8EAjAAMB8GA1UdIwQYMBaAFAYLn8qh15mt1CLus4uxFJPIV5t+MBMGA1UdJQQM'||
'MAoGCCsGAQUFBwMCMB0GA1UdDgQWBBTcTn1IZAP2yA83HvOmOFKTFyUxSjAOBgNV'||
'HQ8BAf8EBAMCB4AwDQYJKoZIhvcNAQELBQADggIBAIRS5eF+++IpBz2O5lF7Nvjf'||
'O61e13jq2XsEjGVM+9So4hvd3JG/O5bxl8hJNLTVH9l4lwAbiTfGiW0BUWzIPh+Q'||
'463hiavHjN16z5V7J0kYqNshwiE5URM8V7l3F1ckAjds/KHqJXPqtsffiAlvPpJK'||
'GrjnDJech6RBk+OB9mId7xLPE+DVlvlylfDSkTym+Zk03rSZZrduKpnwZ9Rg0Prd'||
'VCj64KQHdMrYabquWGkDyfr7FmUi/YO4LU3SEXXrOqT1URtfbYq1RSF3YAoh7TWz'||
'fEEErkT0UQwfx636YGmOUo1410UuMB88xcUIlxr2LigHZ33U9gFn9tekHh/MKPiC'||
'myED8mpctAl/MwcUducfOxq2bBEtZAKGxXXQYMQy3VFLrw9rCGnTYaXkOzadnDaQ'||
'7TFCIEtx8rpZW8RAOmDs97pb9MefB/CqeJ/ylqvZ/eb+5vd2LMp356bkHzSHm4aF'||
'OxxUjHDknROGMF0H0wcs14H23uiEWrLcUO44C8k8YMPk+SwO1bDZorbtQ3hfhUqJ'||
'u+MPmRBdPmWgzbWvEdEbUYFqpdFhu/oW542JudzmgqizQKIddTjyNALiMlh7wM3L'||
'JU5FgCtROKArrwG827cS9NFq4cm/9nJL5MkCPpyRPnV2urabiJiYOI+mmj0Q1B7Y'||
'wWfiB6crOOKtT+llueGq';

w_x5c_key	clob := 'MIIFDjBABgkqhkiG9w0BBQ0wMzAbBgkqhkiG9w0BBQwwDgQIhawD3wVz/ZACAggA'||
'MBQGCCqGSIb3DQMHBAh/n91vaJKG1ASCBMhDVN92Pa5ZVqnAGiN2pK12uRSAhNE9'||
'EMSaFGY+duGzTQJGep+tZXrJOMhGIOi3pPqtiJbGGnb60I/t2Ww6m/AeGi6TY4Bq'||
'm6u3tqMKsC488wU5RYahVFTG8e08A2oKXPPth1k/jwhx5NRn3xEH02i5jdh3CexQ'||
'AhGTfz+2kfJ3lC+jgGhFRqOip/TP/T0jBKgAHT8hw3v3wh5fQkimOf1jlHcZsxsF'||
'n3eZC4sp8/BYTJyJBVbdlmgJEvpMnzXowEdytObFGyUifmUVLvEqJxp5U5XfzTlp'||
'qRoolBhHmLNhv2Q5rKXxNzLZoaQCEbZ7pFOQrcaeFWyYDeYtePr+KDaOcMpHASa6'||
'ExsI24frrUF6mtRfQCZ3z4TBWXKs/QqFYW2uarlcjFPJVeYpyG/MoKAzsD0AEuJY'||
'y42gI2poTyRVeRxDyHD4peJL4jW5hCT2vysjDvRtLehPVQXx7H4SzUBsMGXyzbEG'||
'FQYjG57aZeY6QLlAVYZD9HcYvIL4scJlMJSAx83C4wczRbWraD4QSfJXhOnsuzf5'||
'zxQiEkEJtsZvqpKyj7dHyePxH1QcAcHbyMtg8zVXThsmwb44BtlcCy1j6c9sd3Di'||
'xEtgwMals8rwemkNgc7uwxJfwjdItzaATDqvJCpPJHOA6oa5megRNWhOfOjVpbnU'||
'wPD8bTMTSndaGUzZceNI4fqEo3TwQnYoFZkw0J5qpKi+kvQHvW8Zh76Th7dBJKOO'||
'XcHYkPEkiwXQT0YRLf+oEmcAO9/HhVGsM+DzB677QUfH7+OwjgNVd4bFcdzpoZzh'||
'ivLWtCfkhwI+sqCKAMCGAYzUPIgLqx0mE5WhapK5RfIxfHcKt92EKqq4WZ1IQ0bY'||
'cnr881dQD/1Hgpqs9wjZ2XEtn05N/k3llZELutAqAsTSYu/RDjWOWp/Ic5gs4HGG'||
'WTOQv+2Xb6MyTDjmJNZJmJCLiDNsPVC9aRIl16EObUB+Cj2a8j8RVb4F9iZ90rOn'||
'xNgcQtMBukdgMq0DzLaQfNQv9DmNtocdLFTUCnBE4If72OqMD24sQqqFG/HnLHk1'||
'/N4FZYXLzrIKWSg2qBurm0Bf2efVWNlzji5t6OcYIRFFDthDfujx5lw1GGLHqZL2'||
'tjrJbU47iiZyUQk4ZUzx1s5gR7pEbtX4g6k2tkU+xj4Ii+1ryP7Iu8xCXFAgIwU7'||
'LH/x5aLPySyhmD9dVXUI1xfSIvq1wBfU+2UT12zdZB9FUPI0j5uGjc71N5TfLR8u'||
'3EmUDwUtFylVNcGLqmWjJMzKgcKUjnrNE1oCpWySMmXI9gdsL01hBQj1VMAw+U56'||
'cij9jLaMiehovctzoZm08G1mg75ss+zBUD9cVzi0eyXBmScdO3t2Zba2JaSntD2y'||
'BIGTaa7Ejgv/EYd0GyM9+sKQCytaEL8IPRCePeGfZtt4gEO/2i+gs4hISVGOVJU5'||
'n7mfq/sGHNkU6sJL2Wr1DFZ4A191gA6v4jdTYzse+mzprI2UO/LFBNNYdvQHwmbG'||
'DQpmg5sFdm5U6/YfB9ZzM5CEC30Opx2CLZFAskdfjaqXc2ICtiE1mzhVJ3jVuPOA'||
'V1WPzZXyFtBoovl6lRoJokVViiDlDDtzkYNHL0GS8xQbLDmlqBmgGDvsEUn0TIyn'||
'+bo=';

w_x5c		clob := w_x5c_key;
w_typ		varchar2(255) := 'JWT';
w_alg		varchar2(255) := 'RS256';

w_json_clob	clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'test_header';

w_errore		varchar2(4000);
errore			exception;

begin

w_json_clob := f_JSON_tag('TEST',0,'','I','');
w_json_clob := w_json_clob||f_JSON_elemento('TEST',1,w_x5c,'x5c','S','','');
w_json_clob := w_json_clob||f_JSON_elemento('TEST',1,w_typ,'typ','','','');
w_json_clob := w_json_clob||f_JSON_elemento('TEST',1,w_alg,'alg','','S','');
w_json_clob := w_json_clob||f_JSON_tag('TEST',0,'','F','');

  return w_json_clob;
end f_TEST_header;

function f_TEST_payload
(a_servizio	IN	varchar2)

return CLOB

IS

w_sub		varchar2(255) := 'MNPLSN74S24F158N';
w_sede		varchar2(255) := '039010';
w_postazione	varchar2(255) := '039010-PC-0001';
w_otp		varchar2(255) := '123456';
w_jti		varchar2(255) := ''; --SYS_GUID();
w_exp		int := f_UTIL_date2sec(sysdate)+600;
w_iat		int := f_UTIL_date2sec(sysdate);

w_json_clob	clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'test_payload';

w_errore		varchar2(4000);
errore			exception;

begin
w_json_clob := f_JSON_tag('TEST',0,'','I','');
w_json_clob := w_json_clob||f_JSON_elemento('TEST',1,w_sub,'sub','','','');
w_json_clob := w_json_clob||f_JSON_elemento('TEST',1,w_sede,'sede','','','');
w_json_clob := w_json_clob||f_JSON_elemento('TEST',1,w_postazione,'postazione','','','');
w_json_clob := w_json_clob||f_JSON_elemento('TEST',1,w_otp,'otp','','','');
  w_jti := to_char(w_iat)||'-6302a12362e2883e113b7983-289110403';
w_json_clob := w_json_clob||f_JSON_elemento('TEST',1,w_jti,'jti','','','');
w_json_clob := w_json_clob||f_JSON_elemento('TEST',1,to_char(w_exp),'exp','','','');
w_json_clob := w_json_clob||f_JSON_elemento('TEST',1,to_char(w_iat),'iat','','S','');
w_json_clob := w_json_clob||f_JSON_tag('TEST',0,'','F','');

  return w_json_clob;

end f_TEST_payload;

function f_TEST_signature
(a_servizio	IN	varchar2
,a_header_b64	IN	clob
,a_payload_b64	IN	clob
)

return CLOB

IS

w_json_clob	clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'test_signature';

w_errore		varchar2(4000);
errore			exception;

begin

w_json_clob := '487f5e53e0d914c266c52c128b6d0cc6163058aab452278686cec6b6cb34d38b';

  return w_json_clob;

end f_TEST_signature;

function f_TEST_body
(a_servizio		IN	varchar2
,a_id_operazione	IN	varchar2
)

return CLOB

IS

w_contenuto		clob := 'JVBERi0xLjUNCiW1tbW1DQoxIDAgb2JqDQo8PC9UeXBlL0NhdGFsb2cvUGFnZXMgMiAwIFIvTGFuZyhpdC1JVCkgPj4NCmVuZG9iag0KMiAwIG9iag0KPDwvVHlwZS9QYWdlcy9Db3VudCAxL0tpZHNbIDMgMCBSXSA+Pg0KZW5kb2JqDQozIDAgb2JqDQo8PC9UeXBlL1BhZ2UvUGFyZW50IDIgMCBSL1Jlc291cmNlczw8L0ZvbnQ8PC9GMSA1IDAgUj4+L0V4dEdTdGF0ZTw8L0dTNyA3IDAgUi9HUzggOCAwIFI+Pi9Qcm9jU2V0Wy9QREYvVGV4dC9JbWFnZUIvSW1hZ2VDL0ltYWdlSV0gPj4vTWVkaWFCb3hbIDAgMCA1OTUuMzIgODQxLjkyXSAvQ29udGVudHMgNCAwIFIvR3JvdXA8PC9UeXBlL0dyb3VwL1MvVHJhbnNwYXJlbmN5L0NTL0RldmljZVJHQj4+L1RhYnMvUz4+DQplbmRvYmoNCjQgMCBvYmoNCjw8L0ZpbHRlci9GbGF0ZURlY29kZS9MZW5ndGggMTE1Pj4NCnN0cmVhbQ0KeJwtjL0NCsJAEAb7hX2Hr1SLdTfez6YNCmjATjywEEu9KkL0/SEXcbqBYWYmFV1xzwZF7KMcOngw6Tt8nky3Hd5MQ2HanwxmogHlxbTWDQpDTJICclJxlKlV4zWjftsY9Wf+t5HpvsH2gXJmOrbfhWkBKg0K';
w_protocollo		varchar2(255) := '1/2022';
w_nomefile              varchar2(255) := 'provaFile.pdf';
w_tipoFile 		varchar2(255) := '1';
w_tipoAllegato 		varchar2(255) := '2';
w_stato 		varchar2(255) := '1';

w_json_clob	clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'test_body';

w_errore		varchar2(4000);
errore			exception;

begin
--
-- R001 - Allegato
-- R002 - Certificazione
-- R003 - Comunicazione
-- R004 - Consultazione ANPR
-- R005 - Consultazione ANSC
-- R006 - Firma Dichiarante
-- R007 - Firma USC
-- R008 - Notifiche
-- R009 - Validazione
-- R010 - Anteprima
--

w_json_clob := f_JSON_tag(a_servizio,0,'','I','');
w_json_clob := w_json_clob||
               f_JSON_testataRichiesta(a_servizio,a_id_operazione);

  if a_servizio = 'R001' then
w_json_clob := w_json_clob||f_JSON_tag('TEST',1,'allegatoInput','I','');
w_json_clob := w_json_clob||f_JSON_elemento('TEST',2,w_contenuto,'contenuto','','','');
w_json_clob := w_json_clob||f_JSON_elemento('TEST',2,w_protocollo,'protocollo','','','');
w_json_clob := w_json_clob||f_JSON_elemento('TEST',2,w_nomefile,'nomefile','','','');
w_json_clob := w_json_clob||f_JSON_elemento('TEST',2,w_tipoFile,'tipoFile','','','');
w_json_clob := w_json_clob||f_JSON_elemento('TEST',2,w_tipoAllegato,'tipoAllegato','','','');
w_json_clob := w_json_clob||f_JSON_elemento('TEST',2,w_stato,'stato','','S','');
--w_json_clob := w_json_clob||f_JSON_tag('TEST',1,'allegatoInput','F','');
w_json_clob := w_json_clob||f_JSON_tag('TEST',1,'','F','');

  elsif a_servizio = 'R009' then
--w_json_clob := w_json_clob||f_JSON_tag('TEST',1,'evento','I','');
--w_json_clob := w_json_clob||f_JSON_elemento('TEST',2,'','id','','','');
--w_json_clob := w_json_clob||f_JSON_elemento('TEST',2,'','idansc','','','');--    "idansc": "2022-9423-26624-040007",
--w_json_clob := w_json_clob||f_JSON_elemento('TEST',2,'1','idTipoEvento','','','');	-- anst01
--w_json_clob := w_json_clob||f_JSON_elemento('TEST',2,'1','idtipocontenuto','','','');	-- anst02
--w_json_clob := w_json_clob||f_JSON_elemento('TEST',2,'27862','idUsecase','','','');	-- anst03
--w_json_clob := w_json_clob||f_JSON_elemento('TEST',2,'Dichiarazione entro i 10 giorni - resa dal padre','descrizioneCasoUso','','','');
--w_json_clob := w_json_clob||f_JSON_elemento('TEST',2,'CONFERMATO','stato','','','');
--w_json_clob := w_json_clob||f_JSON_elemento('TEST',2,'2020-01-02','dataFormazione','','','');
--w_json_clob := w_json_clob||f_JSON_elemento('TEST',2,'2020','annoAtto','','','');
--w_json_clob := w_json_clob||f_JSON_elemento('TEST',2,'01','meseAtto','','','');
--w_json_clob := w_json_clob||f_JSON_elemento('TEST',2,'01','giornoAtto','','','');
w_json_clob := w_json_clob||'  "evento": {
    "idTipoEvento": "1",
    "idtipocontenuto": "1",
    "idUsecase": "11111000",
    "stato": "CONFERMATO",
    "dataformazione": "2020-01-02",
    "annoAtto": "2020",
    "meseAtto": "1",
    "giornoAtto": "2",
    "ora": "10",
    "minuto": "15",
    "dataDecorrenza": "2022-10-17",
    "numeroatto": "1",
    "tipoDichiarante": "P",
    "ausilioInterprete": "no",
    "allegati": [
      {
        "id": "1310011",
        "hashAllegato": "dGmmtStiTICFnJyQYvAAVGmKT2wj0eZ4+UCRJrMh7gA=",
        "descrizione": "DICHIARAZIONE DI NASCITA"
      }
    ],
    "intestatari": [
      {
        "cognome": "CognomeNato",
        "nome": "NomeNato",
        "sesso": "m",
        "descrizioneSesso": "maschile",
        "dataNascita": "2020-01-02",
        "nomeComuneNascita": "FAENZA",
        "siglaProvinciaNascita": "RA",
        "nomeStatoNascita": "ITALIA",
        "nomeComuneResidenza": "FAENZA",
        "siglaProvinciaResidenza": "FA",
        "nomeStatoResidenza": "ITALIA",
        "genere": "o",
        "nazionalita": "ITALIANA",
        "note": ""
      }
    ],
    "datiDiNascita": {
        "annoNascita": "2020",
        "meseNascita": "1",
        "giornoNascita": "02",
        "luogoFiliazione": "Ospedale",
        "oraNascita": "7",
        "minutoNascita": "35",
        "natoMorto": "no",
        "natoVivoMaDeceduto": "no",
        "partoGemellare": "no",
        "nomeStatoEvento": "ITALIA",
        "siglaProvinciaEvento": "RA",
        "nomeComuneEvento": "FAENZA",
        "sesso": "m"
        },
    "madre": {
      "cognome": "CognomeMadre",
      "nome": "NomeMadre",
      "sesso": "f",
      "descrizioneSesso": "femminile",
      "datanNscita": "1980-01-02",
      "nomeComuneNascita": "BOLOGNA",
      "siglaProvinciaNascita": "BO",
      "nomeStatoNascita": "ITALIA",
      "nomeComuneResidenza": "BOLOGNA",
      "siglaProvinciaResidenza": "BO",
      "nomeStatoResidenza": "ITALIA",
      "genere": "a",
      "nazionalita": "ITALIANA",
      "flagDichiarante":"true",
      "flagComparente":"false",
      "flagFirmatario":"false"
    },
    "padre": {
      "cognome": "CognomePadre",
      "nome": "NomePadre",
      "sesso": "m",
      "descrizioneSesso": "maschile",
      "datanascita": "1980-01-01",
      "nomeComuneNascita": "BOLOGNA",
      "siglaProvinciaNascita": "BO",
      "nomeStatoNascita": "ITALIA",
      "nomeComuneResidenza": "BOLOGNA",
      "siglaProvinciaResidenza": "BO",
      "nomeStatoResidenza": "ITALIA",
      "genere": "o",
      "nazionalita": "ITALIANA",
      "flagDichiarante":"false",
      "flagComparente":"false",
      "flagFirmatario":"false"
    },
    "dichiarante" : {
      "flagDichiarante":"false",
      "flagComparente":"false",
      "flagFirmatario":"false"
    }';

w_json_clob := w_json_clob||f_JSON_tag('TEST',1,'','F','');

  elsif a_servizio = 'R010' then
w_json_clob := w_json_clob||' "criteriRicercaEvento": {
        "idAnsc": "2022-1-1310032-039010"
    }';
w_json_clob := w_json_clob||f_JSON_tag('TEST',1,'','F','');

  end if;

w_json_clob := w_json_clob||f_JSON_tag('TEST',0,'','F','');

  return w_json_clob;

end f_TEST_body;

function f_TEST_request
(a_servizio	IN	varchar2)

return CLOB

IS

w_ws_client			varchar2(255);
w_ws_url			varchar2(255);

w_absoluteStore			varchar2(255);
w_permitSoapAction		varchar2(255);
w_doUnescapeHtml		varchar2(255);
w_trustStoreName		varchar2(255);
w_trustStorePassword		varchar2(255);
w_keyStoreName			varchar2(255);
w_keyStorePassword		varchar2(255);
w_keyPassword			varchar2(255);
w_forceContentTypeRequest	varchar2(255);

w_service_url		varchar2(4000);

w_json_header		clob;
w_json_header_b64	clob;
w_json_payload		clob;
w_json_payload_b64	clob;
w_json_signature_b64	clob;
w_json_token_jwt	clob;
w_json_body		clob;
w_json_response		clob;

w_servizio_log		varchar2(255) := a_servizio;
w_operazione_log	varchar2(255) := 'test_request';

w_errore		varchar2(4000);
errore			exception;

begin
--  w_ws_client	:= f_valore_inp('WS_CLIENT',1,255,'X','');
  w_ws_client	:= 'http://tst-tr-fin-as1:8085/sa4WSclientV2';
  w_ws_url	:= 'https://anscserviceval.anpr.interno.it/services/service/doc/allegato/upload/1';

  w_absoluteStore           := 'true';
  w_permitSoapAction        := 'false';
  w_doUnescapeHtml          := 'false';
  w_trustStoreName          := '/usr/java/jdk8u292-b10/jre/lib/security/cacerts';
  w_trustStorePassword      := 'changeit';
  w_keyStoreName            := '/workarea/tomANPR/webapps/sa4WSclientV2/cert/client_ansc.jks';
  w_keyStorePassword        := 'lavoro17';
  w_keyPassword             := 'lavoro17';
  w_forceContentTypeRequest := 'application/json'; -- 'application/json;charset=UTF-8';

  w_service_url	:= w_ws_client||'/BridgeServletHttps?'
                              ||'absoluteStore='||w_absoluteStore
                              ||'&permitSoapAction='||w_permitSoapAction
                              ||'&doUnescapeHtml='||w_doUnescapeHtml
                              ||'&URL='||w_ws_url
                              ||'&trustStoreName='||w_trustStoreName
                              ||'&trustStorePassword='||w_trustStorePassword
                              ||'&keyStoreName='||w_keyStoreName
                              ||'&keyStorePassword='||w_keyStorePassword
                              ||'&keyPassword='||w_keyPassword
                              ||'&forceContentTypeRequest='||w_forceContentTypeRequest
                   ;
  INS_LOG(w_servizio_log, w_operazione_log, 'w_service_url', w_service_url);

  w_json_header         := f_test_header(a_servizio);
  w_json_header         := replace(w_json_header,chr(10),'');
  INS_LOG(w_servizio_log, w_operazione_log, 'w_json_header', w_json_header);

  w_json_header_b64     := f_util_base64_encode(f_util_clob2blob(f_test_header(a_servizio)));
  w_json_header_b64     := replace(w_json_header_b64,'=','');
  INS_LOG(w_servizio_log, w_operazione_log, 'w_json_header_b64', w_json_header_b64);

  w_json_payload        := f_test_payload(a_servizio);
  w_json_payload        := replace(w_json_payload,chr(10),'');
  INS_LOG(w_servizio_log, w_operazione_log, 'w_json_payload', w_json_payload);

  w_json_payload_b64    := f_util_base64_encode(f_util_clob2blob(f_test_payload(a_servizio)));
  w_json_payload_b64    := replace(w_json_payload_b64,'=','');
  INS_LOG(w_servizio_log, w_operazione_log, 'w_json_payload_b64', w_json_payload_b64);

  w_json_signature_b64  := f_test_signature(a_servizio,w_json_header_b64,w_json_payload_b64);
  INS_LOG(w_servizio_log, w_operazione_log, 'w_json_signature_b64', w_json_signature_b64);

  w_json_token_jwt      := w_json_header_b64||'.'||w_json_payload_b64;--||'.'||w_json_signature_b64;
  INS_LOG(w_servizio_log, w_operazione_log, 'w_json_token_jwt', w_json_token_jwt);

  w_json_body           := f_test_body(a_servizio,'');
  INS_LOG(w_servizio_log, w_operazione_log, 'w_json_body', w_json_body);

  w_json_response 	:= WS_REQUEST(w_service_url, '', '', w_json_token_jwt, w_json_body, '');
  INS_LOG(w_servizio_log, w_operazione_log, 'w_json_response', w_json_response);

  return w_json_response;

end f_TEST_request;

end;
/
