--liquibase formatted sql
--changeset amonopoli:202504020955_2 runOnChange:true
create or replace function f_ANPR_ricerca_operazioni
(a_archivio_rif  	IN	varchar2
,a_cod_fiscale   	IN	varchar2
,a_terminalista  	IN	varchar2
,a_id_soggetto_anpr	IN	varchar2	default null
)

return number
	
IS

w_servizio		varchar2(255) := '3003';
w_id_operazione 	varchar2(255) := '';

w_note                  varchar2(255) := nvl(a_id_soggetto_anpr, a_cod_fiscale);

w_archivio_rif  	varchar2(255) := nvl(a_archivio_rif,'ANPR');
w_cod_fiscale   	varchar2(255) := a_cod_fiscale; --nvl(a_cod_fiscale,'RGGGLD66E59D548H');
w_terminalista  	varchar2(255) := a_terminalista; --nvl(a_terminalista,'GSDWIN11');

w_flag_ws       	varchar2(255);
w_cod_errore_ws     	varchar2(255);	
w_des_errore_ws     	varchar2(32000);	

w_ambiente_anpr		varchar2(255);

w_comune_cliente	varchar2(255);

errore			exception;
w_errore		varchar2(4000);

begin

  w_id_operazione := '';
  ANPCIU_NR(w_id_operazione,w_servizio);

  if a_id_soggetto_anpr is not null then
     w_cod_fiscale := '';

  end if;

  begin
    insert into anpciu_par (id_operazione, servizio, cod_fiscale)
    values (w_id_operazione, w_servizio, w_note)
    ;
    insert into anpciu (id_operazione, servizio, tipo_operazione, archivio_rif, matricola, terminalista, note)
    values (w_id_operazione, w_servizio, 'C', w_archivio_rif, to_number(null), w_terminalista, w_note)
    ;
  end;
  commit;

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
