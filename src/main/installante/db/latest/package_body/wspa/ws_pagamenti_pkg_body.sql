--liquibase formatted sql
--changeset amonopoli:202501150940_2 runOnChange:true stripComments:false
create or replace package body WS_PAGAMENTI_PKG
IS
function versione

return varchar2

IS

w_versione 		varchar2(255);

begin
--
-- Versione   Data         Autore   Note
-- V1.0       05/02/2021   AM       .prima emissione
-- V1.1       16/03/2021   AM       .generalizzato gestione del ws, passando a nomenclatura WS_PAGAMENTI
-- V1.2       29/03/2021   AM       .integrazione con ws ANPR x recuperare i dati di residenza del pagatore
-- V2.0       11/10/2021   AM       .integrazione con ws DEPAG (aggiornaDovuto, leggiDovuto, eliminaDovuto)
-- V2.1       13/10/2021   AM       .depag: url_provider per conferma pagamento
-- V3.0       17/01/2022   AM       .depag: gestione del multi-servizi
-- V3.1       21/03/2023   AM       .depag: personalizzazione San Donato M.se (servizi CER / CER_B)
-- V3.2       04/05/2023   AM       .depag: anno/numero acc. non valorizzato su tag BILANCIO
-- V3.3       22/05/2023   AM       .depag: servizio_depag su leggi_dovuto e elimina_dovuto (rif. San Donato)
-- V3.4       23/06/2023   AM       .depag: causaleVersamento contenente il servizio_depag e descrizione servizio (rif. San Donato)
-- V3.5       08/09/2023   AM       .depag: w_url_time x millisecondi
-- V4.0       15/01/2025   AM       .integrazione con gestionale zk (rif. tabella ws_pagamenti_tes)
--

  w_versione := 'V4.0 del 15/01/2025';

  return w_versione;
end versione;

procedure dati_cliente
is

w_operazione_log	varchar2(255) := 'dati_cliente';

w_errore		varchar2(4000);
errore			exception;

begin
  begin
    select m.cod_provincia
         , m.cod_Comune
         , lpad(m.cod_provincia,3,'0')||lpad(m.cod_Comune,3,'0')
         , m.descrizione
         , m.sigla_provincia
         , lpad(m.cap,5,'0')
      into w_cod_pro_cliente
         , w_cod_com_cliente
         , w_codice_cliente
         , w_des_com_cliente
         , w_sigla_pro_cliente
         , w_cap_cliente
      from arccom m
     where (m.cod_provincia, m.cod_comune) = (select pro_cliente, com_cliente from menuditta)
    ;
  exception
    when others then
         w_errore := 'errore in dati_cliente ('||SQLERRM||')';
         raise errore;
  end;

  begin
    select MAX(versione)
      into w_versione_applicativo
      from ad4_istanze
     where progetto = 'DE4GSD'
       AND USER_ORACLE = USER
       and rownum  = 1
    ;
    w_versione_applicativo := f_ANPR_stringa(w_versione_applicativo||' - '||WS_PAGAMENTI_pkg.versione,'/');
  exception
    when others then
         w_errore := 'errore in ad4_istanze ('||SQLERRM||')';
         raise errore;
  end;

exception
  when errore then
       WS_PAGAMENTI_pkg.ins_log(w_operazione_log, w_errore);
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       WS_PAGAMENTI_pkg.ins_log(w_operazione_log, w_errore);
end dati_cliente;

procedure ins_log
(a_operazione   varchar2
,a_note 	varchar2
,a_campo_clob 	clob	default null
)

is

w_id			number;

w_operazione_log	varchar2(255) := 'ins_log';

w_errore		varchar2(4000);
errore			exception;

begin
  begin
    insert into WS_PAGAMENTI_log (operazione, note, campo_clob)
    values (a_operazione, a_note, a_campo_clob)
    ;
    commit;
  exception
    when others then
         raise errore;
  end;
<< fine >>
null;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       begin
         insert into WS_PAGAMENTI_log (operazione, note, campo_clob)
         values (w_operazione_log, a_note, a_campo_clob)
         ;
         commit;
       end;
end ins_log;

function f_xml_tag
(a_ns			IN	varchar2
,a_tag 			IN	varchar2
,a_tipo_tag		IN	varchar2)

return clob

is

w_ns			varchar2(255);

w_xml_clob		clob;

w_operazione_log	varchar2(255) := 'xml_tag';
w_errore		varchar2(255);
errore			exception;


begin
  if a_ns is null then
     w_ns := '';
  else
     w_ns := a_ns||':';
  end if;

  if upper(nvl(a_tipo_tag,'I')) = 'I' then
w_xml_clob := '<'||w_ns||a_tag||'>'||chr(10);
  elsif upper(nvl(a_tipo_tag,'I')) = 'F' then
w_xml_clob := '</'||w_ns||a_tag||'>'||chr(10);
  end if;

  return w_xml_clob;
end f_xml_tag;

function f_xml_elemento
(a_valore 		IN	varchar2
,a_ns			IN	varchar2
,a_tag 			IN	varchar2
,a_check_null		IN	varchar2 default NULL)

return clob

is

w_ns			varchar2(255);
w_xml_clob		clob;

w_operazione_log	varchar2(255) := 'xml_elemento';

w_errore		varchar2(255);
errore			exception;

begin
  if a_ns is null then
     w_ns := '';
  else
     w_ns := a_ns||':';
  end if;

  if upper(nvl(a_check_null,'N')) = 'S' and a_valore is null then
     goto fine;
  end if;

w_xml_clob := '<'||w_ns||a_tag||'>'||a_valore||'</'||w_ns||a_tag||'>'||chr(10);

