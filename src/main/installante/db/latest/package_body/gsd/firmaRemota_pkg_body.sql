--liquibase formatted sql
--changeset amonopoli:202306061100_2 runOnChange:true stripComments:false
create or replace package body firmaremota_pkg as
function VERSIONE
return varchar2
IS

w_versione    varchar2(255);
w_revisione   varchar2(255);

begin
--
-- V1.0.00 del 29/01/2019   AM   Prima Emissione
-- V1.1.00 del 29/05/2019   AM   Estensione del servizio alle comunicazioni di Anagrafe
-- V1.2.00 del 18/09/2019   AM   Estensione del servizio alle comunicazioni di Leva Militare
-- V1.3.00 del 24/10/2019   AM   Estensione del servizio alle comunicazioni di Elettorale
-- V1.3.01 del 30/10/2019   AM   attivazione_ws: gestione dell'errore in output della function
-- V2.0.00 del 20/10/2020   AM   utilizzo del nuovo servizio firma automatica
-- V2.1.00 del 25/11/2020   AM   invio massivo comunicazioni CIV (id_com separati da '#')
-- V3.0.00 del 23/03/2021   AM   richiesta_otp: nuovo servizio di Richiesta OTP
-- V3.1.00 del 25/03/2021   AM   gestione (cablata) del provider_firma, dipendente dall'ente
-- V3.2.00 del 29/03/2021   AM   risolto errore di dataType di w_id_clob da varchar2 a clob
-- V4.0.00 del 15/03/2023   AM   attivazione_ws: controllo allegati registrati su GDM (CIV)
-- V4.1.00 del 06/06/2023   AM   attivazione_ws: aggiornamento gdm_oggetti_file in seguito a firma (CIV)
--
  w_versione  := 'V4.1';
  w_revisione := '00 del 06/06/2023';

  return w_versione||'.'||w_revisione;
end;

procedure DATI_CLIENTE
IS
begin
  begin
    select com.cod_provincia, com.cod_comune, com.descrizione, com.sigla_provincia, pro.descrizione
      into w_cod_pro_cliente, w_cod_com_cliente, w_des_com_cliente, w_sigla_pro_cliente, w_des_pro_cliente
      from arcpro pro, arccom com
     where pro.cod_provincia   = com.cod_provincia
       and (com.cod_provincia, com.cod_comune) = (select pro_cliente, com_cliente from menuditta)
    ;
  end;

/*
  if lpad(w_cod_pro_cliente,3,'0')||lpad(w_cod_com_cliente,3,'0') in ('039010') then	-- 039010 Faenza (TEST)
     w_provider_firma := 'ProxySign-infocert'; 
  elsif lpad(w_cod_pro_cliente,3,'0')||lpad(w_cod_com_cliente,3,'0') in ('023089') or 	-- 023089 Valeggio s/Mincio
        lpad(w_cod_pro_cliente,3,'0')||lpad(w_cod_com_cliente,3,'0') in ('035024') 	-- 035024 Guastalla
  then
     w_provider_firma := 'infocert';
  else
     w_provider_firma := 'aruba';
  end if;
*/
  w_provider_firma := nvl(rtrim(f_valore_inp('FIRMA_PROV',1,255,'X','')),'aruba');

end DATI_CLIENTE;

procedure INSERIMENTO_LOG
(a_operazione          IN   varchar2
,a_note                IN   varchar2
,a_campo_clob          IN   clob      default NULL
)
IS

w_errore               varchar2(4000);
errore                 exception;
w_nome_log             varchar2(255) := 'Inserimento Log';
begin
  begin
    insert into firmaremota_log (data_ora, operazione, note, campo_clob)
    values (sysdate, a_operazione, a_note, a_campo_clob)
    ;
  end;
--COMMIT;
exception
  when others then
       w_errore   := 'Errore ('||SQLERRM||')';
       begin
         insert into firmaremota_log (data_ora, operazione, note, campo_clob)
         values (sysdate, w_nome_log, w_errore, a_campo_clob)
      ;
       end;
--COMMIT;
end INSERIMENTO_LOG;

function ATTIVAZIONE_WS
(a_archivio_rif        IN   varchar2
,a_id_rif              IN   varchar2
,a_id                  IN   varchar2
,a_usr                 IN   varchar2
,a_pwd                 IN   varchar2
,a_otp                 IN   varchar2
)

return CLOB

IS

w_servizio             varchar2(255);

w_allegato_b64         clob;
w_usr                  varchar2(255) := a_usr; -- nvl(a_usr,'USER');
w_pwd                  varchar2(255) := a_pwd; -- nvl(a_pwd,'PASSWORD');
w_otp                  varchar2(255) := a_otp; -- nvl(a_otp,'123456');

w_soap_request         clob;

w_out_xml_clob         clob;
w_out_xml_blob         blob;

w_flag_da_firmare              varchar2(255);
w_len_allegato                 number;

w_flag_ws_firma                varchar2(255);
w_note_ws_firma                varchar2(255);
w_allegato_firmato_b64         clob;
w_allegato_firmato_blob        blob;
w_archivio_rif                 varchar2(255);
w_id_rif                       varchar2(255);

w_errore               varchar2(4000);
errore                 exception;
w_nome_log             varchar2(255) := 'Attivazione WS';
w_step                 number;

