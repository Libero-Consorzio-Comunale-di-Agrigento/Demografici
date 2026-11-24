--liquibase formatted sql
--changeset amonopoli:202412041230_1 runOnChange:true stripComments:false
create or replace package ANPR_PKG
is


w_cod_pro_cliente		number;
w_cod_com_cliente		number;
w_codice_cliente		varchar2(255);
w_des_com_cliente		varchar2(255);
w_sigla_pro_cliente		varchar2(255);
w_cap_cliente			varchar2(255);

w_data_subentro			number;

w_flag_circoscrizionali		varchar2(255);

w_data_ads			varchar2(255) := f_valore_inp('DATA_ADS',1,10,'X','');

w_tipo_invio			varchar2(255) := f_ANPR_valore_inp('TIPO_INVIO',1,10,'X','');
w_nome_applicativo		varchar2(255) := 'DE4GSD';
w_versione_applicativo		varchar2(255) := 'V4.5.2';
w_fornitore_applicativo		varchar2(255) := 'ADS - Gruppo Finmatica - Bologna';

w_ora_31167			varchar2(255) := f_ANPR_valore_inp('ORA-31167',1,1,'X','S');

w_codDestinatario		varchar2(255);

w_ws_client			varchar2(255);

procedure dati_cliente;
function  versione                     return varchar2;

procedure ins_anpads                   (a_servizio varchar2,a_matricola number,a_matricola_aire varchar2,a_fascia number,a_tipo_fam number,a_cod_fam number,a_tipo_scheda_anpr varchar2,a_flag_subentro varchar2 default null,a_allegato_clob clob default null,a_num_componenti_anpr number default null,a_rapporto_par_anpr varchar2 default null);
procedure upd_anpads                   (a_servizio varchar2,a_matricola varchar2,a_id_soggetto_ANPR number,a_id_famiglia_ANPR number,a_famiglia_aire varchar2,a_cod_fiscale_AE varchar2,a_validita_cf_AE number,a_data_validita_cf_AE varchar2);
procedure upd_anpads_5001              (a_servizio varchar2,a_cod_mov number,a_cod_eve number,a_matricola number,a_cod_fam number,a_cod_fam_aire number);
procedure upd_anpads_id_unico          (a_servizio varchar2,a_matricola varchar2,a_id_soggetto_ANPR number,a_id_unico_ANPR varchar2);

procedure ins_log                      (a_servizio varchar2,a_operazione varchar2,a_note varchar2,a_campo_clob clob default null);
procedure del_allegati                 (a_servizio varchar2,a_chiave number default NULL);
procedure ins_allegati                 (a_servizio varchar2,a_chiave number,a_nome_allegato varchar2,a_allegato_clob clob,a_flag_base64 varchar2 default NULL);
procedure upd_allegati                 (a_servizio varchar2,a_chiave number,a_tag_substr varchar2,a_flag_base64 varchar2 default NULL);
procedure valida_xml	               (a_servizio varchar2,a_allegato_clob clob);

procedure attivazione_ws               (a_servizio varchar2,a_id_operazione number,a_tipo_operazione varchar2,a_anno_rif number,a_numero_rif number,a_matricola number,a_fascia_fam number,a_cod_fam number,a_id_anadoc number,a_id_anamsi number,a_archivio_rif varchar2,a_terminalista varchar2,w_id_ANPR out number,w_esito_ANPR out varchar2,w_flag_errore out varchar2,w_flag_anomalia out varchar2,w_xml_richiesta out clob,w_xml_risposta out clob,a_note varchar2 default null);

procedure ctr_risposta_ko              (a_servizio varchar2,a_id_operazione number,a_campo_clob clob,w_id_ANPR out number,w_esito_ANPR out varchar2,w_flag_errore out varchar2);
procedure ctr_risposta_ok              (a_servizio varchar2,a_id_operazione number,a_campo_clob clob,w_id_ANPR out number,w_esito_ANPR out varchar2,w_flag_anomalia OUT varchar2,a_chiave varchar2 default null);
procedure ctr_risposta_comune          (a_servizio varchar2,a_id_operazione number,a_campo_clob clob,w_id_ANPR out number,w_esito_ANPR out varchar2,w_flag_anomalia out varchar2);

function  ws_1000_iscrizione_apr       (a_servizio varchar2,a_id_operazione number,a_tipo_operazione varchar2,a_anno_rif number,a_numero_rif number) return clob;
function  ws_1010_iscrizione_FAM       (a_servizio varchar2,a_id_operazione number,a_tipo_operazione varchar2,a_fascia_fam number,a_cod_fam number) return clob;
function  ws_1014_procedimento         (a_servizio varchar2,a_id_operazione number,a_tipo_operazione varchar2,a_anno_rif number,a_numero_rif number,a_matricola number) return clob;