<< fine >>
null;

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       WS_PAGAMENTI_pkg.ins_log(w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_xml_elemento;

function f_next_intestazioneFO
(a_token	IN	varchar2
)

return clob

is

w_TokenAuth			varchar2(255) := a_token;
w_IdentificativoConnettore	varchar2(255) := rtrim(f_valore_inp('NEXT_CONN',1,255,'X',''));
w_CodiceFiscaleEnte		varchar2(255) := rtrim(f_valore_inp('NEXT_ENTE',1,255,'X',''));

w_xml_clob		clob;

w_operazione_log	varchar2(255) := 'xml_intestazione';

w_errore		varchar2(255);
errore			exception;

begin
w_xml_clob := '<p0:IntestazioneFO xmlns:p0="http://entranext.it/fohead" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://entranext.it/fohead">'||chr(10);
w_xml_clob := w_xml_clob||f_xml_elemento(w_TokenAuth,'','TokenAuth','');
w_xml_clob := w_xml_clob||f_xml_elemento(w_IdentificativoConnettore,'','IdentificativoConnettore','');
w_xml_clob := w_xml_clob||f_xml_elemento(w_CodiceFiscaleEnte,'','CodiceFiscaleEnte','');
w_xml_clob := w_xml_clob||f_xml_tag('p0','IntestazioneFO','F');

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       WS_PAGAMENTI_pkg.ins_log(w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_next_intestazioneFO;

function f_next_loginRequest

return clob

is

w_versione		varchar2(255) := rtrim(f_valore_inp('NEXT_VERS',1,255,'X',''));
w_identificativo	varchar2(255) := rtrim(f_valore_inp('NEXT_IDE',1,255,'X',''));
w_username		varchar2(255) := rtrim(f_valore_inp('NEXT_USR',1,255,'X',''));
w_password		varchar2(255) := rtrim(f_valore_inp('NEXT_PWD',1,255,'X',''));

w_xml_clob		clob;

w_operazione_log	varchar2(255) := 'xml_loginRequest';

w_errore		varchar2(255);
errore			exception;

begin

w_xml_clob := '<p1:LoginRequest xmlns:p1="http://entranext.it/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://entranext.it/">'||chr(10);
w_xml_clob := w_xml_clob||f_xml_elemento(w_versione,'','Versione','S');
w_xml_clob := w_xml_clob||f_xml_elemento(w_identificativo,'','Identificativo','S');
w_xml_clob := w_xml_clob||f_xml_elemento(w_username,'','Username');
w_xml_clob := w_xml_clob||f_xml_elemento(w_password,'','PasswordMD5');
w_xml_clob := w_xml_clob||f_xml_tag('p1','LoginRequest','F');

<< fine >>
null;

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       WS_PAGAMENTI_pkg.ins_log(w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_next_loginRequest;

function f_next_residenza
(a_tag			IN	varchar2
,a_des_com		IN	varchar2
,a_sigla_pro		IN	varchar2
,a_cap			IN	varchar2
,a_indirizzo		IN	varchar2
,a_num_civ		IN	varchar2
,a_suffisso		IN	varchar2
)

return CLOB
IS

w_riferimento		varchar2(255);
w_comune		varchar2(255) := a_des_com;
w_localita		varchar2(255);
w_provincia		varchar2(255) := a_sigla_pro;
w_cap			varchar2(255) := a_cap;
w_indirizzo		varchar2(255) := a_indirizzo;
w_numeroCivico		varchar2(255) := a_num_civ;
w_lettera		varchar2(255) := a_suffisso;
w_km			varchar2(255);
w_codiceVia		varchar2(255);

w_xml_clob		clob;

w_operazione_log	varchar2(255) := 'xml_residenza';

w_errore		varchar2(255);
errore			exception;

begin
w_xml_clob := f_xml_tag('p1',a_tag,'I');
w_xml_clob := w_xml_clob||f_xml_elemento(w_riferimento,'p1','Riferimento','S');
w_xml_clob := w_xml_clob||f_xml_elemento(w_comune,'p1','Comune','S');
w_xml_clob := w_xml_clob||f_xml_elemento(w_localita,'p1','Localita','S');
w_xml_clob := w_xml_clob||f_xml_elemento(w_provincia,'p1','Provincia','S');
w_xml_clob := w_xml_clob||f_xml_elemento(w_cap,'p1','CAP','S');
w_xml_clob := w_xml_clob||f_xml_elemento(w_indirizzo,'p1','Indirizzo','S');
w_xml_clob := w_xml_clob||f_xml_elemento(w_numeroCivico,'p1','NumeroCivico','S');
w_xml_clob := w_xml_clob||f_xml_elemento(w_lettera,'p1','Lettera','S');
w_xml_clob := w_xml_clob||f_xml_elemento(w_km,'p1','Km','S');
w_xml_clob := w_xml_clob||f_xml_elemento(w_codiceVia,'p1','CodiceVia','S');
w_xml_clob := w_xml_clob||f_xml_tag('p1',a_tag,'F');

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       WS_PAGAMENTI_pkg.ins_log(w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_next_residenza;

function f_next_soggetto
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
)

return CLOB

IS

w_naturaGiuridica	varchar2(255) := 'PersonaFisica';
w_ragioneSociale	varchar2(255);
w_cognome		varchar2(255) := a_cognome;
w_nome			varchar2(255) := a_nome;
w_codiceFiscale		varchar2(255) := a_cod_fiscale;
w_partitaIva		varchar2(255);
w_eMail			varchar2(255) := a_indirizzo_mail;
w_CodiceIsoNazionalita	varchar2(255) := a_nazionalita;

w_xml_clob		clob;

w_operazione_log	varchar2(255) := 'xml_soggetto';

w_errore		varchar2(255);
errore			exception;

begin
w_xml_clob := f_xml_tag('p1',a_tag,'I');
w_xml_clob := w_xml_clob||f_xml_elemento(w_NaturaGiuridica,'p1','NaturaGiuridica','S');
w_xml_clob := w_xml_clob||f_xml_elemento(w_RagioneSociale,'p1','RagioneSociale','S');
w_xml_clob := w_xml_clob||f_xml_elemento(w_Cognome,'p1','Cognome','S');
w_xml_clob := w_xml_clob||f_xml_elemento(w_Nome,'p1','Nome','S');
w_xml_clob := w_xml_clob||f_xml_elemento(w_CodiceFiscale,'p1','CodiceFiscale','S');
w_xml_clob := w_xml_clob||f_xml_elemento(w_PartitaIva,'p1','PartitaIva','S');
w_xml_clob := w_xml_clob||f_xml_elemento(w_Email,'p1','Email','S');
w_xml_clob := w_xml_clob||f_xml_elemento(w_CodiceIsoNazionalita,'p1','CodiceIsoNazionalita','S');
  if a_des_com_res is not null then
w_xml_clob := w_xml_clob||f_next_residenza('Residenza',a_des_com_res,a_sigla_pro_res,a_cap_res,a_indirizzo_res,a_num_civ_res,a_suffisso_res);
  end if;
w_xml_clob := w_xml_clob||f_xml_tag('p1',a_tag,'F');

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       WS_PAGAMENTI_pkg.ins_log(w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_next_soggetto;

function f_next_dettagli
(a_des_certificato	IN	varchar2
,a_des_diritto		IN	varchar2
,a_causale		IN	varchar2
,a_quantita		IN	varchar2
,a_importo		IN	varchar2
,a_voce_di_costo	IN	varchar2
)

return CLOB

IS

w_nomeVoceDiCosto		varchar2(255) := a_voce_di_costo;
w_quantita			varchar2(255) := a_quantita;
w_importo			varchar2(255);
w_iva				varchar2(255) := '00.00';
w_descrizione			varchar2(255) := a_des_certificato; --a_des_diritto;
w_causaleImporto		varchar2(255) := a_causale;
w_aliquotaIva			varchar2(255) := 'E03';
w_numeroAccertamentoContabile	varchar2(255);
w_annoAccertamentoContabile	varchar2(255);
w_descrizioneHTML		varchar2(255);

w_xml_clob		clob;

w_operazione_log	varchar2(255) := 'xml_dettaglio';

w_errore		varchar2(255);
errore			exception;

begin
w_xml_clob := f_xml_tag('p1','Dettagli','I');
w_xml_clob := w_xml_clob||f_xml_elemento(w_NomeVoceDiCosto,'p1','NomeVoceDiCosto','S');
w_xml_clob := w_xml_clob||f_xml_elemento(w_Quantita,'p1','Quantita','');
  w_importo := f_importo(a_importo);
w_xml_clob := w_xml_clob||f_xml_elemento(w_Importo,'p1','Importo','');
w_xml_clob := w_xml_clob||f_xml_elemento(w_Iva,'p1','Iva','');
w_xml_clob := w_xml_clob||f_xml_elemento(w_Descrizione,'p1','Descrizione','S');
w_xml_clob := w_xml_clob||f_xml_elemento(w_CausaleImporto,'p1','CausaleImporto','');
w_xml_clob := w_xml_clob||f_xml_elemento(w_AliquotaIva,'p1','AliquotaIva','');
--  w_NumeroAccertamentoContabile := 1;
--  w_AnnoAccertamentoContabile   := 2021;
w_xml_clob := w_xml_clob||f_xml_elemento(w_NumeroAccertamentoContabile,'p1','NumeroAccertamentoContabile','');
w_xml_clob := w_xml_clob||f_xml_elemento(w_AnnoAccertamentoContabile,'p1','AnnoAccertamentoContabile','S');
w_xml_clob := w_xml_clob||f_xml_elemento(w_DescrizioneHTML,'p1','DescrizioneHTML','S');
w_xml_clob := w_xml_clob||f_xml_tag('p1','Dettagli','F');

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       WS_PAGAMENTI_pkg.ins_log(w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_next_dettagli;

function f_next_posizione_debitoria
(a_anno_pagamento	IN	varchar2
,a_progr_pagamento	IN	varchar2
)

return CLOB

IS

cursor sel_ws is
select ws.*
  from ws_pagamenti_tes_v ws
 where ws.count_da_inviare > 0
   and ws.tabella_rif      = 'CERCEM'
   and ws.anno_pagamento   = a_anno_pagamento
   and ws.progr_pagamento  = a_progr_pagamento
;

cursor sel_cem is
select cem.*
  from cercem cem
     , ws_pagamenti ws
 where cem.annullamento    is null
   and nvl(cem.segreteria,0) + nvl(cem.stato_civile,0) + nvl(cem.carta_identita,0) + nvl(cem.rimborso_st,0) + nvl(cem.bollo,0) > 0
   and cem.anno_emissione      = ws.anno_rif
   and cem.progr_emissione     = ws.progr_rif
   and ws.flag_invio_ws        is null
   and ws.tabella_rif          = 'CERCEM'
   and ws.anno_pagamento       = a_anno_pagamento
   and ws.progr_pagamento      = a_progr_pagamento
 order by ws.anno_rif, ws.progr_rif
;

w_Descrizione			varchar2(255);
w_annoImposta			varchar2(255);
w_Numero			varchar2(255);
w_Sezionale			varchar2(255);
w_Note				varchar2(255);
w_RiferimentoPraticaEsterna	varchar2(255);
w_ImportoDovuto			varchar2(255);
w_Annullato			varchar2(255) := 'false';
w_GestioneIva			varchar2(255) := 'false';
w_CodiceSottoservizio		varchar2(255);

w_cognome			varchar2(255);
w_nome				varchar2(255);
w_cod_fiscale			varchar2(255);
w_nazionalita			varchar2(255);
w_indirizzo_mail		varchar2(255);
w_des_com_res			varchar2(255);
w_sigla_pro_res			varchar2(255);
w_cap_res			varchar2(255);
w_indirizzo_res			varchar2(255);
w_num_civ_res			varchar2(255);
w_suffisso_res			varchar2(255);

w_id_operazione_anpr		number;
w_parametri_anpr		varchar2(255);
w_des_com_anpr			varchar2(255);
w_sigla_pro_anpr		varchar2(255);
w_cap_anpr			varchar2(255);
w_indirizzo_anpr		varchar2(255);
w_num_civ_anpr			varchar2(255);
w_suffisso_anpr			varchar2(255);

w_des_certificato     		varchar2(255);
w_des_diritto     		varchar2(255);
w_voce_di_costo			varchar2(255);

w_AllegaDocumentoDebitorio	varchar2(255) := 'false';
w_AllegaDocumentoDiPagamento	varchar2(255) := 'false';

w_IdentificativoOperatore	varchar2(255);
w_Modalita			varchar2(255);
w_RiferimentoPagamento		varchar2(255);
w_Importo			varchar2(255);
w_DataVersamento		varchar2(255);
w_Note2				varchar2(255);
w_EseguiInBackground 		varchar2(255);

w_next_conf                     varchar2(255) := rtrim(f_valore_inp('NEXT_CONF',1,1,'X','S'));

w_xml_clob		clob;

w_operazione_log	varchar2(255) := 'xml_dettaglio';

w_errore		varchar2(255);
errore			exception;

begin
 for rec_ws in sel_ws loop
--     WS_PAGAMENTI_pkg.ins_log(w_operazione_log, 'anno '||rec_ws.anno_emissione_min||' - progr '||rec_ws.progr_emissione_min, w_xml_clob);
     begin
       w_cognome	:= f_WSPA_get_pagatore(rec_ws.anno_emissione_min,rec_ws.progr_emissione_min,'COGNOME');
       w_nome		:= f_WSPA_get_pagatore(rec_ws.anno_emissione_min,rec_ws.progr_emissione_min,'NOME');
       w_cod_fiscale	:= f_WSPA_get_pagatore(rec_ws.anno_emissione_min,rec_ws.progr_emissione_min,'COD_FISCALE');
       w_nazionalita	:= '';
       w_indirizzo_mail	:= '';

       w_id_operazione_anpr := '';
       ANPCIU_NR(w_id_operazione_anpr,'3002');
       w_parametri_anpr     := rpad(nvl(w_cod_fiscale,' '),16,' ')||
                               rpad(nvl(w_cognome,' '),100,' ')||
                               rpad(nvl(w_nome,' '),100,' ')||
                               rpad('0',7,'0')||
                               rpad('0',7,'0');
       begin
         insert into anpciu_par (id_operazione, cod_fiscale, cognome, nome, data_rif)
         values (w_id_operazione_anpr, w_cod_fiscale, w_cognome, w_nome, to_char(sysdate,'j'))
         ;
         insert into anpciu (id_operazione, servizio, tipo_operazione, archivio_rif, matricola, note, terminalista)
         values (w_id_operazione_anpr, '3002', 'C', 'ANPR', f_tabrep_terminale(), w_parametri_anpr, rec_ws.terminalista)
         ;
       end;
       commit;

       begin
         select anp.res_nomeComune
              , anp.res_siglaProvinciaIstat
              , anp.res_cap
              , anp.res_specie||' '||anp.res_denominazioneToponimo
              , anp.res_numero
              , anp.res_lettera
           into w_des_com_anpr
              , w_sigla_pro_anpr
              , w_cap_anpr
              , w_indirizzo_anpr
              , w_num_civ_anpr
              , w_suffisso_anpr
           from anpana anp
          where id_operazione = w_id_operazione_anpr
            and rownum = 1
         ;
       exception
         when others then
              w_des_com_anpr   := '';
              w_sigla_pro_anpr := '';
              w_cap_anpr       := '';
              w_indirizzo_anpr := '';
              w_num_civ_anpr   := '';
              w_suffisso_anpr  := '';
       end;

       if w_des_com_anpr   is not null and
          w_sigla_pro_anpr is not null and
          w_cap_anpr       is not null and
          w_indirizzo_anpr is not null
       then
          w_des_com_res		:= w_des_com_anpr;
          w_sigla_pro_res	:= w_sigla_pro_anpr;
          w_cap_res		:= w_cap_anpr;
          w_indirizzo_res	:= w_indirizzo_anpr;
          w_num_civ_res		:= w_num_civ_anpr;
          w_suffisso_res	:= w_suffisso_anpr;
          WS_PAGAMENTI_pkg.ins_log(w_operazione_log, 'ws ANPR: ok ('||w_id_operazione_anpr||')', '');
       else
          w_des_com_res		:= f_WSPA_get_pagatore(rec_ws.anno_emissione_min,rec_ws.progr_emissione_min,'DES_COM_RES');
          w_sigla_pro_res	:= f_WSPA_get_pagatore(rec_ws.anno_emissione_min,rec_ws.progr_emissione_min,'SIGLA_PRO_RES');
          w_cap_res		:= f_WSPA_get_pagatore(rec_ws.anno_emissione_min,rec_ws.progr_emissione_min,'CAP_RES');
          w_indirizzo_res	:= f_WSPA_get_pagatore(rec_ws.anno_emissione_min,rec_ws.progr_emissione_min,'INDIRIZZO_RES');
          w_num_civ_res		:= f_WSPA_get_pagatore(rec_ws.anno_emissione_min,rec_ws.progr_emissione_min,'NUM_CIV_RES');
          w_suffisso_res	:= f_WSPA_get_pagatore(rec_ws.anno_emissione_min,rec_ws.progr_emissione_min,'SUFFISSO_RES');
          WS_PAGAMENTI_pkg.ins_log(w_operazione_log, 'ws ANPR: ko ('||w_id_operazione_anpr||')', '');
       end if;
     exception
       when others then
            w_cognome		:= '';
            w_nome		:= '';
            w_cod_fiscale	:= '';
            w_nazionalita	:= '';
            w_indirizzo_mail	:= '';
            w_des_com_res	:= '';
            w_sigla_pro_res	:= '';
            w_cap_res		:= '';
            w_indirizzo_res	:= '';
            w_num_civ_res	:= '';
            w_suffisso_res	:= '';
     end;


w_xml_clob := w_xml_clob||f_xml_tag('p1','PosizioneDebitoria','I');
     w_descrizione := rec_ws.cod_fiscale_pagatore||' - RICHIESTE: '||rec_ws.tot_documenti;
w_xml_clob := w_xml_clob||f_xml_elemento(w_Descrizione,'p1','Descrizione','S');
     w_annoImposta := a_anno_pagamento;
w_xml_clob := w_xml_clob||f_xml_elemento(w_AnnoImposta,'p1','AnnoImposta','');
     w_numero      := a_progr_pagamento;
w_xml_clob := w_xml_clob||f_xml_elemento(w_Numero,'p1','Numero','');
w_xml_clob := w_xml_clob||f_xml_elemento(w_Sezionale,'p1','Sezionale','S');
w_xml_clob := w_xml_clob||f_xml_elemento(w_Note,'p1','Note','S');
     w_RiferimentoPraticaEsterna := substr(rec_ws.tabella_rif,4)||'_'||a_progr_pagamento||'_'||a_anno_pagamento;
w_xml_clob := w_xml_clob||f_xml_elemento(w_RiferimentoPraticaEsterna,'p1','RiferimentoPraticaEsterna','S');
     w_importoDovuto := f_importo(rec_ws.tot_diritti);
w_xml_clob := w_xml_clob||f_xml_elemento(w_ImportoDovuto,'p1','ImportoDovuto','S');
w_xml_clob := w_xml_clob||f_xml_elemento(w_Annullato,'p1','Annullato','');
w_xml_clob := w_xml_clob||f_xml_elemento(w_GestioneIva,'p1','GestioneIva','');
w_xml_clob := w_xml_clob||f_xml_elemento(w_CodiceSottoservizio,'p1','CodiceSottoservizio','S');
w_xml_clob := w_xml_clob||f_next_soggetto('SoggettoVersante',w_cognome,w_nome,w_cod_fiscale,w_indirizzo_mail,w_nazionalita,w_des_com_res,w_sigla_pro_res,w_cap_res,w_indirizzo_res,w_num_civ_res,w_suffisso_res);
w_xml_clob := w_xml_clob||f_next_soggetto('SoggettoPagatore',w_cognome,w_nome,w_cod_fiscale,w_indirizzo_mail,w_nazionalita,w_des_com_res,w_sigla_pro_res,w_cap_res,w_indirizzo_res,w_num_civ_res,w_suffisso_res);

     for rec_cem in sel_cem loop
         w_des_certificato := rec_cem.cod_certificato||' - '||rec_cem.cognome_nome;
         if nvl(rec_cem.segreteria,0) > 0 then
            w_des_diritto := f_next_des_diritto(rec_cem.cod_certificato,1);
            w_voce_di_costo := f_next_voce_di_costo(rec_cem.cod_certificato,1,rec_cem.modalita_rilascio);
w_xml_clob := w_xml_clob||f_next_dettagli(w_des_certificato,w_des_diritto,'Servizi','1',rec_cem.segreteria,w_voce_di_costo);
         end if;
         if nvl(rec_cem.stato_civile,0) > 0 then
            w_des_diritto   := f_next_des_diritto(rec_cem.cod_certificato,2);
            w_voce_di_costo := f_next_voce_di_costo(rec_cem.cod_certificato,2,rec_cem.modalita_rilascio);
w_xml_clob := w_xml_clob||f_next_dettagli(w_des_certificato,w_des_diritto,'Servizi','1',rec_cem.stato_civile,w_voce_di_costo);
         end if;
         if nvl(rec_cem.carta_identita,0) > 0 then
            w_des_diritto   := f_next_des_diritto(rec_cem.cod_certificato,3);
            w_voce_di_costo := f_next_voce_di_costo(rec_cem.cod_certificato,3,rec_cem.modalita_rilascio);
w_xml_clob := w_xml_clob||f_next_dettagli(w_des_certificato,w_des_diritto,'Servizi','1',rec_cem.carta_identita,w_voce_di_costo);
         end if;
         if nvl(rec_cem.rimborso_st,0) > 0 then
            w_des_diritto   := f_next_des_diritto(rec_cem.cod_certificato,4);
            w_voce_di_costo := f_next_voce_di_costo(rec_cem.cod_certificato,4,rec_cem.modalita_rilascio);
w_xml_clob := w_xml_clob||f_next_dettagli(w_des_certificato,w_des_diritto,'Servizi','1',rec_cem.rimborso_st,w_voce_di_costo);
         end if;
         if nvl(rec_cem.bollo,0) > 0 then
            w_des_diritto   := f_next_des_diritto(rec_cem.cod_certificato,9);
            w_voce_di_costo := f_next_voce_di_costo(rec_cem.cod_certificato,9,rec_cem.modalita_rilascio);
w_xml_clob := w_xml_clob||f_next_dettagli(w_des_certificato,w_des_diritto,'Servizi','1',rec_cem.bollo,w_voce_di_costo);
         end if;
      end loop;

w_xml_clob := w_xml_clob||f_xml_elemento(w_AllegaDocumentoDebitorio,'p1','AllegaDocumentoDebitorio','S');
w_xml_clob := w_xml_clob||f_xml_elemento(w_AllegaDocumentoDiPagamento,'p1','AllegaDocumentoDiPagamento','S');
w_xml_clob := w_xml_clob||f_xml_tag('p1','PosizioneDebitoria','F');
      w_identificativoOperatore := f_next_operatore(rec_ws.terminalista);
w_xml_clob := w_xml_clob||f_xml_elemento(w_IdentificativoOperatore,'p1','IdentificativoOperatore','');
         w_modalita := f_next_modalita(rec_ws.tipo_pagamento);
w_xml_clob := w_xml_clob||f_xml_elemento(w_Modalita,'p1','Modalita','S');
w_xml_clob := w_xml_clob||f_xml_elemento(w_RiferimentoPagamento,'p1','RiferimentoPagamentoImportato','');
         w_importo := f_importo(rec_ws.tot_diritti);
w_xml_clob := w_xml_clob||f_xml_elemento(w_Importo,'p1','Importo','S');
         w_dataVersamento := f_next_data(rec_ws.data_reg);
w_xml_clob := w_xml_clob||f_xml_elemento(w_DataVersamento,'p1','DataVersamento','S');
w_xml_clob := w_xml_clob||f_xml_elemento(w_Note2,'p1','Note','');
         if nvl(w_next_conf,'N') = 'S' then
            w_EseguiInBackground := 'false';
         else
            w_EseguiInBackground := 'true';
         end if;
w_xml_clob := w_xml_clob||f_xml_elemento(w_EseguiInBackground,'p1','EseguiInBackgroundQuandoPossibile','S');
  end loop;

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       WS_PAGAMENTI_pkg.ins_log(w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_next_posizione_debitoria;

function f_next_posizioni_in_attesa
(a_anno_emissione	IN	varchar2
,a_progr_emissione	IN	varchar2
)

return CLOB

IS

w_urlBack		varchar2(255) := rtrim(f_valore_inp('NEXT_URLKO',1,255,'X',''));
w_urlReturn		varchar2(255) := rtrim(f_valore_inp('NEXT_URLOK',1,255,'X',''));

w_xml_clob		clob;

w_operazione_log	varchar2(255) := 'xml_posizioni_in_attesa';

w_errore		varchar2(255);
errore			exception;

begin
w_xml_clob := '<p1:InserisciPosizioniInAttesaQuietanzamentoRequest xmlns:p1="http://entranext.it/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://entranext.it/">'||chr(10);
w_xml_clob := w_xml_clob||f_xml_elemento(w_UrlBack,'p1','UrlBack','S');
w_xml_clob := w_xml_clob||f_xml_elemento(w_UrlReturn,'p1','UrlReturn','');
w_xml_clob := w_xml_clob||f_next_posizione_debitoria(a_anno_emissione,a_progr_emissione);
w_xml_clob := w_xml_clob||f_xml_tag('p1','InserisciPosizioniInAttesaQuietanzamentoRequest','F');

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       WS_PAGAMENTI_pkg.ins_log(w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_next_posizioni_in_attesa;

function f_next_envelope
(a_header		IN	clob
,a_body			IN	clob
)

return CLOB

IS

w_xml_clob		clob;

w_operazione_log	varchar2(255) := 'f_next_envelope';

w_errore		varchar2(255);
errore			exception;

begin
w_xml_clob := '<?xml version="1.0" encoding="utf-8"?>'||chr(10);
w_xml_clob := w_xml_clob||'<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'||chr(10);
w_xml_clob := w_xml_clob||f_xml_tag('soap','Header','I');
  if a_header is not null then
w_xml_clob := w_xml_clob||a_header;
  end if;
w_xml_clob := w_xml_clob||f_xml_tag('soap','Header','F');
w_xml_clob := w_xml_clob||f_xml_tag('soap','Body','I');
w_xml_clob := w_xml_clob||a_body;
w_xml_clob := w_xml_clob||f_xml_tag('soap','Body','F');
w_xml_clob := w_xml_clob||f_xml_tag('soap','Envelope','F');

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       WS_PAGAMENTI_pkg.ins_log(w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_next_envelope;

function f_importo
(a_importo		IN	varchar2
)

return varchar2

IS

w_decimali		varchar2(255);
w_importo 		varchar2(255);

w_operazione_log	varchar2(255) := 'f_importo';

w_errore		varchar2(255);
errore			exception;

begin
  if a_importo is not null then
     if instr(a_importo,'.') > 0 then
        w_decimali := substr(a_importo,instr(a_importo,'.')+1);
        if a_importo like '.%' then
           w_importo := '0.'||rpad(w_decimali,2,'0');
        else
           w_importo := substr(a_importo,1,instr(a_importo,'.'))||rpad(w_decimali,2,'0');
        end if;
     elsif instr(a_importo,',') > 0 then
        w_decimali := substr(a_importo,instr(a_importo,',')+1);
        if a_importo like ',%' then
           w_importo := '0,'||rpad(w_decimali,2,'0');
        else
           w_importo := substr(a_importo,1,instr(a_importo,','))||rpad(w_decimali,2,'0');
        end if;
        w_importo := replace(w_importo,',','.');
     else
        w_importo := a_importo||'.00';
     end if;
  end if;

  return w_importo;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       WS_PAGAMENTI_pkg.ins_log(w_operazione_log, w_errore, a_importo);
       return w_importo;
end f_importo;

function f_next_data
(a_data		IN	varchar2
)

return varchar2

IS

w_data	 		varchar2(255);

w_operazione_log	varchar2(255) := 'f_data';

w_errore		varchar2(255);
errore			exception;

begin
  if a_data is not null then
     w_data := to_char(to_date(a_data,'j'),'yyyy-mm-dd"T"hh24:mi:ss');
  end if;

  return w_data;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       WS_PAGAMENTI_pkg.ins_log(w_operazione_log, w_errore, a_data);
       return w_data;
end f_next_data;

function  f_next_des_diritto
(a_cod_certificato	IN	varchar2
,a_cod_diritto          IN	number
)

return varchar2

IS

w_des_diritto 		varchar2(255);

w_operazione_log	varchar2(255) := 'f_des_diritto';

w_errore		varchar2(255);
errore			exception;

begin
  if a_cod_certificato is not null then
     begin
       select descrizione
         into w_des_diritto
         from cerdtd dtd
            , cerddc ddc
        where dtd.cod_diritto       = ddc.cod_diritto
          and dtd.fascia_tariffaria = ddc.fascia_tariffaria
          and ddc.cod_certificato   = a_cod_certificato
          and ddc.cod_diritto       = a_cod_diritto
          and rownum = 1
       ;
     exception
       when others then
            w_des_diritto := '';
     end;
  end if;

  if w_des_diritto is null then
     if a_cod_diritto = 1 then
        w_des_diritto := 'Diritti di Segreteria';
     elsif a_cod_diritto = 2 then
        w_des_diritto := 'Diritti di Stato Civile';
     elsif a_cod_diritto = 3 then
        w_des_diritto := 'Diritti per Carta di Identita';
     elsif a_cod_diritto = 4 then
        w_des_diritto := 'Rimborso Stampati';
     elsif a_cod_diritto = 9 then
        w_des_diritto := 'Bollo';
     end if;
  end if;

  return w_des_diritto;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       WS_PAGAMENTI_pkg.ins_log(w_operazione_log, w_errore, a_cod_certificato||'-'||a_cod_diritto);
       return w_des_diritto;
end f_next_des_diritto;

function  f_next_voce_di_costo
(a_cod_certificato	IN	varchar2
,a_cod_diritto          IN	number
,a_modalita_rilascio    IN	number
)

return varchar2

IS

w_flag_bollo		varchar2(255);
w_voce_di_costo		varchar2(255);

w_operazione_log	varchar2(255) := 'f_voce_di_costo';

w_errore		varchar2(255);
errore			exception;

begin
  if a_modalita_rilascio is null then
     goto fine;
  end if;

  begin
    select decode(dri.fascia_tariffaria,'','N','S')
      into w_flag_bollo
      from cerdri dri
     where cod_ri = a_modalita_rilascio
    ;
  exception
    when others then
         w_flag_bollo := 'N';
  end;

  if a_cod_certificato is not null and a_cod_diritto is not null  then
     if a_cod_diritto != 9 then
        begin
          select decode(w_flag_bollo,'S',vdc.codice_vdc_2,vdc.codice_vdc_1)
            into w_voce_di_costo
            from ws_pagamenti_vdc vdc
               , cerddc ddc
           where vdc.cod_diritto_rif       = ddc.cod_diritto
             and vdc.fascia_tariffaria_rif = ddc.fascia_tariffaria
             and ddc.cod_certificato       = a_cod_certificato
             and ddc.cod_diritto           = a_cod_diritto
             and rownum = 1
          ;
        exception
          when others then
               w_voce_di_costo := '';
        end;

     elsif a_cod_diritto = 9 then
        begin
          select vdc.codice_vdc_1
            into w_voce_di_costo
            from ws_pagamenti_vdc vdc
               , cerdri dri
           where vdc.cod_diritto_rif       = a_cod_diritto
             and vdc.fascia_tariffaria_rif = dri.fascia_tariffaria
             and dri.cod_ri                = a_modalita_rilascio
             and rownum = 1
          ;
        exception
          when others then
               w_voce_di_costo := '';
        end;

     end if;
  end if;

<< fine >>

  return w_voce_di_costo;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       WS_PAGAMENTI_pkg.ins_log(w_operazione_log, w_errore, a_cod_certificato||'-'||a_cod_diritto);
       return w_voce_di_costo;
end f_next_voce_di_costo;

function f_next_modalita
(a_tipo_pagamento	IN	varchar2
)

return varchar2

IS

w_modalita 		varchar2(255);

w_operazione_log	varchar2(255) := 'f_modalita';

w_errore		varchar2(255);
errore			exception;

begin
-- <s:enumeration value="Nessuna"/>
-- <s:enumeration value="CassaContanti"/>
-- <s:enumeration value="CassaBancomat"/>
-- <s:enumeration value="CassaCartaDiCredito"/>
-- <s:enumeration value="Prepagato"/>
-- <s:enumeration value="POS"/>
-- <s:enumeration value="PosPagoPA"/>
  if a_tipo_pagamento is not null then
     if a_tipo_pagamento = 1 then
        w_modalita := 'CassaContanti';
     elsif a_tipo_pagamento = 2 then
        w_modalita := 'POS';
     elsif a_tipo_pagamento = 3 then
        w_modalita := 'PosPagoPA';
     else
        w_modalita := 'NonCodificato';
     end if;
  else
     w_modalita := 'Nessuna';
  end if;

  return w_modalita;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       WS_PAGAMENTI_pkg.ins_log(w_operazione_log, w_errore, a_tipo_pagamento);
       return w_modalita;
end f_next_modalita;

function f_next_operatore
(a_terminalista		IN	varchar2
)

return varchar2

IS

w_operatore		varchar2(255);

w_operazione_log	varchar2(255) := 'f_operatore';

w_errore		varchar2(255);
errore			exception;

begin
  if a_terminalista is not null then
     begin
       select ws.identificativo_provider
         into w_operatore
         from ws_pagamenti_ute ws
        where cod_utente = a_terminalista
          and rownum = 1
       ;
     exception
       when no_data_found then
            w_operatore := rtrim(f_valore_inp('NEXT_OPE',1,255,'X',''));
       when others then
            w_operatore := '';
     end;
  end if;

  return w_operatore;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       WS_PAGAMENTI_pkg.ins_log(w_operazione_log, w_errore, a_terminalista);
       return w_operatore;
end f_next_operatore;

function ws_cerca_tag
(a_campo_clob		IN	clob
,a_tag			IN	varchar2
)

return varchar2

IS

w_tag			varchar2(255);
w_return		varchar2(4000);

w_operazione_log	varchar2(255) := 'ws_cerca_tag';

w_errore		varchar2(255);
errore			exception;

begin
  if a_campo_clob is not null and a_tag is not null then
     w_tag := a_tag||'>';
     if instr(a_campo_clob,w_tag) > 0 then
        w_return := substr(a_campo_clob,instr(a_campo_clob,w_tag)+length(w_tag));
        w_return := substr(w_return,1,instr(w_return,'<')-1);
     else
        w_return := '';
     end if;
  end if;

  return w_return;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       WS_PAGAMENTI_pkg.ins_log(w_operazione_log, w_errore, w_tag);
       return w_return;
end ws_cerca_tag;

procedure ws_next_response
(a_campo_clob		IN	clob
,w_flag_errore		IN OUT	varchar2
,w_messaggio		IN OUT	varchar2
,w_url_conferma		IN OUT	varchar2
)

IS

w_esito			varchar2(4000);

w_operazione_log	varchar2(255) := 'ws_next_response';

w_errore		varchar2(255);
errore			exception;

begin

  if a_campo_clob is null then
     w_errore := 'response vuota';
  else
     w_esito  := ws_cerca_tag(a_campo_clob,'Esito');
     if w_esito IN ('OK','PAGATO') then
        w_flag_errore  := '';
        w_messaggio    := ws_cerca_tag(a_campo_clob,'Descrizione');
        w_url_conferma := ws_cerca_tag(a_campo_clob,'Url');
        WS_PAGAMENTI_pkg.ins_log(w_operazione_log, w_esito, w_messaggio);
        WS_PAGAMENTI_pkg.ins_log(w_operazione_log, 'url_conferma', w_url_conferma);
     else
        w_flag_errore  := 'S';
        w_url_conferma := '';
        if w_esito is not null then
           w_messaggio   := ws_cerca_tag(a_campo_clob,'Descrizione');
           WS_PAGAMENTI_pkg.ins_log(w_operazione_log, w_esito, w_messaggio);
        else
           w_esito       := ws_cerca_tag(a_campo_clob,'faultcode');
           if w_esito is not null then
              w_messaggio  := ws_cerca_tag(a_campo_clob,'faultstring');
              WS_PAGAMENTI_pkg.ins_log(w_operazione_log, w_esito, w_messaggio);
           else
              w_messaggio  := 'errore';
              WS_PAGAMENTI_pkg.ins_log(w_operazione_log, 'errore', a_campo_clob);
           end if;
        end if;
     end if;
  end if;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       WS_PAGAMENTI_pkg.ins_log(w_operazione_log, w_errore, a_campo_clob);
end ws_next_response;

function ws_request
(a_service_url 		IN	varchar2
,a_service_name 	IN	varchar2
,a_service_ns 		IN	varchar2
,a_soap_request 	IN	clob
,a_service_timeout 	IN	number default 600
,a_username		IN	varchar2 default NULL
,a_password		IN	varchar2 default NULL
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

w_operazione_log	varchar2(255) := 'ws_request';

w_errore		varchar2(4000);
errore			exception;

begin
  WS_PAGAMENTI_pkg.ins_log(w_operazione_log, 'URL', a_service_url);
  WS_PAGAMENTI_pkg.ins_log(w_operazione_log, 'request', a_soap_request);

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

w_step := 4;
  utl_http.set_header(http_request, 'Content-Type', 'text/xml');
w_step := 5;
  utl_http.set_header(http_request, 'Content-Length', length(w_soap_request));
--  utl_http.set_header(http_request, 'SOAPAction', a_service_ns||'/'||a_service_name);
  utl_http.set_header(http_request, 'SOAPAction', a_service_name);

  utl_http.set_authentication(http_request, a_username, a_password);

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

w_step := 11;
  WS_PAGAMENTI_pkg.ins_log(w_operazione_log, 'response', soap_response);
  out_xml:= xmltype(soap_response);
w_step := 12;
  out_xml_clob	:= xmltype.getclobval(out_xml);

  return out_xml_clob;
exception
  when others then
       w_errore := 'exception ('||SQLERRM||')';
       WS_PAGAMENTI_pkg.ins_log(w_operazione_log, a_service_url, w_step||'. '||w_errore);
end ws_request;

procedure ws_attivazione
(a_anno_pagamento	IN	number
,a_progr_pagamento	IN	number
,w_flag_errore		IN OUT	varchar2
,w_messaggio		IN OUT  varchar2
,w_url_conferma		IN OUT	varchar2
)

IS

w_count_da_inviare   	number := 0;
w_count_inviati      	number := 0;
w_count_da_annullare 	number := 0;

w_provider		varchar2(255);

w_operazione_log	varchar2(255) := 'ws_attivazione';

w_errore		varchar2(4000);
errore			exception;

begin
  ws_pagamenti_pkg.DATI_CLIENTE;

  begin
    select ws.count_inviati
         , ws.count_da_inviare
         , ws.count_da_annullare
      into w_count_inviati, w_count_da_inviare, w_count_da_annullare
      from ws_pagamenti_tes_v ws
     where anno_pagamento = a_anno_pagamento
       and progr_pagamento = a_progr_pagamento
    ;
  exception
    when others then
         w_count_da_inviare   := 0;
         w_count_inviati      := 0;
         w_count_da_annullare := 0;
  end;

  if w_count_da_inviare = 0 then
     if w_count_inviati > 0 then
        if w_count_da_annullare > 0 then
           w_flag_errore := 'S';
           w_messaggio   := 'Funzione di Annullamento Pagamento non disponibile ('||a_progr_pagamento||'/'||a_anno_pagamento||')';
        else
           w_flag_errore := 'S';
           w_messaggio   := 'Pagamento giÃ  inviato ('||a_progr_pagamento||'/'||a_anno_pagamento||')';
        end if;
     else
        w_flag_errore := 'S';
        w_messaggio   := 'Nessun debito associato al Pagamento  ('||a_progr_pagamento||'/'||a_anno_pagamento||')';
     end if;
     raise errore;
  end if;

  w_provider := f_WSPA_get_provider();

  if w_provider = 'NEXTSTEP' then
     ws_pagamenti_pkg.ws_nextstep(a_anno_pagamento,a_progr_pagamento,w_flag_errore,w_messaggio,w_url_conferma);

  elsif w_provider = 'DEPAG' then
     ws_pagamenti_pkg.ws_depag(a_anno_pagamento,a_progr_pagamento,'AGGIORNA_DOVUTO','',w_flag_errore,w_messaggio,w_url_conferma);

  else
     w_errore := 'Integrazione pagamenti non gestita ('||w_provider||')';
     raise errore;

  end if;

exception
  when errore then
       w_flag_errore  := 'S';
       w_errore       := w_messaggio;
       w_url_conferma := '';
       WS_PAGAMENTI_pkg.ins_log(w_operazione_log, 'errore', w_errore);
  when others then
       w_errore       := 'exception ('||SQLERRM||')';
       w_flag_errore  := 'S';
       w_messaggio    := w_errore;
       w_url_conferma := '';
       WS_PAGAMENTI_pkg.ins_log(w_operazione_log, 'errore', w_errore);
end ws_attivazione;

procedure ws_nextstep
(a_anno_pagamento	IN	number
,a_progr_pagamento	IN	number
,w_flag_errore		IN OUT	varchar2
,w_messaggio		IN OUT  varchar2
,w_url_conferma		IN OUT	varchar2
)

IS

w_provider		varchar2(255);

w_service_url 		varchar2(4000) := f_valore_inp('WS_CLIENT',1,255,'X','');
w_service_name 	 	varchar2(255);
w_service_ns 		varchar2(255);

w_header_clob		clob;
w_body_clob		clob;
w_request_clob		clob;
w_response_clob		clob;

w_esito			varchar2(255);
w_tokenAuth		varchar2(4000);

w_chiave_provider       varchar2(255);
w_url_provider    	varchar2(255);

w_operazione_log	varchar2(255) := 'ws_nextstep';

w_errore		varchar2(4000);
errore			exception;

begin
--
-- credenziali di TEST
-- Identificativo connettore	: EntraNext_CSV
-- Codice fiscale Ente		: 00202280343
-- Versione			: 1.6.9
-- Identificativo		: T001
-- Username			: ads
-- Password (giÃ  in MD5)	: 0e99762d1d5a00384de6218fd30d12fe
-- Endpoint Collaudo (1)	: https://wsmastertest.entranext.it/LinkNext.asmx
-- Endpoint Collaudo (2)	: https://hostingwstest.entranext.it/LinkNext.asmx
--
  w_service_url := w_service_url||'/BridgeServletHttps?'||
                   'absoluteStore=true'||
                   '&trustStoreName=webapps/sa4WSclientV2/temp/wsNextStep.jks'||
                   '&trustStorePassword=lavoro17'||
                   '&keyStoreName=webapps/sa4WSclientV2/temp/wsNextStep.jks'||
                   '&keyStorePassword=lavoro17'||
                   '&keyPassword=lavoro17'||
                   '&URL='||rtrim(f_valore_inp('NEXT_URL',1,255,'X',''));

<< loginRequest >>
  w_service_name := 'Login';

  w_header_clob  := f_next_intestazioneFO('');
  w_body_clob    := f_next_loginRequest();
  w_request_clob := f_next_envelope(w_header_clob,w_body_clob);

  w_response_clob := WS_PAGAMENTI_pkg.ws_request(w_service_url,w_service_name,w_service_ns,w_request_clob);

  ws_next_response(w_response_clob,w_flag_errore,w_messaggio,w_url_conferma);
  if w_flag_errore is null then
     w_tokenAuth   := ws_cerca_tag(w_response_clob,'TokenAuth');
  else
     w_tokenAuth   := '';
     raise errore;
  end if;

<< posizioniInAttesa >>
  w_service_name := 'InserisciPosizioniInAttesaQuietanzamento';

  if w_tokenAuth is not null then
     w_header_clob  := f_next_intestazioneFO(w_tokenAuth);
     w_body_clob    := f_next_posizioni_in_attesa(a_anno_pagamento,a_progr_pagamento);
     w_request_clob := f_next_envelope(w_header_clob,w_body_clob);

     w_response_clob := WS_PAGAMENTI_pkg.ws_request(w_service_url,w_service_name,w_service_ns,w_request_clob);

     ws_next_response(w_response_clob,w_flag_errore,w_messaggio,w_url_conferma);
     w_tokenAuth := '';
     if w_flag_errore is not null then
        begin
          update ws_pagamenti_tes
             set flag_invio_ws = ''
               , data_invio_ws = to_char(sysdate,'j')
               , note_ws       = w_messaggio
           where anno_pagamento  = a_anno_pagamento
             and progr_pagamento = a_progr_pagamento
          ;
          update ws_pagamenti
             set flag_invio_ws = ''
               , data_invio_ws = to_char(sysdate,'j')
               , note_ws       = w_messaggio
           where anno_pagamento  = a_anno_pagamento
             and progr_pagamento = a_progr_pagamento
          ;
        exception
          when others then
               null;
        end;
        raise errore;

     else
        w_chiave_provider := ws_cerca_tag(w_response_clob,'IdentificativoTransazione');
        w_url_provider    := ws_cerca_tag(w_response_clob,'Url');
        WS_PAGAMENTI_pkg.ins_log(w_operazione_log, 'chiave_prov', w_chiave_provider);
        WS_PAGAMENTI_pkg.ins_log(w_operazione_log, 'url_prov', w_url_provider);
        begin
          update ws_pagamenti_tes
             set flag_invio_ws = 'S'
               , data_invio_ws = to_char(sysdate,'j')
               , note_ws       = w_messaggio
               , chiave_provider = w_chiave_provider
               , url_provider    = w_url_provider
           where anno_pagamento  = a_anno_pagamento
             and progr_pagamento = a_progr_pagamento
          ;
          update ws_pagamenti
             set flag_invio_ws = 'S'
               , data_invio_ws = to_char(sysdate,'j')
               , note_ws       = w_messaggio
               , chiave_provider = w_chiave_provider
               , url_provider    = w_url_provider
           where anno_pagamento  = a_anno_pagamento
             and progr_pagamento = a_progr_pagamento
          ;
        exception
          when others then
               null;
        end;
     end if;

  end if;

exception
  when errore then
       w_flag_errore  := 'S';
       w_errore       := w_messaggio;
       w_url_conferma := '';
       WS_PAGAMENTI_pkg.ins_log(w_operazione_log, 'errore', w_errore);
  when others then
       w_errore       := 'exception ('||SQLERRM||')';
       w_flag_errore  := 'S';
       w_messaggio    := w_errore;
       w_url_conferma := '';
       WS_PAGAMENTI_pkg.ins_log(w_operazione_log, 'errore', w_errore);
end ws_nextstep;

procedure ws_depag
(a_anno_pagamento	IN	number
,a_progr_pagamento	IN	number
,a_servizio		IN  	varchar2
,a_iuv			IN  	varchar2
,w_flag_errore		IN OUT	varchar2
,w_messaggio		IN OUT  varchar2
,w_url_conferma		IN OUT	varchar2
)

IS

w_provider		varchar2(255);

w_service_url 		varchar2(4000) := f_valore_inp('WS_CLIENT',1,255,'X','');
w_service_name 	 	varchar2(255);
w_service_ns 		varchar2(255);
w_username 		varchar2(4000) := f_valore_inp('DEPAG_USR',1,255,'X','');
w_password 		varchar2(4000) := f_valore_inp('DEPAG_PWD',1,255,'X','');

w_header_clob		clob;
w_body_clob		clob;
w_request_clob		clob;
w_response_clob		clob;

--w_esito			varchar2(255);
--w_tokenAuth		varchar2(4000);
w_param_clob		clob;

w_chiave_provider       varchar2(255);
w_url_provider    	varchar2(255);

w_operazione_log	varchar2(255) := 'ws_depag';

w_errore		varchar2(4000);
errore			exception;

w_step			number;

begin
--
-- credenziali di TEST
-- Endpoint 	: https://depag.e-pal.it/PagamentiOnLine/services/depag
--
  w_service_url := w_service_url||'/BridgeServletHttps?'||
--                   'absoluteStore=true'||
--                   '&trustStoreName=webapps/sa4WSclientV2/temp/wsNextStep.jks'||
--                   '&trustStorePassword=lavoro17'||
--                   '&keyStoreName=webapps/sa4WSclientV2/temp/wsNextStep.jks'||
--                   '&keyStorePassword=lavoro17'||
--                   '&keyPassword=lavoro17'||
                   'absoluteStore=false'||
                   '&permitSoapAction=true'||
                   '&doUnescapeHtml=false'||
                   '&URL='||rtrim(f_valore_inp('DEPAG_URL',1,255,'X',''));

  if a_servizio = 'AGGIORNA_DOVUTO' then
     goto aggiornaDovuto;
  elsif a_servizio = 'LEGGI_DOVUTO' then
     goto leggiDovuto;
  elsif a_servizio = 'ELIMINA_DOVUTO' then
     goto eliminaDovuto;
  else
     goto servizioNonGestito;
  end if;

<< aggiornaDovuto >>
  w_service_name := 'aggiornaDovuto';

  w_header_clob  := '';
  w_body_clob    := f_depag_aggiorna_dovuto(a_anno_pagamento,a_progr_pagamento);
  w_request_clob := f_depag_envelope(w_header_clob,w_body_clob);

  w_response_clob := WS_PAGAMENTI_pkg.ws_request(w_service_url,w_service_name,w_service_ns,w_request_clob,'',w_username,w_password);

  ws_depag_response(w_response_clob,w_flag_errore,w_messaggio,w_url_conferma,w_param_clob);

  if w_flag_errore is not null then
     WS_PAGAMENTI_pkg.ins_log(w_operazione_log, 'aggiorna_dovuto.KO', w_param_clob);
     begin
       update ws_pagamenti_tes
          set flag_invio_ws = ''
            , data_invio_ws = to_char(sysdate,'j')
            , note_ws       = w_messaggio
        where anno_pagamento  = a_anno_pagamento
          and progr_pagamento = a_progr_pagamento
       ;
       update ws_pagamenti
          set flag_invio_ws = ''
            , data_invio_ws = to_char(sysdate,'j')
            , note_ws       = w_messaggio
        where anno_pagamento  = a_anno_pagamento
          and progr_pagamento = a_progr_pagamento
       ;
     exception
       when others then
            null;
     end;
     raise errore;

  else
     WS_PAGAMENTI_pkg.ins_log(w_operazione_log, 'aggiorna_dovuto.OK', w_param_clob);
     w_chiave_provider := ws_cerca_tag(w_param_clob,'IUV');

     w_url_provider    := f_depag_get_url(w_chiave_provider);

     WS_PAGAMENTI_pkg.ins_log(w_operazione_log, 'chiave_prov', w_chiave_provider);
     WS_PAGAMENTI_pkg.ins_log(w_operazione_log, 'url_prov', w_url_provider);
     begin
       update ws_pagamenti_tes
          set flag_invio_ws = 'S'
            , data_invio_ws = to_char(sysdate,'j')
            , note_ws       = w_messaggio
            , chiave_provider = w_chiave_provider
            , url_provider    = w_url_provider
        where anno_pagamento  = a_anno_pagamento
          and progr_pagamento = a_progr_pagamento
       ;
       update ws_pagamenti
          set flag_invio_ws = 'S'
            , data_invio_ws = to_char(sysdate,'j')
            , note_ws       = w_messaggio
            , chiave_provider = w_chiave_provider
            , url_provider    = w_url_provider
        where anno_pagamento  = a_anno_pagamento
          and progr_pagamento = a_progr_pagamento
       ;
       w_url_conferma := w_url_provider;
     exception
       when others then
            null;
     end;
  end if;

  goto fine;

<< leggiDovuto >>
  w_service_name := 'leggiDovuto';

  w_header_clob  := '';
  w_body_clob    := f_depag_leggi_dovuto(a_iuv);
  w_request_clob := f_depag_envelope(w_header_clob,w_body_clob);
  w_response_clob := WS_PAGAMENTI_pkg.ws_request(w_service_url,w_service_name,w_service_ns,w_request_clob,'',w_username,w_password);
  ws_depag_response(w_response_clob,w_flag_errore,w_messaggio,w_url_conferma,w_param_clob);

  if w_flag_errore is not null then
     WS_PAGAMENTI_pkg.ins_log(w_operazione_log, 'leggi_dovuto.KO', w_param_clob);
     raise errore;
  else
     WS_PAGAMENTI_pkg.ins_log(w_operazione_log, 'leggi_dovuto.OK', w_param_clob);
     begin
       delete ws_pagamenti_wrk
        where iuv = a_iuv
       ;
     exception
       when others then
            w_errore := 'errore in eliminazione ws_pagamenti_wrk ('||a_iuv||')';
            raise errore;
     end;
     begin
       insert into ws_pagamenti_wrk
              (IUV, ESITO_OPERAZIONE, CHIAVE,
               TIPO_PAGATORE, CODICE_PAGATORE, ANAGRAFICA_PAGATORE,
               INDIRIZZO_PAGATORE, CIVICO_PAGATORE, CAP_PAGATORE, LOCALITA_PAGATORE, PROVINCIA_PAGATORE, NAZIONE_PAGATORE, EMAIL_PAGATORE,
               TIPO_DOVUTO, TIPO_VERSAMENTO, CAUSALE_VERSAMENTO, DATA_SCADENZA, IMPORTO_TOTALE,
               SV_PROGRESSIVO, SV_SERVIZIO, SV_CAUSALE, SV_IMPORTO, SV_COMMISSIONE_CARICO_PA, SV_DATI_RISCOSSIONE, SV_ACCERTAMENTO, SV_BILANCIO,
               IP_IMPORTO_PAGATO, IP_DATA_PAGAMENTO, IP_CODICE_VERSANTE, IP_ANAGRAFICA_VERSANTE, IP_IUR, IP_IUV_SPC
              )
       select a_iuv,
              ws_cerca_tag(w_param_clob,'ESITO_OPERAZIONE'),
              ws_cerca_tag(w_param_clob,'CHIAVE'),
              ws_cerca_tag(w_param_clob,'TIPO_PAGATORE'),
              ws_cerca_tag(w_param_clob,'CODICE_PAGATORE'),
              ws_cerca_tag(w_param_clob,'ANAGRAFICA_PAGATORE'),
              ws_cerca_tag(w_param_clob,'INDIRIZZO_PAGATORE'),
              ws_cerca_tag(w_param_clob,'CIVICO_PAGATORE'),
              ws_cerca_tag(w_param_clob,'CAP_PAGATORE'),
              ws_cerca_tag(w_param_clob,'LOCALITA_PAGATORE'),
              ws_cerca_tag(w_param_clob,'PROVINCIA_PAGATORE'),
              ws_cerca_tag(w_param_clob,'NAZIONE_PAGATORE'),
              ws_cerca_tag(w_param_clob,'EMAIL_PAGATORE'),
              ws_cerca_tag(w_param_clob,'TIPO_DOVUTO'),
              ws_cerca_tag(w_param_clob,'TIPO_VERSAMENTO'),
              ws_cerca_tag(w_param_clob,'CAUSALE_VERSAMENTO'),
              ws_cerca_tag(w_param_clob,'DATA_SCADENZA'),
              ws_cerca_tag(w_param_clob,'IMPORTO_TOTALE'),
              ws_cerca_tag(w_param_clob,'PROGRESSIVO'),
              ws_cerca_tag(w_param_clob,'SERVIZIO'),
              ws_cerca_tag(w_param_clob,'CAUSALE'),
              ws_cerca_tag(w_param_clob,'IMPORTO'),
              ws_cerca_tag(w_param_clob,'COMMISSIONE_CARICO_PA'),
              ws_cerca_tag(w_param_clob,'DATI_RISCOSSIONE'),
              ws_cerca_tag(w_param_clob,'ACCERTAMENTO'),
              ws_cerca_tag(w_param_clob,'BILANCIO'),
              ws_cerca_tag(w_param_clob,'IMPORTO_PAGATO'),
              ws_cerca_tag(w_param_clob,'DATA_PAGAMENTO'),
              ws_cerca_tag(w_param_clob,'CODICE_VERSANTE'),
              ws_cerca_tag(w_param_clob,'ANAGRAFICA_VERSANTE'),
              ws_cerca_tag(w_param_clob,'IUR'),
              ws_cerca_tag(w_param_clob,'IUV_SPC')
         from dual
       ;
     exception
       when others then
            w_errore := 'errore in eliminazione ws_pagamenti_wrk ('||a_iuv||')';
            raise errore;
     end;
  end if;

  goto fine;

<< eliminaDovuto >>
  w_service_name := 'eliminaDovuto';

  w_header_clob  := '';
  w_body_clob    := f_depag_elimina_dovuto(a_iuv);
  w_request_clob := f_depag_envelope(w_header_clob,w_body_clob);
  w_response_clob := WS_PAGAMENTI_pkg.ws_request(w_service_url,w_service_name,w_service_ns,w_request_clob,'',w_username,w_password);
  ws_depag_response(w_response_clob,w_flag_errore,w_messaggio,w_url_conferma,w_param_clob);

  if w_flag_errore is not null then
     WS_PAGAMENTI_pkg.ins_log(w_operazione_log, 'elimina_dovuto.KO', w_param_clob);
  else
     WS_PAGAMENTI_pkg.ins_log(w_operazione_log, 'elimina_dovuto.OK', w_param_clob);
     begin
       update ws_pagamenti_tes
          set flag_annullato = 'S'
            , note_ws        = '(ANNULLATO in data '||to_char(sysdate,'dd/mm/yyyy hh24:mi:ss')||')'||chr(10)||chr(10)||note_ws
        where anno_pagamento  = a_anno_pagamento
          and progr_pagamento = a_progr_pagamento
       ;
       update ws_pagamenti
          set flag_annullato = 'S'
            , note_ws        = '(ANNULLATO in data '||to_char(sysdate,'dd/mm/yyyy hh24:mi:ss')||')'||chr(10)||chr(10)||note_ws
        where anno_pagamento  = a_anno_pagamento
          and progr_pagamento = a_progr_pagamento
       ;
     exception
       when others then
            w_errore := 'errore in upd ('||sqlerrm||')';
            raise errore;
     end;
  end if;

  goto fine;

<< servizioNonGestito >>
   w_errore := 'servizio '||a_servizio||' non gestito';
   raise errore;

<< fine >>
null;

exception
  when errore then
       w_flag_errore  := 'S';
       w_errore       := w_messaggio;
       w_url_conferma := '';
       WS_PAGAMENTI_pkg.ins_log(w_operazione_log, 'errore', w_errore);
  when others then
       w_errore       := 'exception ('||SQLERRM||')';
       w_flag_errore  := 'S';
       w_messaggio    := w_errore;
       w_url_conferma := '';
       WS_PAGAMENTI_pkg.ins_log(w_operazione_log, 'errore', w_errore);
end ws_depag;

function f_depag_aggiorna_dovuto
(a_anno_pagamento	IN	varchar2
,a_progr_pagamento	IN	varchar2
)

return CLOB

IS

cursor sel_ws is
select ws.*
     , decode(w_codice_cliente,
         '015192',f_WSPA_get_servizio_SDM(ws.tabella_rif,cem.cod_certificato,'DEPAG',nvl(cem.segreteria,0) + nvl(cem.stato_civile,0) + nvl(cem.rimborso_st,0) + nvl(cem.carta_identita,0) + nvl(cem.bollo,0)),
                  f_WSPA_get_servizio(ws.tabella_rif,cem.cod_certificato,'DEPAG')) servizio_depag
  from cercem cem
     , ws_pagamenti_tes_v ws
 where cem.anno_emissione      = ws.anno_emissione_min
   and cem.progr_emissione     = ws.progr_emissione_min
   and ws.count_da_inviare > 0
   and ws.tabella_rif      = 'CERCEM'
   and ws.anno_pagamento   = a_anno_pagamento
   and ws.progr_pagamento  = a_progr_pagamento
;

cursor sel_cem is
select cem.*
  from cercem cem
     , ws_pagamenti ws
 where cem.annullamento    is null
   and nvl(cem.segreteria,0) + nvl(cem.stato_civile,0) + nvl(cem.carta_identita,0) + nvl(cem.rimborso_st,0) + nvl(cem.bollo,0) > 0
   and cem.anno_emissione      = ws.anno_rif
   and cem.progr_emissione     = ws.progr_rif
   and ws.flag_invio_ws        is null
   and ws.tabella_rif          = 'CERCEM'
   and ws.anno_pagamento       = a_anno_pagamento
   and ws.progr_pagamento      = a_progr_pagamento
 order by ws.anno_rif, ws.progr_rif
;

w_ente				varchar2(255) := rtrim(f_valore_inp('DEPAG_ENTE',1,255,'X',''));
w_servizio			varchar2(255) := rtrim(f_valore_inp('DEPAG_SER',1,255,'X',''));
w_des_servizio			varchar2(255) := '';

w_param_clob			clob;
w_param_b64_blob		blob;
w_param_b64_clob		clob;

w_chiave			varchar2(255);
w_tipoPagatore			varchar2(255);
w_tipoDovuto			varchar2(255);
w_causaleVersamento		varchar2(255);
w_dataScadenza			varchar2(255);
w_importoTotale			varchar2(255);
w_progressivo			number;
w_bilancio			varchar2(4000);
w_note				varchar2(4000);

w_cognome			varchar2(255);
w_nome				varchar2(255);
w_cod_fiscale			varchar2(255);
w_nazionalita			varchar2(255);
w_indirizzo_mail		varchar2(255);

w_des_com_res			varchar2(255);
w_sigla_pro_res			varchar2(255);
w_cap_res			varchar2(255);
w_indirizzo_res			varchar2(255);
w_num_civ_res			varchar2(255);
w_suffisso_res			varchar2(255);
w_civico_res			varchar2(255);

w_id_operazione_anpr		number;
w_parametri_anpr		varchar2(255);
w_des_com_anpr			varchar2(255);
w_sigla_pro_anpr		varchar2(255);
w_cap_anpr			varchar2(255);
w_indirizzo_anpr		varchar2(255);
w_num_civ_anpr			varchar2(255);
w_suffisso_anpr			varchar2(255);

w_des_certificato     		varchar2(255);
w_voce_di_costo			varchar2(255);
w_importo			varchar2(255);

w_next_conf                     varchar2(255) := rtrim(f_valore_inp('NEXT_CONF',1,1,'X','S'));

w_xml_clob		clob;

w_operazione_log	varchar2(255) := 'xml_aggiorna_dovuto';

w_errore		varchar2(255);
errore			exception;

begin

 for rec_ws in sel_ws loop
--     WS_PAGAMENTI_pkg.ins_log(w_operazione_log, 'anno '||rec_ws.anno_emissione_min||' - progr '||rec_ws.progr_emissione_min, w_xml_clob);
     begin
       w_cognome	:= f_WSPA_get_pagatore(rec_ws.anno_emissione_min,rec_ws.progr_emissione_min,'COGNOME');
       w_nome		:= f_WSPA_get_pagatore(rec_ws.anno_emissione_min,rec_ws.progr_emissione_min,'NOME');
       w_cod_fiscale	:= f_WSPA_get_pagatore(rec_ws.anno_emissione_min,rec_ws.progr_emissione_min,'COD_FISCALE');
       w_nazionalita	:= '';
       w_indirizzo_mail	:= '';

--
-- 07/10/2021 (AM)
-- evito l'interrogazione ANPR perchÃ¨ i dati di indirizzo non sono obbligatori
--
       w_id_operazione_anpr := '';
       ANPCIU_NR(w_id_operazione_anpr,'3002');
       w_parametri_anpr     := rpad(nvl(w_cod_fiscale,' '),16,' ')||
                               rpad(nvl(w_cognome,' '),100,' ')||
                               rpad(nvl(w_nome,' '),100,' ')||
                               rpad('0',7,'0')||
                               rpad('0',7,'0');
       begin
         insert into anpciu_par (id_operazione, cod_fiscale, cognome, nome, data_rif)
         values (w_id_operazione_anpr, w_cod_fiscale, w_cognome, w_nome, to_char(sysdate,'j'))
         ;
         insert into anpciu (id_operazione, servizio, tipo_operazione, archivio_rif, matricola, note, terminalista)
         values (w_id_operazione_anpr, '3002', 'C', 'ANPR', f_tabrep_terminale(), w_parametri_anpr, rec_ws.terminalista)
         ;
       end;
       commit;

       begin
         select anp.res_nomeComune
              , anp.res_siglaProvinciaIstat
              , anp.res_cap
              , anp.res_specie||' '||anp.res_denominazioneToponimo
              , anp.res_numero
              , anp.res_lettera
           into w_des_com_anpr
              , w_sigla_pro_anpr
              , w_cap_anpr
              , w_indirizzo_anpr
              , w_num_civ_anpr
              , w_suffisso_anpr
           from anpana anp
          where id_operazione = w_id_operazione_anpr
            and rownum = 1
         ;
       exception
         when others then
              w_des_com_anpr   := '';
              w_sigla_pro_anpr := '';
              w_cap_anpr       := '';
              w_indirizzo_anpr := '';
              w_num_civ_anpr   := '';
              w_suffisso_anpr  := '';
       end;

       if w_des_com_anpr   is not null and
          w_sigla_pro_anpr is not null and
          w_cap_anpr       is not null and
          w_indirizzo_anpr is not null
       then
          w_des_com_res		:= w_des_com_anpr;
          w_sigla_pro_res	:= w_sigla_pro_anpr;
          w_cap_res		:= w_cap_anpr;
          w_indirizzo_res	:= w_indirizzo_anpr;
          w_num_civ_res		:= w_num_civ_anpr;
          w_suffisso_res	:= w_suffisso_anpr;
          WS_PAGAMENTI_pkg.ins_log(w_operazione_log, 'ws ANPR: ok ('||w_id_operazione_anpr||')', '');
       else
          w_des_com_res		:= f_WSPA_get_pagatore(rec_ws.anno_emissione_min,rec_ws.progr_emissione_min,'DES_COM_RES');
          w_sigla_pro_res	:= f_WSPA_get_pagatore(rec_ws.anno_emissione_min,rec_ws.progr_emissione_min,'SIGLA_PRO_RES');
          w_cap_res		:= f_WSPA_get_pagatore(rec_ws.anno_emissione_min,rec_ws.progr_emissione_min,'CAP_RES');
          w_indirizzo_res	:= f_WSPA_get_pagatore(rec_ws.anno_emissione_min,rec_ws.progr_emissione_min,'INDIRIZZO_RES');
          w_num_civ_res		:= f_WSPA_get_pagatore(rec_ws.anno_emissione_min,rec_ws.progr_emissione_min,'NUM_CIV_RES');
          w_suffisso_res	:= f_WSPA_get_pagatore(rec_ws.anno_emissione_min,rec_ws.progr_emissione_min,'SUFFISSO_RES');
          WS_PAGAMENTI_pkg.ins_log(w_operazione_log, 'ws ANPR: ko ('||w_id_operazione_anpr||')', '');
       end if;
     exception
       when others then
            w_cognome		:= '';
            w_nome		:= '';
            w_cod_fiscale	:= '';
            w_nazionalita	:= '';
            w_indirizzo_mail	:= '';
            w_des_com_res	:= '';
            w_sigla_pro_res	:= '';
            w_cap_res		:= '';
            w_indirizzo_res	:= '';
            w_num_civ_res	:= '';
            w_suffisso_res	:= '';
            w_civico_res	:= '';
     end;

     w_servizio := nvl(rec_ws.servizio_depag,w_servizio);
     begin
       select descrizione
         into w_des_servizio
         from ws_pagamenti_ser
        where cod_depag = w_servizio
          and rownum = 1
       ;
     exception
       when others then
            w_des_servizio := '';
     end;

w_xml_clob := w_xml_clob||f_xml_tag('ws','aggiornaDovuto','I');
w_xml_clob := w_xml_clob||f_xml_elemento(w_ente,'ws','ente','S');
w_xml_clob := w_xml_clob||f_xml_elemento(w_servizio,'ws','servizio','S');
w_xml_clob := w_xml_clob||f_xml_tag('ws','param','I');
w_param_clob := f_xml_tag('','AGGIORNA_DOVUTO','I');
     w_chiave := substr(rec_ws.tabella_rif,4)||'_'||a_progr_pagamento||'_'||a_anno_pagamento;
w_param_clob := w_param_clob||f_xml_elemento(w_chiave,'','CHIAVE','S');
     w_tipoPagatore := 'F';
w_param_clob := w_param_clob||f_xml_elemento(w_tipoPagatore,'','TIPO_PAGATORE','S');
w_param_clob := w_param_clob||f_xml_elemento(w_cod_fiscale,'','CODICE_PAGATORE','S');
w_param_clob := w_param_clob||f_xml_elemento(w_cognome||' '||w_nome,'','ANAGRAFICA_PAGATORE','S');
w_param_clob := w_param_clob||f_xml_elemento(w_indirizzo_res,'','INDIRIZZO_PAGATORE','S');
     w_civico_res := rtrim(w_num_civ_res||'/'||w_suffisso_res,'/');
w_param_clob := w_param_clob||f_xml_elemento(w_civico_res,'','CIVICO_PAGATORE','S');
w_param_clob := w_param_clob||f_xml_elemento(w_cap_res,'','CAP_PAGATORE','S');
w_param_clob := w_param_clob||f_xml_elemento(w_des_com_res,'','LOCALITA_PAGATORE','S');
w_param_clob := w_param_clob||f_xml_elemento(w_sigla_pro_res,'','PROVINCIA_PAGATORE','S');
w_param_clob := w_param_clob||f_xml_elemento('','','NAZIONE_PAGATORE','S');
w_param_clob := w_param_clob||f_xml_elemento(w_indirizzo_mail,'','EMAIL_PAGATORE','S');
     w_tipoDovuto := rec_ws.tabella_rif;
w_param_clob := w_param_clob||f_xml_elemento(w_tipoDovuto,'','TIPO_DOVUTO','');
     if w_des_servizio is not null then
        w_causaleVersamento := w_servizio||' - '||w_des_servizio;
     else
        w_causaleVersamento := rec_ws.cod_fiscale_pagatore||' - RICHIESTE: '||rec_ws.tot_documenti;
     end if;
w_param_clob := w_param_clob||f_xml_elemento(w_causaleVersamento,'','CAUSALE_VERSAMENTO','');
     w_dataScadenza := f_depag_data(rec_ws.data_reg);
w_param_clob := w_param_clob||f_xml_elemento(w_dataScadenza,'','DATA_SCADENZA','');
     w_importoTotale := f_importo(rec_ws.tot_diritti);
w_param_clob := w_param_clob||f_xml_elemento(w_importoTotale,'','IMPORTO_TOTALE','');
     w_progressivo := 0;
     w_progressivo := w_progressivo + 1;
w_param_clob := w_param_clob||f_xml_tag('','SINGOLO_VERSAMENTO','I');
w_param_clob := w_param_clob||f_xml_elemento(w_progressivo,'','PROGRESSIVO','');
w_param_clob := w_param_clob||f_xml_elemento(w_servizio,'','SERVIZIO','');
w_param_clob := w_param_clob||f_xml_elemento(w_causaleVersamento,'','CAUSALE','');
w_param_clob := w_param_clob||f_xml_elemento(w_importoTotale,'','IMPORTO','');

     for rec_cem in sel_cem loop
         w_des_certificato := rec_cem.cod_certificato||' - '||rec_cem.cognome_nome;
         if nvl(rec_cem.segreteria,0) > 0 then
            w_voce_di_costo := f_depag_voce_di_costo(rec_cem.cod_certificato,1,rec_cem.modalita_rilascio);
            w_importo       := f_importo(rec_cem.segreteria);
            w_bilancio      := w_bilancio||w_voce_di_costo||'|'||w_importo||'#';
         end if;
         if nvl(rec_cem.stato_civile,0) > 0 then
            w_voce_di_costo := f_depag_voce_di_costo(rec_cem.cod_certificato,2,rec_cem.modalita_rilascio);
            w_importo       := f_importo(rec_cem.stato_civile);
            w_bilancio      := w_bilancio||w_voce_di_costo||'|'||w_importo||'#';
         end if;
         if nvl(rec_cem.carta_identita,0) > 0 then
            w_voce_di_costo := f_depag_voce_di_costo(rec_cem.cod_certificato,3,rec_cem.modalita_rilascio);
            w_importo       := f_importo(rec_cem.carta_identita);
            w_bilancio      := w_bilancio||w_voce_di_costo||'|'||w_importo||'#';
         end if;
         if nvl(rec_cem.rimborso_st,0) > 0 then
            w_voce_di_costo := f_depag_voce_di_costo(rec_cem.cod_certificato,4,rec_cem.modalita_rilascio);
            w_importo       := f_importo(rec_cem.rimborso_st);
            w_bilancio      := w_bilancio||w_voce_di_costo||'|'||w_importo||'#';
         end if;
         if nvl(rec_cem.bollo,0) > 0 then
            w_voce_di_costo := f_depag_voce_di_costo(rec_cem.cod_certificato,9,rec_cem.modalita_rilascio);
            w_importo       := f_importo(rec_cem.bollo);
            w_bilancio      := w_bilancio||w_voce_di_costo||'|'||w_importo||'#';
         end if;
     end loop;

     w_bilancio := rtrim(w_bilancio,'#');
w_param_clob := w_param_clob||f_xml_elemento(w_bilancio,'','BILANCIO','S');
w_param_clob := w_param_clob||f_xml_elemento(w_note,'','NOTE','S');
w_param_clob := w_param_clob||f_xml_tag('','SINGOLO_VERSAMENTO','F');
w_param_clob := w_param_clob||f_xml_tag('','AGGIORNA_DOVUTO','F');
     WS_PAGAMENTI_pkg.ins_log(w_operazione_log, 'request.param', w_param_clob);
     w_param_b64_blob := WS_PAGAMENTI_PKG.clob_to_blob(w_param_clob);
     w_param_b64_clob := WS_PAGAMENTI_PKG.encode_base64(w_param_b64_blob);

w_xml_clob := w_xml_clob||w_param_b64_clob;
w_xml_clob := w_xml_clob||f_xml_tag('ws','param','F');
w_xml_clob := w_xml_clob||f_xml_tag('ws','aggiornaDovuto','F');

--      w_identificativoOperatore := f_next_operatore(rec_ws.terminalista);
--      w_modalita := f_next_modalita(rec_ws.tipo_pagamento);

  end loop;

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       WS_PAGAMENTI_pkg.ins_log(w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_depag_aggiorna_dovuto;

function f_depag_leggi_dovuto
(a_iuv			IN	varchar2
)

return CLOB

IS

w_ente				varchar2(255) := rtrim(f_valore_inp('DEPAG_ENTE',1,255,'X',''));
w_servizio			varchar2(255) := rtrim(f_valore_inp('DEPAG_SER',1,255,'X',''));

w_servizio_depag		varchar2(255);

w_param_clob			clob;
w_param_b64_blob		blob;
w_param_b64_clob		clob;

w_xml_clob		clob;

w_operazione_log	varchar2(255) := 'xml_leggi_dovuto';

w_errore		varchar2(255);
errore			exception;

begin
  begin
    select decode(w_codice_cliente,
             '015192',f_WSPA_get_servizio_SDM(v.tabella_rif,cem.cod_certificato,'DEPAG',v.tot_diritti),
                      f_WSPA_get_servizio(v.tabella_rif,cem.cod_certificato,'DEPAG')) servizio_depag
      into w_servizio_depag
      from cercem cem,
           ws_pagamenti_tes_v v
     where cem.anno_emissione  = v.anno_emissione_min   
       and cem.progr_emissione = v.progr_emissione_min
       and v.chiave_provider   = a_iuv
       and rownum = 1
    ;
  exception
    when others then
         w_servizio_depag := '';
  end;
  
  w_servizio := nvl(w_servizio_depag,w_servizio);
  
w_xml_clob := w_xml_clob||f_xml_tag('ws','leggiDovuto','I');
w_xml_clob := w_xml_clob||f_xml_elemento(w_ente,'ws','ente','S');
w_xml_clob := w_xml_clob||f_xml_elemento(w_servizio,'ws','servizio','S');
w_xml_clob := w_xml_clob||f_xml_tag('ws','param','I');

w_param_clob := f_xml_tag('','LEGGI_DOVUTO','I');
w_param_clob := w_param_clob||f_xml_elemento(a_iuv,'','IUV','S');
w_param_clob := w_param_clob||f_xml_tag('','LEGGI_DOVUTO','F');

  WS_PAGAMENTI_pkg.ins_log(w_operazione_log, 'request.param', w_param_clob);
  w_param_b64_blob := WS_PAGAMENTI_PKG.clob_to_blob(w_param_clob);
  w_param_b64_clob := WS_PAGAMENTI_PKG.encode_base64(w_param_b64_blob);

w_xml_clob := w_xml_clob||w_param_b64_clob;
w_xml_clob := w_xml_clob||f_xml_tag('ws','param','F');
w_xml_clob := w_xml_clob||f_xml_tag('ws','leggiDovuto','F');

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       WS_PAGAMENTI_pkg.ins_log(w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_depag_leggi_dovuto;

function f_depag_elimina_dovuto
(a_iuv			IN	varchar2
)

return CLOB

IS

w_ente			varchar2(255) := rtrim(f_valore_inp('DEPAG_ENTE',1,255,'X',''));
w_servizio		varchar2(255) := rtrim(f_valore_inp('DEPAG_SER',1,255,'X',''));

w_servizio_depag	varchar2(255);

w_param_clob		clob;
w_param_b64_blob	blob;
w_param_b64_clob	clob;

w_xml_clob		clob;

w_operazione_log	varchar2(255) := 'xml_elimina_dovuto';

w_errore		varchar2(255);
errore			exception;

begin
  begin
    select decode(w_codice_cliente,
             '015192',f_WSPA_get_servizio_SDM(v.tabella_rif,cem.cod_certificato,'DEPAG',v.tot_diritti),
                      f_WSPA_get_servizio(v.tabella_rif,cem.cod_certificato,'DEPAG')) servizio_depag
      into w_servizio_depag
      from cercem cem,
           ws_pagamenti_tes_v v
     where cem.anno_emissione  = v.anno_emissione_min   
       and cem.progr_emissione = v.progr_emissione_min
       and v.chiave_provider   = a_iuv
       and rownum = 1
    ;
  exception
    when others then
         w_servizio_depag := '';
  end;
  
  w_servizio := nvl(w_servizio_depag,w_servizio);
                        
w_xml_clob := w_xml_clob||f_xml_tag('ws','eliminaDovuto','I');
w_xml_clob := w_xml_clob||f_xml_elemento(w_ente,'ws','ente','S');
w_xml_clob := w_xml_clob||f_xml_elemento(w_servizio,'ws','servizio','S');
w_xml_clob := w_xml_clob||f_xml_tag('ws','param','I');

w_param_clob := f_xml_tag('','ELIMINA_DOVUTO','I');
w_param_clob := w_param_clob||f_xml_elemento(a_iuv,'','IUV','S');
w_param_clob := w_param_clob||f_xml_tag('','ELIMINA_DOVUTO','F');

  WS_PAGAMENTI_pkg.ins_log(w_operazione_log, 'request.param', w_param_clob);
  w_param_b64_blob := WS_PAGAMENTI_PKG.clob_to_blob(w_param_clob);
  w_param_b64_clob := WS_PAGAMENTI_PKG.encode_base64(w_param_b64_blob);

w_xml_clob := w_xml_clob||w_param_b64_clob;
w_xml_clob := w_xml_clob||f_xml_tag('ws','param','F');
w_xml_clob := w_xml_clob||f_xml_tag('ws','eliminaDovuto','F');

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       WS_PAGAMENTI_pkg.ins_log(w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_depag_elimina_dovuto;

function f_depag_data
(a_data		IN	varchar2
)

return varchar2

IS

w_data	 		varchar2(255);

w_operazione_log	varchar2(255) := 'f_data';

w_errore		varchar2(255);
errore			exception;

begin
  if a_data is not null then
     w_data := to_char(to_date(a_data,'j'),'yyyy-mm-dd');
  end if;

  return w_data;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       WS_PAGAMENTI_pkg.ins_log(w_operazione_log, w_errore, a_data);
       return w_data;
end f_depag_data;

function  f_depag_voce_di_costo
(a_cod_certificato	IN	varchar2
,a_cod_diritto          IN	number
,a_modalita_rilascio    IN	number
)

return varchar2

IS

w_flag_bollo		varchar2(255);
w_codice		varchar2(255);
w_anno_acc		number;
w_numero_acc		number;

w_voce_di_costo		varchar2(255);

w_operazione_log	varchar2(255) := 'f_voce_di_costo';

w_errore		varchar2(255);
errore			exception;

begin
  if a_modalita_rilascio is null then
     goto fine;
  end if;

  begin
    select decode(dri.fascia_tariffaria,'','N','S')
      into w_flag_bollo
      from cerdri dri
     where cod_ri = a_modalita_rilascio
    ;
  exception
    when others then
         w_flag_bollo := 'N';
  end;

  if a_cod_certificato is not null and a_cod_diritto is not null  then
     if a_cod_diritto != 9 then
        begin
          select decode(w_flag_bollo,'S',vdc.codice_vdc_2,vdc.codice_vdc_1),
                 vdc.anno_accertamento, vdc.numero_accertamento
            into w_codice, w_anno_acc, w_numero_acc
            from ws_pagamenti_vdc vdc
               , cerddc ddc
           where vdc.cod_diritto_rif       = ddc.cod_diritto
             and vdc.fascia_tariffaria_rif = ddc.fascia_tariffaria
             and ddc.cod_certificato       = a_cod_certificato
             and ddc.cod_diritto           = a_cod_diritto
             and rownum = 1
          ;
        exception
          when others then
               w_voce_di_costo := '';
        end;

     elsif a_cod_diritto = 9 then
        begin
          select vdc.codice_vdc_1, vdc.anno_accertamento, vdc.numero_accertamento
            into w_codice, w_anno_acc, w_numero_acc
            from ws_pagamenti_vdc vdc
               , cerdri dri
           where vdc.cod_diritto_rif       = a_cod_diritto
             and vdc.fascia_tariffaria_rif = dri.fascia_tariffaria
             and dri.cod_ri                = a_modalita_rilascio
             and rownum = 1
          ;
        exception
          when others then
               w_voce_di_costo := '';
        end;

     end if;
  end if;

  if w_anno_acc||w_numero_acc is not null then
     w_voce_di_costo := '9'||'|'||w_codice||'|'||w_anno_acc||'/'||w_numero_acc;
  else
     w_voce_di_costo := '9'||'|'||w_codice||'|';
  end if;

<< fine >>

  return w_voce_di_costo;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       WS_PAGAMENTI_pkg.ins_log(w_operazione_log, w_errore, a_cod_certificato||'-'||a_cod_diritto);
       return w_voce_di_costo;
end f_depag_voce_di_costo;

function f_depag_envelope
(a_header		IN	clob
,a_body			IN	clob
)

return CLOB

IS

w_xml_clob		clob;

w_operazione_log	varchar2(255) := 'f_next_envelope';

w_errore		varchar2(255);
errore			exception;

begin

w_xml_clob := '<?xml version="1.0" encoding="utf-8"?>'||chr(10);
w_xml_clob := w_xml_clob||'<soap:Envelope  xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:ws="ws.depag.finmatica.it">'||chr(10);
w_xml_clob := w_xml_clob||f_xml_tag('soap','Header','I');
  if a_header is not null then
w_xml_clob := w_xml_clob||a_header;
  end if;
w_xml_clob := w_xml_clob||f_xml_tag('soap','Header','F');
w_xml_clob := w_xml_clob||f_xml_tag('soap','Body','I');
w_xml_clob := w_xml_clob||a_body;
w_xml_clob := w_xml_clob||f_xml_tag('soap','Body','F');
w_xml_clob := w_xml_clob||f_xml_tag('soap','Envelope','F');

  return w_xml_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       WS_PAGAMENTI_pkg.ins_log(w_operazione_log, w_errore, w_xml_clob);
       return w_xml_clob;
end f_depag_envelope;

procedure ws_depag_response
(a_campo_clob		IN	clob
,w_flag_errore		IN OUT	varchar2
,w_messaggio		IN OUT	varchar2
,w_url_conferma		IN OUT	varchar2
,w_param		IN OUT	clob
)

IS

w_param_blob		blob;
w_param_clob		clob;

w_esito			varchar2(4000);

w_operazione_log	varchar2(255) := 'ws_depag_response';

w_errore		varchar2(255);
errore			exception;

begin
--
--In caso di successo della richiesta
--<AGGIORNA_DOVUTO_RESULT>
--  <ESITO_OPERAZIONE>OK</ESITO_OPERAZIONE>
--  <DATI>
--    <IUV>00076370313043860</IUV>
--    <CODICE_AVVISO>300076370313043860</CODICE_AVVISO>
--  </DATI>
--</AGGIORNA_DOVUTO_RESULT>
--
--oppure in caso di errore
--<AGGIORNA_DOVUTO_RESULT>
--  <ESITO_OPERAZIONE>ERROR</ESITO_OPERAZIONE>
--  <CODICE_ERRORE>PO0100</CODICE_ERRORE>
--  <DESCRIZIONE_ERRORE>Posizione debitoria non aggiornata: stato posizione debitoria incompatibile.</DESCRIZIONE_ERRORE>
--</AGGIORNA_DOVUTO_RESULT>
--

  if a_campo_clob is null then
     w_errore := 'response vuota';
  else
     w_param_clob := ws_cerca_tag(a_campo_clob,'param');
     w_param_blob := ws_pagamenti_pkg.decode_base64(w_param_clob);
     w_param_clob := ws_pagamenti_pkg.blob_to_clob(w_param_blob);
     WS_PAGAMENTI_pkg.ins_log(w_operazione_log, 'response.param', w_param_clob);
     w_esito  := ws_cerca_tag(w_param_clob,'ESITO_OPERAZIONE');
     if w_esito IN ('OK') then
        w_flag_errore  := '';
        w_messaggio    := 'Operazione avvenuta con successo';
        w_url_conferma := '';
--        WS_PAGAMENTI_pkg.ins_log(w_operazione_log, w_esito, 'iuv: '||w_messaggio);
--        WS_PAGAMENTI_pkg.ins_log(w_operazione_log, 'url_conferma', w_url_conferma);
     else
        w_flag_errore  := 'S';
        w_url_conferma := '';
        if w_esito is not null then
           w_messaggio   := ws_cerca_tag(w_param_clob,'DESCRIZIONE_ERRORE');
           w_messaggio   := w_messaggio||' ('||ws_cerca_tag(w_param_clob,'CODICE_ERRORE')||')';
           WS_PAGAMENTI_pkg.ins_log(w_operazione_log, w_esito, w_messaggio);
        else
           w_esito       := ws_cerca_tag(a_campo_clob,'faultcode');
           if w_esito is not null then
              w_messaggio  := ws_cerca_tag(a_campo_clob,'faultstring');
              WS_PAGAMENTI_pkg.ins_log(w_operazione_log, w_esito, w_messaggio);
           else
              w_messaggio  := 'errore';
              WS_PAGAMENTI_pkg.ins_log(w_operazione_log, 'errore', a_campo_clob);
           end if;
        end if;
     end if;
  end if;

  w_param := w_param_clob;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       WS_PAGAMENTI_pkg.ins_log(w_operazione_log, w_errore, a_campo_clob);
end ws_depag_response;

function  f_depag_get_url
(a_iuv			IN	varchar2
)

return varchar2

IS

w_url_ente		varchar2(255);
w_url_iuv		varchar2(255);
w_url_user		varchar2(255);
w_url_time		varchar2(255);
w_url_segreto		varchar2(255);
w_url_token		varchar2(4000);
w_url_token_md5		varchar2(4000);

w_url			varchar2(4000);

w_errore		varchar2(4000);
errore			exception;

w_operazione_log	varchar2(255) := 'f_depag_get_url';

begin
--http://depag.e-pal.it/PagamentiOnLine/pagamentoPosNexi?
--ENTE=01556360152
--&IUV=12219600000026074
--&USER=DE4WS
--&TIME=12102021_163800000
--&TOKEN=TOKEN

  if a_iuv is not null then
     w_url_ente        := rtrim(f_valore_inp('DEPAG_ENTE',1,255,'X',''));
     w_url_iuv         := a_iuv;
     w_url_user        := rtrim(f_valore_inp('DEPAG_USR',1,255,'X',''));
--     w_url_time        := to_char(sysdate,'ddMMyyyy_hh24missSSS');
--     w_url_time        := to_char(CURRENT_TIMESTAMP(3), 'ddMMyyyy_hh24miSSFF3');
     w_url_time        := to_char(sysdate,'ddMMyyyy_hh24miss')||'000';
     w_url_segreto     := 'SEGRETO';
     w_url_token       := w_url_ente||'#'||w_url_iuv||'#'||w_url_user||'#'||w_url_time||'#'||w_url_segreto;
     w_url_token_md5   := ws_pagamenti_pkg.F_GET_HASH_MD5(w_url_token);

     w_url             := rtrim(f_valore_inp('DEPAG_POS',1,255,'X',''));
     w_url             := w_url||
                          '?ENTE='||w_url_ente||
                          '&IUV='||w_url_iuv||
                          '&USER='||w_url_user||
                          '&TIME='||w_url_time||
                          '&TOKEN='||w_url_token_md5;
  end if;

  return w_url;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       WS_PAGAMENTI_pkg.ins_log(w_operazione_log, w_errore, a_iuv);
end f_depag_get_url;

function DECODE_BASE64
(a_clob_in          	IN	clob)

return BLOB

IS

v_blob			blob;
v_result		blob;
v_offset		integer;
v_buffer_size		binary_integer := 48;
v_buffer_varchar	varchar2(48);
v_buffer_raw		raw(48);

w_errore		varchar2(4000);
errore			exception;

w_nome_log		varchar2(255) := 'decode B64';
w_step			number;

begin
w_step := 1;
  if a_clob_in is null then
     return null;
  end if;
  dbms_lob.createtemporary(v_blob, true);
w_step := 2;
  v_offset := 1;

  for i in 1 .. ceil(dbms_lob.getlength(a_clob_in) / v_buffer_size) loop
w_step := 1000000.1 + i;
      dbms_lob.read(a_clob_in, v_buffer_size, v_offset, v_buffer_varchar);
w_step := 1000000.2 + i;
      v_buffer_raw := utl_raw.cast_to_raw(v_buffer_varchar);
w_step := 1000000.3 + i;
      v_buffer_raw := utl_encode.base64_decode(v_buffer_raw);
w_step := 1000000.4 + i;
--dbms_output.put_line(i||') len '||utl_raw.length(v_buffer_raw)||' - v_buf '||v_buffer_raw);
      dbms_lob.writeappend(v_blob, utl_raw.length(v_buffer_raw), v_buffer_raw);
w_step := 1000000.5 + i;
      v_offset := v_offset + v_buffer_size;
w_step := 1000000.6 + i;
  end loop;
w_step := 3;
  v_result := v_blob;
w_step := 4;
  dbms_lob.freetemporary(v_blob);

w_step := 5;
  return v_result;

exception
  when others then
       w_errore := '('||w_step||') exception '||SQLERRM||')';
       WS_PAGAMENTI_pkg.ins_log('',w_nome_log, w_errore);
end decode_base64;

function ENCODE_BASE64
(a_blob_in		IN	blob)

return CLOB

IS
v_clob			clob;
v_result		clob;
v_offset		integer;
v_chunk_size		binary_integer := (48 / 4) * 3;
v_buffer_varchar	varchar2(48);
v_buffer_raw 		raw(48);

w_errore		varchar2(4000);
errore			exception;

w_nome_log		varchar2(255) := 'encode B64';
w_step			number;

begin
w_step := 1;
  if a_blob_in is null then
     return null;
  end if;
  dbms_lob.createtemporary(v_clob, true);
w_step := 2;
  v_offset := 1;

  for i in 1 .. ceil(dbms_lob.getlength(a_blob_in) / v_chunk_size) loop
w_step := 1000000.1 + i;
      dbms_lob.read(a_blob_in, v_chunk_size, v_offset, v_buffer_raw);
w_step := 1000000.2 + i;
      v_buffer_raw := utl_encode.base64_encode(v_buffer_raw);
w_step := 1000000.3 + i;
      v_buffer_varchar := utl_raw.cast_to_varchar2(v_buffer_raw);
w_step := 1000000.4 + i;
      dbms_lob.writeappend(v_clob, length(v_buffer_varchar), v_buffer_varchar);
w_step := 1000000.5 + i;
      v_offset := v_offset + v_chunk_size;
w_step := 1000000.6 + i;
  end loop;
w_step := 3;
  v_result := v_clob;
w_step := 4;
  dbms_lob.freetemporary(v_clob);

w_step := 5;
  return v_result;

exception
  when others then
       w_errore := '('||w_step||') exception '||SQLERRM||')';
       WS_PAGAMENTI_pkg.ins_log('',w_nome_log, w_errore);
end encode_base64;

function CLOB_TO_BLOB
(a_clob_in          IN    clob)

return BLOB

IS
v_blob            blob;
v_result          blob;
v_offset          integer;
v_buffer_size     binary_integer := 48;
v_buffer_varchar  varchar2(48);
v_buffer_raw      raw(48);

w_errore          varchar2(4000);
errore            exception;

w_nome_log        varchar2(255) := 'clob_to_blob';
w_step            number;

begin
w_step := 1;
  if a_clob_in is null then
     return null;
  end if;
  dbms_lob.createtemporary(v_blob, true);
w_step := 2;
  v_offset := 1;

  for i in 1 .. ceil(dbms_lob.getlength(a_clob_in) / v_buffer_size) loop
w_step := 1000000.1 + i;
      dbms_lob.read(a_clob_in, v_buffer_size, v_offset, v_buffer_varchar);
w_step := 1000000.2 + i;
      v_buffer_raw := utl_raw.cast_to_raw(v_buffer_varchar);
w_step := 1000000.3 + i;
      dbms_lob.writeappend(v_blob, utl_raw.length(v_buffer_raw), v_buffer_raw);
w_step := 1000000.5 + i;
      v_offset := v_offset + v_buffer_size;
w_step := 1000000.6 + i;
  end loop;
w_step := 3;
  v_result := v_blob;
w_step := 4;
  dbms_lob.freetemporary(v_blob);
w_step := 5;
  return v_result;
exception
  when others then
       w_errore := '('||w_step||') exception '||SQLERRM||')';
       WS_PAGAMENTI_pkg.ins_log('',w_nome_log, w_errore);
end clob_to_blob;

function BLOB_TO_CLOB
(a_blob_in          IN    blob)

return CLOB

IS

w_documento_blob           blob := a_blob_in;
w_documento_clob           clob;

w_number_temp              number;
dest_offset                number := 1;
src_offset                 number := 1;
amount                     integer := DBMS_LOB.lobmaxsize;
blob_csid                  number := DBMS_LOB.default_csid;
lang_ctx                   integer := DBMS_LOB.default_lang_ctx;
warning                    integer;

w_errore          varchar2(4000);
errore            exception;

w_nome_log        varchar2(255) := 'blob_to_clob';
w_step            number;

begin
-- Verifica dimensione file caricato
w_step := 1;
  w_number_temp        := DBMS_LOB.getlength (w_documento_blob);
  if nvl (w_number_temp, 0) = 0 then
     w_errore := 'Attenzione File caricato Vuoto - Verificare Client Oracle';
     raise errore;
  end if;

w_step := 2;
-- Trasformazione in CLOB
  begin
    DBMS_LOB.createtemporary (lob_loc =>   w_documento_clob
                             ,cache =>     true
                             ,dur =>       DBMS_LOB.session
                             );
w_step := 3;
    DBMS_LOB.converttoclob (w_documento_clob
                           ,w_documento_blob
                           ,amount
                           ,dest_offset
                           ,src_offset
                           ,blob_csid
                           ,lang_ctx
                           ,warning
                           );
  exception
    when others then
         w_errore := 'Errore in trasformazione Blob in Clob  (' || sqlerrm || ')';
         raise errore;
  end;

  return w_documento_clob;
exception
  when errore then
       WS_PAGAMENTI_pkg.ins_log('',w_nome_log, w_errore);
  when others then
       w_errore := '('||w_step||') exception '||SQLERRM||')';
       WS_PAGAMENTI_pkg.ins_log('',w_nome_log, w_errore);
end blob_to_clob;

function f_get_hash_MD5
(in_string 		IN 	varchar2
)

return 	varchar2

as
  cln_md5raw 	raw(2000);
  out_raw 	raw(16);
begin
  cln_md5raw := utl_raw.cast_to_raw(in_string);
  dbms_obfuscation_toolkit.md5(input=>cln_md5raw,checksum=>out_raw);
  -- return hex version (32 length)
  return rawtohex(out_raw);
end;

end;
/