w_flag_automatica      varchar2(255);

cursor sel_alle_civ is
select a.*--, a.rowid
  from civcom_alle a
 where id_oggetto_file_gdm        is null
   and a_archivio_rif  = 'CIVCOM'
   and id_com          = nvl(a_id_rif,id_com)
   and id              = nvl(a_id,id)
   and flag_da_firmare is not null
   and flag_ws_firma   is null
   and nvl(instr(a_id_rif,'#'),0) = 0
UNION ALL
select a.*--, a.rowid
  from civcom_alle a
 where id_oggetto_file_gdm        is null
   and a_archivio_rif  = 'CIVCOM'
   and a_id_rif        like '%#'||id_com||'#%'
   and flag_da_firmare is not null
   and flag_ws_firma   is null
   and nvl(instr(a_id_rif,'#'),0) > 0
UNION ALL
select a.*--, a.rowid
  from civcom_alle_gdm a
 where id_oggetto_file_gdm        is not null
   and a_archivio_rif  = 'CIVCOM'
   and id_com          = nvl(a_id_rif,id_com)
   and id              = nvl(a_id,id)
   and flag_da_firmare is not null
   and flag_ws_firma   is null
   and nvl(instr(a_id_rif,'#'),0) = 0
UNION ALL
select a.*--, a.rowid
  from civcom_alle_gdm a
 where id_oggetto_file_gdm        is not null
   and a_archivio_rif  = 'CIVCOM'
   and a_id_rif        like '%#'||id_com||'#%'
   and flag_da_firmare is not null
   and flag_ws_firma   is null
   and nvl(instr(a_id_rif,'#'),0) > 0
;
cursor sel_alle_ana is
select a.*--, a.rowid
  from anacom_alle a
 where a_archivio_rif  = 'ANACOM'
   and id_com          = nvl(a_id_rif,id_com)
   and id              = nvl(a_id,id)
   and flag_da_firmare is not null
   and flag_ws_firma   is null
;
cursor sel_alle_lev is
select a.*--, a.rowid
  from levcom_alle a
 where a_archivio_rif  = 'LEVCOM'
   and id_com          = nvl(a_id_rif,id_com)
   and id              = nvl(a_id,id)
   and flag_da_firmare is not null
   and flag_ws_firma   is null
;
cursor sel_alle_ele is
select a.*--, a.rowid
  from elecom_alle a
 where a_archivio_rif  = 'ELECOM'
   and id_com          = nvl(a_id_rif,id_com)
   and id              = nvl(a_id,id)
   and flag_da_firmare is not null
   and flag_ws_firma   is null
;

w_ctr_da_firmare        number;

w_cod_errore_ws 	varchar2(255);
w_des_errore_ws 	varchar2(255);
w_xml_clob      	clob;
w_xml_clob_loop      	clob;
w_xml           	xmltype;
w_id_clob               clob;
w_binary_clob           clob;
w_binary_blob           blob;

w_extract_str   	varchar2(255) := '/soap:Envelope/soap:Body/ns2:firmaB64V2Response';
w_extract_str_1 	varchar2(255) := 'xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"';
w_extract_str_2 	varchar2(255) := 'xmlns:ns2="http://services.firmaremota.finmatica.it/"';

cursor sel_b64 (w_root varchar2) is
select extractValue(value(rowdata),w_root||'id',w_extract_str_1||' '||w_extract_str_2) stringa_id
     , extract(value(rowdata),w_root||'binaryB64',w_extract_str_1||' '||w_extract_str_2).getClobVal() binary_b64
  from table(XMLSequence(w_xml)) rowdata
;

begin
--dbms_output.put_line('debug - archivio_rif '||a_archivio_rif||' id_rif '||a_id_rif||' a_id '||a_id||' a_usr '||a_usr||' a_pwd '||a_pwd||' a_otp '||a_otp);
--  goto test_response;

  w_service_url 	:= rtrim(f_valore_inp('FIRMA_URL',1,255,'X',''));
  w_url_gsd     	:= rtrim(f_valore_inp('FIRMA_IAS',1,255,'X',''));
  w_flag_automatica	:= nvl(f_valore_inp('FIRMA_AUTO',1,1,'X','S'),'N');

w_step := 1;
  firmaremota_pkg.dati_cliente;
--dbms_output.put_line('inizio - pro_cliente: '||w_cod_pro_cliente||' - com_cliente: '||w_cod_com_cliente);
w_step := 2;
w_step := 3;
w_step := 4;
w_step := 5;
w_step := 6;

  if nvl(w_flag_automatica,'N') = 'S' then
     w_servizio     := 'firmaAutomaticaB64';
  else
     w_servizio     := 'firmaB64V2';
  end if;
  w_soap_action  := '';
  w_soap_request := '';
  w_allegato_b64 := '';

--  w_soap_request  := '<?xml version="1.0" encoding="utf-8" ?>
  w_soap_request  := '<soapenv:Envelope '||w_soap_str_1||' '||w_soap_str_2||'>
'||                  '  <soapenv:Header/>
'||                  '  <soapenv:Body>
'||                  '    <ser:'||w_servizio||'>
'||                  '      <req>';

  w_ctr_da_firmare := 0;
  if a_archivio_rif = 'CIVCOM' then
     for rec in sel_alle_civ loop