function  ws_5001_mutazione_FAM        (a_servizio varchar2,a_id_operazione number,a_tipo_operazione varchar2,a_fascia_fam number,a_cod_fam number,a_archivio_rif varchar2) return clob;
function  ws_A000_iscrizione_aire      (a_servizio varchar2,a_id_operazione number,a_tipo_operazione varchar2,a_anno_rif number,a_numero_rif number) return clob;
function  ws_2000_cancellazione_apr    (a_servizio varchar2,a_id_operazione number,a_tipo_operazione varchar2,a_anno_rif number,a_numero_rif number) return clob;
function  ws_2009_cancellazione_FAM    (a_servizio varchar2,a_id_operazione number,a_tipo_operazione varchar2,a_fascia_fam number,a_cod_fam number) return clob;
function  ws_5000_mutazione            (a_servizio varchar2,a_id_operazione number,a_tipo_operazione varchar2,a_anno_rif number,a_numero_rif number,a_id_anadoc number,a_id_anamsi number,a_matricola number,a_fascia_fam number,a_cod_fam number,a_archivio_rif varchar2) return clob;
function  ws_5000_mutazione_MOV        (a_servizio varchar2,a_id_operazione number,a_tipo_operazione varchar2,a_anno_rif number,a_numero_rif number,a_archivio_rif varchar2) return clob;
function  ws_5000_mutazione_DOC        (a_servizio varchar2,a_id_operazione number,a_tipo_operazione varchar2,a_id_anadoc number,a_archivio_rif varchar2,a_cod_cdf number) return clob;
function  ws_5000_mutazione_MSI        (a_servizio varchar2,a_id_operazione number,a_tipo_operazione varchar2,a_id_anamsi number) return clob;
function  ws_5000_mutazione_SFD        (a_servizio varchar2,a_id_operazione number,a_tipo_operazione varchar2,a_anno_rif number,a_numero_rif number) return clob;
function  ws_5000_mutazione_CDF        (a_servizio varchar2,a_id_operazione number,a_tipo_operazione varchar2,a_matricola number,a_cod_fam number,a_archivio_rif varchar2) return clob;
function  ws_5000_mutazione_ELE        (a_servizio varchar2,a_id_operazione number,a_tipo_operazione varchar2,a_matricola number,a_archivio_rif varchar2,a_anno_rif number,a_numero_rif number) return clob;
function  ws_5000_mutazione_LEV        (a_servizio varchar2,a_id_operazione number,a_tipo_operazione varchar2,a_matricola number,a_archivio_rif varchar2) return clob;
function  ws_5000_mutazione_SUB        (a_servizio varchar2,a_id_operazione number,a_tipo_operazione varchar2,a_matricola number,a_archivio_rif varchar2,a_anno_rif number,a_numero_rif number) return clob;
function  ws_5000_mutazione_ARI        (a_servizio varchar2,a_id_operazione number,a_tipo_operazione varchar2,a_matricola number,a_archivio_rif varchar2) return clob;

function  ws_5013_revoca               (a_servizio varchar2,a_id_operazione number,a_tipo_operazione varchar2,a_anno_rif number,a_numero_rif number,a_id_anadoc number,a_id_anamsi number,a_matricola number,a_cod_fam number,a_archivio_rif varchar2) return clob;
function  ws_5013_revoca_MOV           (a_servizio varchar2,a_id_operazione number,a_tipo_operazione varchar2,a_anno_rif number,a_numero_rif number) return clob;
function  ws_5013_revoca_DOC           (a_servizio varchar2,a_id_operazione number,a_tipo_operazione varchar2,a_archivio_rif varchar2,a_id_anadoc number) return clob;

