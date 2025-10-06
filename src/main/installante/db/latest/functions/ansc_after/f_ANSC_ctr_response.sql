--liquibase formatted sql
--changeset amonopoli:202305090930 runOnChange:true stripComments:false
create or replace function f_ANSC_ctr_response
(a_servizio		IN	varchar2
,a_id_operazione	IN	number
,a_archivio_rif		IN	varchar2
,a_id_rif		IN	varchar2
,a_campo_clob		IN	clob
,a_terminalista		IN	varchar2
,a_id_atto		IN	varchar2
)

return varchar2

IS

w_ansciu_ins		number;
w_anslog_ins		number;

w_id_operazione_ANSC 	number;
w_esito_ANSC 		varchar2(255);
w_flag_errore 		varchar2(255);
w_flag_anomalia 	varchar2(255);
w_flag_invio_ws 	varchar2(255);
w_note_ws 		clob;

w_operazione_log	varchar2(255) := 'ctr_response';
w_note_log		varchar2(255);

w_return		varchar2(32000);

begin
  if a_servizio      is not null and
     a_id_operazione is not null and
     a_archivio_rif  is not null and 
     ( (a_servizio <> 'R008_R' and a_id_rif is not null) or (a_servizio = 'R008_R') )
  then
     begin
       w_ansciu_ins   := f_ansciu_ins(a_id_operazione,a_servizio,a_archivio_rif,a_id_rif,'',a_terminalista,'', a_id_atto);
       w_note_log     := 'ansciu_ins: '||w_ansciu_ins;
       w_anslog_ins   := f_ANSC_inserisci_log(a_servizio,w_operazione_log,w_note_log);

       ansc_pkg.ctr_risposta(a_servizio,a_id_operazione,a_archivio_rif,a_id_rif,a_id_atto,a_campo_clob,w_id_operazione_ANSC,w_esito_ANSC,w_flag_errore,w_flag_anomalia,w_flag_invio_ws,w_note_ws);
       if w_flag_invio_ws is not null then
          w_return := '';
       elsif w_note_ws is not null then
          w_return := w_note_ws;
       else
          w_return := 'Problemi nell''invio della comunicazione ANSC';
       end if;
     exception 
       when others then
            w_return := 'OPS! Qualcosa è andato storto...'||'('||sqlerrm||')';
     end;
  end if;

  return w_return;

end;
/