-- dbms_output.put_line('dentro il loop civ');
         firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, 'archivio_rif '||a_archivio_rif||' id_rif '||rec.id);
         w_errore          := '';
         w_flag_da_firmare := nvl(rec.flag_da_firmare,'N');
         w_len_allegato    := nvl(dbms_lob.getlength(rec.allegato_blob),0);
         if w_flag_da_firmare != 'S' or w_len_allegato = 0 then
            w_errore := 'no firma - flag_da_firmare: '||w_flag_da_firmare||' - len_blob: '||w_len_allegato;
            firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, w_errore);
            goto fine_civ;
         end if;
         w_ctr_da_firmare := 1;
         w_allegato_b64 := firmaremota_pkg.encode_base64(rec.allegato_blob);
w_step := w_step||rec.id;
         w_soap_request  := w_soap_request||'
'||                         '        <data>
'||                         '          <id>'||a_archivio_rif||'-'||to_char(rec.id)||'</id>
'||                         '          <binaryB64>'||w_allegato_b64||'</binaryB64>
'||                         '        </data>';
w_step := 7.0;

<< fine_civ >>
null;
     end loop;

  elsif a_archivio_rif = 'ANACOM' then
     for rec in sel_alle_ana loop
-- dbms_output.put_line('dentro il loop ana');
         firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, 'archivio_rif '||a_archivio_rif||' id_rif '||rec.id);
         w_errore          := '';
         w_flag_da_firmare := nvl(rec.flag_da_firmare,'N');
         w_len_allegato    := nvl(dbms_lob.getlength(rec.allegato_blob),0);
         if w_flag_da_firmare != 'S' or w_len_allegato = 0 then
            w_errore := 'no firma - flag_da_firmare: '||w_flag_da_firmare||' - len_blob: '||w_len_allegato;
            firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, w_errore);
            goto fine_ana;
         end if;
         w_ctr_da_firmare := 1;
         w_allegato_b64 := firmaremota_pkg.encode_base64(rec.allegato_blob);
w_step := w_step||rec.id;
         w_soap_request  := w_soap_request||'
'||                         '        <data>
'||                         '          <id>'||a_archivio_rif||'-'||to_char(rec.id)||'</id>
'||                         '          <binaryB64>'||w_allegato_b64||'</binaryB64>
'||                         '        </data>';
w_step := 7.0;

<< fine_ana >>
null;
     end loop;

  elsif a_archivio_rif = 'LEVCOM' then
     for rec in sel_alle_lev loop
-- dbms_output.put_line('dentro il loop lev');
         firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, 'archivio_rif '||a_archivio_rif||' id_rif '||rec.id);
         w_errore          := '';
         w_flag_da_firmare := nvl(rec.flag_da_firmare,'N');
         w_len_allegato    := nvl(dbms_lob.getlength(rec.allegato_blob),0);
         if w_flag_da_firmare != 'S' or w_len_allegato = 0 then
            w_errore := 'no firma - flag_da_firmare: '||w_flag_da_firmare||' - len_blob: '||w_len_allegato;
            firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, w_errore);
            goto fine_lev;
         end if;
         w_ctr_da_firmare := 1;
         w_allegato_b64 := firmaremota_pkg.encode_base64(rec.allegato_blob);
w_step := w_step||rec.id;
         w_soap_request  := w_soap_request||'
'||                         '        <data>
'||                         '          <id>'||a_archivio_rif||'-'||to_char(rec.id)||'</id>
'||                         '          <binaryB64>'||w_allegato_b64||'</binaryB64>
'||                         '        </data>';
w_step := 7.0;

<< fine_lev >>
null;
     end loop;

  elsif a_archivio_rif = 'ELECOM' then
     for rec in sel_alle_ele loop
-- dbms_output.put_line('dentro il loop lev');
         firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, 'archivio_rif '||a_archivio_rif||' id_rif '||rec.id);
         w_errore          := '';
         w_flag_da_firmare := nvl(rec.flag_da_firmare,'N');
         w_len_allegato    := nvl(dbms_lob.getlength(rec.allegato_blob),0);
         if w_flag_da_firmare != 'S' or w_len_allegato = 0 then
            w_errore := 'no firma - flag_da_firmare: '||w_flag_da_firmare||' - len_blob: '||w_len_allegato;
            firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, w_errore);
            goto fine_ele;
         end if;
         w_ctr_da_firmare := 1;
         w_allegato_b64 := firmaremota_pkg.encode_base64(rec.allegato_blob);
w_step := w_step||rec.id;
         w_soap_request  := w_soap_request||'
'||                         '        <data>
'||                         '          <id>'||a_archivio_rif||'-'||to_char(rec.id)||'</id>
'||                         '          <binaryB64>'||w_allegato_b64||'</binaryB64>
'||                         '        </data>';
w_step := 7.0;

<< fine_ele >>
null;
     end loop;

  end if;

  if w_ctr_da_firmare = 0 then
--     w_des_errore_ws := 'Nessun allegato da firmare';
     w_des_errore_ws := '';
     w_out_xml_clob  := w_des_errore_ws;
     goto fine;
  end if;

  if nvl(w_flag_automatica,'N') = 'S' then
     w_soap_request  := w_soap_request||'
