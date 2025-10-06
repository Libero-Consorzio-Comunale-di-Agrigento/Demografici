--liquibase formatted sql
--changeset amonopoli:202504020955_1 runOnChange:true
create or replace function f_ANPR_ricerca_componenti
(a_archivio_rif  	IN	varchar2
,a_matricola	   	IN	varchar2
,a_data_rif      	IN	varchar2
,a_terminalista  	IN	varchar2
,a_id_soggetto_anpr	IN	varchar2
,a_id_famiglia_anpr	IN	varchar2
,a_tipo_scheda_anpr	IN	varchar2
)

return number

IS

-- w_comune_cliente	varchar2(255) := f_get_comune_cliente('COD_COMUNE');
-- w_ambiente_ansc	varchar2(255) := rtrim(f_ANSC_valore_inp('AMBIENTE',1,10,'X','S'));
-- w_ambiente_anpr	varchar2(255) := f_ANPR_valore_inp('TIPO_INVIO',1,10,'X','S');

w_id_operazione 	varchar2(255);

w_servizio		varchar2(255);
w_tipo_operazione	varchar2(255);

w_archivio_rif  	varchar2(255) := nvl(a_archivio_rif,'ANPR');
w_data_rif      	varchar2(255) := to_char(nvl(to_date(a_data_rif,'dd/mm/yyyy'),sysdate),'j');
w_terminalista  	varchar2(255) := a_terminalista;

w_tipo_scheda_anpr 	varchar2(255);
w_id_famiglia_anpr 	varchar2(255);
w_note			varchar2(4000);
w_matricola		number;

w_flag_ws       	varchar2(255);
w_cod_errore_ws     	varchar2(255);
w_des_errore_ws     	varchar2(32000);

errore			exception;
w_errore		varchar2(4000);

begin
  if a_tipo_scheda_anpr is null or a_id_famiglia_anpr is null then
     w_errore := 'Impossibile effettuare la richiesta: dati della famiglia ANPR mancanti';
     raise errore;
  end if;

  if w_archivio_rif = 'ADS' then
     w_matricola        := a_matricola;
     w_data_rif         := w_data_rif;
     w_id_famiglia_anpr := '';
     w_tipo_scheda_anpr := '';
     w_note             := '';
  elsif w_archivio_rif = 'ANPR' then
     w_matricola        := '';
     w_data_rif         := w_data_rif;
     w_id_famiglia_anpr := a_id_famiglia_anpr;
     w_tipo_scheda_anpr := a_tipo_scheda_anpr;
     w_note             := rpad(' ',223,' ')||rpad(nvl(w_data_rif,0),7,'0')||nvl(a_tipo_scheda_anpr,' ')||rpad(nvl(a_id_famiglia_anpr,' '),20,' ');
  end if;

  w_servizio        := '3002';
  w_tipo_operazione := 'C';
  w_id_operazione   := '';
  ANPCIU_NR(w_id_operazione,w_servizio);

  begin
    delete anpciu_par
     where id_operazione = w_id_operazione
    ;
    insert into anpciu_par (id_operazione, servizio, tipo_scheda_anpr, id_scheda_anpr, data_rif)
    values (w_id_operazione, w_servizio, w_tipo_scheda_anpr, w_id_famiglia_anpr, w_data_rif)
    ;
  exception
    when others then
--         w_errore := 'Errore in ins ANPCIU_RIF ('||SQLERRM||')';
         w_errore := 'Errore in inserimento ANPCIU_RIF';
         raise errore;
  end;

  begin
    insert into anpciu (id_operazione, servizio, tipo_operazione, archivio_rif, note, terminalista)
    values (w_id_operazione, w_servizio, w_tipo_operazione, w_archivio_rif, w_note, w_terminalista)
    ;
    commit;
  exception
    when others then
--         w_errore := 'Errore in ins ANPCIU ('||SQLERRM||')';
         w_errore := 'Errore in inserimento ANPCIU';
         raise errore;
  end;

  begin
    select ciu.flag_INVIO_ws, err.codice_errore, ERR.testo_errore
      into w_flag_ws, w_cod_errore_ws, w_des_errore_ws
      from anperr err, anpciu CIU
     where err.id_operazione (+) = ciu.id_operazione
       and err.sequenza      (+) is null
       and ciu.id_operazione = w_id_operazione
    ;
    if w_cod_errore_ws = 'EN122' then
       return -1;
    end if;
  exception
    when others then
         w_flag_ws := '';
  end;

  if w_flag_ws is not null then
     return w_id_operazione;

  else
     w_errore := nvl(w_des_errore_ws,'Nessuna risposta dal web-service');
     raise errore;
  end if;

exception
  when errore then
       w_errore := 'Messaggio da ANPR: '||w_errore;
       raise_application_error(-20999, w_errore);
  when others then
       w_errore := 'Errore in fase di ricerca ANPR';
       raise_application_error(-20999, w_errore);
end;
/
