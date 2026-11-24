--liquibase formatted sql
--changeset amonopoli:202203221240_1 runOnChange:true stripComments:false
CREATE OR REPLACE function f_SAPW_riga_dati
(a_anagrafe		IN 	varchar2
,a_tipo_evento		IN 	varchar2
,a_anno_pratica		IN 	number
,a_pratica		IN 	number
,a_anno_dic		IN 	number
,a_numero_dic		IN 	number
,a_matricola		IN	number
,a_nome_terminalista 	IN	varchar2
,a_separatore		IN	varchar2
,a_utente            	IN  	varchar2)

return varchar2

IS

w_sep			        varchar2(255)  := nvl(a_separatore,chr(9));

w_riga_dati_vuota	        varchar2(4000);
w_riga_dati 		        varchar2(4000);
w_terminalista                  varchar2(81);
w_indirizzo_mail_terminalista   varchar2(100);
w_numero_tel_terminalista       varchar2(100);

w_firma_omessa                  varchar2(255);

w_cod_cdf			number;

BEGIN
  begin
    select nome||' '||cognome,indirizzo_mail,numero_tel
      into w_terminalista,w_indirizzo_mail_terminalista,w_numero_tel_terminalista
      from CERDTE
     where cod_utente = a_utente
    ;
  exception
    when others then
         w_terminalista                := '';
         w_indirizzo_mail_terminalista := '';
         w_numero_tel_terminalista     := '';
  end;

  w_riga_dati_vuota := rpad(w_sep,65,w_sep)||rpad(w_sep,45,w_sep);

  begin
    select to_char(ANNO_PRATICA)||w_sep||to_char(PRATICA)||w_sep||
           DATA_PRATICA||w_sep||TIPO_PRATICA||w_sep||
           COGNOME_NOME_DICHIARANTE||w_sep||COD_FISCALE_DICHIARANTE||w_sep||
           RIGA_TRASFERIMENTO_1||w_sep||RIGA_TRASFERIMENTO_2||w_sep||
           RIGA_TRASFERIMENTO_3||w_sep||RIGA_TRASFERIMENTO_4||w_sep||
           COGNOME_NOME||w_sep||COGNOME||w_sep||NOME||w_sep||SESSO||w_sep||
           PATERNITA||w_sep||MATERNITA||w_sep||NAT_OA||w_sep||DATA_NASCITA||w_sep||
           COMUNE_NASCITA||w_sep||COMUNE_ATTO_NASCITA||w_sep||ATTO_NASCITA||w_sep||
           STATO_CIVILE||w_sep||CONIUGAT_OA||w_sep||COGNOME_NOME_CONIUGE||w_sep||
           CITTADINANZA||w_sep||COD_FISCALE||w_sep||RAPPORTO_PARENTELA||w_sep||
           to_char(SEQUENZA_PAR)||w_sep||RESIDENZA_FAM||w_sep||INDIRIZZO_FAM||w_sep||
           RESIDENZA||w_sep||INDIRIZZO||w_sep||CAP_COMUNE_RESIDENZA||w_sep||
           INDIRIZZO_DICHIARATO||w_sep||COMUNE_DICHIARATO||w_sep||
           NUMERO_CARTA_DICHIARANTE||w_sep||DATA_CARTA_DICHIARANTE||w_sep||
           COMUNE_DATA||w_sep||COMUNE||w_sep||DATA||w_sep||
           f_get_campo_sap(a_anagrafe,a_tipo_evento,a_anno_pratica,a_pratica,'1','DATA_RESTITUZIONE')||w_sep||
           f_get_campo_sap(a_anagrafe,a_tipo_evento,a_anno_pratica,a_pratica,'1','NOTE')||w_sep||
           MATRICOLA||w_sep||MATRICOLA_DICHIARANTE||w_sep||
           DESCRIZIONE_EVENTO||w_sep||PROFESSIONE_DICHIARANTE||w_sep||TITOLO_STUDIO_DICHIARANTE||w_sep||
           decode(sesso_dichiarante,'M','il Sig.','F','la Sig.ra','il Sig./la Sig.ra')||w_sep||
           decode(sesso_dichiarante,'M','Sig.','F','Sig.ra','Sig./Sig.ra')||w_sep||
           COMUNE_PROVENIENZA||w_sep||DATA_DECORRENZA
      into w_riga_dati
      from CERTPR
     where anagrafe     = a_anagrafe
       and tipo_evento 	= a_tipo_evento
       and anno_pratica	= a_anno_pratica
       and pratica      = a_pratica
       and anno_dic     = nvl(a_anno_dic, anno_dic)
       and numero_dic   = nvl(a_numero_dic, numero_dic)
       and matricola    = nvl(a_matricola, matricola)
       and rownum       = 1
    ;
    if w_terminalista is not null then
       w_firma_omessa := f_get_firma_omessa('SAPW','ANA_FIRMA');
    else
       w_firma_omessa := '';
    end if;

    w_riga_dati := w_riga_dati||w_sep||
                   'FAM_DCA_1'||w_sep||'FAM_DCA_2'||w_sep||'FAM_DCA_3'||w_sep||'FAM_VAA'||w_sep||
                   'DOC_PT_1'||w_sep||'DOC_CC_1'||w_sep||'DOC_PT_2'||w_sep||'DOC_CC_2';
    w_cod_cdf   := f_flag_cdf_x_pratica(A_ANAGRAFE,A_TIPO_EVENTO,A_ANNO_PRATICA,A_PRATICA,A_ANNO_DIC,A_NUMERO_DIC);
    if w_cod_cdf is not null then
       w_riga_dati := w_riga_dati||w_sep||
                   'CDF_1'||w_sep||'CDF_2'||w_sep||'CDF_3'||w_sep||'CDF_4'||w_sep||'CDF_5';
    else
       w_riga_dati := w_riga_dati||w_sep||
                   ''||w_sep||''||w_sep||''||w_sep||''||w_sep||'';
    end if;

    w_riga_dati := w_riga_dati||w_sep||
                    nvl(w_terminalista,'')||w_sep||w_firma_omessa||w_sep||
                    nvl(w_numero_tel_terminalista,'')||w_sep||nvl(w_indirizzo_mail_terminalista,'');


                    

  if w_riga_dati is not null then
      w_riga_dati := w_riga_dati||w_sep||w_sep||
                     f_SER_riga_dati(w_sep,'ANA')||w_sep||
                     f_SER_riga_dati(w_sep,'COM')||w_sep||
                     f_SER_riga_dati(w_sep,'URP');
  end if;

exception
  when no_data_found then
       w_riga_dati := w_riga_dati_vuota;
  when others then
       w_riga_dati := w_riga_dati_vuota;
end;

return w_riga_dati;

END;
/