'||                  '        <service>'||w_provider_firma||'</service>
'||                  '        <user>certificati-anagrafe</user>
'||                  '      </req>
'||                  '    </ser:'||w_servizio||'>
'||                  '  </soapenv:Body>
'||                  '</soapenv:Envelope>';
  else
     w_soap_request  := w_soap_request||'
'||                  '        <password>'||w_pwd||'</password>
'||                  '        <pin>'||w_otp||'</pin>
'||                  '        <service>'||w_provider_firma||'</service>
'||                  '        <user>'||w_usr||'</user>
'||                  '      </req>
'||                  '    </ser:'||w_servizio||'>
'||                  '  </soapenv:Body>
'||                  '</soapenv:Envelope>';
  end if;

   firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, 'request', w_soap_request);

w_step := 7;
   w_out_xml_clob   := firmaremota_pkg.WS_REQUEST(w_service_url, w_service_name, w_service_ns, w_soap_request, '');
w_step := 7.1;
   firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, 'response', w_out_xml_clob);
   goto salta_test_response;

<< test_response >>
null;

<< salta_test_response >>
w_step := 7.2;
   w_cod_errore_ws := dbms_lob.substr(firmaremota_pkg.GET_VALUE_BY_TAG(w_out_xml_clob, 'code'),255,1);
--dbms_output.put_line('debug - code '||w_cod_errore_ws);  
      firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, 'response.code', w_cod_errore_ws);
w_step := 7.3;
   if nvl(w_cod_errore_ws,' ') = 'OK' then
      goto test_return;
w_step := 8;
      w_xml_clob := substr(w_out_xml_clob,instr(w_out_xml_clob,'<soap:Envelope'));
w_step := 9;
      w_xml_clob := substr(w_xml_clob,1,instr(w_xml_clob,'</soap:Envelope>')+15);
      firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, 'response.substr', w_out_xml_clob);
w_step := 10;
      w_xml      := xmltype(w_xml_clob);

w_step := 11;
      w_extract_str   := '/soap:Envelope/soap:Body/ns2:firmaB64V2Response';
      w_extract_str_1 := 'xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"';
      w_extract_str_2 := 'xmlns:ns2="http://services.firmaremota.finmatica.it/"';
      w_xml           := w_xml.extract(w_extract_str||'/child::node()'
                                      ,w_extract_str_1||' '||w_extract_str_2);
      w_xml_clob := '';                          
w_step := 12;
      w_xml_clob := xmltype.getclobval(w_xml);
      goto salta_test_return;

<< test_return >>
      w_xml_clob := substr(w_out_xml_clob,instr(w_out_xml_clob,'<return'));
      w_xml_clob := substr(w_xml_clob,1,instr(w_xml_clob,'</return>')+8);
--      w_xml      := xmltype(w_xml_clob);

<< salta_test_return >>
      firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, 'response.extract', w_xml_clob);

<< while_loop >>      
      w_xml_clob_loop := w_xml_clob;
      while instr(w_xml_clob_loop,'<binaryB64>') > 0 loop
          w_id_clob := substr(w_xml_clob_loop,instr(w_xml_clob_loop,'<id>')+4);
          w_id_clob := substr(w_id_clob,1,instr(w_id_clob,'</id>')-1);
          firmaremota_pkg.GET_DATI_RIF(w_id_clob,w_archivio_rif,w_id_rif);
          firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, 'w_archivio_rif '||w_archivio_rif||' w_id_rif '||w_id_rif);
--dbms_output.put_line('debug - w_archivio_rif '||w_archivio_rif||' w_id_rif '||w_id_rif);  
          if w_id_rif is null then
w_step := 20.2;
             w_errore := 'Dati di riferimento non decodificati ('||w_id_clob||')';
             firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, w_errore);
          else
             w_binary_clob := substr(w_xml_clob_loop,instr(w_xml_clob_loop,'<binaryB64>')+11);
             w_binary_clob := substr(w_binary_clob,1,instr(w_binary_clob,'</binaryB64')-1);
--dbms_output.put_line('debug - binary ('||dbms_lob.getlength(w_binary_clob)||') '||substr(w_binary_clob,1,200));  
w_step := 20.3;
             firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, 'prima della firma', w_binary_clob);
w_step := 20.4;
             w_binary_blob := firmaremota_pkg.decode_base64(w_binary_clob);

             if a_archivio_rif = 'CIVCOM' then
w_step := 20.5;
                begin
                  update civcom_alle
                     set flag_ws_firma = 'S',
                         note_ws_firma = '',
                         allegato_clob = decode(id_oggetto_file_gdm,'',nvl(w_binary_clob,allegato_clob)),
                         allegato_blob = decode(id_oggetto_file_gdm,'',nvl(w_binary_blob,allegato_blob)),
                         nome_allegato = nome_allegato||'.p7m'
                   where id              = to_number(w_id_rif)
                     and flag_da_firmare is not null
                     and flag_ws_firma   is null
                  ;
                  if sql%found then
                     begin
                       update gdm_oggetti_file
                          set filename = filename||'.p7m',
                              testoocr = nvl(w_binary_blob,testoocr)
                        where id_oggetto_file = (select id_oggetto_file_gdm
                                                   from civcom_alle
                                                  where id              = to_number(w_id_rif)
                                                    and flag_da_firmare is not null
                                                    and flag_ws_firma   is not null)
                       ;
                     exception
                       when others then
                            w_errore := 'errore in upd GDM_OGGETTI_FILE ('||SQLERRM||')';
                            firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, w_errore);
                     end;
                  end if;   
                exception
                  when others then
                       w_errore := 'errore in upd CIVCOM_ALLE ('||SQLERRM||')';
                       firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, w_errore);
                end;
                firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, 'documento firmato', w_binary_clob);

             elsif a_archivio_rif = 'ANACOM' then
