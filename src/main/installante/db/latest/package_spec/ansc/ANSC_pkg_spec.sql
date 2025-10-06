--liquibase formatted sql
--changeset amonopoli:202305181215_1 runOnChange:true stripComments:false
create or replace package ANSC_PKG

IS

w_cod_pro_cliente		number;
w_cod_com_cliente		number;
w_codice_cliente		varchar2(255);
w_des_com_cliente		varchar2(255);
w_sigla_pro_cliente		varchar2(255);
w_cap_cliente			varchar2(255);
w_id_cliente			number;

w_nome_applicativo		varchar2(255) := 'DE4GSD';
w_versione_applicativo		varchar2(255) := 'V4.5.2';
w_fornitore_applicativo		varchar2(255) := 'ADS - Gruppo Finmatica - Bologna';

w_ws_client			varchar2(255);

procedure dati_cliente;
function  versione                     return varchar2;

procedure ins_log                      (a_servizio varchar2,a_operazione varchar2,a_note varchar2,a_campo_clob clob default null,a_id_atto varchar2 default null);

procedure attivazione_ws               (a_servizio varchar2,a_id_operazione number,a_archivio_rif varchar2,a_id_rif varchar2,a_archivio_civ varchar2,a_id_civ number,a_id_usecase number,a_terminalista varchar2,a_otp varchar2,a_id_atto varchar2,w_json_request OUT clob,w_json_response OUT clob);

function  ws_request                   (a_servizio varchar2,a_service_url varchar2,a_service_name varchar2,a_service_ns varchar2,a_json_header clob,a_json_request clob,a_service_timeout number default 600) return CLOB;

function  f_JSON_tag                   (a_servizio varchar2,a_livello number,a_tag varchar2,a_tipo_tag varchar2,a_is_array varchar2) return clob;
function  f_JSON_elemento              (a_servizio varchar2,a_livello number,a_valore clob,a_tag varchar2,a_is_array varchar2,a_is_ultimo varchar2,a_check_null varchar2 default null) return clob;

function  f_JSON_testataRichiesta      (a_servizio varchar2,a_id_operazione varchar2) return CLOB;
function  f_JSON_body                  (a_servizio varchar2,a_id_operazione varchar2,a_tipo_atto number,a_id_rif varchar2) return CLOB;

procedure ctr_risposta                 (a_servizio varchar2,a_id_operazione varchar2,a_archivio_rif varchar2,a_id_rif varchar2,a_id_atto varchar2,a_campo_clob clob,w_id_operazione_ANSC OUT number,w_esito_ANSC OUT varchar2,w_flag_errore OUT varchar2,w_flag_anomalia OUT varchar2,w_flag_invio_ws OUT varchar2,w_note_ws OUT clob);
procedure ctr_risposta_JSON            (a_servizio varchar2,a_id_operazione varchar2,a_archivio_rif varchar2,a_id_rif varchar2,a_id_atto varchar2,a_campo_clob clob,w_id_operazione_ANSC OUT number,w_esito_ANSC OUT varchar2,w_flag_errore OUT varchar2,w_flag_anomalia OUT varchar2);
procedure ctr_risposta_XML             (a_servizio varchar2,a_id_operazione varchar2,a_archivio_rif varchar2,a_id_rif varchar2,a_id_atto varchar2,a_campo_clob clob,w_id_operazione_ANSC OUT number,w_esito_ANSC OUT varchar2,w_flag_errore OUT varchar2,w_flag_anomalia OUT varchar2,w_flag_invio_ws OUT varchar2,w_note_ws OUT clob);

function  f_UTIL_ansciu_ins_x_stato    (a_servizio varchar2,a_archivio_rif varchar2,a_id_rif varchar2,a_stato_ansc varchar2) return number;
function  f_UTIL_ansciu_upd_R005_G     (a_servizio varchar2,a_id_operazione number,a_id_operazione_ansc number,a_esito_ansc number,a_note_ws clob,a_info_ws clob) return number;
function  f_UTIL_errore_decode         (a_codice_errore varchar2,a_testo_errore varchar2) return varchar2;
function  f_UTIL_get_tipo_atto         (a_archivio_rif varchar2) return number;
function  f_UTIL_get_id_atto           (a_archivio_rif varchar2,a_id_rif varchar2) return varchar2;
function  f_UTIL_leggi_campo_jsn       (a_servizio varchar2,a_campo_clob clob,a_tag_ricerca varchar2) return clob;
function  f_UTIL_leggi_campo_jsn_number(a_servizio varchar2,a_campo_clob clob,a_tag_ricerca varchar2) return number;
function  f_UTIL_leggi_campo_jsn_char  (a_servizio varchar2,a_campo_clob clob,a_tag_ricerca varchar2) return varchar2;
function  f_UTIL_leggi_campo_xml       (a_servizio varchar2,a_campo_clob clob,a_tag_ricerca varchar2) return clob;
function  f_UTIL_date2millisec         (a_data date) return number;
function  f_UTIL_date2sec              (a_data date) return number;
function  f_UTIL_millisec2date         (a_millisec number) return date;
function  f_UTIL_sec2date              (a_sec number) return date;
function  f_UTIL_base64_decode         (a_clob_in clob) return BLOB;
function  f_UTIL_base64_encode         (a_blob_in blob) return CLOB;
function  f_UTIL_clob2blob             (a_clob_in clob) return BLOB;
function  f_UTIL_blob2clob             (a_blob_in blob) return CLOB;

function  f_TEST_header                (a_servizio varchar2) return CLOB;
function  f_TEST_payload               (a_servizio varchar2) return CLOB;
function  f_TEST_signature             (a_servizio varchar2,a_header_b64 clob,a_payload_b64 clob) return CLOB;
function  f_TEST_body                  (a_servizio varchar2,a_id_operazione varchar2) return CLOB;
function  f_TEST_request               (a_servizio varchar2) return CLOB;

end;
/