function  ws_1013_ann_iscrizione       (a_servizio varchar2,a_id_operazione number,a_tipo_operazione varchar2,a_anno_rif number,a_numero_rif number) return clob;
function  ws_2011_ann_cancellazione    (a_servizio varchar2,a_id_operazione number,a_tipo_operazione varchar2,a_anno_rif number,a_numero_rif number) return clob;
function  ws_5012_ann_mutazione        (a_servizio varchar2,a_id_operazione number,a_tipo_operazione varchar2,a_anno_rif number,a_numero_rif number,a_id_anadoc number,a_id_anamsi number,a_matricola number,a_fascia_fam number,a_cod_fam number,a_archivio_rif varchar2) return clob;
function  ws_5012_ann_mutazione_MOV    (a_servizio varchar2,a_id_operazione number,a_tipo_operazione varchar2,a_anno_rif number,a_numero_rif number,a_id_anadoc number,a_id_anamsi number,a_matricola number,a_archivio_rif varchar2) return clob;
function  ws_5012_ann_mutazione_FAM    (a_servizio varchar2,a_id_operazione number,a_tipo_operazione varchar2,a_fascia_fam number,a_cod_fam number,a_archivio_rif varchar2) return clob;
function  ws_6001_certificazione       (a_servizio varchar2,a_id_operazione number,a_tipo_operazione varchar2,a_anno_rif number,a_numero_rif number) return clob;
function  ws_3000_consultazione        (a_servizio varchar2,a_id_operazione number,a_tipo_operazione varchar2,a_matricola number,a_archivio_rif varchar2) return clob;
function  ws_7001_scarico_tabelle      (a_servizio varchar2,a_id_operazione number,a_tipo_operazione varchar2,a_numero_rif number,a_archivio_rif varchar2) return clob;
function  ws_7002_download_file        (a_servizio varchar2,a_id_operazione number,a_tipo_operazione varchar2,a_numero_rif number,a_archivio_rif varchar2) return clob;

procedure ws_e001_subentro;           -- return CLOB;
procedure ws_e001_parametri;
procedure ws_e001_subentro_controlli; -- return CLOB;
function  ws_e001_subentro_liste_ele   return CLOB;
function  ws_e001_subentro_sezioni_ele return CLOB;

procedure ws_s001_subentro;           -- return CLOB;
procedure ws_s001_parametri;
procedure ws_s001_subentro_controlli; -- return CLOB;
function  ws_s001_subentro_soggetti    (a_cod_fam_inizio number,a_cod_fam_fine number) return CLOB;

function  f_xml_testataRichiesta       (a_servizio varchar2,a_id_operazione varchar2,a_tipo_operazione varchar2,a_protocollo varchar2,a_data_protocollo number,a_data_decorrenza number,a_data_definizione number,a_cod_mov number default null,a_cod_eve number default null) return CLOB;
function  f_xml_datiOperazione         (a_servizio varchar2,a_id_operazione varchar2,a_protocollo varchar2,a_data_protocollo number,a_id_operazione_anpr varchar2) return CLOB;

function  f_xml_tag                    (a_servizio varchar2,a_tag varchar2,a_tipo_tag varchar2) return clob;
function  f_xml_elemento               (a_servizio varchar2,a_valore varchar2,a_tag varchar2,a_check_null varchar2 default null) return clob;

function  f_xml_codiceFiscale          (a_servizio varchar2,a_codice_fiscale varchar2,a_matricola number,a_cf_calcolato varchar2 default null) return clob;
function  f_xml_generalita             (a_servizio varchar2,a_cognome varchar2,a_nome varchar2,a_sesso varchar2,a_data_nas number,a_anno_nas varchar2) return clob;
function  f_xml_luogoEvento            (a_servizio varchar2,a_cod_provincia number,a_cod_comune number,a_data_rif number,a_tag varchar2,a_flag_comune varchar2, a_provincia_contea varchar2 default NULL) return clob;
function  f_xml_idSchedaSoggettoComune (a_servizio varchar2,a_matricola varchar2) return clob;
function  f_xml_statoCivile            (a_servizio varchar2,a_stato_civile varchar2,a_sesso varchar2) return clob;
function  f_xml_attributiSoggetto      (a_servizio varchar2,a_matricola number,a_sospensione number,a_cod_via number,a_num_civ number,a_suffisso varchar2,a_interno number) return clob;
function  f_xml_atto                   (a_servizio varchar2,a_cod_pro_atto number,a_cod_com_atto number,a_data_rif number,a_anno number,a_ufficio number,a_parte number,a_serie varchar2,a_atto number,a_tag varchar2) return clob;
function  f_xml_atto_anpr              (a_servizio varchar2,a_cod_pro_atto number,a_cod_com_atto number,a_data_rif number,a_anno number,a_ufficio number,a_parte number,a_serie varchar2,a_atto number,a_tag varchar2,a_id_atto_ansc varchar2 default null) return clob;
function  f_xml_cittadinanza           (a_servizio varchar2,a_nazionalita varchar2,a_data_inizio_naz number,a_flag_altra_cit varchar2 default NULL) return clob;
function  f_xml_altriDati              (a_servizio varchar2,a_cod_prof number,a_sesso varchar2,a_posizione_prof number,a_titolo_studio varchar2) return clob;
function  f_xml_indirizzo              (a_servizio varchar2,a_cod_via number,a_num_civ number,a_suffisso varchar2,a_interno number,a_sub_interno varchar2,a_scala varchar2,a_piano varchar2,a_tag varchar2 default null) return clob;
function  f_xml_indirizzo_esteso       (a_servizio varchar2,a_cod_via number,a_num_civ number,a_suffisso varchar2,a_interno number,a_sub_interno varchar2,a_scala varchar2,a_piano varchar2
                                                           ,a_flag_metrico varchar2,a_progr_snc varchar2,a_flag_lettera varchar2,a_flag_esponente varchar2,a_flag_nui varchar2,a_nui varchar2,a_colore varchar2
                                                           ,a_corte varchar2,a_interno2 number,a_sub_interno2 varchar2,a_secondario varchar2,a_scala_esterna varchar2 
                                                           ,a_tag varchar2 default null) return clob;