w_step := 20.5;
                begin
                  update anacom_alle
                     set flag_ws_firma = 'S',
                         note_ws_firma = '',
                         allegato_clob = nvl(w_binary_clob,allegato_clob),
                         allegato_blob = nvl(w_binary_blob,allegato_blob),
                         nome_allegato = nome_allegato||'.p7m'
                   where id              = to_number(w_id_rif)
                     and flag_da_firmare is not null
                     and flag_ws_firma   is null
                  ;
                exception
                  when others then
                       w_errore := 'errore in upd ANACOM_ALLE ('||SQLERRM||')';
                       firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, w_errore);
                end;
                firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, 'documento firmato', w_binary_clob);

             elsif a_archivio_rif = 'LEVCOM' then
w_step := 20.5;
                begin
                  update levcom_alle
                     set flag_ws_firma = 'S',
                         note_ws_firma = '',
                         allegato_clob = nvl(w_binary_clob,allegato_clob),
                         allegato_blob = nvl(w_binary_blob,allegato_blob),
                         nome_allegato = nome_allegato||'.p7m'
                   where id              = to_number(w_id_rif)
                     and flag_da_firmare is not null
                     and flag_ws_firma   is null
                  ;
                exception
                  when others then
                       w_errore := 'errore in upd LEVCOM_ALLE ('||SQLERRM||')';
                       firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, w_errore);
                end;
                firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, 'documento firmato', w_binary_clob);

             elsif a_archivio_rif = 'ELECOM' then
w_step := 20.5;
                begin
                  update elecom_alle
                     set flag_ws_firma = 'S',
                         note_ws_firma = '',
                         allegato_clob = nvl(w_binary_clob,allegato_clob),
                         allegato_blob = nvl(w_binary_blob,allegato_blob),
                         nome_allegato = nome_allegato||'.p7m'
                   where id              = to_number(w_id_rif)
                     and flag_da_firmare is not null
                     and flag_ws_firma   is null
                  ;
                exception
                  when others then
                       w_errore := 'errore in upd ELECOM_ALLE ('||SQLERRM||')';
                       firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, w_errore);
                end;
                firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, 'documento firmato', w_binary_clob);

             end if;
          end if;
          w_xml_clob_loop := substr(w_xml_clob_loop,instr(w_xml_clob_loop,'</binaryB64>')+12);
      end loop;
      goto salta_for_loop;

<< for_loop>>
      for rec in sel_b64 ('/return/data/') loop
--dbms_output.put_line('debug - id '||rec.stringa_id);  
--dbms_output.put_line('debug - binary ('||dbms_lob.getlength(rec.binary_b64)||') '||substr(rec.binary_b64,1,200));  
w_step := 20.1;
         firmaremota_pkg.GET_DATI_RIF(rec.stringa_id,w_archivio_rif,w_id_rif);
         firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, 'w_archivio_rif '||w_archivio_rif||' w_id_rif '||w_id_rif);
--dbms_output.put_line('debug - w_archivio_rif '||w_archivio_rif||' w_id_rif '||w_id_rif);  
         if w_id_rif is null then
w_step := 20.2;
            w_errore := 'Dati di riferimento non decodificati ('||rec.stringa_id||')';
            firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, w_errore);
         else
w_step := 20.3;
            firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, 'prima della firma', rec.binary_b64);
w_step := 20.4;
--            w_binary_clob := firmaremota_pkg.GET_VALUE_BY_TAG(rec.binary_b64,'binaryB64');
            w_binary_clob := replace(replace(rec.binary_b64,'<binaryB64>',''),'</binaryB64>','');
w_step := 20.5;
            w_binary_blob := firmaremota_pkg.decode_base64(w_binary_clob);

            if a_archivio_rif = 'CIVCOM' then
w_step := 20.6;
               begin
                 update civcom_alle
                    set flag_ws_firma = 'S',
                        note_ws_firma = '',
                        allegato_clob = nvl(w_binary_clob,allegato_clob),
                        allegato_blob = nvl(w_binary_blob,allegato_blob),
                        nome_allegato = nome_allegato||'.p7m'
                  where id              = to_number(w_id_rif)
                    and flag_da_firmare is not null
                    and flag_ws_firma   is null
                 ;
               exception
                 when others then
                      w_errore := 'errore in upd CIVCOM_ALLE ('||SQLERRM||')';
                      firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, w_errore);
               end;
               firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, 'documento firmato', w_binary_clob);

            elsif a_archivio_rif = 'ANACOM' then
