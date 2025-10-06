--liquibase formatted sql
--changeset amonopoli:202306061100_1 runOnChange:true stripComments:false
create or replace package firmaremota_pkg as
w_cod_pro_cliente      number;
w_cod_com_cliente      number;
w_des_com_cliente      varchar2(255);
w_sigla_pro_cliente    varchar2(255);
w_des_pro_cliente      varchar2(255);

w_provider_firma       varchar2(255);

w_service_name         varchar2(255);
w_service_ns           varchar2(255);
w_service_url          varchar2(255) := rtrim(f_valore_inp('FIRMA_URL',1,255,'X',''));

w_soap_action          varchar2(255);

-- xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" 
-- xmlns:ser="http://services.firmaremota.finmatica.it/"
w_soap_str_1           varchar2(255) := 'xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"';
w_soap_str_2           varchar2(255) := 'xmlns:ser="http://services.firmaremota.finmatica.it/"';
w_extract_str_1        varchar2(255) := 'xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"';
w_extract_str_2        varchar2(255) := 'xmlns:ser="http://services.firmaremota.finmatica.it/"';
w_extract_str_3        varchar2(255);
w_extract_str_4        varchar2(255);
w_extract_str_5        varchar2(255);
w_extract_str_6        varchar2(255);
w_estract_str_7        varchar2(255);
w_estract_str_8        varchar2(255);
w_estract_str_9        varchar2(255);
w_estract_str_10       varchar2(255);

w_url_gsd              varchar2(255) := rtrim(f_valore_inp('FIRMA_IAS',1,255,'X',''));

function  VERSIONE return varchar2;

procedure DATI_CLIENTE;

procedure INSERIMENTO_LOG
(a_operazione          IN   varchar2
,a_note                IN   varchar2
,a_campo_clob          IN   clob      default NULL
);

function ATTIVAZIONE_WS
(a_archivio_rif        IN   varchar2
,a_id_rif              IN   varchar2
,a_id                  IN   varchar2
,a_usr                 IN   varchar2
,a_pwd                 IN   varchar2
,a_otp                 IN   varchar2
) return CLOB;

function RICHIESTA_OTP
(a_usr                 IN   varchar2
,a_pwd                 IN   varchar2
) return CLOB;

function WS_REQUEST
(a_service_url         IN   varchar2
,a_service_name        IN   varchar2
,a_service_ns          IN   varchar2
,a_soap_request        IN   clob
,a_service_timeout     IN   number default 600
) return CLOB;

function GET_VALUE_BY_TAG
(a_xml		IN   clob
,a_tag 		IN   varchar2
) return clob;

procedure GET_DATI_RIF
(a_stringa_id          IN      clob
,w_archivio_rif        IN OUT  varchar2
,w_id_rif              IN OUT  varchar2
);

function DECODE_BASE64
(a_clob_in             IN   clob
) return BLOB;

function ENCODE_BASE64
(a_blob_in             IN   blob
) return CLOB;
end;
/
