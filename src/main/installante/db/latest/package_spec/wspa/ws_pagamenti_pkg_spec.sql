--liquibase formatted sql
--changeset amonopoli:202501150940_1 runOnChange:true stripComments:false
create or replace package WS_PAGAMENTI_PKG
IS
w_cod_pro_cliente		number;
w_cod_com_cliente		number;
w_codice_cliente		varchar2(255);
w_des_com_cliente		varchar2(255);
w_sigla_pro_cliente		varchar2(255);
w_cap_cliente			varchar2(255);

w_nome_applicativo		varchar2(255) := 'DE4GSD';
w_versione_applicativo		varchar2(255) := 'V4.5.4';
w_fornitore_applicativo		varchar2(255) := 'ADS - Gruppo Finmatica - Bologna';

procedure dati_cliente;

function  versione              return varchar2;

procedure ins_log
(a_operazione 		IN	varchar2
,a_note 		IN	varchar2
,a_campo_clob 		IN	clob default null
);

function  f_xml_tag
(a_ns			IN	varchar2
,a_tag 			IN	varchar2
,a_tipo_tag 		IN	varchar2
) 				return clob;

function  f_xml_elemento
(a_valore 		IN	varchar2
,a_ns			IN	varchar2
,a_tag 			IN	varchar2
,a_check_null 		IN	varchar2 default null
) 				return clob;

function  f_next_intestazioneFO
(a_token		IN	varchar2
)				return clob;

function  f_next_loginRequest    return clob;

function  f_next_residenza
(a_tag			IN	varchar2
,a_des_com		IN	varchar2
,a_sigla_pro		IN	varchar2
,a_cap			IN	varchar2
,a_indirizzo		IN	varchar2
,a_num_civ		IN	varchar2
,a_suffisso		IN	varchar2
)                               return CLOB;

function  f_next_soggetto
(a_tag			IN	varchar2
,a_cognome		IN	varchar2
,a_nome			IN	varchar2
,a_cod_fiscale		IN	varchar2
,a_indirizzo_mail	IN	varchar2
,a_nazionalita		IN	varchar2
,a_des_com_res		IN	varchar2
,a_sigla_pro_res	IN	varchar2
,a_cap_res		IN	varchar2
,a_indirizzo_res	IN	varchar2
,a_num_civ_res		IN	varchar2
,a_suffisso_res		IN	varchar2
)				return CLOB;

function  f_next_dettagli
(a_des_certificato	IN	varchar2
,a_des_diritto		IN	varchar2
,a_causale		IN	varchar2
,a_quantita		IN	varchar2
,a_importo		IN	varchar2
,a_voce_di_costo	IN	varchar2
)				return CLOB;

function  f_next_posizione_debitoria
(a_anno_pagamento	IN	varchar2
,a_progr_pagamento	IN	varchar2
)				return CLOB;

function  f_next_posizioni_in_attesa
(a_anno_emissione	IN	varchar2
,a_progr_emissione	IN	varchar2
)				return CLOB;

function  f_next_envelope
(a_header		IN	clob
,a_body			IN	clob
)				return CLOB;

function  f_next_data
(a_data			IN	varchar2
)				return varchar2;

function  f_importo
(a_importo		IN	varchar2
)				return varchar2;

function  f_next_des_diritto
(a_cod_certificato	IN	varchar2
,a_cod_diritto          IN	number
)				return varchar2;

function  f_next_voce_di_costo
(a_cod_certificato	IN	varchar2
,a_cod_diritto          IN	number
,a_modalita_rilascio	IN	number
)				return varchar2;

function  f_next_modalita
(a_tipo_pagamento	IN	varchar2
)				return varchar2;

function  f_next_operatore
(a_terminalista		IN	varchar2
)				return varchar2;

function  ws_cerca_tag
(a_campo_clob		IN	clob
,a_tag			IN	varchar2
)				return varchar2;

procedure ws_next_response
(a_campo_clob		IN	clob
,w_flag_errore		IN OUT	varchar2
,w_messaggio		IN OUT	varchar2
,w_url_conferma		IN OUT	varchar2
);

function  ws_request
(a_service_url 		IN	varchar2
,a_service_name 	IN	varchar2
,a_service_ns 		IN	varchar2
,a_soap_request 	IN	clob
,a_service_timeout 	IN	number default 600
,a_username		IN	varchar2 default NULL
,a_password		IN	varchar2 default NULL
) 				return CLOB;

procedure ws_attivazione
(a_anno_pagamento	IN	number
,a_progr_pagamento	IN	number
,w_flag_errore		IN OUT	varchar2
,w_messaggio		IN OUT  varchar2
,w_url_conferma		IN OUT	varchar2
);

procedure ws_nextstep
(a_anno_pagamento	IN	number
,a_progr_pagamento	IN	number
,w_flag_errore		IN OUT	varchar2
,w_messaggio		IN OUT  varchar2
,w_url_conferma		IN OUT	varchar2
);

procedure ws_depag
(a_anno_pagamento	IN	number
,a_progr_pagamento	IN	number
,a_servizio		IN	varchar2
,a_iuv			IN	varchar2
,w_flag_errore		IN OUT	varchar2
,w_messaggio		IN OUT  varchar2
,w_url_conferma		IN OUT	varchar2
);

function  f_depag_aggiorna_dovuto
(a_anno_pagamento	IN	varchar2
,a_progr_pagamento	IN	varchar2
)				return CLOB;

function  f_depag_leggi_dovuto
(a_iuv			IN	varchar2
)				return CLOB;

function  f_depag_elimina_dovuto
(a_iuv			IN	varchar2
)				return CLOB;

function  f_depag_data
(a_data			IN	varchar2
)				return varchar2;

function  f_depag_voce_di_costo
(a_cod_certificato	IN	varchar2
,a_cod_diritto          IN	number
,a_modalita_rilascio	IN	number
)				return varchar2;

function  f_depag_envelope
(a_header		IN	clob
,a_body			IN	clob
)				return CLOB;

procedure ws_depag_response
(a_campo_clob		IN	clob
,w_flag_errore		IN OUT	varchar2
,w_messaggio		IN OUT	varchar2
,w_url_conferma		IN OUT	varchar2
,w_param		IN OUT	clob
);

function  f_depag_get_url
(a_iuv			IN	varchar2
)				return varchar2;

function  DECODE_BASE64
(a_clob_in 		IN	clob
) 			return BLOB;

function  ENCODE_BASE64
(a_blob_in 		IN	blob
) 			return CLOB;

function  CLOB_TO_BLOB
(a_clob_in 		IN	clob
) 			return BLOB;

function  BLOB_TO_CLOB
(a_blob_in 		IN 	blob
) 			return CLOB;

function f_get_hash_MD5
(in_string 		IN 	varchar2
)			return 	varchar2;


end;
/