function  f_xml_localitaEstera         (a_servizio varchar2,a_via_aire varchar2,a_zipcode varchar2,a_cod_pro_aire number,a_cod_com_aire number,a_provincia_contea varchar2,a_cod_consolato number,a_tipo_consolato number,a_stato number) return clob;
function  f_xml_idFamConvComune        (a_servizio varchar2,a_fascia number,a_cod_fam number,a_tipo_fam number,a_tipo_conv number,a_matricola_CC number,a_data_CC number,a_id_operazione number default NULL) return clob;
function  f_xml_divorzio               (a_servizio varchar2,a_matricola number,a_data_div number,a_data_div_ann number,a_stato_civile varchar2 default NULL) return clob;
function  f_xml_cartaIdentita          (a_servizio varchar2,a_matricola number,a_id_anadoc number default NULL) return clob;
function  f_xml_permessoSoggiorno      (a_servizio varchar2,a_matricola number,a_id_anadoc number default NULL) return clob;
function  f_xml_listaElettorale        (a_servizio varchar2,a_matricola number) return clob;
function  f_xml_listaLeva              (a_servizio varchar2,a_matricola number) return clob;
function  f_xml_censimento             (a_servizio varchar2,a_anno_cens number,a_sezione_cens number,a_foglio_cens number,a_questionario_cens number,a_data_decorrenza number) return clob;
function  f_xml_autoveicoli            (a_servizio varchar2,a_matricola number) return clob;
function  f_xml_legame                 (a_servizio varchar2,a_tipo_fam number,a_fascia number,a_cod_fam number,a_rapporto_par varchar2,a_sesso varchar2,a_data_inizio_fam number,a_progr_componente number,a_matricola number) return clob;
function  f_xml_datiDelProcedimento    (a_servizio varchar2,a_pratica number,a_anno_pratica number,a_data_reg number,a_anagrafe varchar2 default NULL,a_tipo_evento varchar2 default NULL) return clob;
function  f_xml_motivoIscrizione       (a_servizio varchar2,a_cod_mov number,a_cod_eve number,a_cod_variazione varchar2,a_cod_pro_eve number) return clob;
function  f_xml_iscrizioneAire         (a_servizio varchar2,a_cod_mov number,a_cod_eve number,a_cod_variazione varchar2,a_iniziativa number,a_individuazione number,a_data_arrivo number) return clob;
function  f_xml_datiCancellazione      (a_servizio varchar2,a_cod_mov number,a_cod_eve number,a_cod_variazione varchar2,a_cod_pro_eve number,a_data_eve number) return clob;
function  f_xml_convivenzaDiFatto      (a_servizio varchar2,a_matricola number,a_cod_cdf number,a_data_rif number,a_archivio_rif varchar2) return clob;

function  ws_request                   (a_service_url varchar2,a_service_name varchar2,a_service_ns varchar2,a_soap_request clob,a_service_timeout number default 600) return CLOB;

function  DECODE_BASE64                (a_clob_in clob) return BLOB;
function  ENCODE_BASE64                (a_blob_in blob) return CLOB;
function  CLOB_TO_BLOB                 (a_clob_in clob) return BLOB;
function  BLOB_TO_CLOB                 (a_blob_in blob) return CLOB;

procedure richiesta_notifiche          (a_servizio varchar2);
procedure verifica_stato_notifiche     (a_servizio varchar2,a_id_operazione number);
procedure acquisisci_notifiche         (a_servizio varchar2,a_campo_clob clob);
procedure acquisisci_operazioni        (a_servizio varchar2,a_id_operazione varchar2,a_stato_lavorazione varchar2,a_tipo_operazione varchar2,a_campo_clob clob);

function  f_UTIL_leggi_campo_xml       (a_servizio varchar2,a_campo_clob clob,a_tag_ricerca varchar2) return clob;

function  ws_test                      (a_servizio varchar2,a_id_operazione varchar2,a_tipo_operazione varchar2) return clob;

end;
/