w_step := 20.6;
               begin
                 update anacom_alle
                    set flag_ws_firma = 'S',
                        note_ws_firma = '',
                        allegato_clob = nvl(w_binary_clob,allegato_clob),
                        allegato_blob = nvl(w_binary_blob,allegato_blob),
                        nome_allegato = nome_allegato||'.p7m'
                  where id              = to_number(w_id_rif)
                    and flag_da_firmare is not null
                    and flag_ws_firma   is null
                 ;
               exception
                 when others then
                      w_errore := 'errore in upd ANACOM_ALLE ('||SQLERRM||')';
                      firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, w_errore);
               end;
               firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, 'documento firmato', w_binary_clob);

            elsif a_archivio_rif = 'LEVCOM' then
w_step := 20.6;
               begin
                 update levcom_alle
                    set flag_ws_firma = 'S',
                        note_ws_firma = '',
                        allegato_clob = nvl(w_binary_clob,allegato_clob),
                        allegato_blob = nvl(w_binary_blob,allegato_blob),
                        nome_allegato = nome_allegato||'.p7m'
                  where id              = to_number(w_id_rif)
                    and flag_da_firmare is not null
                    and flag_ws_firma   is null
                 ;
               exception
                 when others then
                      w_errore := 'errore in upd LEVCOM_ALLE ('||SQLERRM||')';
                      firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, w_errore);
               end;
               firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, 'documento firmato', w_binary_clob);

            elsif a_archivio_rif = 'ELECOM' then
w_step := 20.6;
               begin
                 update elecom_alle
                    set flag_ws_firma = 'S',
                        note_ws_firma = '',
                        allegato_clob = nvl(w_binary_clob,allegato_clob),
                        allegato_blob = nvl(w_binary_blob,allegato_blob),
                        nome_allegato = nome_allegato||'.p7m'
                  where id              = to_number(w_id_rif)
                    and flag_da_firmare is not null
                    and flag_ws_firma   is null
                 ;
               exception
                 when others then
                      w_errore := 'errore in upd ELECOM_ALLE ('||SQLERRM||')';
                      firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, w_errore);
               end;
               firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, 'documento firmato', w_binary_clob);

            end if;
         end if;
      end loop;
<< salta_for_loop >>
null;
      w_out_xml_clob := '';
   else
w_step := 21.1;
      w_des_errore_ws := dbms_lob.substr(firmaremota_pkg.GET_VALUE_BY_TAG(w_out_xml_clob, 'message'),200,1);
      firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, 'response.des_errore', w_des_errore_ws);

--dbms_output.put_line('debug - message '||w_des_errore_ws);  
      if a_archivio_rif = 'CIVCOM' then
         begin
           update civcom_alle
              set flag_ws_firma = '',
                  note_ws_firma = w_des_errore_ws||' ('||w_cod_errore_ws||')'
            where id_com          = nvl(a_id_rif,id_com)
              and id              = nvl(a_id,id)
              and flag_da_firmare is not null
              and flag_ws_firma   is null
              and nvl(instr(a_id_rif,'#'),0) = 0
           ;
           update civcom_alle
              set flag_ws_firma = '',
                  note_ws_firma = w_des_errore_ws||' ('||w_cod_errore_ws||')'
            where a_id_rif        like '%#'||id_com||'#%'
              and flag_da_firmare is not null
              and flag_ws_firma   is null
              and nvl(instr(a_id_rif,'#'),0) > 0
           ;
         exception
           when others then
                w_errore := 'errore in upd CIVCOM_ALLE ('||SQLERRM||')';
                firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, w_errore);
         end;

      elsif a_archivio_rif = 'ANACOM' then
         begin
           update anacom_alle
              set flag_ws_firma = '',
                  note_ws_firma = w_des_errore_ws||' ('||w_cod_errore_ws||')'
            where id_com          = nvl(a_id_rif,id_com)
              and id              = nvl(a_id,id)
              and flag_da_firmare is not null
              and flag_ws_firma   is null
           ;
         exception
           when others then
                w_errore := 'errore in upd ANACOM_ALLE ('||SQLERRM||')';
                firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, w_errore);
         end;

      elsif a_archivio_rif = 'LEVCOM' then
         begin
           update levcom_alle
              set flag_ws_firma = '',
                  note_ws_firma = w_des_errore_ws||' ('||w_cod_errore_ws||')'
            where id_com          = nvl(a_id_rif,id_com)
              and id              = nvl(a_id,id)
              and flag_da_firmare is not null
              and flag_ws_firma   is null
           ;
         exception
           when others then
                w_errore := 'errore in upd LEVCOM_ALLE ('||SQLERRM||')';
                firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, w_errore);
         end;

      elsif a_archivio_rif = 'ELECOM' then
         begin
           update elecom_alle
              set flag_ws_firma = '',
                  note_ws_firma = w_des_errore_ws||' ('||w_cod_errore_ws||')'
            where id_com          = nvl(a_id_rif,id_com)
              and id              = nvl(a_id,id)
              and flag_da_firmare is not null
              and flag_ws_firma   is null
           ;
         exception
           when others then
                w_errore := 'errore in upd ELECOM_ALLE ('||SQLERRM||')';
                firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, w_errore);
         end;

      end if;
      firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, w_errore);
      w_out_xml_clob := w_des_errore_ws;

   end if;

