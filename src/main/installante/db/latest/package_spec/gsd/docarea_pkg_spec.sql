--liquibase formatted sql
--changeset amonopoli:202306090915_1 runOnChange:true stripComments:false
create or replace package DOCAREA_PKG as

w_versione  		varchar2(20);
w_revisione 		varchar2(30);

w_cod_pro_cliente	number;
w_cod_com_cliente	number;
w_des_com_cliente	varchar2(255);
w_sigla_pro_cliente	varchar2(255);
w_des_pro_cliente	varchar2(255);

function VERSIONE
return varchar2;

procedure DATI_CLIENTE;

procedure INS_LOG
(a_operazione 		varchar2
,a_note 		varchar2
,a_campo_clob 		clob default NULL
);

function PROTOCOLLA
(a_archivio_rif		varchar2
,a_id_rif 	 	number
) return varchar2;

function PROTOCOLLA_UTENTE
(a_archivio_rif		varchar2
,a_id_rif 	 	number
,a_terminalista		varchar2
) return varchar2;

function PROTOCOLLA_CIV
(a_archivio_rif		varchar2
,a_id_rif 	 	number
,a_terminalista		varchar2	default null
) return varchar2;

function PROTOCOLLA_ANA
(a_archivio_rif		varchar2
,a_id_rif 	 	number
,a_terminalista		varchar2	default null
) return varchar2;

function PROTOCOLLA_LEV
(a_archivio_rif		varchar2
,a_id_rif 	 	number
,a_terminalista		varchar2	default null
) return varchar2;

function PROTOCOLLA_ELE
(a_archivio_rif		varchar2
,a_id_rif 	 	number
,a_terminalista		varchar2	default null
) return varchar2;

procedure PROTOCOLLA_X34D
(a_anno_revisione 	number
,a_revisione 		varchar2
,a_progr_revisione 	number
,a_cod_pro_dest 	number
,a_cod_com_dest		number
,a_indirizzo_mail 	varchar2);

function JPROTOCOLLA
(a_DB_where 		varchar2
,a_DB_tabella 		varchar2
,a_DB_campo 		varchar2
,a_DB_datasource 	varchar2
,a_filename 		varchar2
,a_xml_dati 		varchar2
,a_alleTable 		varchar2
,a_alleField 		varchar2
,a_alleNameField 	varchar2
,a_allePkField 		varchar2
,a_alleWhereCondition	varchar2
) return varchar2;

function JPROTOCOLLA_CIV
(a_archivio_rif		varchar2
,a_id_rif		number
,a_terminalista		varchar2	default null
) return varchar2;

function JPROTOCOLLA_ANA
(a_archivio_rif		varchar2
,a_id_rif		number
,a_terminalista		varchar2	default null
) return varchar2;

function JPROTOCOLLA_LEV
(a_archivio_rif		varchar2
,a_id_rif		number
,a_terminalista		varchar2	default null
) return varchar2;

function JPROTOCOLLA_ELE
(a_archivio_rif		varchar2
,a_id_rif		number
,a_terminalista		varchar2	default null
) return varchar2;

function JPROTOCOLLA_X34D
(a_anno_revisione 	number
,a_revisione 		varchar2
,a_progr_revisione 	number
,a_cod_pro_dest 	number
,a_cod_com_dest		number
) return  varchar2;

function GET_XML_JPROTOCOLLO
(a_mitt_des_amm 	varchar2
,a_mitt_cod_amm 	varchar2
,a_mitt_cod_aoo 	varchar2
,a_mitt_cod_uo 		varchar2
,a_dest_des_amm 	varchar2
,a_dest_cod_amm 	varchar2
,a_dest_cod_aoo 	varchar2
,a_dest_cod_uo 		varchar2
,a_dest_mail 		varchar2
,a_oggetto 		varchar2
,a_ide_cod_amm 		varchar2
,a_ide_cod_aoo 		varchar2
,a_ide_flusso 		varchar2
,a_cod_titolario 	varchar2
,a_numero_fascicolo 	varchar2
,a_anno_fascicolo 	number
,a_filename 		varchar2
,a_tipo_documento 	varchar2
,a_dest_persona_id	varchar2	default NULL
,a_dest_persona_cognome	varchar2	default NULL
,a_dest_persona_nome	varchar2	default NULL
) return varchar2;

function GET_XML_JPROTOCOLLO_CIV
(a_archivio_rif		varchar2
,a_id_rif		number
,a_terminalista		varchar2	default null
) return varchar2;

function GET_XML_JPROTOCOLLO_ANA
(a_archivio_rif		varchar2
,a_id_rif		number
,a_terminalista		varchar2	default null
) return varchar2;

