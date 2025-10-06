--liquibase formatted sql
--changeset amonopoli:202306090915_2 runOnChange:true stripComments:false
create or replace package body DOCAREA_PKG as

function VERSIONE
return varchar2
IS
begin
--
-- V1.0.01   24/03/2016   AM   Prima Emissione
-- V1.0.02   12/01/2017   AM   1. in presenza di Unita Organizzativa (w_cod_uo_mitt), viene passata solo nel tag "Applicativo" come unita protocollante
--                                e non anche come unita organizzativa mittente, perche altrimenti viene eseguito lo smistamento sulla scrivania del mittente
--                             2. inserito indicazione del Fascicolo (numero e anno) nella Segnatura
-- V2.0.00   31/01/2019   AM   Estensione del servizio alle comunicazioni di stato civile
-- V2.0.01   15/03/2019   AM   Corretto gestione dell'errore, in fase di protocollazione, nel caso di errore tomcat
-- V2.0.04   30/04/2019   AM   gestito ORA-31167 (XML nodes over 64K in size cannot be inserted) (rif. Cittadella)
-- V2.1.00   06/06/2019   AM   Estensione del servizio alle comunicazioni di anagrafe
-- V2.2.00   18/09/2019   AM   Estensione del servizio alle comunicazioni di leva militare
-- V2.3.00   24/10/2019   AM   Estensione del servizio alle comunicazioni di elettorale
--
--           08/01/2020   AM   modificato w_mitt_cod_uo di TEST x switch del sistema di protocollazione
--           25/11/2020   AM   modificato dati mittente di TEST x switch del sistema di protocollazione (da P_MO a C_H827)
-- V2.3.01   01/03/2021   AM   gestito ORA-31167 anche x Valeggio s/Mincio
-- V2.3.02   01/12/2021   AM   dati mittente di TEST: nuovi parametri GINP di tipo DOCAREA_%
-- V2.4.00   10/01/2022   AM   nuovo parametro DUCD_MAIL_S x gestire l'obbligatorieta dello smistamento nel tag "Mittente"
-- v2.4.01   21/02/2022   AM   IPA_AGGIORNA_MAIL: gestione del flag_ipa
-- v3.0.00   15/03/2023   AM   jProtocollaCIV: gestione dell'allegato salvato su GDM (rif. civcom_alle_gdm)
-- v3.1.00   10/01/2024   AM   IPA_AGGIORNA_MAIL: evitato insert di righe ripetute (perche' restituite doppie dal ws)
-- v3.1.01   08/01/2025   AM   JPROTOCOLLO_X34D: w_allePkField da 'TESSERA_ELE' a 'ID'
-- v3.2.00   19/12/2024   AM   PROTOCOLLA_UTENTE / GET_XML_JPROTOCOLLO_FILE: per passaggio Utente Protocollante
-- v3.2.01   05/02/2025   AM   GET_XML_JPROTOCOLLO_FILE: tag TipoDocumento non stampato se w_tipo_documento vuoto
--
  w_versione  := 'V3.2';
  w_revisione := '01 del 05/02/2025';

  return w_versione||'.'||w_revisione;
end;

procedure DATI_CLIENTE
IS
begin
  begin
    select com.cod_provincia, com.cod_comune, com.descrizione, com.sigla_provincia, pro.descrizione
      into w_cod_pro_cliente, w_cod_com_cliente, w_des_com_cliente, w_sigla_pro_cliente, w_des_pro_cliente
      from arcpro pro, arccom com
     where pro.cod_provincia	= com.cod_provincia
       and (com.cod_provincia, com.cod_comune) = (select pro_cliente, com_cliente from menuditta)
    ;
  end;
end DATI_CLIENTE;

procedure INS_LOG
(a_operazione		varchar2
,a_note			varchar2
,a_campo_clob		clob default NULL
)

IS

w_id			number;

w_oprazione_log   	varchar2(255) := 'INS_LOG';

w_errore		varchar2(4000);
errore		        exception;

begin
  begin
    insert into docarea_log (data_ora, operazione, note, campo_clob)
    values (sysdate, a_operazione, a_note, a_campo_clob)
    ;
  end;

exception
  when others then
       w_errore	:= 'Errore ('||SQLERRM||')';
       begin
         insert into docarea_log (data_ora, operazione, note)
         values (sysdate, 'inserimento_log', w_errore)
	   ;
       end;
end INS_LOG;

function PROTOCOLLA
(a_archivio_rif		varchar2
,a_id_rif		number
)

return varchar2

IS

w_return                varchar2(255);

w_operazione_log	varchar2(255)	:= 'protocolla';

w_errore		varchar2(4000);
errore                  exception;

begin
  if a_archivio_rif in ('CIVCOM') then
     w_return := docarea_pkg.PROTOCOLLA_CIV(a_archivio_rif,a_id_rif);

  elsif a_archivio_rif in ('ANACOM') then
     w_return := docarea_pkg.PROTOCOLLA_ANA(a_archivio_rif,a_id_rif);

  elsif a_archivio_rif in ('LEVCOM') then
     w_return := docarea_pkg.PROTOCOLLA_LEV(a_archivio_rif,a_id_rif);

  elsif a_archivio_rif in ('ELECOM') then
     w_return := docarea_pkg.PROTOCOLLA_ELE(a_archivio_rif,a_id_rif);

  elsif a_archivio_rif in ('ELE34D') then
--
-- non gestito perche da form viene richiamata PROTOCOLLA_X34D
--
     w_return := docarea_pkg.PROTOCOLLA_ELE(a_archivio_rif,a_id_rif);

  else
     w_errore := 'archivio_rif non gestito: '||a_archivio_rif;
     raise errore;
  end if;

  return w_return;

exception
  when errore then
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
       return null;
  when others then
       w_errore	:= 'errore ('||sqlerrm||')';
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
       return null;
end PROTOCOLLA;

function PROTOCOLLA_UTENTE
(a_archivio_rif		varchar2
,a_id_rif		number
,a_terminalista		varchar2
)

return varchar2

IS

w_return                varchar2(255);

w_operazione_log	varchar2(255)	:= 'protocolla_utente';

w_errore		varchar2(4000);
errore                  exception;

begin
  if a_archivio_rif in ('CIVCOM') then
     w_return := docarea_pkg.PROTOCOLLA_CIV(a_archivio_rif,a_id_rif,a_terminalista);

  elsif a_archivio_rif in ('ANACOM') then
     w_return := docarea_pkg.PROTOCOLLA_ANA(a_archivio_rif,a_id_rif,a_terminalista);

  elsif a_archivio_rif in ('LEVCOM') then
     w_return := docarea_pkg.PROTOCOLLA_LEV(a_archivio_rif,a_id_rif,a_terminalista);

  elsif a_archivio_rif in ('ELECOM') then
     w_return := docarea_pkg.PROTOCOLLA_ELE(a_archivio_rif,a_id_rif,a_terminalista);

  elsif a_archivio_rif in ('ELE34D') then
--
-- non gestito perche da form viene richiamata PROTOCOLLA_X34D
--
     w_return := docarea_pkg.PROTOCOLLA_ELE(a_archivio_rif,a_id_rif,a_terminalista);

  else
     w_errore := 'archivio_rif non gestito: '||a_archivio_rif;
     raise errore;
  end if;

  return w_return;

exception
  when errore then
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
       return null;
  when others then
       w_errore	:= 'errore ('||sqlerrm||')';
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
       return null;
end PROTOCOLLA_UTENTE;

function PROTOCOLLA_CIV
(a_archivio_rif		varchar2
,a_id_rif		number
,a_terminalista		varchar2 	default NULL
)

return varchar2

IS

w_anno_prot 		number;
w_num_prot 		number;
w_data_prot 		varchar2(10);
w_note_ws_prot		varchar2(4000);
w_flag_ws_prot		varchar2(1);

w_return		varchar2(32000);

w_operazione_log	varchar2(255) := 'protocolla_civ';

w_errore		varchar2(4000);
errore			exception;

begin
   docarea_pkg.INS_LOG(w_operazione_log, 'inizio', 'archivio_rif: '||a_archivio_rif||' - id_rif: '||a_id_rif);

   if a_archivio_rif = 'CIVCOM' then
      w_return := docarea_pkg.JPROTOCOLLA_CIV(a_archivio_rif, a_id_rif, a_terminalista);

   else
      w_errore := 'archivio_rif non gestito: '||a_archivio_rif;
      raise errore;
   end if;

   if w_return is null then
      goto fine;
   end if;

   docarea_pkg.CTR_RESPONSE_PROT(w_return, w_flag_ws_prot, w_note_ws_prot, w_anno_prot, w_num_prot, w_data_prot);

   if a_archivio_rif = 'CIVCOM' then
      begin
        update civcom_prot
           set anno_protocollo   = w_anno_prot,
               numero_protocollo = w_num_prot,
               data_protocollo   = to_char(to_date(w_data_prot,'dd/mm/yyyy'),'j'),
               flag_ws_prot      = w_flag_ws_prot,
               note_ws_prot      = w_note_ws_prot
         where id = a_id_rif
        ;
--        w_return := w_flag_ws_prot;
        w_return := nvl(w_flag_ws_prot,w_note_ws_prot);
      exception
        when others then
             w_errore := 'errore in upd CIVCOM_PROT ('||SQLERRM||')';
             raise errore;
      end;
   end if;

<< fine >>
null;

  return w_return;

exception
  when errore then
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
  when others then
       w_errore := 'errore ('||sqlerrm||')';
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
end PROTOCOLLA_CIV;

function PROTOCOLLA_ANA
(a_archivio_rif		varchar2
,a_id_rif		number
,a_terminalista		varchar2 	default NULL
)

return varchar2

IS

w_anno_prot 		number;
w_num_prot 		number;
w_data_prot 		varchar2(10);
w_note_ws_prot		varchar2(4000);
w_flag_ws_prot		varchar2(1);

w_return		varchar2(32000);

w_operazione_log	varchar2(255) := 'protocolla_ana';

w_errore		varchar2(4000);
errore			exception;

begin
   docarea_pkg.INS_LOG(w_operazione_log, 'inizio', 'archivio_rif: '||a_archivio_rif||' - id_rif: '||a_id_rif);

   if a_archivio_rif = 'ANACOM' then
      w_return := docarea_pkg.JPROTOCOLLA_ANA(a_archivio_rif, a_id_rif, a_terminalista);

   else
      w_errore := 'archivio_rif non gestito: '||a_archivio_rif;
      raise errore;
   end if;

   if w_return is null then
      goto fine;
   end if;

   docarea_pkg.CTR_RESPONSE_PROT(w_return, w_flag_ws_prot, w_note_ws_prot, w_anno_prot, w_num_prot, w_data_prot);

   if a_archivio_rif = 'ANACOM' then
      begin
        update anacom_prot
           set anno_protocollo   = w_anno_prot,
               numero_protocollo = w_num_prot,
               data_protocollo   = to_char(to_date(w_data_prot,'dd/mm/yyyy'),'j'),
               flag_ws_prot      = w_flag_ws_prot,
               note_ws_prot      = w_note_ws_prot
         where id = a_id_rif
        ;
--        w_return := w_flag_ws_prot;
        w_return := nvl(w_flag_ws_prot,w_note_ws_prot);
      exception
        when others then
             w_errore := 'errore in upd ANACOM_PROT ('||SQLERRM||')';
             raise errore;
      end;
   end if;

<< fine >>
null;

  return w_return;

exception
  when errore then
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
  when others then
       w_errore := 'errore ('||sqlerrm||')';
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
end PROTOCOLLA_ANA;

function PROTOCOLLA_LEV
(a_archivio_rif		varchar2
,a_id_rif		number
,a_terminalista		varchar2 	default NULL
)

return varchar2

IS

w_anno_prot 		number;
w_num_prot 		number;
w_data_prot 		varchar2(10);
w_note_ws_prot		varchar2(4000);
w_flag_ws_prot		varchar2(1);

w_return		varchar2(32000);

w_operazione_log	varchar2(255) := 'protocolla_lev';

w_errore		varchar2(4000);
errore			exception;

begin
   docarea_pkg.INS_LOG(w_operazione_log, 'inizio', 'archivio_rif: '||a_archivio_rif||' - id_rif: '||a_id_rif);

   if a_archivio_rif = 'LEVCOM' then
      w_return := docarea_pkg.JPROTOCOLLA_LEV(a_archivio_rif, a_id_rif, a_terminalista);

   else
      w_errore := 'archivio_rif non gestito: '||a_archivio_rif;
      raise errore;
   end if;

   if w_return is null then
      goto fine;
   end if;

   docarea_pkg.CTR_RESPONSE_PROT(w_return, w_flag_ws_prot, w_note_ws_prot, w_anno_prot, w_num_prot, w_data_prot);

   if a_archivio_rif = 'LEVCOM' then
      begin
        update levcom_prot
           set anno_protocollo   = w_anno_prot,
               numero_protocollo = w_num_prot,
               data_protocollo   = to_char(to_date(w_data_prot,'dd/mm/yyyy'),'j'),
               flag_ws_prot      = w_flag_ws_prot,
               note_ws_prot      = w_note_ws_prot
         where id = a_id_rif
        ;
--        w_return := w_flag_ws_prot;
        w_return := nvl(w_flag_ws_prot,w_note_ws_prot);
      exception
        when others then
             w_errore := 'errore in upd LEVCOM_PROT ('||SQLERRM||')';
             raise errore;
      end;
   end if;

<< fine >>
null;

  return w_return;

exception
  when errore then
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
  when others then
       w_errore := 'errore ('||sqlerrm||')';
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
end PROTOCOLLA_LEV;

function PROTOCOLLA_ELE
(a_archivio_rif		varchar2
,a_id_rif		number
,a_terminalista		varchar2 	default NULL
)

return varchar2

IS

w_anno_prot 		number;
w_num_prot 		number;
w_data_prot 		varchar2(10);
w_note_ws_prot		varchar2(4000);
w_flag_ws_prot		varchar2(1);

w_return		varchar2(32000);

w_operazione_log	varchar2(255) := 'protocolla_ele';

w_errore		varchar2(4000);
errore			exception;

begin
   docarea_pkg.INS_LOG(w_operazione_log, 'inizio', 'archivio_rif: '||a_archivio_rif||' - id_rif: '||a_id_rif);

   if a_archivio_rif = 'ELECOM' then
      w_return := docarea_pkg.JPROTOCOLLA_ELE(a_archivio_rif, a_id_rif, a_terminalista);

   else
      w_errore := 'archivio_rif non gestito: '||a_archivio_rif;
      raise errore;
   end if;

   if w_return is null then
      goto fine;
   end if;

   docarea_pkg.CTR_RESPONSE_PROT(w_return, w_flag_ws_prot, w_note_ws_prot, w_anno_prot, w_num_prot, w_data_prot);

   if a_archivio_rif = 'ELECOM' then
      begin
        update elecom_prot
           set anno_protocollo   = w_anno_prot,
               numero_protocollo = w_num_prot,
               data_protocollo   = to_char(to_date(w_data_prot,'dd/mm/yyyy'),'j'),
               flag_ws_prot      = w_flag_ws_prot,
               note_ws_prot      = w_note_ws_prot
         where id = a_id_rif
        ;
--        w_return := w_flag_ws_prot;
        w_return := nvl(w_flag_ws_prot,w_note_ws_prot);
      exception
        when others then
             w_errore := 'errore in upd ELECOM_PROT ('||SQLERRM||')';
             raise errore;
      end;
   end if;

<< fine >>
null;

  return w_return;

exception
  when errore then
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
  when others then
       w_errore := 'errore ('||sqlerrm||')';
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
end PROTOCOLLA_ELE;

procedure PROTOCOLLA_X34D
(a_anno_revisione		number
,a_revisione			varchar2
,a_progr_revisione		number
,a_cod_pro_dest			number
,a_cod_com_dest			number
,a_indirizzo_mail		varchar2
)

IS

w_anno_prot 		number;
w_num_prot 		number;
w_data_prot 		varchar2(10);
w_note_ws_prot		varchar2(4000);
w_flag_ws_prot		varchar2(1);

w_return		varchar2(32000);

w_operazione_log	varchar2(255) := 'protocolla_x34d';

w_errore		varchar2(4000);

begin
   docarea_pkg.INS_LOG(w_operazione_log, 'inizio');

   w_return := docarea_pkg.JPROTOCOLLA_X34D(a_anno_revisione,a_revisione,a_progr_revisione,a_cod_pro_dest,a_cod_com_dest);

   if w_return is null then
      goto fine;
   end if;

   docarea_pkg.CTR_RESPONSE_PROT(w_return, w_flag_ws_prot, w_note_ws_prot, w_anno_prot, w_num_prot, w_data_prot);

   begin
     update ele34d
        set anno_protocollo   = w_anno_prot,
            numero_protocollo = w_num_prot,
            data_protocollo   = to_char(to_date(w_data_prot,'dd/mm/yyyy'),'j'),
            flag_ws_prot      = w_flag_ws_prot,
            note_ws_prot      = w_note_ws_prot
      where anno            = a_anno_revisione
        and revisione       = a_revisione
        and progr_revisione = a_progr_revisione
        and cod_pro_dest    = a_cod_pro_dest
        and cod_Com_dest    = a_cod_com_dest
     ;
   exception
     when others then
          w_errore := 'errore in upd ELE34D ('||SQLERRM||')';
          docarea_pkg.INS_LOG(w_operazione_log, w_errore);
   end;

<< fine >>
null;

exception
  when others then
       w_errore := 'errore ('||sqlerrm||')';
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
end PROTOCOLLA_X34D;

function JPROTOCOLLA
(a_DB_where		varchar2
,a_DB_tabella		varchar2
,a_DB_campo		varchar2
,a_DB_datasource	varchar2
,a_filename 		varchar2
,a_xml_dati 		varchar2
,a_alleTable		varchar2
,a_alleField		varchar2
,a_alleNameField	varchar2
,a_allePkField		varchar2
,a_alleWhereCondition	varchar2
)

return varchar2

IS

w_docarea_inp		varchar2(4000) := f_valore_inp('DOCAREA',1,1000,'X','');

w_url_docarea 		varchar2(1000);
w_ente_docarea		varchar2(255);
w_user_docarea		varchar2(255);
w_pwd_docarea		varchar2(255);

w_DB_where		varchar2(255) := a_DB_where;
w_DB_tabella		varchar2(255) := a_DB_tabella;
w_DB_campo		varchar2(255) := a_DB_campo;
w_DB_datasource		varchar2(255) := a_DB_dataSource;

w_filename 		varchar2(255) := a_filename;
w_xml_dati 		varchar2(255) := a_xml_dati;

w_alleTable		varchar2(255) := a_alleTable;
w_alleField		varchar2(255) := a_alleField;
w_alleNameField		varchar2(255) := a_alleNameField;
w_allePkField		varchar2(255) := a_allePkField;
w_alleWhereCondition	varchar2(255) := a_alleWhereCondition;

w_url     		varchar2(1000);

http_request		utl_http.req;
http_response		utl_http.resp;
soap_response_30000     varchar2(30000);
soap_response           clob;

w_return  		varchar2(32000);

w_operazione_log	varchar2(255) := 'jprotocolla';
w_errore		varchar2(4000);

begin
  docarea_pkg.INS_LOG(w_operazione_log, 'inizio');

-- S SERVER=http://masterags/JProtocollaDocArea ENTE=P_PC USER=AGSPRWS PASSWORD=AGSPRWS
  if nvl(substr(w_docarea_inp,1,1),'N') = 'S' then
     w_url_docarea  := substr(w_docarea_inp,instr(w_docarea_inp,'SERVER=')+7);
     w_url_docarea  := substr(w_url_docarea,1,instr(w_url_docarea,' ')-1);
     w_ente_docarea := substr(w_docarea_inp,instr(w_docarea_inp,'ENTE=')+5);
     w_ente_docarea := substr(w_ente_docarea,1,instr(w_ente_docarea,' ')-1);
     w_user_docarea := substr(w_docarea_inp,instr(w_docarea_inp,'USER=')+5);
     w_user_docarea := substr(w_user_docarea,1,instr(w_user_docarea,' ')-1);
     w_pwd_docarea  := substr(w_docarea_inp,instr(w_docarea_inp,'PASSWORD=')+9);
  else
     w_url_docarea  := '';
     w_ente_docarea := '';
     w_user_docarea := '';
     w_pwd_docarea  := '';
  end if;

  w_url := w_url_docarea||'/Protocolla'||
             '?ente='||w_ente_docarea||
             '&utente='||w_user_docarea||
             '&password='||w_pwd_docarea||
             '&whereCondition='||w_DB_where||
             '&testoTable='||w_DB_tabella||
             '&testoField='||w_DB_campo||
             '&dataSource='||w_DB_datasource||
             '&filename='||w_filename||
             '&sqlXmlDati='||w_xml_dati||
             '&alleTable='||w_alleTable||
             '&alleField='||w_alleField||
             '&alleNameField='||w_alleNameField||
             '&allePkField='||w_allePkField||
             '&alleWhereCondition='||w_alleWhereCondition;

  docarea_pkg.INS_LOG(w_operazione_log, w_url);

  goto use_afc_http;

<< use_utl_http >>

  utl_http.set_transfer_timeout(600);
  http_request  := utl_http.begin_request( w_url, 'GET', 'HTTP/1.1');
  http_response := utl_http.get_response(http_request);

Dbms_Output.Put_Line ( 'docarea - Status code: ' || http_response.status_code );
Dbms_Output.Put_Line ( 'docarea - Reason phrase: ' || http_response.reason_phrase );

  begin
     UTL_HTTP.read_text (http_response, soap_response_30000, 30000);
     UTL_HTTP.end_response (http_response);
  EXCEPTION
     WHEN UTL_HTTP.end_of_body THEN
          UTL_HTTP.end_response (http_response);
     when others then
          docarea_pkg.INS_LOG(w_operazione_log, 'errore ('||SQLERRM||')');
  end;

  w_return := soap_response_30000;

  goto send_return;

<< use_afc_http >>

   afc_http.SET_SERVICE_URL(w_url);
   afc_http.SET_METHOD('GET');
   w_return := afc_http.SENDREQUEST(w_URL,'','');

<< send_return >>
  docarea_pkg.INS_LOG(w_operazione_log, 'return: '||w_return);

  return w_return;

exception
  when others then
       w_errore := 'errore ('||sqlerrm||')';
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
end JPROTOCOLLA;

function JPROTOCOLLA_CIV
(a_archivio_rif		varchar2
,a_id_rif		number
,a_terminalista		varchar2	default null
)

return varchar2

is

w_DB_where		varchar2(255) := 'where id = '||a_id_rif||
                                         ' and rownum = 1';
w_DB_tabella		varchar2(255) := a_archivio_rif||'_PROT';
w_DB_campo		varchar2(255) := 'INDICE_CLOB';
w_DB_datasource		varchar2(255) := 'jdbc/gsd';

w_alleTable		varchar2(255) := a_archivio_rif||'_ALLE';
w_alleField		varchar2(255) := 'ALLEGATO_BLOB';
w_alleNameField		varchar2(255) := 'NOME_ALLEGATO';
w_allePkField		varchar2(255) := 'ID';
w_alleWhereCondition	varchar2(255) := 'where id_com = '||a_id_rif;

w_ctr_gdm		number;

w_filename 		varchar2(255);
w_xml_dati 		varchar2(255)	:= 'select docarea_pkg.get_xml_jprotocollo_civ('''||a_archivio_rif||''','||a_id_rif||','''||a_terminalista||''') from dual';

w_return  		varchar2(32000);

w_operazione_log	varchar2(255) := 'jprotocolla_civ';

w_errore		varchar2(4000);
errore			exception;

begin
  docarea_pkg.INS_LOG(w_operazione_log, 'inizio');

  begin
    select nvl(p.nome_indice,'nome_indice')
      into w_filename
      from civcom_prot p
     where id     = a_id_rif
       and rownum = 1
    ;
    if instr(w_filename,'/') > 0 then
       w_filename := substr(w_filename,instr(w_filename,'/',-1)+1);
    elsif instr(w_filename,'\') > 0 then
       w_filename := substr(w_filename,instr(w_filename,'\',-1)+1);
    end if;
  exception
    when others then
         w_filename := '';
  end;

  w_ctr_gdm := 0;
  begin
    select 1
      into w_ctr_gdm
      from civcom_alle_gdm
     where id_com = a_id_rif
       and rownum = 1
    ;
  exception
    when others then
         w_ctr_gdm := 0;
  end;

  if w_ctr_gdm = 1 then
     w_alleTable := w_alleTable||'_GDM';
  end if;

  w_return := docarea_pkg.JPROTOCOLLA(w_DB_where, w_DB_tabella, w_DB_campo, w_DB_datasource, w_filename, w_xml_dati, w_alleTable, w_alleField, w_alleNameField, w_allePkField, w_alleWhereCondition);

  docarea_pkg.INS_LOG(w_operazione_log, 'return: '||w_return);

  return w_return;

exception
  when errore then
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
  when others then
       w_errore := 'errore ('||sqlerrm||')';
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
end JPROTOCOLLA_CIV;

function JPROTOCOLLA_ANA
(a_archivio_rif		varchar2
,a_id_rif		number
,a_terminalista		varchar2	default null
)

return varchar2

is

w_DB_where		varchar2(255) := 'where id = '||a_id_rif||
                                         ' and rownum = 1';
w_DB_tabella		varchar2(255) := a_archivio_rif||'_PROT';
w_DB_campo		varchar2(255) := 'INDICE_CLOB';
w_DB_datasource		varchar2(255) := 'jdbc/gsd';

w_alleTable		varchar2(255) := a_archivio_rif||'_ALLE';
w_alleField		varchar2(255) := 'ALLEGATO_BLOB';
w_alleNameField		varchar2(255) := 'NOME_ALLEGATO';
w_allePkField		varchar2(255) := 'ID';
w_alleWhereCondition	varchar2(255) := 'where id_com = '||a_id_rif;

w_filename 		varchar2(255);
w_xml_dati 		varchar2(255)	:= 'select docarea_pkg.get_xml_jprotocollo_ana('''||a_archivio_rif||''','||a_id_rif||','''||a_terminalista||''') from dual';

w_return  		varchar2(32000);

w_operazione_log	varchar2(255) := 'jprotocolla_ana';

w_errore		varchar2(4000);
errore			exception;

begin
  docarea_pkg.INS_LOG(w_operazione_log, 'inizio');

  begin
    select nvl(p.nome_indice,'nome_indice')
      into w_filename
      from anacom_prot p
     where id     = a_id_rif
       and rownum = 1
    ;
    if instr(w_filename,'/') > 0 then
       w_filename := substr(w_filename,instr(w_filename,'/',-1)+1);
    elsif instr(w_filename,'\') > 0 then
       w_filename := substr(w_filename,instr(w_filename,'\',-1)+1);
    end if;
  exception
    when others then
         w_filename := '';
  end;

  w_return := docarea_pkg.JPROTOCOLLA(w_DB_where, w_DB_tabella, w_DB_campo, w_DB_datasource, w_filename, w_xml_dati, w_alleTable, w_alleField, w_alleNameField, w_allePkField, w_alleWhereCondition);

  docarea_pkg.INS_LOG(w_operazione_log, 'return: '||w_return);

  return w_return;

exception
  when errore then
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
  when others then
       w_errore := 'errore ('||sqlerrm||')';
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
end JPROTOCOLLA_ANA;

function JPROTOCOLLA_LEV
(a_archivio_rif		varchar2
,a_id_rif		number
,a_terminalista		varchar2	default null
)

return varchar2

is

w_DB_where		varchar2(255) := 'where id = '||a_id_rif||
                                         ' and rownum = 1';
w_DB_tabella		varchar2(255) := a_archivio_rif||'_PROT';
w_DB_campo		varchar2(255) := 'INDICE_CLOB';
w_DB_datasource		varchar2(255) := 'jdbc/gsd';

w_alleTable		varchar2(255) := a_archivio_rif||'_ALLE';
w_alleField		varchar2(255) := 'ALLEGATO_BLOB';
w_alleNameField		varchar2(255) := 'NOME_ALLEGATO';
w_allePkField		varchar2(255) := 'ID';
w_alleWhereCondition	varchar2(255) := 'where id_com = '||a_id_rif;

w_filename 		varchar2(255);
w_xml_dati 		varchar2(255)	:= 'select docarea_pkg.get_xml_jprotocollo_lev('''||a_archivio_rif||''','||a_id_rif||','''||a_terminalista||''') from dual';

w_return  		varchar2(32000);

w_operazione_log	varchar2(255) := 'jprotocolla_lev';

w_errore		varchar2(4000);
errore			exception;

begin
  docarea_pkg.INS_LOG(w_operazione_log, 'inizio');

  begin
    select nvl(p.nome_indice,'nome_indice')
      into w_filename
      from levcom_prot p
     where id     = a_id_rif
       and rownum = 1
    ;
    if instr(w_filename,'/') > 0 then
       w_filename := substr(w_filename,instr(w_filename,'/',-1)+1);
    elsif instr(w_filename,'\') > 0 then
       w_filename := substr(w_filename,instr(w_filename,'\',-1)+1);
    end if;
  exception
    when others then
         w_filename := '';
  end;

  w_return := docarea_pkg.JPROTOCOLLA(w_DB_where, w_DB_tabella, w_DB_campo, w_DB_datasource, w_filename, w_xml_dati, w_alleTable, w_alleField, w_alleNameField, w_allePkField, w_alleWhereCondition);

  docarea_pkg.INS_LOG(w_operazione_log, 'return: '||w_return);

  return w_return;

exception
  when errore then
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
  when others then
       w_errore := 'errore ('||sqlerrm||')';
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
end JPROTOCOLLA_LEV;

function JPROTOCOLLA_ELE
(a_archivio_rif		varchar2
,a_id_rif		number
,a_terminalista		varchar2	default null
)

return varchar2

is

w_DB_where		varchar2(255) := 'where id = '||a_id_rif||
                                         ' and rownum = 1';
w_DB_tabella		varchar2(255) := a_archivio_rif||'_PROT';
w_DB_campo		varchar2(255) := 'INDICE_CLOB';
w_DB_datasource		varchar2(255) := 'jdbc/gsd';

w_alleTable		varchar2(255) := a_archivio_rif||'_ALLE';
w_alleField		varchar2(255) := 'ALLEGATO_BLOB';
w_alleNameField		varchar2(255) := 'NOME_ALLEGATO';
w_allePkField		varchar2(255) := 'ID';
w_alleWhereCondition	varchar2(255) := 'where id_com = '||a_id_rif;

w_filename 		varchar2(255);
w_xml_dati 		varchar2(255)	:= 'select docarea_pkg.get_xml_jprotocollo_ele('''||a_archivio_rif||''','||a_id_rif||','''||a_terminalista||''') from dual';

w_return  		varchar2(32000);

w_operazione_log	varchar2(255) := 'jprotocolla_ele';

w_errore		varchar2(4000);
errore			exception;

begin
  docarea_pkg.INS_LOG(w_operazione_log, 'inizio');

  begin
    select nvl(p.nome_indice,'nome_indice')
      into w_filename
      from elecom_prot p
     where id     = a_id_rif
       and rownum = 1
    ;
    if instr(w_filename,'/') > 0 then
       w_filename := substr(w_filename,instr(w_filename,'/',-1)+1);
    elsif instr(w_filename,'\') > 0 then
       w_filename := substr(w_filename,instr(w_filename,'\',-1)+1);
    end if;
  exception
    when others then
         w_filename := '';
  end;

  w_return := docarea_pkg.JPROTOCOLLA(w_DB_where, w_DB_tabella, w_DB_campo, w_DB_datasource, w_filename, w_xml_dati, w_alleTable, w_alleField, w_alleNameField, w_allePkField, w_alleWhereCondition);

  docarea_pkg.INS_LOG(w_operazione_log, 'return: '||w_return);

  return w_return;

exception
  when errore then
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
  when others then
       w_errore := 'errore ('||sqlerrm||')';
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
end JPROTOCOLLA_ELE;

function JPROTOCOLLA_X34D
(a_anno_revisione		number
,a_revisione			varchar2
,a_progr_revisione		number
,a_cod_pro_dest			number
,a_cod_com_dest			number
)

return varchar2

is

w_DB_where		varchar2(255) := 'where anno = '||a_anno_revisione||
                                         ' and revisione = '''||a_revisione||''' '||
                                         ' and progr_revisione = '||a_progr_revisione||
                                         ' and cod_pro_dest = '||a_cod_pro_dest||
                                         ' and cod_com_dest = '||a_cod_com_dest||
                                         ' and rownum = 1';
w_DB_tabella		varchar2(255) := 'ELE34D';
w_DB_campo		varchar2(255) := 'INDICE_CLOB';
w_DB_datasource		varchar2(255) := 'jdbc/gsd';

w_alleTable		varchar2(255) := 'ELE34D';
w_alleField		varchar2(255) := 'ALLEGATO_CLOB';
w_alleNameField		varchar2(255) := 'NOME_ALLEGATO';
w_allePkField		varchar2(255) := 'ID';
w_alleWhereCondition	varchar2(255) := 'where anno = '||a_anno_revisione||
                                         ' and revisione = '''||a_revisione||''' '||
                                         ' and progr_revisione = '||a_progr_revisione||
                                         ' and cod_pro_dest = '||a_cod_pro_dest||
                                         ' and cod_com_dest = '||a_cod_com_dest;

w_filename 		varchar2(255);
w_xml_dati 		varchar2(255)	:= 'select docarea_pkg.get_xml_jprotocollo_x34d('||a_anno_revisione||','''||a_revisione||''','||a_progr_revisione||','||a_cod_pro_dest||','||a_cod_com_dest||') from dual';

w_return  		varchar2(32000);

w_operazione_log	varchar2(255) := 'jprotocolla_x34d';
w_errore		varchar2(4000);

begin
  docarea_pkg.INS_LOG(w_operazione_log, 'inizio');

  begin
    select d.nome_indice
      into w_filename
      from ele34d d
     where anno            = a_anno_revisione
       and revisione       = a_revisione
       and progr_revisione = a_progr_revisione
       and cod_pro_dest    = a_cod_pro_dest
       and cod_com_dest    = a_cod_com_dest
       and rownum = 1
    ;
    if instr(w_filename,'/') > 0 then
       w_filename := substr(w_filename,instr(w_filename,'/',-1)+1);
    elsif instr(w_filename,'\') > 0 then
       w_filename := substr(w_filename,instr(w_filename,'\',-1)+1);
    end if;
  exception
    when others then
         w_filename := '';
  end;

  w_return := docarea_pkg.JPROTOCOLLA(w_DB_where, w_DB_tabella, w_DB_campo, w_DB_datasource, w_filename, w_xml_dati, w_alleTable, w_alleField, w_alleNameField, w_allePkField, w_alleWhereCondition);

  docarea_pkg.INS_LOG(w_operazione_log, 'return: '||w_return);

  return w_return;

exception
  when others then
       w_errore := 'errore ('||sqlerrm||')';
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
end JPROTOCOLLA_X34D;

function GET_XML_JPROTOCOLLO
(a_mitt_des_amm		varchar2
,a_mitt_cod_amm 	varchar2
,a_mitt_cod_aoo 	varchar2
,a_mitt_cod_uo 		varchar2
,a_dest_des_amm		varchar2
,a_dest_cod_amm 	varchar2
,a_dest_cod_aoo 	varchar2
,a_dest_cod_uo 		varchar2
,a_dest_mail		varchar2
,a_oggetto 		varchar2
,a_ide_cod_amm		varchar2
,a_ide_cod_aoo		varchar2
,a_ide_flusso		varchar2
,a_cod_titolario	varchar2
,a_numero_fascicolo	varchar2
,a_anno_fascicolo	number
,a_filename 		varchar2
,a_tipo_documento	varchar2
,a_dest_persona_id	varchar2	default NULL
,a_dest_persona_cognome	varchar2	default NULL
,a_dest_persona_nome	varchar2	default NULL
)

return varchar2

is

w_docarea_ws		varchar2(255) := rtrim(f_valore_inp('DOCAREA_WS',1,4,'X','S'));
w_ducd_mail_s_inp       varchar2(1)   := f_valore_inp('DUCD_MAILS',1,1,'X','S');

w_mitt_des_amm		varchar2(255);
w_mitt_cod_amm 		varchar2(255);
w_mitt_cod_aoo 		varchar2(255);
w_mitt_cod_uo 		varchar2(255);

w_dest_des_amm		varchar2(255);
w_dest_cod_amm 		varchar2(255);
w_dest_cod_aoo 		varchar2(255);
w_dest_cod_uo 		varchar2(255);
w_dest_mail		varchar2(255);

w_oggetto 		varchar2(2000);

w_ide_cod_amm		varchar2(255);
w_ide_cod_aoo		varchar2(255);
w_ide_flusso		varchar2(255);

w_cod_titolario		varchar2(255);
w_numero_fascicolo	varchar2(255);
w_anno_fascicolo	number;

w_filename 		varchar2(255);
w_tipo_documento	varchar2(255);

w_operazione_log	varchar2(255)	:= 'get_xml';
w_errore		varchar2(4000);

errore			exception;

w_return 		varchar2(32767);

begin

  w_mitt_des_amm     := a_mitt_des_amm;
  w_mitt_cod_amm     := a_mitt_cod_amm;
  w_mitt_cod_aoo     := a_mitt_cod_aoo;
  w_mitt_cod_uo      := a_mitt_cod_uo;
  w_dest_des_amm     := a_dest_des_amm;
  w_dest_cod_amm     := a_dest_cod_amm;
  w_dest_cod_aoo     := a_dest_cod_aoo;
  w_dest_cod_uo      := a_dest_cod_uo;
  w_dest_mail        := a_dest_mail;
  w_oggetto          := a_oggetto;
  w_ide_cod_amm      := a_ide_cod_amm;
  w_ide_cod_aoo      := a_ide_cod_aoo;
  w_ide_flusso       := a_ide_flusso;
  w_cod_titolario    := a_cod_titolario;
  w_numero_fascicolo := a_numero_fascicolo;
  w_anno_fascicolo   := a_anno_fascicolo;
  w_filename         := a_filename;
  w_tipo_documento   := a_tipo_documento;

/*
  if nvl(w_docarea_ws,' ') = 'TEST' then -- su http://test-agspr-as02/JProtocolloDocArea/ (gsd-win-forms11 - gallesPAL)
     w_mitt_des_amm := 'Ente di Test - GSD-WIN-FORMS11';
     w_mitt_cod_amm := 'H827';
     w_mitt_cod_aoo := 'H827';
     w_mitt_cod_uo  := 'A04.01.04';
     w_dest_mail    := 'a.monopoli@ads.it';
  end if;
  if nvl(w_docarea_ws,' ') = 'TEST' then -- su http://test-consags/JProtocolloDocArea/	 (tst-tr-fin-f11 - tst-tr-fin-db)
     w_mitt_des_amm := 'Ente di Test - TST-TR-FIN';
     w_mitt_cod_amm := 'A00_PROVPC';
     w_mitt_cod_aoo := 'A00_PROVPC';
     w_mitt_cod_uo  := 'U_CONT';
     w_dest_mail    := 'a.monopoli@ads.it';
  end if;
*/
  if nvl(w_docarea_ws,' ') = 'TEST' then
     w_mitt_des_amm := 'Ente di Test';
     w_mitt_cod_amm := rtrim(f_valore_inp('DOCAREA_AM',1,100,'X',''));
     w_mitt_cod_aoo := rtrim(f_valore_inp('DOCAREA_AO',1,100,'X',''));
     w_mitt_cod_uo  := rtrim(f_valore_inp('DOCAREA_UO',1,100,'X',''));
     w_dest_mail    := nvl(rtrim(f_valore_inp('DOCAREA_EM',1,100,'X','')),'destinatario@mail.it');
  end if;

  w_return := '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'||
              '<Segnatura>'||
              ' <Intestazione>'||
              '   <Oggetto>'||w_oggetto||'</Oggetto>'||
              '   <Identificatore>'||
              '     <CodiceAmministrazione>'||w_ide_cod_amm||'</CodiceAmministrazione>'||
              '     <CodiceAOO>'||w_ide_cod_aoo||'</CodiceAOO>'||
              '     <Flusso>'||w_ide_flusso||'</Flusso>'||
              '   </Identificatore>'||
              '   <Mittente >'||
              '     <Amministrazione>'||
              '       <Denominazione>'||w_mitt_des_amm||'</Denominazione>'||
              '       <CodiceAmministrazione>'||w_mitt_cod_amm||'</CodiceAmministrazione>';

  if nvl(w_ducd_mail_s_inp,'N') = 'S' and w_mitt_cod_uo is not null then
     w_return := w_return||
              '       <UnitaOrganizzativa id="'||w_mitt_cod_uo||'"></UnitaOrganizzativa>';
  end if;

  w_return := w_return||
              '     </Amministrazione>'||
              '   </Mittente>'||
              '   <Destinatario>'||
              '     <Amministrazione>'||
              '       <Denominazione>'||w_dest_des_amm||'</Denominazione>'||
              '       <CodiceAmministrazione>'||w_dest_cod_amm||'</CodiceAmministrazione>'||
              '       <IndirizzoTelematico tipo="smtp">'||w_dest_mail||'</IndirizzoTelematico>';

  if w_dest_cod_uo is not null then
     w_return := w_return||
              '       <UnitaOrganizzativa id="'||w_dest_cod_uo||'"></UnitaOrganizzativa>';
  end if;

  w_return := w_return||
              '     </Amministrazione>';

  w_return := w_return||
              '     <AOO>'||
              '       <CodiceAOO>'||w_dest_cod_aoo||'</CodiceAOO>'||
              '     </AOO>';

  w_return := w_return||
              '   </Destinatario>'||

              '   <Classifica>'||
              '     <CodiceAmministrazione>'||w_mitt_cod_amm||'</CodiceAmministrazione>'||
              '     <CodiceAOO>'||w_mitt_cod_aoo||'</CodiceAOO>'||
              '     <CodiceTitolario>'||w_cod_titolario||'</CodiceTitolario>'||
              '   </Classifica>';

  if w_numero_fascicolo is not null and w_anno_fascicolo is not null then
     w_return := w_return||
              '   <Fascicolo numero="'||w_numero_fascicolo||'" anno="'||w_anno_fascicolo||'"></Fascicolo>';
  end if;

  w_return := w_return||
              ' </Intestazione>'||
              ' <Descrizione>'||
              '   <Documento nome="'||w_filename||'" id="ID_DOCUMENTO_CALCOLATO">';

  if w_tipo_documento is not null then
     w_return := w_return||
              '     <TipoDocumento>'||w_tipo_documento||'</TipoDocumento>';
  end if;

  w_return := w_return||
              '   </Documento>'||
              '   <Allegati/>'||
              ' </Descrizione>'||
              ' <ApplicativoProtocollo nome="AGSPR">'||
              '   <Parametro valore="'||w_mitt_cod_uo||'" nome="uo"/>'||
              '   <Parametro valore="COMPETENZA" nome="tipoSmistamento"/>'||
              ' </ApplicativoProtocollo>'||
              '</Segnatura>';

  return w_return;

exception
  when others then
       w_errore	:= 'errore ('||sqlerrm||')';
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
end GET_XML_JPROTOCOLLO;

function GET_XML_JPROTOCOLLO_CIV
(a_archivio_rif		varchar2
,a_id_rif		number
,a_terminalista		varchar2	default null
)

return varchar2

is

cursor sel_d is
select com_d.id
     , 'COMUNE DI '||com.descrizione dest_des_amm
     , pec.cod_amm                   dest_cod_amm
     , pec.cod_aoo                   dest_cod_aoo
     , pec.cod_uo                    dest_cod_uo
     , pec.indirizzo_mail            dest_mail
  from arccom com
     , arcpec pec
     , civcom_dest com_d
 where com.cod_provincia = pec.cod_provincia
   and com.cod_Comune    = pec.cod_Comune
   and pec.flag_civ      = 'S'
   and pec.cod_provincia = com_d.cod_pro_dest
   and pec.cod_comune    = com_d.cod_Com_dest
   and com_d.id_com      = a_id_rif
UNION
select com_d.id
     , den.descrizione 	             dest_des_amm
     , den.cod_amm                   dest_cod_amm
     , den.cod_aoo                   dest_cod_aoo
     , den.cod_uo                    dest_cod_uo
     , den.indirizzo_pec             dest_mail
  from civden den
     , civcom_dest com_d
 where den.codice_en      = com_d.cod_ente_dest
   and com_d.cod_com_dest is null
   and com_d.id_com       = a_id_rif
 order by 1
;

w_mitt_des_amm		varchar2(255);
w_mitt_cod_amm 		varchar2(255);
w_mitt_cod_aoo 		varchar2(255);
w_mitt_cod_uo 		varchar2(255);

w_dest_des_amm		varchar2(255);
w_dest_cod_amm 		varchar2(255);
w_dest_cod_aoo 		varchar2(255);
w_dest_cod_uo 		varchar2(255);
w_dest_mail		varchar2(255);

w_oggetto 		varchar2(2000);

w_ide_cod_amm		varchar2(255);
w_ide_cod_aoo		varchar2(255);
w_ide_flusso		varchar2(255);

w_cod_titolario		varchar2(255);
w_numero_fascicolo	varchar2(255);
w_anno_fascicolo	number;

w_filename 		varchar2(255);
w_tipo_documento	varchar2(255);

w_return 		varchar2(32767);

w_operazione_log	varchar2(255)	:= 'get_xml_civ';

w_errore		varchar2(4000);
errore			exception;

begin

--  docarea_pkg.INS_LOG(w_operazione_log, 'inizio');
  docarea_pkg.dati_cliente;

  begin
    select 'COMUNE DI '||com.descrizione,
           pec.cod_amm, pec.cod_aoo, pec.cod_uo
      into w_mitt_des_amm,
           w_mitt_cod_amm, w_mitt_cod_aoo, w_mitt_cod_uo
      from arccom com, arcpec pec
     where com.cod_provincia = pec.cod_provincia
       and com.cod_Comune    = pec.cod_Comune
       and pec.cod_provincia = w_cod_pro_cliente
       and pec.cod_comune    = w_cod_com_cliente
       and pec.flag_civ      = 'S'
       and rownum = 1
    ;
  exception
    when others then
	 w_mitt_des_amm := '';
         w_mitt_cod_amm := '';
         w_mitt_cod_aoo := '';
         w_mitt_cod_uo  := '';
  end;

  begin
    select p.oggetto||' - '||p.oggetto_info, p.nome_indice
      into w_oggetto, w_filename
      from gsdcom_prot p
     where p.archivio_rif = a_archivio_rif
       and p.id_rif       = a_id_rif
       and rownum = 1
    ;
  exception
    when others then
         w_oggetto        := a_archivio_rif;
         w_filename       := '';
  end;

  w_ide_cod_amm := w_mitt_cod_amm;
  w_ide_cod_aoo := w_mitt_cod_aoo;
  w_ide_flusso  := 'U';

  w_return := docarea_pkg.GET_XML_JPROTOCOLLO_MITT(w_oggetto, w_ide_cod_amm, w_ide_cod_aoo, w_ide_flusso, w_mitt_des_amm, w_mitt_cod_amm, w_mitt_cod_aoo, w_mitt_cod_uo);

  for rec_d in sel_d loop
      w_dest_des_amm := rec_d.dest_des_amm;
      w_dest_cod_amm := rec_d.dest_cod_amm;
      w_dest_cod_aoo := rec_d.dest_cod_aoo;
      w_dest_cod_uo  := rec_d.dest_cod_uo;
      w_dest_mail    := rec_d.dest_mail;
      w_return := w_return||docarea_pkg.GET_XML_JPROTOCOLLO_DEST(w_dest_des_amm, w_dest_cod_amm, w_dest_cod_aoo, w_dest_cod_uo, w_dest_mail);
  end loop;

  begin
    select p.classificazione, p.tipo_documento, p.numero_fascicolo, p.anno_fascicolo
      into w_cod_titolario, w_tipo_documento, w_numero_fascicolo, w_anno_fascicolo
      from parametri_protocollo p
         , gsdcom_par gp
     where p.fase          = gp.fase
       and p.funzione      = gp.funzione
       and gp.archivio_rif = a_archivio_rif
       and gp.id_rif       = a_id_rif
       and rownum     = 1
    ;
  exception
    when others then
         w_cod_titolario    := '';
         w_tipo_documento   := '';
         w_numero_fascicolo := '';
         w_anno_fascicolo   := '';
  end;

  w_return := w_return||docarea_pkg.GET_XML_JPROTOCOLLO_FILE(w_mitt_cod_amm, w_mitt_cod_aoo, w_mitt_cod_uo, w_cod_titolario, w_numero_fascicolo, w_anno_fascicolo, w_filename, w_tipo_documento,a_terminalista);

  return w_return;

exception
  when errore then
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
  when others then
       w_errore	:= 'errore ('||sqlerrm||')';
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
end GET_XML_JPROTOCOLLO_CIV;

function GET_XML_JPROTOCOLLO_ANA
(a_archivio_rif		varchar2
,a_id_rif		number
,a_terminalista		varchar2	default null
)

return varchar2

is

cursor sel_d is
select com_d.id
     , 'COMUNE DI '||com.descrizione dest_des_amm
     , pec.cod_amm                   dest_cod_amm
     , pec.cod_aoo                   dest_cod_aoo
     , pec.cod_uo                    dest_cod_uo
     , pec.indirizzo_mail            dest_mail
     , to_char(null)                 dest_persona_id
     , to_char(null)                 dest_persona_cognome
     , to_char(null)                 dest_persona_nome
  from arccom com
     , arcpec pec
     , anacom_dest com_d
 where com.cod_provincia  = pec.cod_provincia
   and com.cod_Comune     = pec.cod_Comune
   and pec.flag_ana       = 'S'
   and pec.cod_provincia  = com_d.cod_pro_dest
   and pec.cod_comune     = com_d.cod_Com_dest
   and com_d.id_com       = a_id_rif
UNION
select com_d.id
     , dco.descrizione||' - '||con.sede dest_des_amm
     , con.cod_amm                      dest_cod_amm
     , con.cod_aoo                      dest_cod_aoo
     , con.cod_uo                       dest_cod_uo
     , con.indirizzo_pec                dest_mail
     , to_char(null)                    dest_persona_id
     , to_char(null)                    dest_persona_cognome
     , to_char(null)                    dest_persona_nome
  from arcdco dco
     , arccon con
     , anacom_dest com_d
 where dco.tipo_consolato = con.tipo_consolato
   and con.cod_consolato  = com_d.cod_consolato_dest
   and con.tipo_consolato = com_d.tipo_consolato_dest
   and com_d.id_com       = a_id_rif
UNION
select com_d.id
     , translate(ana.cognome_nome,'/',' ') dest_des_amm
     , to_char(null)                       dest_cod_amm
     , to_char(null)                       dest_cod_aoo
     , to_char(null)                       dest_cod_uo
     , ari.indirizzo_rec                   dest_mail
     , ana.cod_fiscale                     dest_persona_id
     , f_cognome(ana.cognome_nome)         dest_persona_cognome
     , f_nome(ana.cognome_nome)            dest_persona_nome
  from anadtr dtr
     , anaari ari
     , anaana ana
     , anacom_dest com_d
 where dtr.tipo_comunicazione = 'E'
   and dtr.descrizione        like '%PEC%'
   and dtr.cod_tr             = ari.tipo_recapito
   and ari.matricola          = com_d.matricola_dest
   and ana.matricola          = com_d.matricola_dest
   and com_d.id_com           = a_id_rif
   and rownum = 1
UNION
select com_d.id
     , den.descrizione 	             dest_des_amm
     , den.cod_amm                   dest_cod_amm
     , den.cod_aoo                   dest_cod_aoo
     , den.cod_uo                    dest_cod_uo
     , den.indirizzo_pec             dest_mail
     , to_char(null)                 dest_persona_id
     , to_char(null)                 dest_persona_cognome
     , to_char(null)                 dest_persona_nome
  from anaden den
     , anacom_dest com_d
 where den.cod_en         = com_d.cod_ente_dest
   and com_d.cod_com_dest||com_d.cod_consolato_dest||com_d.matricola_dest is null
   and com_d.id_com       = a_id_rif
 order by 1
;

w_mitt_des_amm		varchar2(255);
w_mitt_cod_amm 		varchar2(255);
w_mitt_cod_aoo 		varchar2(255);
w_mitt_cod_uo 		varchar2(255);

w_dest_des_amm		varchar2(255);
w_dest_cod_amm 		varchar2(255);
w_dest_cod_aoo 		varchar2(255);
w_dest_cod_uo 		varchar2(255);
w_dest_mail		varchar2(255);

w_dest_persona_id	varchar2(255);
w_dest_persona_cognome	varchar2(255);
w_dest_persona_nome	varchar2(255);

w_oggetto 		varchar2(2000);

w_ide_cod_amm		varchar2(255);
w_ide_cod_aoo		varchar2(255);
w_ide_flusso		varchar2(255);

w_cod_titolario		varchar2(255);
w_numero_fascicolo	varchar2(255);
w_anno_fascicolo	number;

w_filename 		varchar2(255);
w_tipo_documento	varchar2(255);

w_return 		varchar2(32767);

w_operazione_log	varchar2(255)	:= 'get_xml_ana';

w_errore		varchar2(4000);
errore			exception;

begin

--  docarea_pkg.INS_LOG(w_operazione_log, 'inizio');
  docarea_pkg.dati_cliente;

  begin
    select 'COMUNE DI '||com.descrizione,
           pec.cod_amm, pec.cod_aoo, pec.cod_uo
      into w_mitt_des_amm,
           w_mitt_cod_amm, w_mitt_cod_aoo, w_mitt_cod_uo
      from arccom com, arcpec pec
     where com.cod_provincia = pec.cod_provincia
       and com.cod_Comune    = pec.cod_Comune
       and pec.cod_provincia = w_cod_pro_cliente
       and pec.cod_comune    = w_cod_com_cliente
       and pec.flag_ana      = 'S'
       and rownum = 1
    ;
  exception
    when others then
	 w_mitt_des_amm := '';
         w_mitt_cod_amm := '';
         w_mitt_cod_aoo := '';
         w_mitt_cod_uo  := '';
  end;

  begin
    select p.oggetto||' - '||p.oggetto_info, p.nome_indice
      into w_oggetto, w_filename
      from gsdcom_prot p
     where p.archivio_rif = a_archivio_rif
       and p.id_rif       = a_id_rif
       and rownum = 1
    ;
  exception
    when others then
         w_oggetto        := a_archivio_rif;
         w_filename       := '';
  end;

  w_ide_cod_amm := w_mitt_cod_amm;
  w_ide_cod_aoo := w_mitt_cod_aoo;
  w_ide_flusso  := 'U';

  w_return := docarea_pkg.GET_XML_JPROTOCOLLO_MITT(w_oggetto, w_ide_cod_amm, w_ide_cod_aoo, w_ide_flusso, w_mitt_des_amm, w_mitt_cod_amm, w_mitt_cod_aoo, w_mitt_cod_uo);

  for rec_d in sel_d loop
      w_dest_des_amm         := rec_d.dest_des_amm;
      w_dest_cod_amm         := rec_d.dest_cod_amm;
      w_dest_cod_aoo         := rec_d.dest_cod_aoo;
      w_dest_cod_uo          := rec_d.dest_cod_uo;
      w_dest_mail            := rec_d.dest_mail;
      w_dest_persona_id      := rec_d.dest_persona_id;
      w_dest_persona_cognome := rec_d.dest_persona_cognome;
      w_dest_persona_nome    := rec_d.dest_persona_nome;
      w_return := w_return||docarea_pkg.GET_XML_JPROTOCOLLO_DEST(w_dest_des_amm, w_dest_cod_amm, w_dest_cod_aoo, w_dest_cod_uo, w_dest_mail,
                                                                 w_dest_persona_id, w_dest_persona_cognome, w_dest_persona_nome);
  end loop;

  begin
    select p.classificazione, p.tipo_documento, p.numero_fascicolo, p.anno_fascicolo
      into w_cod_titolario, w_tipo_documento, w_numero_fascicolo, w_anno_fascicolo
      from parametri_protocollo p
         , gsdcom_par gp
     where p.fase          = gp.fase
       and p.funzione      = gp.funzione
       and gp.archivio_rif = a_archivio_rif
       and gp.id_rif       = a_id_rif
       and rownum     = 1
    ;
  exception
    when others then
         w_cod_titolario    := '';
         w_tipo_documento   := '';
         w_numero_fascicolo := '';
         w_anno_fascicolo   := '';
  end;

  w_return := w_return||docarea_pkg.GET_XML_JPROTOCOLLO_FILE(w_mitt_cod_amm, w_mitt_cod_aoo, w_mitt_cod_uo, w_cod_titolario, w_numero_fascicolo, w_anno_fascicolo, w_filename, w_tipo_documento,a_terminalista);

  return w_return;

exception
  when errore then
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
  when others then
       w_errore	:= 'errore ('||sqlerrm||')';
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
end GET_XML_JPROTOCOLLO_ANA;

function GET_XML_JPROTOCOLLO_LEV
(a_archivio_rif		varchar2
,a_id_rif		number
,a_terminalista		varchar2	default null
)

return varchar2

is

cursor sel_d is
select com_d.id
     , 'COMUNE DI '||com.descrizione dest_des_amm
     , pec.cod_amm                   dest_cod_amm
     , pec.cod_aoo                   dest_cod_aoo
     , pec.cod_uo                    dest_cod_uo
     , pec.indirizzo_mail            dest_mail
  from arccom com
     , arcpec pec
     , levcom_dest com_d
 where com.cod_provincia = pec.cod_provincia
   and com.cod_Comune    = pec.cod_Comune
   and pec.flag_lev      = 'S'
   and pec.cod_provincia = com_d.cod_pro_dest
   and pec.cod_comune    = com_d.cod_Com_dest
   and com_d.id_com      = a_id_rif
UNION
select com_d.id
     , den.descrizione 	             dest_des_amm
     , den.cod_amm                   dest_cod_amm
     , den.cod_aoo                   dest_cod_aoo
     , den.cod_uo                    dest_cod_uo
     , den.indirizzo_pec             dest_mail
  from levden den
     , levcom_dest com_d
 where den.codice_en      = com_d.cod_ente_dest
   and com_d.cod_com_dest is null
   and com_d.id_com       = a_id_rif
 order by 1
;

w_mitt_des_amm		varchar2(255);
w_mitt_cod_amm 		varchar2(255);
w_mitt_cod_aoo 		varchar2(255);
w_mitt_cod_uo 		varchar2(255);

w_dest_des_amm		varchar2(255);
w_dest_cod_amm 		varchar2(255);
w_dest_cod_aoo 		varchar2(255);
w_dest_cod_uo 		varchar2(255);
w_dest_mail		varchar2(255);

w_oggetto 		varchar2(2000);

w_ide_cod_amm		varchar2(255);
w_ide_cod_aoo		varchar2(255);
w_ide_flusso		varchar2(255);

w_cod_titolario		varchar2(255);
w_numero_fascicolo	varchar2(255);
w_anno_fascicolo	number;

w_filename 		varchar2(255);
w_tipo_documento	varchar2(255);

w_return 		varchar2(32767);

w_operazione_log	varchar2(255)	:= 'get_xml_lev';

w_errore		varchar2(4000);
errore			exception;

begin

--  docarea_pkg.INS_LOG(w_operazione_log, 'inizio');
  docarea_pkg.dati_cliente;

  begin
    select 'COMUNE DI '||com.descrizione,
           pec.cod_amm, pec.cod_aoo, pec.cod_uo
      into w_mitt_des_amm,
           w_mitt_cod_amm, w_mitt_cod_aoo, w_mitt_cod_uo
      from arccom com, arcpec pec
     where com.cod_provincia = pec.cod_provincia
       and com.cod_Comune    = pec.cod_Comune
       and pec.cod_provincia = w_cod_pro_cliente
       and pec.cod_comune    = w_cod_com_cliente
       and pec.flag_lev      = 'S'
       and rownum = 1
    ;
  exception
    when others then
	 w_mitt_des_amm := '';
         w_mitt_cod_amm := '';
         w_mitt_cod_aoo := '';
         w_mitt_cod_uo  := '';
  end;

  begin
    select p.oggetto||' - '||p.oggetto_info, p.nome_indice
      into w_oggetto, w_filename
      from gsdcom_prot p
     where p.archivio_rif = a_archivio_rif
       and p.id_rif       = a_id_rif
       and rownum = 1
    ;
  exception
    when others then
         w_oggetto        := a_archivio_rif;
         w_filename       := '';
  end;

  w_ide_cod_amm := w_mitt_cod_amm;
  w_ide_cod_aoo := w_mitt_cod_aoo;
  w_ide_flusso  := 'U';

  w_return := docarea_pkg.GET_XML_JPROTOCOLLO_MITT(w_oggetto, w_ide_cod_amm, w_ide_cod_aoo, w_ide_flusso, w_mitt_des_amm, w_mitt_cod_amm, w_mitt_cod_aoo, w_mitt_cod_uo);

  for rec_d in sel_d loop
      w_dest_des_amm := rec_d.dest_des_amm;
      w_dest_cod_amm := rec_d.dest_cod_amm;
      w_dest_cod_aoo := rec_d.dest_cod_aoo;
      w_dest_cod_uo  := rec_d.dest_cod_uo;
      w_dest_mail    := rec_d.dest_mail;
      w_return := w_return||docarea_pkg.GET_XML_JPROTOCOLLO_DEST(w_dest_des_amm, w_dest_cod_amm, w_dest_cod_aoo, w_dest_cod_uo, w_dest_mail);
  end loop;

  begin
    select p.classificazione, p.tipo_documento, p.numero_fascicolo, p.anno_fascicolo
      into w_cod_titolario, w_tipo_documento, w_numero_fascicolo, w_anno_fascicolo
      from parametri_protocollo p
         , gsdcom_par gp
     where p.fase          = gp.fase
       and p.funzione      = gp.funzione
       and gp.archivio_rif = a_archivio_rif
       and gp.id_rif       = a_id_rif
       and rownum     = 1
    ;
  exception
    when others then
         w_cod_titolario    := '';
         w_tipo_documento   := '';
         w_numero_fascicolo := '';
         w_anno_fascicolo   := '';
  end;

  w_return := w_return||docarea_pkg.GET_XML_JPROTOCOLLO_FILE(w_mitt_cod_amm, w_mitt_cod_aoo, w_mitt_cod_uo, w_cod_titolario, w_numero_fascicolo, w_anno_fascicolo, w_filename, w_tipo_documento,a_terminalista);

  return w_return;

exception
  when errore then
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
  when others then
       w_errore	:= 'errore ('||sqlerrm||')';
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
end GET_XML_JPROTOCOLLO_LEV;

function GET_XML_JPROTOCOLLO_ELE
(a_archivio_rif		varchar2
,a_id_rif		number
,a_terminalista		varchar2	default null
)

return varchar2

is

cursor sel_d is
select com_d.id
     , 'COMUNE DI '||com.descrizione dest_des_amm
     , pec.cod_amm                   dest_cod_amm
     , pec.cod_aoo                   dest_cod_aoo
     , pec.cod_uo                    dest_cod_uo
     , pec.indirizzo_mail            dest_mail
     , to_char(null)                 dest_persona_id
     , to_char(null)                 dest_persona_cognome
     , to_char(null)                 dest_persona_nome
  from arccom com
     , arcpec pec
     , elecom_dest com_d
 where com.cod_provincia = pec.cod_provincia
   and com.cod_Comune    = pec.cod_Comune
   and pec.flag_ele      = 'S'
   and pec.cod_provincia = com_d.cod_pro_dest
   and pec.cod_comune    = com_d.cod_Com_dest
   and com_d.id_com      = a_id_rif
UNION
select com_d.id
     , translate(ana.cognome_nome,'/',' ') dest_des_amm
     , to_char(null)                       dest_cod_amm
     , to_char(null)                       dest_cod_aoo
     , to_char(null)                       dest_cod_uo
     , ari.indirizzo_rec                   dest_mail
     , ana.cod_fiscale                     dest_persona_id
     , f_cognome(ana.cognome_nome)         dest_persona_cognome
     , f_nome(ana.cognome_nome)            dest_persona_nome
  from anadtr dtr
     , anaari ari
     , anaana ana
     , elecom_dest com_d
 where dtr.tipo_comunicazione = 'E'
   and dtr.descrizione        like '%PEC%'
   and dtr.cod_tr             = ari.tipo_recapito
   and ari.matricola          = com_d.matricola_dest
   and ana.matricola          = com_d.matricola_dest
   and com_d.id_com           = a_id_rif
   and rownum = 1
UNION
select com_d.id
     , den.descrizione 	             dest_des_amm
     , den.cod_amm                   dest_cod_amm
     , den.cod_aoo                   dest_cod_aoo
     , den.cod_uo                    dest_cod_uo
     , den.indirizzo_pec             dest_mail
     , to_char(null)                 dest_persona_id
     , to_char(null)                 dest_persona_cognome
     , to_char(null)                 dest_persona_nome
  from eleden den
     , elecom_dest com_d
 where den.codice_en      = com_d.cod_ente_dest
   and com_d.cod_com_dest is null
   and com_d.id_com       = a_id_rif
 order by 1
;

w_mitt_des_amm		varchar2(255);
w_mitt_cod_amm 		varchar2(255);
w_mitt_cod_aoo 		varchar2(255);
w_mitt_cod_uo 		varchar2(255);

w_dest_des_amm		varchar2(255);
w_dest_cod_amm 		varchar2(255);
w_dest_cod_aoo 		varchar2(255);
w_dest_cod_uo 		varchar2(255);
w_dest_mail		varchar2(255);

w_dest_persona_id	varchar2(255);
w_dest_persona_cognome	varchar2(255);
w_dest_persona_nome	varchar2(255);

w_oggetto 		varchar2(2000);

w_ide_cod_amm		varchar2(255);
w_ide_cod_aoo		varchar2(255);
w_ide_flusso		varchar2(255);

w_cod_titolario		varchar2(255);
w_numero_fascicolo	varchar2(255);
w_anno_fascicolo	number;

w_filename 		varchar2(255);
w_tipo_documento	varchar2(255);

w_return 		varchar2(32767);

w_operazione_log	varchar2(255)	:= 'get_xml_ele';

w_errore		varchar2(4000);
errore			exception;

begin

--  docarea_pkg.INS_LOG(w_operazione_log, 'inizio');
  docarea_pkg.dati_cliente;

  begin
    select 'COMUNE DI '||com.descrizione,
           pec.cod_amm, pec.cod_aoo, pec.cod_uo
      into w_mitt_des_amm,
           w_mitt_cod_amm, w_mitt_cod_aoo, w_mitt_cod_uo
      from arccom com, arcpec pec
     where com.cod_provincia = pec.cod_provincia
       and com.cod_Comune    = pec.cod_Comune
       and pec.cod_provincia = w_cod_pro_cliente
       and pec.cod_comune    = w_cod_com_cliente
       and pec.flag_ele      = 'S'
       and rownum = 1
    ;
  exception
    when others then
	 w_mitt_des_amm := '';
         w_mitt_cod_amm := '';
         w_mitt_cod_aoo := '';
         w_mitt_cod_uo  := '';
  end;

  begin
    select p.oggetto||' - '||p.oggetto_info, p.nome_indice
      into w_oggetto, w_filename
      from gsdcom_prot p
     where p.archivio_rif = a_archivio_rif
       and p.id_rif       = a_id_rif
       and rownum = 1
    ;
  exception
    when others then
         w_oggetto        := a_archivio_rif;
         w_filename       := '';
  end;

  w_ide_cod_amm := w_mitt_cod_amm;
  w_ide_cod_aoo := w_mitt_cod_aoo;
  w_ide_flusso  := 'U';

  w_return := docarea_pkg.GET_XML_JPROTOCOLLO_MITT(w_oggetto, w_ide_cod_amm, w_ide_cod_aoo, w_ide_flusso, w_mitt_des_amm, w_mitt_cod_amm, w_mitt_cod_aoo, w_mitt_cod_uo);

  for rec_d in sel_d loop
      w_dest_des_amm         := rec_d.dest_des_amm;
      w_dest_cod_amm         := rec_d.dest_cod_amm;
      w_dest_cod_aoo         := rec_d.dest_cod_aoo;
      w_dest_cod_uo          := rec_d.dest_cod_uo;
      w_dest_mail            := rec_d.dest_mail;
      w_dest_persona_id      := rec_d.dest_persona_id;
      w_dest_persona_cognome := rec_d.dest_persona_cognome;
      w_dest_persona_nome    := rec_d.dest_persona_nome;
      w_return := w_return||docarea_pkg.GET_XML_JPROTOCOLLO_DEST(w_dest_des_amm, w_dest_cod_amm, w_dest_cod_aoo, w_dest_cod_uo, w_dest_mail,
                                                                 w_dest_persona_id, w_dest_persona_cognome, w_dest_persona_nome);
  end loop;

  begin
    select p.classificazione, p.tipo_documento, p.numero_fascicolo, p.anno_fascicolo
      into w_cod_titolario, w_tipo_documento, w_numero_fascicolo, w_anno_fascicolo
      from parametri_protocollo p
         , gsdcom_par gp
     where p.fase          = gp.fase
       and p.funzione      = gp.funzione
       and gp.archivio_rif = a_archivio_rif
       and gp.id_rif       = a_id_rif
       and rownum     = 1
    ;
  exception
    when others then
         w_cod_titolario    := '';
         w_tipo_documento   := '';
         w_numero_fascicolo := '';
         w_anno_fascicolo   := '';
  end;

  w_return := w_return||docarea_pkg.GET_XML_JPROTOCOLLO_FILE(w_mitt_cod_amm, w_mitt_cod_aoo, w_mitt_cod_uo, w_cod_titolario, w_numero_fascicolo, w_anno_fascicolo, w_filename, w_tipo_documento,a_terminalista);

  return w_return;

exception
  when errore then
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
  when others then
       w_errore	:= 'errore ('||sqlerrm||')';
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
end GET_XML_JPROTOCOLLO_ELE;

function GET_XML_JPROTOCOLLO_X34D
(a_anno_revisione		number
,a_revisione			varchar2
,a_progr_revisione		number
,a_cod_pro_dest			number
,a_cod_com_dest			number
)

return varchar2

is

w_mitt_des_amm		varchar2(255);
w_mitt_cod_amm 		varchar2(255);
w_mitt_cod_aoo 		varchar2(255);
w_mitt_cod_uo 		varchar2(255);

w_dest_des_amm		varchar2(255);
w_dest_cod_amm 		varchar2(255);
w_dest_cod_aoo 		varchar2(255);
w_dest_cod_uo 		varchar2(255);
w_dest_mail		varchar2(255);

w_oggetto 		varchar2(2000);

w_ide_cod_amm		varchar2(255);
w_ide_cod_aoo		varchar2(255);
w_ide_flusso		varchar2(255);

w_cod_titolario		varchar2(255);
w_numero_fascicolo	varchar2(255);
w_anno_fascicolo	number;

w_filename 		varchar2(255);
w_tipo_documento	varchar2(255);

w_operazione_log	varchar2(255)	:= 'get_xml_x34d';
w_errore		varchar2(4000);

w_return 		varchar2(32767);

begin

--  docarea_pkg.INS_LOG(w_operazione_log, 'inizio');
  docarea_pkg.dati_cliente;

  begin
    select 'COMUNE DI '||com.descrizione,
           pec.cod_amm, pec.cod_aoo, pec.cod_uo
      into w_mitt_des_amm,
           w_mitt_cod_amm, w_mitt_cod_aoo, w_mitt_cod_uo
      from arccom com, arcpec pec
     where com.cod_provincia = pec.cod_provincia
       and com.cod_Comune    = pec.cod_Comune
       and pec.cod_provincia = w_cod_pro_cliente
       and pec.cod_comune    = w_cod_com_cliente
       and pec.flag_ele      = 'S'
       and rownum = 1
    ;
  exception
    when others then
	 w_mitt_des_amm := '';
         w_mitt_cod_amm := '';
         w_mitt_cod_aoo := '';
         w_mitt_cod_uo  := '';
  end;

  begin
    select 'COMUNE DI '||com.descrizione,
           pec.cod_amm, pec.cod_aoo, pec.cod_uo,
           pec.indirizzo_mail
      into w_dest_des_amm,
           w_dest_cod_amm, w_dest_cod_aoo, w_dest_cod_uo,
           w_dest_mail
      from arccom com, arcpec pec
     where com.cod_provincia = pec.cod_provincia
       and com.cod_Comune    = pec.cod_Comune
       and pec.cod_provincia = a_cod_pro_dest
       and pec.cod_comune    = a_cod_Com_dest
       and pec.flag_ele      = 'S'
       and rownum = 1
    ;
  exception
    when others then
	 w_dest_des_amm := '';
         w_dest_cod_amm := '';
         w_dest_cod_aoo := '';
         w_dest_cod_uo  := '';
         w_dest_mail    := '';
  end;

  w_oggetto     := 'TRASMISSIONE MOD.3-4/D ELETTRONICO';

  w_ide_cod_amm := w_mitt_cod_amm;
  w_ide_cod_aoo := w_mitt_cod_aoo;
  w_ide_flusso  := 'U';

  begin
    select p.classificazione, p.tipo_documento, p.numero_fascicolo, p.anno_fascicolo
      into w_cod_titolario, w_tipo_documento, w_numero_fascicolo, w_anno_fascicolo
      from parametri_protocollo p
     where p.fase     = 'X34D'
       and p.funzione = 'X34D'
       and rownum     = 1
    ;
  exception
    when others then
         w_cod_titolario    := '';
         w_tipo_documento   := '';
         w_numero_fascicolo := '';
         w_anno_fascicolo   := '';
  end;

  begin
    select d.nome_indice
      into w_filename
      from ele34d d
     where d.anno            = a_anno_revisione
       and d.revisione       = a_revisione
       and d.progr_revisione = a_progr_revisione
       and d.cod_pro_dest    = a_cod_pro_dest
       and d.cod_com_dest     = a_cod_Com_dest
       and rownum = 1
    ;
  exception
    when others then
         w_filename       := '';
  end;

  w_return := docarea_pkg.GET_XML_JPROTOCOLLO(w_mitt_des_amm, w_mitt_cod_amm, w_mitt_cod_aoo, w_mitt_cod_uo, w_dest_des_amm, w_dest_cod_amm, w_dest_cod_aoo, w_dest_cod_uo, w_dest_mail, w_oggetto, w_ide_cod_amm, w_ide_cod_aoo, w_ide_flusso, w_cod_titolario, w_numero_fascicolo, w_anno_fascicolo, w_filename, w_tipo_documento);

  return w_return;

exception
  when others then
       w_errore	:= 'errore ('||sqlerrm||')';
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
end GET_XML_JPROTOCOLLO_X34D;

function  GET_XML_JPROTOCOLLO_MITT
(a_oggetto 		varchar2
,a_ide_cod_amm 		varchar2
,a_ide_cod_aoo 		varchar2
,a_ide_flusso 		varchar2
,a_mitt_des_amm 	varchar2
,a_mitt_cod_amm 	varchar2
,a_mitt_cod_aoo 	varchar2
,a_mitt_cod_uo 		varchar2
)

return varchar2

IS

w_docarea_ws		varchar2(255) := rtrim(f_valore_inp('DOCAREA_WS',1,4,'X','S'));
w_ducd_mail_s_inp       varchar2(1)   := f_valore_inp('DUCD_MAILS',1,1,'X','S');

w_mitt_des_amm		varchar2(255);
w_mitt_cod_amm 		varchar2(255);
w_mitt_cod_aoo 		varchar2(255);
w_mitt_cod_uo 		varchar2(255);

w_dest_des_amm		varchar2(255);
w_dest_cod_amm 		varchar2(255);
w_dest_cod_aoo 		varchar2(255);
w_dest_cod_uo 		varchar2(255);
w_dest_mail		varchar2(255);

w_oggetto 		varchar2(2000);

w_ide_cod_amm		varchar2(255);
w_ide_cod_aoo		varchar2(255);
w_ide_flusso		varchar2(255);

w_cod_titolario		varchar2(255);
w_numero_fascicolo	varchar2(255);
w_anno_fascicolo	number;

w_filename 		varchar2(255);
w_tipo_documento	varchar2(255);

w_operazione_log	varchar2(255)	:= 'get_xml_mitt';
w_errore		varchar2(4000);

errore			exception;

w_return 		varchar2(32767);

begin

  w_mitt_des_amm     := a_mitt_des_amm;
  w_mitt_cod_amm     := a_mitt_cod_amm;
  w_mitt_cod_aoo     := a_mitt_cod_aoo;
  w_mitt_cod_uo      := a_mitt_cod_uo;
  w_oggetto          := a_oggetto;
  w_ide_cod_amm      := a_ide_cod_amm;
  w_ide_cod_aoo      := a_ide_cod_aoo;
  w_ide_flusso       := a_ide_flusso;

/*
  if nvl(w_docarea_ws,' ') = 'TEST' then -- su http://test-agspr-as02/JProtocolloDocArea/ (gsd-win-forms11 - gallesPAL)
     w_mitt_des_amm := 'Ente di Test - GSD-WIN-FORMS11';
     w_mitt_cod_amm := 'H827';
     w_mitt_cod_aoo := 'H827';
     w_mitt_cod_uo  := 'A04.01.04';
     w_dest_mail    := 'a.monopoli@ads.it';
  end if;
  if nvl(w_docarea_ws,' ') = 'TEST' then -- su http://test-consags/JProtocolloDocArea/	 (tst-tr-fin-f11 - tst-tr-fin-db)
     w_mitt_des_amm := 'Ente di Test - TST-TR-FIN';
     w_mitt_cod_amm := 'A00_PROVPC';
     w_mitt_cod_aoo := 'A00_PROVPC';
     w_mitt_cod_uo  := 'U_CONT';
     w_dest_mail    := 'a.monopoli@ads.it';
  end if;
*/
  if nvl(w_docarea_ws,' ') = 'TEST' then
     w_mitt_des_amm := 'Ente di Test';
     w_mitt_cod_amm := rtrim(f_valore_inp('DOCAREA_AM',1,100,'X',''));
     w_mitt_cod_aoo := rtrim(f_valore_inp('DOCAREA_AO',1,100,'X',''));
     w_mitt_cod_uo  := rtrim(f_valore_inp('DOCAREA_UO',1,100,'X',''));
     w_dest_mail    := nvl(rtrim(f_valore_inp('DOCAREA_EM',1,100,'X','')),'destinatario@mail.it');
  end if;

  w_return := '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'||
              '<Segnatura>'||
              ' <Intestazione>'||
              '   <Oggetto>'||w_oggetto||'</Oggetto>'||
              '   <Identificatore>'||
              '     <CodiceAmministrazione>'||w_ide_cod_amm||'</CodiceAmministrazione>'||
              '     <CodiceAOO>'||w_ide_cod_aoo||'</CodiceAOO>'||
              '     <Flusso>'||w_ide_flusso||'</Flusso>'||
              '   </Identificatore>'||
              '   <Mittente >'||
              '     <Amministrazione>'||
              '       <Denominazione>'||w_mitt_des_amm||'</Denominazione>'||
              '       <CodiceAmministrazione>'||w_mitt_cod_amm||'</CodiceAmministrazione>';

  if nvl(w_ducd_mail_s_inp,'N') = 'S' and w_mitt_cod_uo is not null then
     w_return := w_return||
              '       <UnitaOrganizzativa id="'||w_mitt_cod_uo||'"></UnitaOrganizzativa>';
  end if;

  w_return := w_return||
              '     </Amministrazione>'||
              '   </Mittente>';

  return w_return;

exception
  when others then
       w_errore	:= 'errore ('||sqlerrm||')';
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
end GET_XML_JPROTOCOLLO_MITT;

function  GET_XML_JPROTOCOLLO_DEST
(a_dest_des_amm 	varchar2
,a_dest_cod_amm 	varchar2
,a_dest_cod_aoo 	varchar2
,a_dest_cod_uo 		varchar2
,a_dest_mail 		varchar2
,a_dest_persona_id	varchar2	default NULL
,a_dest_persona_cognome	varchar2	default NULL
,a_dest_persona_nome	varchar2	default NULL
)

return varchar2

IS

w_docarea_ws		varchar2(255) := rtrim(f_valore_inp('DOCAREA_WS',1,4,'X','S'));

w_dest_des_amm		varchar2(255);
w_dest_cod_amm 		varchar2(255);
w_dest_cod_aoo 		varchar2(255);
w_dest_cod_uo 		varchar2(255);
w_dest_mail		varchar2(255);

w_dest_persona_id	varchar2(255);
w_dest_persona_cognome	varchar2(255);
w_dest_persona_nome	varchar2(255);

w_operazione_log	varchar2(255)	:= 'get_xml_dest';
w_errore		varchar2(4000);

errore			exception;

w_return 		varchar2(32767);

begin

  w_dest_des_amm     := a_dest_des_amm;
  w_dest_cod_amm     := a_dest_cod_amm;
  w_dest_cod_aoo     := a_dest_cod_aoo;
  w_dest_cod_uo      := a_dest_cod_uo;
  w_dest_mail        := a_dest_mail;

  w_dest_persona_id      := a_dest_persona_id;
  w_dest_persona_cognome := a_dest_persona_cognome;
  w_dest_persona_nome    := a_dest_persona_nome;

  if nvl(w_docarea_ws,' ') = 'TEST' then
     w_dest_mail    := nvl(rtrim(f_valore_inp('DOCAREA_EM',1,100,'X','')),'destinatario@mail.it');
  end if;

  w_return := '   <Destinatario>';
  if w_dest_persona_id is not null then
     w_return := w_return||
              '     <Persona id="'||w_dest_persona_id||'">'||
              '       <Nome>'||w_dest_persona_nome||'</Nome>'||
              '       <Cognome>'||w_dest_persona_cognome||'</Cognome>'||
              '       <IndirizzoTelematico tipo="smtp">'||w_dest_mail||'</IndirizzoTelematico>'||
              '     </Persona>';
  else
     w_return := w_return||
              '     <Amministrazione>'||
              '       <Denominazione>'||w_dest_des_amm||'</Denominazione>'||
              '       <CodiceAmministrazione>'||w_dest_cod_amm||'</CodiceAmministrazione>'||
              '       <IndirizzoTelematico tipo="smtp">'||w_dest_mail||'</IndirizzoTelematico>';
     if w_dest_cod_uo is not null then
        w_return := w_return||
              '       <UnitaOrganizzativa id="'||w_dest_cod_uo||'"></UnitaOrganizzativa>';
     end if;

  w_return := w_return||
              '     </Amministrazione>';
  end if;

  w_return := w_return||
              '     <AOO>'||
              '       <CodiceAOO>'||w_dest_cod_aoo||'</CodiceAOO>'||
              '     </AOO>';

  w_return := w_return||
              '   </Destinatario>';

  return w_return;

exception
  when others then
       w_errore	:= 'errore ('||sqlerrm||')';
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
end GET_XML_JPROTOCOLLO_DEST;

function  GET_XML_JPROTOCOLLO_FILE
(a_mitt_cod_amm 	varchar2
,a_mitt_cod_aoo 	varchar2
,a_mitt_cod_uo 		varchar2
,a_cod_titolario 	varchar2
,a_numero_fascicolo 	varchar2
,a_anno_fascicolo 	number
,a_filename 		varchar2
,a_tipo_documento 	varchar2
,a_terminalista 	varchar2
)

return varchar2

IS

w_docarea_ws		varchar2(255) := rtrim(f_valore_inp('DOCAREA_WS',1,4,'X','S'));
w_docarea_ut		varchar2(255) := nvl(rtrim(f_valore_inp('DOCAREA_UT',1,1,'X','S')),'N');

w_mitt_cod_amm 		varchar2(255);
w_mitt_cod_aoo 		varchar2(255);
w_mitt_cod_uo 		varchar2(255);

w_cod_titolario		varchar2(255);
w_numero_fascicolo	varchar2(255);
w_anno_fascicolo	number;
w_terminalista		varchar2(255) := a_terminalista;
w_nome_terminalista	varchar2(255);

w_filename 		varchar2(255);
w_tipo_documento	varchar2(255);

w_operazione_log	varchar2(255)	:= 'get_xml';
w_errore		varchar2(4000);

errore			exception;

w_return 		varchar2(32767);

begin

  w_mitt_cod_amm     := a_mitt_cod_amm;
  w_mitt_cod_aoo     := a_mitt_cod_aoo;
  w_mitt_cod_uo      := a_mitt_cod_uo;

  w_cod_titolario    := a_cod_titolario;
  w_numero_fascicolo := a_numero_fascicolo;
  w_anno_fascicolo   := a_anno_fascicolo;
  w_filename         := a_filename;
  w_tipo_documento   := a_tipo_documento;

/*
  if nvl(w_docarea_ws,' ') = 'TEST' then -- su http://test-agspr-as02/JProtocolloDocArea/ (gsd-win-forms11 - gallesPAL)
     w_mitt_cod_amm := 'H827';
     w_mitt_cod_aoo := 'H827';
     w_mitt_cod_uo  := 'A04.01.04';
  end if;
  if nvl(w_docarea_ws,' ') = 'TEST' then -- su http://test-consags/JProtocolloDocArea/	 (tst-tr-fin-f11 - tst-tr-fin-db)
     w_mitt_cod_amm := 'A00_PROVPC';
     w_mitt_cod_aoo := 'A00_PROVPC';
     w_mitt_cod_uo  := 'U_CONT';
  end if;
*/

  if nvl(w_docarea_ws,' ') = 'TEST' then
     w_mitt_cod_amm      := upper(f_valore_inp('DOCAREA_AM',1,100,'X',''));
     w_mitt_cod_aoo      := upper(f_valore_inp('DOCAREA_AO',1,100,'X',''));
     w_mitt_cod_uo       := upper(f_valore_inp('DOCAREA_UO',1,100,'X',''));
     w_nome_terminalista := 'BRENA01';
  else
     begin
       select nominativo
         into w_nome_terminalista
         from ad4_utenti
        where utente = w_terminalista
          and rownum = 1
       ;
     exception
       when others then
            w_nome_terminalista := '';
     end;
  end if;

  w_return := '   <Classifica>'||
              '     <CodiceAmministrazione>'||w_mitt_cod_amm||'</CodiceAmministrazione>'||
              '     <CodiceAOO>'||w_mitt_cod_aoo||'</CodiceAOO>'||
              '     <CodiceTitolario>'||w_cod_titolario||'</CodiceTitolario>'||
              '   </Classifica>';

  if w_numero_fascicolo is not null and w_anno_fascicolo is not null then
     w_return := w_return||
              '   <Fascicolo numero="'||w_numero_fascicolo||'" anno="'||w_anno_fascicolo||'"></Fascicolo>';
  end if;

  w_return := w_return||
              ' </Intestazione>'||
              ' <Descrizione>'||
              '   <Documento nome="'||w_filename||'" id="ID_DOCUMENTO_CALCOLATO">';

  if w_tipo_documento is not null then
     w_return := w_return||
              '     <TipoDocumento>'||w_tipo_documento||'</TipoDocumento>';
  end if;

  w_return := w_return||
              '   </Documento>'||
              '   <Allegati/>'||
              ' </Descrizione>'||
              ' <ApplicativoProtocollo nome="AGSPR">'||
              '   <Parametro valore="'||w_mitt_cod_uo||'" nome="uo"/>'||
              '   <Parametro valore="COMPETENZA" nome="tipoSmistamento"/>';

  if w_docarea_ut = 'S' and w_nome_terminalista is not null then
     w_return := w_return||
                 '   <Parametro valore="'||w_nome_terminalista||'" nome="utente"/>';
  end if;

  w_return := w_return||
              ' </ApplicativoProtocollo>'||
              '</Segnatura>';

  return w_return;

exception
  when others then
       w_errore	:= 'errore ('||sqlerrm||')';
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
end GET_XML_JPROTOCOLLO_FILE;

function INVIA_MAIL
(a_archivio_rif		varchar2
,a_id_rif		number
,a_id_dest		number
)

return varchar2

IS

w_return		varchar2(32000);

w_operazione_log	varchar2(255) := 'invia_mail';

w_errore		varchar2(4000);
errore                  exception;

begin
  docarea_pkg.INS_LOG(w_operazione_log, 'inizio');

  if a_archivio_rif = 'CIVCOM' then
     w_return := docarea_pkg.INVIA_MAIL_CIV(a_archivio_rif,a_id_rif,a_id_dest);

  elsif a_archivio_rif = 'ANACOM' then
     w_return := docarea_pkg.INVIA_MAIL_ANA(a_archivio_rif,a_id_rif,a_id_dest);

  elsif a_archivio_rif = 'LEVCOM' then
     w_return := docarea_pkg.INVIA_MAIL_LEV(a_archivio_rif,a_id_rif,a_id_dest);

  elsif a_archivio_rif = 'ELECOM' then
     w_return := docarea_pkg.INVIA_MAIL_ELE(a_archivio_rif,a_id_rif,a_id_dest);

  else
     w_errore := 'archivio_rif non gestito: '||a_archivio_rif;
     raise errore;
  end if;

  return w_return;

exception
  when errore then
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
       return null;
  when others then
       w_errore := 'errore ('||sqlerrm||')';
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
       return null;
end INVIA_MAIL;

function INVIA_MAIL_CIV
(a_archivio_rif		varchar2
,a_id_rif		number
,a_id_dest		number
)

return varchar2

IS

cursor sel_d is
select com_d.id
     , 'COMUNE DI '||com.descrizione dest_des_amm
     , pec.cod_amm                   dest_cod_amm
     , pec.cod_aoo                   dest_cod_aoo
     , pec.cod_uo                    dest_cod_uo
     , pec.indirizzo_mail            dest_mail
  from arccom com
     , arcpec pec
     , civcom_dest com_d
 where com.cod_provincia  = pec.cod_provincia
   and com.cod_Comune     = pec.cod_Comune
   and pec.flag_civ       = 'S'
   and pec.cod_provincia  = com_d.cod_pro_dest
   and pec.cod_comune     = com_d.cod_Com_dest
   and com_d.id           = nvl(a_id_dest,com_d.id)
   and com_d.id_com       = a_id_rif
UNION
select com_d.id
     , den.descrizione 	             dest_des_amm
     , den.cod_amm                   dest_cod_amm
     , den.cod_aoo                   dest_cod_aoo
     , den.cod_uo                    dest_cod_uo
     , den.indirizzo_pec             dest_mail
  from civden den
     , civcom_dest com_d
 where den.codice_en      = com_d.cod_ente_dest
   and com_d.cod_com_dest is null
   and com_d.id_com       = a_id_rif
   and com_d.id           = nvl(a_id_dest,com_d.id)
 order by 1
;

w_docarea_ws            varchar2(255) := rtrim(f_valore_inp('DOCAREA_WS',1,4,'X','S'));

w_conta_dest            number;
w_stringa_dest          varchar2(4000);

w_indirizzo_mail	varchar2(255);
w_anno_prot             number;
w_numero_prot           number;

w_note_ws_mail		varchar2(4000);
w_flag_ws_mail		varchar2(1);

w_return		varchar2(32000);

w_operazione_log	varchar2(255) := 'invia_mail_civ';
w_errore		varchar2(4000);

begin
  docarea_pkg.INS_LOG(w_operazione_log, 'inizio', 'archivio_rif: '||a_archivio_rif||' - id_rif: '||a_id_rif||' - a_id_dest: '||a_id_dest);

  begin
    select com_p.anno_protocollo, com_p.numero_protocollo
      into w_anno_prot, w_numero_prot
      from civcom_prot com_p
     where id = a_id_rif
    ;
  exception
    when others then
         w_errore      := 'Errore in recupero anno / numero protocollo ('||sqlerrm||')';
         docarea_pkg.INS_LOG(w_operazione_log, w_errore);
         w_anno_prot   := '';
         w_numero_prot := '';
  end;

  w_conta_dest := 0;
  for rec in sel_d loop
      w_conta_dest     := w_conta_dest + 1;

      w_indirizzo_mail := rec.dest_mail;
      docarea_pkg.INS_LOG(w_operazione_log, 'indirizzo ('||w_conta_dest||') : '||w_indirizzo_mail);

      if nvl(w_docarea_ws,' ') = 'TEST' and mod(w_conta_dest,3) = 1 then
         w_indirizzo_mail := nvl(rtrim(f_valore_inp('DOCAREA_WS',11,100,'X','')),'a.monopoli@ads.it');
         docarea_pkg.INS_LOG(w_operazione_log, 'redirect: '||w_indirizzo_mail);
      elsif nvl(w_docarea_ws,' ') = 'TEST' and mod(w_conta_dest,3) = 2 then
         w_indirizzo_mail := 'a.monopoli@ads.it';
         docarea_pkg.INS_LOG(w_operazione_log, 'redirect: '||w_indirizzo_mail);
      elsif nvl(w_docarea_ws,' ') = 'TEST' and mod(w_conta_dest,3) = 0 then
         w_indirizzo_mail := 's.nocca@ads.it';
         docarea_pkg.INS_LOG(w_operazione_log, 'redirect: '||w_indirizzo_mail);
      elsif nvl(w_docarea_ws,' ') = 'TEST' then
         w_indirizzo_mail := 'a.monopoli@ymail.com';
         docarea_pkg.INS_LOG(w_operazione_log, 'redirect: '||w_indirizzo_mail);
      end if;

      if w_conta_dest = 1 then
         w_stringa_dest := w_indirizzo_mail;
      elsif w_conta_dest > 1 then
         w_stringa_dest := w_stringa_dest||'###'||w_indirizzo_mail;
      end if;
      docarea_pkg.INS_LOG(w_operazione_log, 'w_stringa_dest: '||w_stringa_dest);

  end loop;

  w_return         := docarea_pkg.INVIA_MAIL_PROT(w_stringa_dest, w_anno_prot, w_numero_prot);

  docarea_pkg.CTR_RESPONSE_MAIL(w_return, w_flag_ws_mail, w_note_ws_mail);

  begin
     update civcom_dest
        set flag_ws_mail      = w_flag_ws_mail,
            note_ws_mail      = w_note_ws_mail
      where id           = nvl(a_id_dest,id)
        and id_com       = a_id_rif
     ;
  exception
    when others then
         w_errore := 'errore in upd CIVCOM_DEST ('||SQLERRM||')';
         docarea_pkg.INS_LOG(w_operazione_log, w_errore);
  end;

  return w_flag_ws_mail;

exception
  when others then
       w_errore := 'errore ('||sqlerrm||')';
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
end INVIA_MAIL_CIV;

function INVIA_MAIL_ANA
(a_archivio_rif		varchar2
,a_id_rif		number
,a_id_dest		number
)

return varchar2

IS

cursor sel_d is
select com_d.id
     , 'COMUNE DI '||com.descrizione dest_des_amm
     , pec.cod_amm                   dest_cod_amm
     , pec.cod_aoo                   dest_cod_aoo
     , pec.cod_uo                    dest_cod_uo
     , pec.indirizzo_mail            dest_mail
  from arccom com
     , arcpec pec
     , anacom_dest com_d
 where com.cod_provincia  = pec.cod_provincia
   and com.cod_Comune     = pec.cod_Comune
   and pec.flag_ana       = 'S'
   and pec.cod_provincia  = com_d.cod_pro_dest
   and pec.cod_comune     = com_d.cod_Com_dest
   and com_d.id           = nvl(a_id_dest,com_d.id)
   and com_d.id_com       = a_id_rif
UNION
select com_d.id
     , dco.descrizione||' - '||con.sede dest_des_amm
     , con.cod_amm                  dest_cod_amm
     , con.cod_aoo                  dest_cod_aoo
     , con.cod_uo                   dest_cod_uo
     , con.indirizzo_pec            dest_mail
  from arcdco dco
     , arccon con
     , anacom_dest com_d
 where dco.tipo_consolato = con.tipo_consolato
   and con.cod_consolato  = com_d.cod_consolato_dest
   and con.tipo_consolato = com_d.tipo_consolato_dest
   and com_d.id           = nvl(a_id_dest,com_d.id)
   and com_d.id_com       = a_id_rif
UNION
select com_d.id
     , translate(ana.cognome_nome,'/',' ') dest_des_amm
     , to_char(null)                dest_cod_amm
     , to_char(null)                dest_cod_aoo
     , to_char(null)                dest_cod_uo
     , ari.indirizzo_rec            dest_mail
  from anadtr dtr
     , anaari ari
     , anaana ana
     , anacom_dest com_d
 where dtr.tipo_comunicazione = 'E'
   and dtr.descrizione        like '%PEC%'
   and dtr.cod_tr             = ari.tipo_recapito
   and ari.matricola          = com_d.matricola_dest
   and ana.matricola          = com_d.matricola_dest
   and com_d.id               = nvl(a_id_dest,com_d.id)
   and com_d.id_com           = a_id_rif
   and rownum = 1
UNION
select com_d.id
     , den.descrizione 	             dest_des_amm
     , den.cod_amm                   dest_cod_amm
     , den.cod_aoo                   dest_cod_aoo
     , den.cod_uo                    dest_cod_uo
     , den.indirizzo_pec             dest_mail
  from anaden den
     , anacom_dest com_d
 where den.cod_en         = com_d.cod_ente_dest
   and com_d.cod_com_dest||com_d.cod_consolato_dest||com_d.matricola_dest is null
   and com_d.id_com       = a_id_rif
   and com_d.id           = nvl(a_id_dest,com_d.id)
 order by 1
;

w_docarea_ws            varchar2(255) := rtrim(f_valore_inp('DOCAREA_WS',1,4,'X','S'));

w_conta_dest            number;
w_stringa_dest          varchar2(4000);

w_indirizzo_mail	varchar2(255);
w_anno_prot             number;
w_numero_prot           number;

w_note_ws_mail		varchar2(4000);
w_flag_ws_mail		varchar2(1);

w_return		varchar2(32000);

w_operazione_log	varchar2(255) := 'invia_mail_ana';
w_errore		varchar2(4000);

begin
  docarea_pkg.INS_LOG(w_operazione_log, 'inizio', 'archivio_rif: '||a_archivio_rif||' - id_rif: '||a_id_rif||' - a_id_dest: '||a_id_dest);

  begin
    select com_p.anno_protocollo, com_p.numero_protocollo
      into w_anno_prot, w_numero_prot
      from anacom_prot com_p
     where id = a_id_rif
    ;
  exception
    when others then
         w_errore      := 'Errore in recupero anno / numero protocollo ('||sqlerrm||')';
         docarea_pkg.INS_LOG(w_operazione_log, w_errore);
         w_anno_prot   := '';
         w_numero_prot := '';
  end;

  w_conta_dest := 0;
  for rec in sel_d loop
      w_conta_dest     := w_conta_dest + 1;

      w_indirizzo_mail := rec.dest_mail;
      docarea_pkg.INS_LOG(w_operazione_log, 'indirizzo ('||w_conta_dest||') : '||w_indirizzo_mail);

      if nvl(w_docarea_ws,' ') = 'TEST' and mod(w_conta_dest,3) = 1 then
         w_indirizzo_mail := nvl(rtrim(f_valore_inp('DOCAREA_WS',11,100,'X','')),'a.monopoli@ads.it');
         docarea_pkg.INS_LOG(w_operazione_log, 'redirect: '||w_indirizzo_mail);
      elsif nvl(w_docarea_ws,' ') = 'TEST' and mod(w_conta_dest,3) = 2 then
         w_indirizzo_mail := 'a.monopoli@ads.it';
         docarea_pkg.INS_LOG(w_operazione_log, 'redirect: '||w_indirizzo_mail);
      elsif nvl(w_docarea_ws,' ') = 'TEST' and mod(w_conta_dest,3) = 0 then
         w_indirizzo_mail := 's.nocca@ads.it';
         docarea_pkg.INS_LOG(w_operazione_log, 'redirect: '||w_indirizzo_mail);
      elsif nvl(w_docarea_ws,' ') = 'TEST' then
         w_indirizzo_mail := 'a.monopoli@ymail.com';
         docarea_pkg.INS_LOG(w_operazione_log, 'redirect: '||w_indirizzo_mail);
      end if;

      if w_conta_dest = 1 then
         w_stringa_dest := w_indirizzo_mail;
      elsif w_conta_dest > 1 then
         w_stringa_dest := w_stringa_dest||'###'||w_indirizzo_mail;
      end if;
      docarea_pkg.INS_LOG(w_operazione_log, 'w_stringa_dest: '||w_stringa_dest);

  end loop;

  w_return         := docarea_pkg.INVIA_MAIL_PROT(w_stringa_dest, w_anno_prot, w_numero_prot);

  docarea_pkg.CTR_RESPONSE_MAIL(w_return, w_flag_ws_mail, w_note_ws_mail);

  begin
     update anacom_dest
        set flag_ws_mail      = w_flag_ws_mail,
            note_ws_mail      = w_note_ws_mail
      where id           = nvl(a_id_dest,id)
        and id_com       = a_id_rif
     ;
  exception
    when others then
         w_errore := 'errore in upd ANACOM_DEST ('||SQLERRM||')';
         docarea_pkg.INS_LOG(w_operazione_log, w_errore);
  end;

  return w_flag_ws_mail;

exception
  when others then
       w_errore := 'errore ('||sqlerrm||')';
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
end INVIA_MAIL_ANA;

function INVIA_MAIL_LEV
(a_archivio_rif		varchar2
,a_id_rif		number
,a_id_dest		number
)

return varchar2

IS

cursor sel_d is
select com_d.id
     , 'COMUNE DI '||com.descrizione dest_des_amm
     , pec.cod_amm                   dest_cod_amm
     , pec.cod_aoo                   dest_cod_aoo
     , pec.cod_uo                    dest_cod_uo
     , pec.indirizzo_mail            dest_mail
  from arccom com
     , arcpec pec
     , levcom_dest com_d
 where com.cod_provincia  = pec.cod_provincia
   and com.cod_Comune     = pec.cod_Comune
   and pec.flag_lev       = 'S'
   and pec.cod_provincia  = com_d.cod_pro_dest
   and pec.cod_comune     = com_d.cod_Com_dest
   and com_d.id           = nvl(a_id_dest,com_d.id)
   and com_d.id_com       = a_id_rif
UNION
select com_d.id
     , den.descrizione 	             dest_des_amm
     , den.cod_amm                   dest_cod_amm
     , den.cod_aoo                   dest_cod_aoo
     , den.cod_uo                    dest_cod_uo
     , den.indirizzo_pec             dest_mail
  from levden den
     , levcom_dest com_d
 where den.codice_en      = com_d.cod_ente_dest
   and com_d.cod_com_dest is null
   and com_d.id_com       = a_id_rif
   and com_d.id           = nvl(a_id_dest,com_d.id)
 order by 1
;

w_docarea_ws            varchar2(255) := rtrim(f_valore_inp('DOCAREA_WS',1,4,'X','S'));

w_conta_dest            number;
w_stringa_dest          varchar2(4000);

w_indirizzo_mail	varchar2(255);
w_anno_prot             number;
w_numero_prot           number;

w_note_ws_mail		varchar2(4000);
w_flag_ws_mail		varchar2(1);

w_return		varchar2(32000);

w_operazione_log	varchar2(255) := 'invia_mail_lev';
w_errore		varchar2(4000);

begin
  docarea_pkg.INS_LOG(w_operazione_log, 'inizio', 'archivio_rif: '||a_archivio_rif||' - id_rif: '||a_id_rif||' - a_id_dest: '||a_id_dest);

  begin
    select com_p.anno_protocollo, com_p.numero_protocollo
      into w_anno_prot, w_numero_prot
      from levcom_prot com_p
     where id = a_id_rif
    ;
  exception
    when others then
         w_errore      := 'Errore in recupero anno / numero protocollo ('||sqlerrm||')';
         docarea_pkg.INS_LOG(w_operazione_log, w_errore);
         w_anno_prot   := '';
         w_numero_prot := '';
  end;

  w_conta_dest := 0;
  for rec in sel_d loop
      w_conta_dest     := w_conta_dest + 1;

      w_indirizzo_mail := rec.dest_mail;
      docarea_pkg.INS_LOG(w_operazione_log, 'indirizzo ('||w_conta_dest||') : '||w_indirizzo_mail);

      if nvl(w_docarea_ws,' ') = 'TEST' and mod(w_conta_dest,3) = 1 then
         w_indirizzo_mail := nvl(rtrim(f_valore_inp('DOCAREA_WS',11,100,'X','')),'a.monopoli@ads.it');
         docarea_pkg.INS_LOG(w_operazione_log, 'redirect: '||w_indirizzo_mail);
      elsif nvl(w_docarea_ws,' ') = 'TEST' and mod(w_conta_dest,3) = 2 then
         w_indirizzo_mail := 'a.monopoli@ads.it';
         docarea_pkg.INS_LOG(w_operazione_log, 'redirect: '||w_indirizzo_mail);
      elsif nvl(w_docarea_ws,' ') = 'TEST' and mod(w_conta_dest,3) = 0 then
         w_indirizzo_mail := 's.nocca@ads.it';
         docarea_pkg.INS_LOG(w_operazione_log, 'redirect: '||w_indirizzo_mail);
      elsif nvl(w_docarea_ws,' ') = 'TEST' then
         w_indirizzo_mail := 'a.monopoli@ymail.com';
         docarea_pkg.INS_LOG(w_operazione_log, 'redirect: '||w_indirizzo_mail);
      end if;

      if w_conta_dest = 1 then
         w_stringa_dest := w_indirizzo_mail;
      elsif w_conta_dest > 1 then
         w_stringa_dest := w_stringa_dest||'###'||w_indirizzo_mail;
      end if;
      docarea_pkg.INS_LOG(w_operazione_log, 'w_stringa_dest: '||w_stringa_dest);

  end loop;

  w_return         := docarea_pkg.INVIA_MAIL_PROT(w_stringa_dest, w_anno_prot, w_numero_prot);

  docarea_pkg.CTR_RESPONSE_MAIL(w_return, w_flag_ws_mail, w_note_ws_mail);

  begin
     update levcom_dest
        set flag_ws_mail      = w_flag_ws_mail,
            note_ws_mail      = w_note_ws_mail
      where id           = nvl(a_id_dest,id)
        and id_com       = a_id_rif
     ;
  exception
    when others then
         w_errore := 'errore in upd LEVCOM_DEST ('||SQLERRM||')';
         docarea_pkg.INS_LOG(w_operazione_log, w_errore);
  end;

  return w_flag_ws_mail;

exception
  when others then
       w_errore := 'errore ('||sqlerrm||')';
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
end INVIA_MAIL_LEV;

function INVIA_MAIL_ELE
(a_archivio_rif		varchar2
,a_id_rif		number
,a_id_dest		number
)

return varchar2

IS

cursor sel_d is
select com_d.id
     , 'COMUNE DI '||com.descrizione dest_des_amm
     , pec.cod_amm                   dest_cod_amm
     , pec.cod_aoo                   dest_cod_aoo
     , pec.cod_uo                    dest_cod_uo
     , pec.indirizzo_mail            dest_mail
  from arccom com
     , arcpec pec
     , elecom_dest com_d
 where com.cod_provincia  = pec.cod_provincia
   and com.cod_Comune     = pec.cod_Comune
   and pec.flag_ele       = 'S'
   and pec.cod_provincia  = com_d.cod_pro_dest
   and pec.cod_comune     = com_d.cod_Com_dest
   and com_d.id           = nvl(a_id_dest,com_d.id)
   and com_d.id_com       = a_id_rif
UNION
select com_d.id
     , translate(ana.cognome_nome,'/',' ') dest_des_amm
     , to_char(null)                dest_cod_amm
     , to_char(null)                dest_cod_aoo
     , to_char(null)                dest_cod_uo
     , ari.indirizzo_rec            dest_mail
  from anadtr dtr
     , anaari ari
     , anaana ana
     , elecom_dest com_d
 where dtr.tipo_comunicazione = 'E'
   and dtr.descrizione        like '%PEC%'
   and dtr.cod_tr             = ari.tipo_recapito
   and ari.matricola          = com_d.matricola_dest
   and ana.matricola          = com_d.matricola_dest
   and com_d.id               = nvl(a_id_dest,com_d.id)
   and com_d.id_com           = a_id_rif
   and rownum = 1
UNION
select com_d.id
     , den.descrizione 	             dest_des_amm
     , den.cod_amm                   dest_cod_amm
     , den.cod_aoo                   dest_cod_aoo
     , den.cod_uo                    dest_cod_uo
     , den.indirizzo_pec             dest_mail
  from eleden den
     , elecom_dest com_d
 where den.codice_en      = com_d.cod_ente_dest
   and com_d.cod_com_dest is null
   and com_d.id_com       = a_id_rif
   and com_d.id           = nvl(a_id_dest,com_d.id)
 order by 1
;

w_docarea_ws            varchar2(255) := rtrim(f_valore_inp('DOCAREA_WS',1,4,'X','S'));

w_conta_dest            number;
w_stringa_dest          varchar2(4000);

w_indirizzo_mail	varchar2(255);
w_anno_prot             number;
w_numero_prot           number;

w_note_ws_mail		varchar2(4000);
w_flag_ws_mail		varchar2(1);

w_return		varchar2(32000);

w_operazione_log	varchar2(255) := 'invia_mail_ele';
w_errore		varchar2(4000);

begin
  docarea_pkg.INS_LOG(w_operazione_log, 'inizio', 'archivio_rif: '||a_archivio_rif||' - id_rif: '||a_id_rif||' - a_id_dest: '||a_id_dest);

  begin
    select com_p.anno_protocollo, com_p.numero_protocollo
      into w_anno_prot, w_numero_prot
      from elecom_prot com_p
     where id = a_id_rif
    ;
  exception
    when others then
         w_errore      := 'Errore in recupero anno / numero protocollo ('||sqlerrm||')';
         docarea_pkg.INS_LOG(w_operazione_log, w_errore);
         w_anno_prot   := '';
         w_numero_prot := '';
  end;

  w_conta_dest := 0;
  for rec in sel_d loop
      w_conta_dest     := w_conta_dest + 1;

      w_indirizzo_mail := rec.dest_mail;
      docarea_pkg.INS_LOG(w_operazione_log, 'indirizzo ('||w_conta_dest||') : '||w_indirizzo_mail);

      if nvl(w_docarea_ws,' ') = 'TEST' and mod(w_conta_dest,3) = 1 then
         w_indirizzo_mail := nvl(rtrim(f_valore_inp('DOCAREA_WS',11,100,'X','')),'a.monopoli@ads.it');
         docarea_pkg.INS_LOG(w_operazione_log, 'redirect: '||w_indirizzo_mail);
      elsif nvl(w_docarea_ws,' ') = 'TEST' and mod(w_conta_dest,3) = 2 then
         w_indirizzo_mail := 'a.monopoli@ads.it';
         docarea_pkg.INS_LOG(w_operazione_log, 'redirect: '||w_indirizzo_mail);
      elsif nvl(w_docarea_ws,' ') = 'TEST' and mod(w_conta_dest,3) = 0 then
         w_indirizzo_mail := 's.nocca@ads.it';
         docarea_pkg.INS_LOG(w_operazione_log, 'redirect: '||w_indirizzo_mail);
      elsif nvl(w_docarea_ws,' ') = 'TEST' then
         w_indirizzo_mail := 'a.monopoli@ymail.com';
         docarea_pkg.INS_LOG(w_operazione_log, 'redirect: '||w_indirizzo_mail);
      end if;

      if w_conta_dest = 1 then
         w_stringa_dest := w_indirizzo_mail;
      elsif w_conta_dest > 1 then
         w_stringa_dest := w_stringa_dest||'###'||w_indirizzo_mail;
      end if;
      docarea_pkg.INS_LOG(w_operazione_log, 'w_stringa_dest: '||w_stringa_dest);

  end loop;

  w_return         := docarea_pkg.INVIA_MAIL_PROT(w_stringa_dest, w_anno_prot, w_numero_prot);

  docarea_pkg.CTR_RESPONSE_MAIL(w_return, w_flag_ws_mail, w_note_ws_mail);

  begin
     update levcom_dest
        set flag_ws_mail      = w_flag_ws_mail,
            note_ws_mail      = w_note_ws_mail
      where id           = nvl(a_id_dest,id)
        and id_com       = a_id_rif
     ;
  exception
    when others then
         w_errore := 'errore in upd LEVCOM_DEST ('||SQLERRM||')';
         docarea_pkg.INS_LOG(w_operazione_log, w_errore);
  end;

  return w_flag_ws_mail;

exception
  when others then
       w_errore := 'errore ('||sqlerrm||')';
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
end INVIA_MAIL_ELE;

procedure INVIA_MAIL_X34D
(a_anno_revisione		number
,a_revisione			varchar2
,a_progr_revisione		number
,a_cod_pro_dest			number
,a_cod_com_dest			number
,a_indirizzo_mail		varchar2
,a_anno_prot 			number
,a_numero_prot 			number
)

IS

w_return		varchar2(32000);

w_codice_ws		varchar2(255);
w_descrizione_ws	varchar2(4000);

w_note_ws_mail		varchar2(4000);
w_flag_ws_mail		varchar2(1);

w_operazione_log	varchar2(255) := 'invia_mail_x34d';
w_errore		varchar2(4000);

begin
  docarea_pkg.INS_LOG(w_operazione_log, 'inizio');

/*
  begin
    select 'COMUNE DI '||com.descrizione,
           pec.cod_amm, pec.cod_aoo, pec.cod_uo,
           pec.indirizzo_mail
      into w_dest_des_amm,
           w_dest_cod_amm, w_dest_cod_aoo, w_dest_cod_uo,
           w_dest_mail
      from arccom com, arcpec pec
     where com.cod_provincia = pec.cod_provincia
       and com.cod_Comune    = pec.cod_Comune
       and pec.cod_provincia = a_cod_pro_dest
       and pec.cod_comune    = a_cod_Com_dest
       and pec.flag_ele      = 'S'
       and rownum = 1
    ;
  exception
    when others then
	 w_dest_des_amm := '';
         w_dest_cod_amm := '';
         w_dest_cod_aoo := '';
         w_dest_cod_uo  := '';
         w_dest_mail    := '';
  end;
*/

  w_return         := docarea_pkg.INVIA_MAIL_PROT(a_indirizzo_mail, a_anno_prot, a_numero_prot);

  w_codice_ws      := docarea_pkg.GET_VALUE_BY_TAG(w_return, 'codice');
  w_descrizione_ws := docarea_pkg.GET_VALUE_BY_TAG(w_return, 'descrizione');

  docarea_pkg.INS_LOG(w_operazione_log, 'esito invio mail ('||w_codice_ws||' - '||w_descrizione_ws||')');

  if nvl(w_codice_ws,' ') = '0' then
     w_flag_ws_mail := 'S';
     w_note_ws_mail := '';
  else
     w_flag_ws_mail := '';
     w_note_ws_mail   := w_descrizione_ws;
  end if;

  begin
     update ele34d
        set flag_ws_mail      = w_flag_ws_mail,
            note_ws_mail      = w_note_ws_mail
      where anno            = a_anno_revisione
        and revisione       = a_revisione
        and progr_revisione = a_progr_revisione
        and cod_pro_dest    = a_cod_pro_dest
        and cod_Com_dest    = a_cod_com_dest
     ;
  exception
    when others then
         w_errore := 'errore in upd ELE34D ('||SQLERRM||')';
         docarea_pkg.INS_LOG(w_operazione_log, w_errore);
  end;


exception
  when others then
       w_errore := 'errore ('||sqlerrm||')';
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
end INVIA_MAIL_X34D;

function INVIA_MAIL_PROT
(a_indirizzo_mail	varchar2
,a_anno_prot		number
,a_numero_prot		number
)

return varchar2

IS

w_ducd_mail_inp         varchar2(4000) := f_valore_inp('DUCD_MAIL',1,1000,'X','');


w_service_url		varchar2(255);
w_username          	varchar2(255);
w_password          	varchar2(255);

w_ns_str_1		varchar2(255) := 'xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"';
w_ns_str_2		varchar2(255) := 'xmlns:pec="http://pec.ducd.affarigenerali.finmatica.it"';
w_ns_str_3		varchar2(255);
w_ns_str_4		varchar2(255);
w_ns_str_5		varchar2(255);

w_extract_str_1		varchar2(255) := 'xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"';
w_extract_str_2		varchar2(255) := 'xmlns:xsd="http://www.w3.org/2001/XMLSchema"';
w_extract_str_3		varchar2(255) := 'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"';
w_extract_str_4  	varchar2(255) := 'xmlns="http://pec.ducd.affarigenerali.finmatica.it"';
w_extract_str_5  	varchar2(255);
w_extract_str_6  	varchar2(255);
w_estract_str_7		varchar2(255);
w_estract_str_8		varchar2(255);
w_estract_str_9		varchar2(255);
w_estract_str_10	varchar2(255);

w_service_name		varchar2(255);
w_service_ns		varchar2(255);

w_indirizzo_mail	varchar2(255);
w_anno_prot             number;
w_numero_prot           number;

w_request		clob;
w_response 		clob;

w_return		varchar2(32000);

w_operazione_log	varchar2(255) := 'invia_mail_prot';
w_errore		varchar2(4000);

begin
  docarea_pkg.INS_LOG(w_operazione_log, 'inizio');

  if w_ducd_mail_inp is not null then
     w_service_url := substr(w_ducd_mail_inp,instr(w_ducd_mail_inp,'SERVER=')+7);
     w_service_url := substr(w_service_url,1,instr(w_service_url,' ')-1);
     w_username    := substr(w_ducd_mail_inp,instr(w_ducd_mail_inp,'USER=')+5);
     w_username    := substr(w_username,1,instr(w_username,' ')-1);
     w_password    := substr(w_ducd_mail_inp,instr(w_ducd_mail_inp,'PASSWORD=')+9);
  else
     w_service_url := '';
     w_username    := '';
     w_password    := '';
  end if;

  w_service_name := 'invioPec';

  w_indirizzo_mail := a_indirizzo_mail;
  w_anno_prot      := a_anno_prot;
  w_numero_prot    := a_numero_prot;

  w_request  := '<soapenv:Envelope '||w_ns_str_1||' '||w_ns_str_2||'>
'||                  '  <soapenv:Header/>
'||                  '  <soapenv:Body>
'||                  '    <pec:'||w_service_name||'>
'||                  '      <pec:in>
'||                  '        <pec:idDocumento>-1</pec:idDocumento>
'||                  '        <pec:listaDestinatari>'||w_indirizzo_mail||'</pec:listaDestinatari>
'||                  '        <pec:utente_creazione>RPI</pec:utente_creazione>
'||                  '        <pec:anno>'||w_anno_prot||'</pec:anno>
'||                  '        <pec:numero>'||w_numero_prot||'</pec:numero>
'||                  '        <pec:tipo_registro/>
'||                  '      </pec:in>
'||                  '    </pec:'||w_service_name||'>
'||                  '  </soapenv:Body>
'||                  '</soapenv:Envelope>';

  docarea_pkg.INS_LOG(w_operazione_log, 'request', w_request);

  w_return := docarea_pkg.WS_REQUEST(w_service_url, w_service_name, w_service_ns, w_request, '', w_username, w_password);

  return w_return;

exception
  when others then
       w_errore := 'errore ('||sqlerrm||')';
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
end INVIA_MAIL_PROT;

function WS_REQUEST
(a_service_url 		varchar2
,a_service_name 	varchar2
,a_service_ns       	varchar2
,a_soap_request		clob
,a_service_timeout  	number   default 600
,a_username		varchar2 default NULL
,a_password		varchar2 default NULL
)

return CLOB

IS

w_soap_request		clob	:= a_soap_request;
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

out_xml               	xmltype;
out_xml_clob		clob;

w_step          	number;

w_errore		varchar2(4000);
errore			exception;

begin

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

  utl_http.set_header(http_request, 'Content-Type', 'text/xml');
  utl_http.set_header(http_request, 'Content-Length', length(w_soap_request));
  utl_http.set_header(http_request, 'SOAPAction', a_service_name);
--  utl_http.set_header(http_request, 'SOAPAction', a_service_ns||'/'||a_service_name);

w_step := 5;
  if a_username is not null then
     DOCAREA_PKG.ins_log('WS Request', a_service_url, 'username '||a_username||' - password '||a_password);
     utl_http.set_authentication(http_request, a_username, a_password);
  end if;

w_step := 6;
  utl_http.write_text(http_request,w_soap_request);

w_step := 7;
  http_response := utl_http.get_response(http_request);

Dbms_Output.Put_Line ( 'Status code: ' || http_response.status_code );
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

DOCAREA_PKG.ins_log('WS Request', 'response', soap_response);
w_step := 11;
--  out_xml:= xmltype(soap_response);

w_step := 12;
--  out_xml_clob	:= xmltype.getclobval(out_xml);
  out_xml_clob	:= soap_response;

  return out_xml_clob;
exception
  when others then
       w_errore := 'exception ('||SQLERRM||')';
       DOCAREA_PKG.ins_log('WS Request', a_service_url, w_step||'. '||w_errore);
--       raise_application_error(-20999, 'Request 0 ('||SQLERRM||')');
end WS_REQUEST;

procedure CTR_RESPONSE_MAIL
(a_return		IN	clob
,a_flag_ws_mail		IN OUT	varchar2
,a_note_ws_mail		IN OUT	varchar2
)

IS

w_return		clob;

w_codice_ws		varchar2(255);
w_descrizione_ws	varchar2(4000);

w_flag_ws_mail		varchar2(255);
w_note_ws_mail		varchar2(255);

w_operazione_log	varchar2(255) := 'ctr_response_mail';

w_errore		varchar2(4000);
errore			exception;

begin
--
-- in caso di successo la response contiene un messaggio del tipo:
-- <invioPecReturn>
--   <codice>0</codice>
--   <descrizione/>
--   <msgId>14599235</msgId>
-- </invioPecReturn>
--
-- in caso di errore:
-- <invioPecReturn>
--   <codice>-4</codice>
--   <descrizione>Errore in parsing xml output dati PEC - Errore: null</descrizione>
--   <msgId xsi:nil="true"/>
--   </invioPecReturn>
--
  w_return := a_return;

  w_codice_ws      := docarea_pkg.GET_VALUE_BY_TAG(w_return, 'codice');
  w_descrizione_ws := docarea_pkg.GET_VALUE_BY_TAG(w_return, 'descrizione');

  docarea_pkg.INS_LOG(w_operazione_log, 'esito invio mail ('||w_codice_ws||' - '||w_descrizione_ws||')');

  if nvl(w_codice_ws,' ') = '0' then
     w_flag_ws_mail := 'S';
     w_note_ws_mail := '';
  else
     w_flag_ws_mail := '';
     w_note_ws_mail   := w_descrizione_ws;
  end if;

  a_flag_ws_mail := w_flag_ws_mail;
  a_note_ws_mail := w_note_ws_mail;

exception
  when errore then
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
  when others then
       w_errore := 'errore ('||sqlerrm||')';
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
end CTR_RESPONSE_MAIL;

procedure CTR_RESPONSE_PROT
(a_return		IN	clob
,a_flag_ws_prot		IN OUT	varchar2
,a_note_ws_prot		IN OUT	varchar2
,a_anno_prot		IN OUT	number
,a_num_prot		IN OUT	number
,a_data_prot		IN OUT	varchar2
)

IS

w_return		clob;
w_flag_ws_prot		varchar2(255);
w_note_ws_prot		varchar2(255);
w_anno_prot		number;
w_num_prot		number;
w_data_prot		varchar2(255);

w_operazione_log	varchar2(255) := 'ctr_response_prot';

w_errore		varchar2(4000);
errore			exception;

begin
--
-- in caso di successo la response contiene un messaggio del tipo:
--
--	<ROWSET requestId="1" pages="1" page="1" lastRow="1" rows="1" firstRow="1">
--	   <ROW num="1">
--       <ANNO>anno</ANNO>
--	      <NUMERO>num</NUMERO>
--	      <DATA>data</DATA>
--	   </ROW>
-- </ROWSET>
--	in caso di errore:
-- <message>
--    <result>error</result>
--    <text>errore</text>
--	</message>

  w_return := a_return;

  if nvl(docarea_pkg.GET_VALUE_BY_TAG(w_return, 'result'), ' ') = 'error' then
     w_errore       := substr(docarea_pkg.GET_VALUE_BY_TAG(w_return, 'text'),1,4000);
     w_flag_ws_prot := '';
     w_note_ws_prot := w_errore;
     docarea_pkg.INS_LOG(w_operazione_log, w_errore);
  else
     w_anno_prot    := to_number(docarea_pkg.GET_VALUE_BY_TAG(w_return, 'ANNO'));
     w_num_prot     := to_number(docarea_pkg.GET_VALUE_BY_TAG(w_return, 'NUMERO'));
     w_data_prot    := docarea_pkg.GET_VALUE_BY_TAG(w_return, 'DATA');
     if w_anno_prot||w_num_prot is not null then
        w_flag_ws_prot := 'S';
        docarea_pkg.INS_LOG(w_operazione_log, 'documento protocollato ('||w_anno_prot||' - '||w_num_prot||' - '||w_data_prot||')');
     else
        w_flag_ws_prot := '';
        w_note_ws_prot := 'documento NON protocollato ('||w_anno_prot||' - '||w_num_prot||' - '||w_data_prot||')';
        docarea_pkg.INS_LOG(w_operazione_log, w_note_ws_prot);
     end if;
  end if;

  a_flag_ws_prot := w_flag_ws_prot;
  a_note_ws_prot := w_note_ws_prot;
  a_anno_prot    := w_anno_prot;
  a_num_prot     := w_num_prot;
  a_data_prot    := w_data_prot;

exception
  when errore then
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
  when others then
       w_errore := 'errore ('||sqlerrm||')';
       docarea_pkg.INS_LOG(w_operazione_log, w_errore);
end CTR_RESPONSE_PROT;

function GET_VALUE_BY_TAG
(a_xml		VARCHAR2
,a_tag 		VARCHAR2
)

return varchar2

IS

w_pos1 		integer;
w_pos2 		integer;

w_return 	varchar2(32767);

begin
   w_pos1 := instr(lower(a_xml), '<'||lower(a_tag));
   if w_pos1 > 0 then
      w_pos1 := instr(a_xml, '>', w_pos1);
      if w_pos1 > 0 then
         w_pos1 := w_pos1 + 1;
         w_pos2 := instr(lower(a_xml), '</'|| lower(a_tag) ||'>');
         if w_pos2 > 0 and w_pos2 > w_pos1 then
            w_return := substr(a_xml, w_pos1, w_pos2 - w_pos1);
         else
            w_pos2 := 0;
         end if;
      end if;
   end if;

   if w_pos1 = 0 or w_pos2 = 0 then
      w_return := '';
   end if;

   return w_return;
end GET_VALUE_BY_TAG;

procedure IPA_AGGIORNA_MAIL
(a_cod_provincia	number
,a_cod_comune		number
,a_cod_amm		varchar2
,a_des_amm		varchar2
,a_cod_aoo		varchar2
,a_des_aoo		varchar2
,a_stringa_mail		varchar2
)

IS

w_cod_provincia		number := a_cod_provincia;
w_cod_comune		number := a_cod_comune;

w_ducd_ipa_inp          varchar2(4000) := f_valore_inp('DUCD_IPA',1,1000,'X','');

w_cod_amm		varchar2(255) := upper(a_cod_amm);
w_des_amm		varchar2(255) := upper(a_des_amm);
w_cod_aoo		varchar2(255);
w_des_aoo		varchar2(255);
w_stringa_mail		varchar2(255);

w_service_name		varchar2(255);
w_service_ns		varchar2(255);

w_service_url		varchar2(255);
w_username          	varchar2(255);
w_password          	varchar2(255);

w_ns_str_1		varchar2(255) := 'xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"';
w_ns_str_2		varchar2(255) := 'xmlns:prot="http://protocolloUtility.ducd.affarigenerali.finmatica.it"';
w_ns_str_3		varchar2(255);
w_ns_str_4		varchar2(255);
w_ns_str_5		varchar2(255);

w_extract_str_1		varchar2(255) := 'xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"';
w_extract_str_2		varchar2(255) := 'xmlns:xsd="http://www.w3.org/2001/XMLSchema"';
w_extract_str_3		varchar2(255) := 'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"';
w_extract_str_4  	varchar2(255) := 'xmlns="http://protocolloUtility.ducd.affarigenerali.finmatica.it"';
w_extract_str_5  	varchar2(255);
w_extract_str_6  	varchar2(255);
w_estract_str_7		varchar2(255);
w_estract_str_8		varchar2(255);
w_estract_str_9		varchar2(255);
w_estract_str_10	varchar2(255);

w_request		clob;
w_response 		clob;

w_campo_xml		xmltype;
w_campo_clob		clob;

w_root_trovata		varchar2(1);

w_operazione_log        varchar2(255) := 'ipa_aggiorna_mail';

w_errore		varchar2(4000);
errore			exception;

cursor sel_result (w_root varchar2) is
select extractValue(value(rowdata),w_root||'/CODICE_AMMINISTRAZIONE', '')      cod_amm
     , extractValue(value(rowdata),w_root||'/CODICE_AOO', '')                  cod_aoo
     , extractValue(value(rowdata),w_root||'/CODICE_UO', '')                   cod_uo
     , extractValue(value(rowdata),w_root||'/DESCRIZIONE_AMMINISTRAZIONE', '') des_amm
     , extractValue(value(rowdata),w_root||'/DESCRIZIONE_AOO', '')             des_aoo
     , extractValue(value(rowdata),w_root||'/DESCRZIONE_UO', '')               des_uo
     , extractValue(value(rowdata),w_root||'/INDIRIZZO', '')                   indirizzo
     , extractValue(value(rowdata),w_root||'/PROVENIENZA',  '')                 provenienza
     , extractValue(value(rowdata),w_root||'/PROVINCIA', '')                   provincia
     , extractValue(value(rowdata),w_root||'/REGIONE', '')                     regione
     , extractValue(value(rowdata),w_root||'/SIGLA_COMUNE',  '')               sigla_comune
     , extractValue(value(rowdata),w_root||'/SIGLA_PROVINCIA', '')             sigla_provincia
     , extractValue(value(rowdata),w_root||'/TIPO_INDIRIZZO', '')              tipo_indirizzo
  from table(XMLSequence(w_campo_xml)) rowdata
;

begin
  DOCAREA_PKG.INS_LOG(w_operazione_log, 'inizio');
  docarea_pkg.dati_cliente;

  if w_ducd_ipa_inp is not null then
     w_service_url := substr(w_ducd_ipa_inp,instr(w_ducd_ipa_inp,'SERVER=')+7);
     w_service_url := substr(w_service_url,1,instr(w_service_url,' ')-1);
     w_username    := substr(w_ducd_ipa_inp,instr(w_ducd_ipa_inp,'USER=')+5);
     w_username    := substr(w_username,1,instr(w_username,' ')-1);
     w_password    := substr(w_ducd_ipa_inp,instr(w_ducd_ipa_inp,'PASSWORD=')+9);
  else
     w_service_url := '';
     w_username    := '';
     w_password    := '';
  end if;

  w_service_name := 'getMailEnte';
  w_request  := '<soapenv:Envelope '||w_ns_str_1||' '||w_ns_str_2||'>
'||                  '  <soapenv:Header/>
'||                  '  <soapenv:Body>
'||                  '    <prot:'||w_service_name||'>
'||                  '      <prot:codice_amministrazione>'||w_cod_amm||'</prot:codice_amministrazione>
'||                  '      <prot:descrizione_amministrazione>'||w_des_amm||'</prot:descrizione_amministrazione>
'||                  '      <prot:codice_aoo>'||w_cod_aoo||'</prot:codice_aoo>
'||                  '      <prot:descrizione_aoo>'||w_des_aoo||'</prot:descrizione_aoo>
'||                  '      <prot:indirizzo_mail>'||w_stringa_mail||'</prot:indirizzo_mail>
'||                  '    </prot:'||w_service_name||'>
'||                  '  </soapenv:Body>
'||                  '</soapenv:Envelope>';

  DOCAREA_PKG.INS_LOG(w_operazione_log, 'request', w_request);

  w_response 	 := DOCAREA_PKG.WS_REQUEST(w_service_url, w_service_name, w_service_ns, w_request, '', w_username, w_password);

--
-- 30/04/2019 (AM): x evitare exception "ORA-31167: XML nodes over 64K in size cannot be inserted"
--
  if lpad(w_cod_pro_cliente,3,'0')||lpad(w_cod_com_cliente,3,'0')    = '028032'		-- 028032 Cittadella
     OR lpad(w_cod_pro_cliente,3,'0')||lpad(w_cod_com_cliente,3,'0') = '023089'		-- 023089 Valeggio sul Mincio
  then
     w_campo_clob := substr(w_response,instr(w_response,'<getMailEnteReturn>')+19);
     w_campo_clob := substr(w_campo_clob,1,instr(w_campo_clob,'</getMailEnteReturn>')-1);
  else
     w_campo_xml  := xmltype(w_response);
     w_campo_xml  := w_campo_xml.extract('/soapenv:Envelope/soapenv:Body/'||w_service_name||'Response/'||w_service_name||'Return/child::node()'
                                          ,w_extract_str_1||' '||w_extract_str_2||' '||w_extract_str_3||' '||w_extract_str_4);
     w_campo_clob := xmltype.getclobval(w_campo_xml);
  end if;

  DOCAREA_PKG.INS_LOG(w_operazione_log, 'response', w_campo_clob);

  w_campo_clob := replace(w_campo_clob,'&lt;','<');
  w_campo_clob := replace(w_campo_clob,'&gt;','>');
  w_campo_clob := replace(w_campo_clob,'&quot;','''');
  if instr(w_campo_clob,'<ROOT>') > 0 then
     w_root_trovata := 'S';
  else
     w_root_trovata := 'N';
  end if;
  DOCAREA_PKG.INS_LOG(w_operazione_log, 'test <root> - '||w_root_trovata, w_campo_clob);

  if w_root_trovata = 'S' then
--     w_campo_clob := substr(w_campo_clob,instr(w_campo_clob,'<ROOT>')+6);
--     w_campo_clob := replace(w_campo_clob,'</ROOT>','');
--     w_campo_clob := replace(w_campo_clob,'<ERROR/>','');
     w_campo_xml := xmltype(w_campo_clob);
     w_campo_xml := w_campo_xml.extract('/ROOT/ENTE','');
     w_campo_clob := xmltype.getclobval(w_campo_xml);
     DOCAREA_PKG.INS_LOG(w_operazione_log, 'extract', w_campo_clob);

     begin
       delete arcpec pec
        where cod_provincia = w_cod_provincia
          and cod_comune    = w_Cod_Comune
          and flag_ipa      is not null
       ;
     exception
       when others then
            w_errore := sqlerrm;
            DOCAREA_PKG.INS_LOG('del_arcpec', w_errore);
     end;
     for rec in sel_result ('ENTE') loop
--dbms_output.put_line('cod_amm '||rec.cod_amm||' - des_amm '||rec.des_amm||' - mail '||rec.indirizzo);
         if rec.provenienza = 'AM' and rec.tipo_indirizzo = 'I' then
            begin
              insert into arcpec
                     (COD_PROVINCIA, COD_COMUNE, COD_AMM, DES_AMM, FLAG_IPA)
              select w_cod_provincia, w_cod_comune, rec.COD_AMM, rec.DES_AMM, 'S'
                from dual
               where not exists (select 'x' from arcipa b
                                  where b.cod_provincia = w_cod_provincia
                                    and b.cod_comune    = w_cod_Comune)
              ;
              update arcipa
                 set cod_amm = rec.cod_amm
                   , des_amm = rec.des_amm
               where cod_provincia = w_cod_provincia
                 and cod_comune    = w_Cod_comune
              ;
            exception
              when others then
                   w_errore := sqlerrm;
                   DOCAREA_PKG.INS_LOG('ins_arcipa', w_errore);
            end;
         end if;

--
-- 10/01/2024 (AM)
-- aggiunto controllo di non duplicazione su
-- . CODICE_AMMINISTRAZIONE
-- . CODICE_AOO
-- . CODICE_UO
-- . TIPO_INDIRIZZO
--
         if rec.tipo_indirizzo != 'G' then
            begin
              insert into arcpec
                     (COD_PROVINCIA, COD_COMUNE, INDIRIZZO_MAIL, TIPO_MAIL, PROVENIENZA,
                      COD_AMM, DES_AMM, COD_AOO, DES_AOO, COD_UO, DES_UO, FLAG_IPA)
              select w_cod_provincia, w_cod_comune, rec.INDIRIZZO, rec.TIPO_INDIRIZZO, rec.PROVENIENZA,
                      rec.COD_AMM, rec.DES_AMM, rec.COD_AOO, rec.DES_AOO, rec.COD_UO, rec.DES_UO, 'S'
                from dual
               where not exists (select 1 from arcpec b
                                  where b.cod_amm          = rec.cod_amm
                                    and nvl(b.cod_aoo,' ') = nvl(rec.cod_aoo,' ')
                                    and nvl(b.cod_uo,' ')  = nvl(rec.cod_uo,' ')
                                    and tipo_mail          = rec.tipo_indirizzo)
              ;
            exception
              when others then
                   w_errore := sqlerrm;
                   DOCAREA_PKG.INS_LOG('ins_arcpec', w_errore);
            end;
         end if;
     end loop;
     DOCAREA_PKG.UPD_ARCPEC(w_cod_provincia, w_cod_comune);
  end if;

  DOCAREA_PKG.INS_LOG(w_operazione_log, 'fine');

exception
  when errore then
       DOCAREA_PKG.INS_LOG(w_operazione_log, w_errore);
  when others then
       w_errore := 'exception ('||SQLERRM||')';
       DOCAREA_PKG.INS_LOG(w_operazione_log, w_errore);
end IPA_AGGIORNA_MAIL;

procedure UPD_ARCPEC
(a_cod_provincia	number
,a_cod_comune		number
)

IS

w_operazione_log	varchar2(255) := 'upd_arcpec';

w_errore		varchar2(4000);
errore			exception;

begin
  begin
    update arcpec pec
       set flag_gen = 'S'
     where 1 = (select count(*) from arcpec b
                 where b.cod_provincia = pec.cod_provincia
                   and b.cod_Comune    = pec.cod_Comune
                   and b.provenienza   = 'AM')
       and provenienza = 'AM'
       and cod_provincia = a_cod_provincia
       and cod_comune    = a_cod_Comune
    ;
  exception
    when others then
         w_errore := sqlerrm;
         DOCAREA_PKG.INS_LOG('upd_arcpec 1', w_errore);
  end;

  begin
    update arcpec pec
       set flag_ana = 'S'
         , flag_civ = 'S'
         , flag_ele = 'S'
         , flag_lev = 'S'
     where 1 = (select count(*) from arcpec b
                 where b.cod_provincia = pec.cod_provincia
                   and b.cod_Comune    = pec.cod_Comune)
       and cod_provincia = a_cod_provincia
       and cod_comune    = a_cod_Comune
    ;
  exception
    when others then
         w_errore := sqlerrm;
         DOCAREA_PKG.INS_LOG('upd_arcpec 0', w_errore);
  end;

  begin
    update arcpec pec
       set flag_ana = 'S'
     where 1 < (select count(*) from arcpec b
                     where b.cod_provincia = pec.cod_provincia
                           and b.cod_Comune    = pec.cod_Comune)
       and (upper(pec.des_amm)      like '%ANAGRAFE%'
            or upper(pec.cod_aoo)   like '%ANAGRAFE%'
            or upper(pec.des_aoo)   like '%ANAGRAFE%'
            or upper(pec.cod_uo)    like '%ANAGRAFE%'
            or upper(pec.des_uo)    like '%ANAGRAFE%'
            or upper(pec.indirizzo_mail) like '%ANAGRAFE%')
       and cod_provincia = a_cod_provincia
       and cod_comune    = a_cod_Comune
       and not exists (select 'x' from arcpec b
                        where b.cod_provincia = a_cod_provincia
                          and b.cod_comune    = a_cod_comune
                          and b.flag_ana      is not null)
    ;
  exception
    when others then
         w_errore := sqlerrm;
         DOCAREA_PKG.INS_LOG('upd_arcpec 3', w_errore);
  end;

  begin
    update arcpec pec
       set flag_civ = 'S'
     where 1 < (select count(*) from arcpec b
                 where b.cod_provincia = pec.cod_provincia
                   and b.cod_Comune    = pec.cod_Comune)
       and (upper(pec.des_amm)      like '%STATO%CIVILE%'
            or upper(pec.cod_aoo)   like '%STATO%CIVILE%'
            or upper(pec.des_aoo)   like '%STATO%CIVILE%'
            or upper(pec.cod_uo)    like '%STATO%CIVILE%'
            or upper(pec.des_uo)    like '%STATO%CIVILE%'
            or upper(pec.indirizzo_mail) like '%STATO%CIVILE%')
       and cod_provincia = a_cod_provincia
       and cod_comune    = a_cod_Comune
       and not exists (select 'x' from arcpec b
                        where b.cod_provincia = a_cod_provincia
                          and b.cod_comune    = a_cod_comune
                          and b.flag_civ      is not null)    ;
  exception
    when others then
         w_errore := sqlerrm;
         DOCAREA_PKG.INS_LOG('upd_arcpec 4', w_errore);
  end;

  begin
    update arcpec pec
       set flag_ele = 'S'
     where 1 < (select count(*) from arcpec b
                 where b.cod_provincia = pec.cod_provincia
                   and b.cod_Comune    = pec.cod_Comune)
       and (upper(pec.des_amm)      like '%ELETTORAL%'
            or upper(pec.cod_aoo)   like '%ELETTORAL%'
            or upper(pec.des_aoo)   like '%ELETTORAL%'
            or upper(pec.cod_uo)    like '%ELETTORAL%'
            or upper(pec.des_uo)    like '%ELETTORAL%'
            or upper(pec.indirizzo_mail) like '%ELETTORAL%')
       and cod_provincia = a_cod_provincia
       and cod_comune    = a_cod_Comune
       and not exists (select 'x' from arcpec b
                        where b.cod_provincia = a_cod_provincia
                          and b.cod_comune    = a_cod_comune
                          and b.flag_ele      is not null)    ;
  exception
    when others then
         w_errore := sqlerrm;
         DOCAREA_PKG.INS_LOG('upd_arcpec 5', w_errore);
  end;

  begin
    update arcpec pec
       set flag_lev = 'S'
     where 1 < (select count(*) from arcpec b
                 where b.cod_provincia = pec.cod_provincia
                   and b.cod_Comune    = pec.cod_Comune)
       and (upper(pec.des_amm)      like '%LEVA%'
            or upper(pec.cod_aoo)   like '%LEVA%'
            or upper(pec.des_aoo)   like '%LEVA%'
            or upper(pec.cod_uo)    like '%LEVA%'
            or upper(pec.des_uo)    like '%LEVA%'
            or upper(pec.indirizzo_mail) like '%LEVA%')
       and cod_provincia = a_cod_provincia
       and cod_comune    = a_cod_Comune
       and not exists (select 'x' from arcpec b
                        where b.cod_provincia = a_cod_provincia
                          and b.cod_comune    = a_cod_comune
                          and b.flag_lev      is not null)    ;
  exception
    when others then
         w_errore := sqlerrm;
         DOCAREA_PKG.INS_LOG('upd_arcpec 6', w_errore);
  end;

  begin
    update arcpec pec
       set flag_ana = 'S'
     where 1 < (select count(*) from arcpec b
                 where b.cod_provincia = pec.cod_provincia
                       and b.cod_Comune    = pec.cod_Comune)
       and not exists (select 'x' from arcpec b
                        where b.cod_provincia = pec.cod_provincia
                          and b.cod_Comune    = pec.cod_Comune
                          and b.flag_ana      = 'S')
       and (upper(pec.des_amm)      like '%DEMOGRAFICI%'
            or upper(pec.cod_aoo)   like '%DEMOGRAFICI%'
            or upper(pec.des_aoo)   like '%DEMOGRAFICI%'
            or upper(pec.cod_uo)    like '%DEMOGRAFICI%'
            or upper(pec.des_uo)    like '%DEMOGRAFICI%'
            or upper(pec.indirizzo_mail) like '%DEMOGRAFICI%'
            or upper(pec.des_amm)      like '%CITTADINO%'
            or upper(pec.cod_aoo)   like '%CITTADINO%'
            or upper(pec.des_aoo)   like '%CITTADINO%'
            or upper(pec.cod_uo)    like '%CITTADINO%'
            or upper(pec.des_uo)    like '%CITTADINO%'
            or upper(pec.indirizzo_mail) like '%CITTADINO%')
       and cod_provincia = a_cod_provincia
       and cod_comune    = a_cod_Comune
    ;
  exception
    when others then
         w_errore := sqlerrm;
         DOCAREA_PKG.INS_LOG('upd_arcpec 7', w_errore);
  end;

  begin
    update arcpec pec
       set flag_civ = 'S'
     where 1 < (select count(*) from arcpec b
                 where b.cod_provincia = pec.cod_provincia
                   and b.cod_Comune    = pec.cod_Comune)
       and not exists (select 'x' from arcpec b
                        where b.cod_provincia = pec.cod_provincia
                          and b.cod_Comune    = pec.cod_Comune
                          and b.flag_civ      = 'S')
       and (upper(pec.des_amm)      like '%DEMOGRAFICI%'
            or upper(pec.cod_aoo)   like '%DEMOGRAFICI%'
            or upper(pec.des_aoo)   like '%DEMOGRAFICI%'
            or upper(pec.cod_uo)    like '%DEMOGRAFICI%'
            or upper(pec.des_uo)    like '%DEMOGRAFICI%'
            or upper(pec.indirizzo_mail) like '%DEMOGRAFICI%'
            or upper(pec.des_amm)      like '%CITTADINO%'
            or upper(pec.cod_aoo)   like '%CITTADINO%'
            or upper(pec.des_aoo)   like '%CITTADINO%'
            or upper(pec.cod_uo)    like '%CITTADINO%'
            or upper(pec.des_uo)    like '%CITTADINO%'
            or upper(pec.indirizzo_mail) like '%CITTADINO%')
       and cod_provincia = a_cod_provincia
       and cod_comune    = a_cod_Comune
    ;
  exception
    when others then
         w_errore := sqlerrm;
         DOCAREA_PKG.INS_LOG('upd_arcpec 8', w_errore);
  end;

  begin
    update arcpec pec
       set flag_ele = 'S'
     where 1 < (select count(*) from arcpec b
                 where b.cod_provincia = pec.cod_provincia
                   and b.cod_Comune    = pec.cod_Comune)
       and not exists (select 'x' from arcpec b
                        where b.cod_provincia = pec.cod_provincia
                          and b.cod_Comune    = pec.cod_Comune
                          and b.flag_ele      = 'S')
       and (upper(pec.des_amm)      like '%DEMOGRAFICI%'
            or upper(pec.cod_aoo)   like '%DEMOGRAFICI%'
            or upper(pec.des_aoo)   like '%DEMOGRAFICI%'
            or upper(pec.cod_uo)    like '%DEMOGRAFICI%'
            or upper(pec.des_uo)    like '%DEMOGRAFICI%'
            or upper(pec.indirizzo_mail) like '%DEMOGRAFICI%'
            or upper(pec.des_amm)      like '%CITTADINO%'
            or upper(pec.cod_aoo)   like '%CITTADINO%'
            or upper(pec.des_aoo)   like '%CITTADINO%'
            or upper(pec.cod_uo)    like '%CITTADINO%'
            or upper(pec.des_uo)    like '%CITTADINO%'
            or upper(pec.indirizzo_mail) like '%CITTADINO%')
       and cod_provincia = a_cod_provincia
       and cod_comune    = a_cod_Comune
    ;
  exception
    when others then
         w_errore := sqlerrm;
         DOCAREA_PKG.INS_LOG('upd_arcpec 9', w_errore);
  end;

  begin
    update arcpec pec
       set flag_lev = 'S'
     where 1 < (select count(*) from arcpec b
                 where b.cod_provincia = pec.cod_provincia
                   and b.cod_Comune    = pec.cod_Comune)
       and not exists (select 'x' from arcpec b
                        where b.cod_provincia = pec.cod_provincia
                          and b.cod_Comune    = pec.cod_Comune
                          and b.flag_lev      = 'S')
       and (upper(pec.des_amm)      like '%DEMOGRAFICI%'
            or upper(pec.cod_aoo)   like '%DEMOGRAFICI%'
            or upper(pec.des_aoo)   like '%DEMOGRAFICI%'
            or upper(pec.cod_uo)    like '%DEMOGRAFICI%'
            or upper(pec.des_uo)    like '%DEMOGRAFICI%'
            or upper(pec.indirizzo_mail) like '%DEMOGRAFICI%'
            or upper(pec.des_amm)      like '%CITTADINO%'
            or upper(pec.cod_aoo)   like '%CITTADINO%'
            or upper(pec.des_aoo)   like '%CITTADINO%'
            or upper(pec.cod_uo)    like '%CITTADINO%'
            or upper(pec.des_uo)    like '%CITTADINO%'
            or upper(pec.indirizzo_mail) like '%CITTADINO%')
       and cod_provincia = a_cod_provincia
       and cod_comune    = a_cod_Comune
    ;
  exception
    when others then
         w_errore := sqlerrm;
         DOCAREA_PKG.INS_LOG('upd_arcpec 10', w_errore);
  end;

  begin
    update arcpec pec
       set flag_ana = 'S'
     where 1 < (select count(*) from arcpec b
                 where b.cod_provincia = pec.cod_provincia
                   and b.cod_Comune    = pec.cod_Comune)
       and 1 = (select count(*) from arcpec b
                 where b.cod_provincia = pec.cod_provincia
                   and b.cod_Comune    = pec.cod_Comune
                   and b.provenienza   = 'AM')
       and not exists (select 'x' from arcpec b
                        where b.cod_provincia = pec.cod_provincia
                          and b.cod_Comune    = pec.cod_Comune
                          and b.flag_ana      is not null)
       and provenienza = 'AM'
       and cod_provincia = a_cod_provincia
       and cod_comune    = a_cod_Comune
    ;
  exception
    when others then
         w_errore := sqlerrm;
         DOCAREA_PKG.INS_LOG('upd_arcpec 11', w_errore);
  end;

  begin
    update arcpec pec
       set flag_civ = 'S'
     where 1 < (select count(*) from arcpec b
                 where b.cod_provincia = pec.cod_provincia
                   and b.cod_Comune    = pec.cod_Comune)
       and 1 = (select count(*) from arcpec b
                 where b.cod_provincia = pec.cod_provincia
                   and b.cod_Comune    = pec.cod_Comune
                   and b.provenienza   = 'AM')
       and not exists (select 'x' from arcpec b
                        where b.cod_provincia = pec.cod_provincia
                          and b.cod_Comune    = pec.cod_Comune
                          and b.flag_civ      is not null)
       and provenienza = 'AM'
       and cod_provincia = a_cod_provincia
       and cod_comune    = a_cod_Comune
    ;
  exception
    when others then
         w_errore := sqlerrm;
         DOCAREA_PKG.INS_LOG('upd_arcpec 11', w_errore);
  end;

  begin
    update arcpec pec
       set flag_ele = 'S'
     where 1 < (select count(*) from arcpec b
                 where b.cod_provincia = pec.cod_provincia
                   and b.cod_Comune    = pec.cod_Comune)
       and 1 = (select count(*) from arcpec b
                 where b.cod_provincia = pec.cod_provincia
                   and b.cod_Comune    = pec.cod_Comune
                   and b.provenienza   = 'AM')
       and not exists (select 'x' from arcpec b
                        where b.cod_provincia = pec.cod_provincia
                          and b.cod_Comune    = pec.cod_Comune
                          and b.flag_ele      is not null)
       and provenienza = 'AM'
       and cod_provincia = a_cod_provincia
       and cod_comune    = a_cod_Comune
    ;
  exception
    when others then
         w_errore := sqlerrm;
         DOCAREA_PKG.INS_LOG('upd_arcpec 11', w_errore);
  end;

  begin
    update arcpec pec
       set flag_lev = 'S'
     where 1 < (select count(*) from arcpec b
                 where b.cod_provincia = pec.cod_provincia
                   and b.cod_Comune    = pec.cod_Comune)
       and 1 = (select count(*) from arcpec b
                 where b.cod_provincia = pec.cod_provincia
                   and b.cod_Comune    = pec.cod_Comune
                   and b.provenienza   = 'AM')
       and not exists (select 'x' from arcpec b
                        where b.cod_provincia = pec.cod_provincia
                          and b.cod_Comune    = pec.cod_Comune
                          and b.flag_lev      is not null)
       and provenienza = 'AM'
       and cod_provincia = a_cod_provincia
       and cod_comune    = a_cod_Comune
    ;
  exception
    when others then
         w_errore := sqlerrm;
         DOCAREA_PKG.INS_LOG('upd_arcpec 11', w_errore);
  end;
exception
  when errore then
       DOCAREA_PKG.ins_log(w_operazione_log, w_errore);
  when others then
       w_errore := 'exception ('||SQLERRM||')';
       DOCAREA_PKG.ins_log(w_operazione_log, w_errore);
end UPD_ARCPEC;

end;
/