<< fine >>
w_step := 13;
--  firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, 'fine');
  return w_out_xml_clob;
 
exception
  when errore then
       firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, '('||w_step||') '||w_errore);
       return null;
  when others then
       w_errore := 'exception ('||SQLERRM||')';
       firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, '('||w_step||') '||w_errore);
       return null;
end ATTIVAZIONE_WS;

function RICHIESTA_OTP
(a_usr                 IN   varchar2
,a_pwd                 IN   varchar2
)

return CLOB

IS

w_servizio             varchar2(255);

w_usr                  varchar2(255) := a_usr; -- nvl(a_usr,'USER');
w_pwd                  varchar2(255) := a_pwd; -- nvl(a_pwd,'PASSWORD');

w_soap_request         clob;

w_xml_clob      	clob;

w_out_xml_clob         clob;
w_out_xml_blob         blob;

w_errore               varchar2(4000);
errore                 exception;
w_nome_log             varchar2(255) := 'Richiesta OTP';
w_step                 number;

w_cod_errore_ws 	varchar2(255);
w_des_errore_ws 	varchar2(255);


begin

  w_service_url 	:= rtrim(f_valore_inp('FIRMA_URL',1,255,'X',''));

w_step := 1;
  firmaremota_pkg.dati_cliente;

  w_soap_action  := '';
  w_soap_request := '';

  w_servizio     := 'richiediOtp';
  w_soap_request  := '<soapenv:Envelope '||w_soap_str_1||' '||w_soap_str_2||'>
'||                  '  <soapenv:Header/>
'||                  '  <soapenv:Body>
'||                  '    <ser:'||w_servizio||'>
'||                  '      <req>
'||                  '        <password>'||w_pwd||'</password>
'||                  '        <service>'||w_provider_firma||'</service>
'||                  '        <user>'||w_usr||'</user>
'||                  '      </req>
'||                  '    </ser:'||w_servizio||'>
'||                  '  </soapenv:Body>
'||                  '</soapenv:Envelope>';

   firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, 'request', w_soap_request);

   w_out_xml_clob   := firmaremota_pkg.WS_REQUEST(w_service_url, w_service_name, w_service_ns, w_soap_request, '');
   firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, 'response', w_out_xml_clob);
   w_cod_errore_ws := dbms_lob.substr(firmaremota_pkg.GET_VALUE_BY_TAG(w_out_xml_clob, 'code'),255,1);
      firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, 'response.code', w_cod_errore_ws);

   if nvl(w_cod_errore_ws,' ') = 'OK' then
      w_xml_clob := substr(w_out_xml_clob,instr(w_out_xml_clob,'<return'));
      w_xml_clob := substr(w_xml_clob,1,instr(w_xml_clob,'</return>')+8);

      firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, 'response.extract (2)', w_xml_clob);

      w_out_xml_clob := '';

   else
      w_des_errore_ws := dbms_lob.substr(firmaremota_pkg.GET_VALUE_BY_TAG(w_out_xml_clob, 'message'),200,1);
      firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, 'response.des_errore', w_des_errore_ws);
   end if;

<< fine >>

  return w_out_xml_clob;
 
exception
  when errore then
       firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, '('||w_step||') '||w_errore);
       return null;
  when others then
       w_errore := 'exception ('||SQLERRM||')';
       firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, '('||w_step||') '||w_errore);
       return null;
end RICHIESTA_OTP;

function WS_REQUEST
(a_service_url        IN    varchar2
,a_service_name       IN    varchar2
,a_service_ns         IN    varchar2
,a_soap_request       IN    clob
,a_service_timeout    IN    number default 600
)
return CLOB
IS
w_soap_request        clob      := a_soap_request;
w_service_timeout     number   := a_service_timeout;
w_index               number;
w_soap_request_len    number;
rest_request          varchar2(30000);
rest_respond          clob;
http_request          utl_http.req;
http_response         utl_http.resp;
soap_response_30000   varchar2(30000);
soap_response         clob;
soap_response_5000    clob;
soap_response_line    varchar2(32000);
i                     number := 0;
out_xml_clob          clob;
w_errore              varchar2(4000);
errore                exception;
w_nome_log            varchar2(255) := 'WS Request';
begin
  utl_http.set_transfer_timeout(w_service_timeout);
--dbms_output.Put_Line ( 'w_service_url: ' || a_service_url );
  http_request:= utl_http.begin_request
                 ( a_service_url
                 , 'POST'
                 , 'HTTP/1.1'
                 );
  utl_http.set_persistent_conn_support(http_request, true);
  utl_http.set_header(http_request, 'Content-Type', 'text/xml');
  utl_http.set_header(http_request, 'Content-Length', length(w_soap_request));
--  utl_http.set_header(http_request, 'SOAPAction', a_service_ns||'/'||a_service_name);
  utl_http.set_header(http_request, 'SOAPAction', w_soap_action);
--dbms_output.put_line('WS_REQUEST - soapaction: '||w_soap_action);
--dbms_output.put_line('WS_REQUEST - prima di write_text');
  w_index         := 1;
  w_soap_request_len := dbms_lob.getlength(w_soap_request);
  while w_index <= w_soap_request_len loop
        utl_http.write_text(http_request, substr(w_soap_request, w_index, 30000));
        w_index := w_index + 30000;
  end loop;
