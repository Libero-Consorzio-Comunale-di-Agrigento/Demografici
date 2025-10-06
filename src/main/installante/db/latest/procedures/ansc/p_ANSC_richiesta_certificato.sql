--liquibase formatted sql
--changeset amonopoli:202326101325 runOnChange:true stripComments:false
create or replace procedure ANSC_richiesta_certificato
(a_archivio_rif		IN	varchar2
,a_id_rif		IN	varchar2
,a_archivio_civ		IN	varchar2
,a_id_civ		IN	varchar2
,a_terminalista		IN	varchar2
,a_otp			IN	varchar2
,a_id_atto		IN	varchar2
,a_id_usecase		IN	varchar2
,w_id_operazione	IN OUT	varchar2
,w_errore_ws  		IN OUT	varchar2
)

IS

w_servizio       varchar2(255) := 'R002';
w_archivio_rif   varchar2(255) := a_archivio_rif;
w_id_rif         varchar2(255) := a_id_rif;
w_archivio_civ   varchar2(255) := a_archivio_civ;
w_id_civ         number        := a_id_civ;
w_id_usecase     number        := a_id_usecase;
w_terminalista   varchar2(255) := a_terminalista;
w_otp            varchar2(255) := a_otp;
w_id_atto        varchar2(255) := a_id_atto;

w_request	 clob;
w_response	 clob;

w_retVal	 	varchar2(32000);
w_idComunicazione	varchar2(32000);

w_servizio_log		varchar2(255) := 'R002';
w_operazione_log	varchar2(255) := 'richiesta_cert';
w_note_log		varchar2(4000);

begin
  w_note_log := 'w_servizio: '||w_servizio||' - '||
                'w_id_operazione: '||w_id_operazione||' - '||
                'w_archivio_rif: '||w_archivio_rif||' - '||
                'w_id_rif: '||w_id_rif||' - '||
                'w_archivio_civ: '||w_archivio_civ||' - '||
                'w_id_civ: '||w_id_civ||' - '||
                'w_id_usecase: '||w_id_usecase||' - '||
                'w_terminalista: '||w_terminalista||' - '||
                'w_otp: '||w_otp||' - '||
                'w_id_atto: '||w_id_atto;
  ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'inizio', w_note_log, a_id_atto);
  begin
    ANSC_PKG.attivazione_ws(w_servizio
                           ,w_id_operazione
                           ,w_archivio_rif
                           ,w_id_rif
                           ,w_archivio_civ
                           ,w_id_civ
                           ,w_id_usecase
                           ,w_terminalista
                           ,w_otp
                           ,w_id_atto
                           ,w_request
                           ,w_response
                           );
  exception
    when others then
         w_id_operazione := '';
         w_errore_ws     := 'Errore nell''invocazione del web-service';
  end;

  ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'response', w_response, a_id_atto);
                         
--dbms_output.put_line('resp (1): '||substr(w_response,1,250));
--dbms_output.put_line('resp (2): '||substr(w_response,251,250));
--dbms_output.put_line('resp (3): '||substr(w_response,501,250));
--dbms_output.put_line('resp (4): '||substr(w_response,751,250));
--dbms_output.put_line('resp (5): '||substr(w_response,1001,250));

--
--response OK
--{"retVal":null,"idComunicazione":2023001945}
--
--response KO
--{"retVal":"Lista errori:\n1. Soggetto richiedente non specificato correttamente","idComunicazione":2023001955}
--

  if w_response is not null then
     if w_response like '{"retVal"%,%"idComunicazione"%}' then
        w_retVal          := substr(w_response,instr(w_response,':')+1);
        w_retVal          := substr(w_retVal,1,instr(w_retVal,',"idComunicazione"')-1);
        if w_retVal = 'null' then
           w_retVal := '';
        end if;
        ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'w_retVal', w_retVal, a_id_atto);

        w_idComunicazione := substr(w_response,instr(w_response,'"idComunicazione"')+18);
        if instr(w_idComunicazione,',') > 0 then
           w_idComunicazione := substr(w_idComunicazione,1,instr(w_idComunicazione,',')-1);
        else
           w_idComunicazione := substr(w_idComunicazione,1,instr(w_idComunicazione,'}')-1);
        end if;
        ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'w_idComunicazione', w_idComunicazione, a_id_atto);

     elsif w_response like '%"exception"%,%"message"%}' then
--{
--   "timestamp":1701162658453,
--   "status":500,
--   "error":"Internal Server Error",
--   "exception":"it.finmatica.de4gsdzk.errors.AnscRuntimeException",
--   "message":"Codice OTP non trovato per l'utente",
--   "path":"/de4gsdzk/richiestaANSC"
--}
        w_idComunicazione := '';

        w_retVal          := substr(w_response,instr(w_response,'"message":')+11);
        w_retVal          := substr(w_retVal,1,instr(w_retVal,'"')-1);
        if w_retVal = 'null' then
           w_retVal := '';
        end if;

     else
        w_idComunicazione := '';
     end if;

     if w_idComunicazione is not null then
        w_id_operazione := w_idComunicazione;
        w_errore_ws     := w_retVal;
     elsif w_idComunicazione is null then
        w_id_operazione := '';
        w_errore_ws     := nvl(w_retVal,w_response);
     end if;
  else
     w_errore_ws := 'risposta vuota';
  end if;

<< fine >>
null;
                         
end;
/