function GET_XML_JPROTOCOLLO_LEV
(a_archivio_rif		varchar2
,a_id_rif		number
,a_terminalista		varchar2	default null
) return varchar2;

function GET_XML_JPROTOCOLLO_ELE
(a_archivio_rif		varchar2
,a_id_rif		number
,a_terminalista		varchar2	default null
) return varchar2;

function  GET_XML_JPROTOCOLLO_X34D
(a_anno_revisione 	number
,a_revisione 		varchar2
,a_progr_revisione 	number
,a_cod_pro_dest 	number
,a_cod_com_dest 	number
) return 		varchar2;

function GET_XML_JPROTOCOLLO_MITT
(a_oggetto 		varchar2
,a_ide_cod_amm 		varchar2
,a_ide_cod_aoo 		varchar2
,a_ide_flusso 		varchar2
,a_mitt_des_amm 	varchar2
,a_mitt_cod_amm 	varchar2
,a_mitt_cod_aoo 	varchar2
,a_mitt_cod_uo 		varchar2
) return varchar2;

function GET_XML_JPROTOCOLLO_DEST
(a_dest_des_amm 	varchar2
,a_dest_cod_amm 	varchar2
,a_dest_cod_aoo 	varchar2
,a_dest_cod_uo 		varchar2
,a_dest_mail 		varchar2
,a_dest_persona_id	varchar2	default NULL
,a_dest_persona_cognome	varchar2	default NULL
,a_dest_persona_nome	varchar2	default NULL
) return varchar2;

function GET_XML_JPROTOCOLLO_FILE
(a_mitt_cod_amm 	varchar2
,a_mitt_cod_aoo 	varchar2
,a_mitt_cod_uo 		varchar2
,a_cod_titolario 	varchar2
,a_numero_fascicolo 	varchar2
,a_anno_fascicolo 	number
,a_filename 		varchar2
,a_tipo_documento 	varchar2
,a_terminalista 	varchar2
) return varchar2;

function INVIA_MAIL
(a_archivio_rif		varchar2
,a_id_rif		number
,a_id_dest		number
) return varchar2;

function INVIA_MAIL_CIV
(a_archivio_rif		varchar2
,a_id_rif		number
,a_id_dest		number
) return varchar2;

function INVIA_MAIL_ANA
(a_archivio_rif		varchar2
,a_id_rif		number
,a_id_dest		number
) return varchar2;

function INVIA_MAIL_LEV
(a_archivio_rif		varchar2
,a_id_rif		number
,a_id_dest		number
) return varchar2;

function INVIA_MAIL_ELE
(a_archivio_rif		varchar2
,a_id_rif		number
,a_id_dest		number
) return varchar2;

procedure INVIA_MAIL_X34D
(a_anno_revisione 	number
,a_revisione 		varchar2
,a_progr_revisione 	number
,a_cod_pro_dest 	number
,a_cod_com_dest		number
,a_indirizzo_mail 	varchar2
,a_anno_prot 		number
,a_numero_prot 		number
);

function INVIA_MAIL_PROT
(a_indirizzo_mail	varchar2
,a_anno_prot		number
,a_numero_prot		number
) return varchar2;

function WS_REQUEST
(a_service_url 		varchar2
,a_service_name 	varchar2
,a_service_ns 		varchar2
,a_soap_request clob
,a_service_timeout 	number default 600
,a_username 		varchar2 default NULL
,a_password 		varchar2 default NULL
) return CLOB;

procedure CTR_RESPONSE_MAIL
(a_return		IN	clob
,a_flag_ws_mail		IN OUT	varchar2
,a_note_ws_mail		IN OUT	varchar2
);

procedure CTR_RESPONSE_PROT
(a_return		IN	clob
,a_flag_ws_prot		IN OUT	varchar2
,a_note_ws_prot		IN OUT	varchar2
,a_anno_prot		IN OUT	number
,a_num_prot		IN OUT	number
,a_data_prot		IN OUT	varchar2
);

function GET_VALUE_BY_TAG
(a_xml 			varchar2
,a_tag 			varchar2
) return 		varchar2;


procedure IPA_AGGIORNA_MAIL
(a_cod_provincia 	number
,a_cod_comune 		number
,a_cod_amm 		varchar2
,a_des_amm 		varchar2
,a_cod_aoo 		varchar2
,a_des_aoo 		varchar2
,a_stringa_mail 	varchar2
);

procedure UPD_ARCPEC
(a_cod_provincia 	number
,a_cod_comune 		number
);

end;
/