--dbms_output.Put_Line('WS_REQUEST - w_soap_request:');
--dbms_output.put_line(substr(replace(w_soap_request,' ',''),1,250));
--dbms_output.put_line(substr(replace(w_soap_request,' ',''),251,250));
--dbms_output.put_line(substr(replace(w_soap_request,' ',''),501,250));
--dbms_output.put_line(substr(replace(w_soap_request,' ',''),751,250));
--dbms_output.put_line('WS_REQUEST - prima di get_response');
  http_response := utl_http.get_response(http_request);
--dbms_output.Put_Line ( 'Status code: ' || http_response.status_code );
--dbms_output.Put_Line ( 'Reason phrase: ' || http_response.reason_phrase );
  begin
    LOOP
      UTL_HTTP.read_text(http_response, soap_response_30000, 30000);
      soap_response := soap_response||soap_response_30000;
    END LOOP;
    UTL_HTTP.end_response(http_response);
  exception
    when UTL_HTTP.end_of_body THEN
         UTL_HTTP.end_response(http_response);
    when others then
         dbms_output.put_line('errore: '||sqlerrm);
  end;
--dbms_output.put_line('prima di xmltype(soap_response)');
--  out_xml:= xmltype(soap_response);
--dbms_output.put_line('dopo xmltype(soap_response)');
--dbms_output.put_line('prima di getclobval(out_xml)');
--  out_xml_clob   := xmltype.getclobval(out_xml);
--dbms_output.put_line('dopo getclobval(out_xml)');
  out_xml_clob   := soap_response;
  return out_xml_clob;
exception
  when others then
       w_errore := 'exception ('||SQLERRM||')';
       firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, w_errore);
end WS_REQUEST;

function GET_VALUE_BY_TAG
(a_xml		IN   clob
,a_tag 		IN   varchar2
)

return clob

IS

w_pos1 		integer;
w_pos2 		integer;

w_return 	clob;

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

procedure GET_DATI_RIF
(a_stringa_id          IN      clob
,w_archivio_rif        IN OUT  varchar2
,w_id_rif              IN OUT  varchar2
) 

IS

w_errore               varchar2(4000);
errore                 exception;

w_nome_log             varchar2(255) := 'get_dati_rif';

begin
--  firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, 'a_stringa_id '||a_stringa_id);
  if a_stringa_id is null then
     w_archivio_rif := '';
     w_id_rif       := '';
     goto fine;
  end if;
 
  if instr(a_stringa_id,'-') > 0 then
     w_archivio_rif := substr(a_stringa_id,1,instr(a_stringa_id,'-')-1);
--     firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, 'w_archivio_rif '||w_archivio_rif);
     w_id_rif       := substr(a_stringa_id,instr(a_stringa_id,'-')+1);
--     firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, 'w_id_rif '||w_id_rif);
--     if instr(w_id_rif,'.') > 0 then
--        w_id_rif := substr(w_id_rif,1,instr(w_id_rif,'.')-1);
--     end if;

  else
     w_archivio_rif := '';
     w_id_rif       := '';
  end if; 

<< fine >>
null;
--  firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, 'fine');
 
exception
  when errore then
       firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, w_errore);
  when others then
       w_errore := 'exception ('||SQLERRM||')';
       firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, w_errore);
end GET_DATI_RIF;

function DECODE_BASE64
(a_clob_in          IN    clob)
return BLOB
IS
v_blob              blob;
v_result            blob;
v_offset            integer;
v_buffer_size       binary_integer := 48;
v_buffer_varchar    varchar2(48);
v_buffer_raw        raw(48);
w_errore            varchar2(4000);
errore              exception;
w_nome_log          varchar2(255) := 'decode B64';
w_step              number;
begin
w_step := 1;
  if a_clob_in is null then
     return null;
  end if;
  dbms_lob.createtemporary(v_blob, true);

  w_step := 2;
  v_offset := 1;
--dbms_output.put_line('ceil... '||ceil(dbms_lob.getlength(a_clob_in) / v_buffer_size));
  for i in 1 .. ceil(dbms_lob.getlength(a_clob_in) / v_buffer_size) loop
w_step := 1000000.1 + i;
--dbms_output.put_line(i||') v_buf_size '||v_buffer_size||' - v_off '||v_offset||' - v_buf_chr '||v_buffer_varchar);
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
--       firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, w_errore);
dbms_output.put_line(substr(w_errore,1,255));
    return null;
end DECODE_BASE64;

function ENCODE_BASE64
(a_blob_in          IN    blob)
return CLOB
IS
v_clob             clob;
v_result           clob;
v_offset           integer;
v_chunk_size       binary_integer := (48 / 4) * 3;
v_buffer_varchar   varchar2(48);
v_buffer_raw       raw(48);
w_errore           varchar2(4000);
errore             exception;
w_nome_log         varchar2(255) := 'encode B64';
w_step             number;
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
--       firmaremota_pkg.INSERIMENTO_LOG(w_nome_log, w_errore);
--dbms_output.put_line(substr(w_errore,1,255));
    return null;
end ENCODE_BASE64;

end;
/
