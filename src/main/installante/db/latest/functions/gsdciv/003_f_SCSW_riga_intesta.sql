--liquibase formatted sql
--changeset amonopoli:202301121326 runOnChange:true
create or replace function f_SCSW_riga_intesta
(p_tipo_atto_nb    IN 	number
,p_separatore      IN 	varchar2
)

return varchar2

IS

w_sep          	varchar2(255) := nvl(p_separatore,chr(9));

w_riga_intesta 	varchar2(32000);

BEGIN
 if nvl(p_tipo_atto_nb,0)  = 0 then
    w_riga_intesta:=   'UFFICIO'||w_sep||'ANNO'||w_sep||'ATTO'||w_sep||'PARTE'||w_sep||'SERIE'||w_sep||
                       'NUMERO_ATTO_ANSC'||w_sep||
                       'TIPO_ATTO'||w_sep||'FORMULA'||w_sep||'DESCRIZIONE_FORMULA'||w_sep||'TESTO_ANNOTAZIONE'||w_sep||
                       'ESTREMI_ATTO_RIF_RIGA1'||w_sep||'ESTREMI_ATTO_RIF_RIGA2'||w_sep||
                       'COGNOME_NOME_1'||w_sep||'RIGA_NASCITA_1'||w_sep||
                       'NAT_OA_1'||w_sep||'DATA_NASCITA_1'||w_sep||
                       'COMUNE_NASCITA_1'||w_sep||'CAP_COMUNE_NASCITA_1'||w_sep||
                       'RIGA_RESIDENZA_1'||w_sep||
                       'COMUNE_RESIDENZA_1'||w_sep||'CAP_COMUNE_RESIDENZA_1'||w_sep||
                       'E'||w_sep||'COGNOME_NOME_2'||w_sep||
                       'RIGA_NASCITA_2'||w_sep||'NAT_OA_2'||w_sep||'DATA_NASCITA_2'||w_sep||
                       'COMUNE_NASCITA_2'||w_sep||'CAP_COMUNE_NASCITA_2'||w_sep||
                       'RIGA_RESIDENZA_2'||w_sep||
                       'COMUNE_RESIDENZA_2'||w_sep||'CAP_COMUNE_RESIDENZA_2'||w_sep||
                       'RIGA_MATRIMONIO'||w_sep||
                       'AL_TRIBUNALE_RIGA1'||w_sep||'AL_TRIBUNALE_RIGA2'||w_sep||
                       'AL_PROCURATORE_RIGA1'||w_sep||'AL_PROCURATORE_RIGA2'||w_sep||
                       'AL_PREFETTO_RIGA1'||w_sep||'AL_PREFETTO_RIGA2'||w_sep||
                       'TRIBUNALE_UTENTE'||w_sep||
                       'AL_COMUNE_RIGA1'||w_sep||'AL_COMUNE_RIGA2'||w_sep||
                       'COMUNE_TRASCRIZIONE_1_RIGA1'||w_sep||'COMUNE_TRASCRIZIONE_1_RIGA2'||w_sep||
                       'COMUNE_TRASCRIZIONE_2_RIGA1'||w_sep||'COMUNE_TRASCRIZIONE_2_RIGA2'||w_sep||
                       'BLOCCO_TRASCRIZIONE_1_RIGA1'||w_sep||'BLOCCO_TRASCRIZIONE_1_RIGA2'||w_sep||
                       'BLOCCO_TRASCRIZIONE_2_RIGA1'||w_sep||'BLOCCO_TRASCRIZIONE_2_RIGA2'||w_sep||
                       'AUTORITA_PROV'||w_sep||'AUTORITA_PROV_DA'||w_sep||'AUTORITA_PROV_IN'||w_sep||
                       'COMUNE_PROV'||w_sep||'AUTORITA_PROV_COMUNE'||w_sep||
                       'FRAZIONE_PROV'||w_sep||'AUTORITA_PROV_UFFICIO'||w_sep||
                       'UFFICIALE_PROV'||w_sep||'NOTA_RIF'||w_sep||
                       'ANNO_NOTA_RIF'||w_sep||'DATA_NOTA_RIF'||w_sep||'PROTOCOLLO_PROV'||w_sep||
                       'ANNO_PROTOCOLLO_PROV'||w_sep||
                       'DATA_PROTOCOLLO_PROV'||w_sep||'COMUNE_DATA'||w_sep||'COMUNE'||w_sep||'DATA'||w_sep||
                       'INVIO_TRIBUNALE_COMPETENTE_RIGA1'||w_sep||'INVIO_TRIBUNALE_COMPETENTE_RIGA2'||w_sep||
                       'INVIO_PROCURATORE_COMPETENTE_RIGA1'||w_sep||'INVIO_PROCURATORE_COMPETENTE_RIGA2'||w_sep||
                       'INVIO_COMUNE_TRASCRIZIONE'||w_sep||
                       'TERMINALISTA'||w_sep||'FIRMA_OMESSA'||w_sep||
                       'TERMINALISTA_ATTO'||w_sep||'FIRMA_OMESSA_TERM_ATTO'||w_sep||
                       'LOGO_CIV';

 elsif nvl(p_tipo_atto_nb,0) = 1 then
    w_riga_intesta:=  'UFFICIO'||w_sep||'ANNO'||w_sep||'ATTO'||w_sep||'PARTE'||w_sep||'SERIE'||w_sep||
                      'NUMERO_ATTO_ANSC'||w_sep|| 
                      'ACQUISTO_PERDITA'||w_sep||
                      'ISCR_CANC'||w_sep||'L_ACQUISTO_LA_PERDITA'||w_sep||
                      'COGNOME_NOME'||w_sep||'COGNOME'||w_sep||'NOME'||w_sep||
                      'DATA_NASCITA'||w_sep||'COMUNE_NASCITA'||w_sep||'CAP_COMUNE_NASCITA'||w_sep||
                      'RESIDENZA'||w_sep||'CAP_RESIDENZA'||w_sep||
                      'INDIRIZZO_ANA'||w_sep||'DATA_CITTADINANZA'||w_sep||
                      'DATA_RICHIESTA'||w_sep||'DATA_GIURAMENTO'||w_sep||'DATA_DECORRENZA'||w_sep||
                      'GIURAMENTO_UFFICIO'||w_sep||'GIURAMENTO_ANNO'||w_sep||'GIURAMENTO_ATTO'||w_sep||'GIURAMENTO_NUMERO_ATTO_ANSC'||w_sep||
                      'DECRETO_NUMERO'||w_sep||'DECRETO_DATA'||w_sep||'DECRETO_DATA_NOTIFICA'||w_sep||'DECRETO_FIRMATO'||w_sep||
                      'COMUNE_DATA'||w_sep||'COMUNE'||w_sep||'DATA'||w_sep||
                      'AUTORITA_PROV'||w_sep||'AUTORITA_PROV_DA'||w_sep||'AUTORITA_PROV_IN'||w_sep||
                      'COMUNE_PROV'||w_sep||'AUTORITA_PROV_COMUNE'||w_sep||
                      'FRAZIONE_PROV'||w_sep||'AUTORITA_PROV_UFFICIO'||w_sep||
                      'NOTA_RIF'||w_sep||'ANNO_NOTA_RIF'||w_sep||'DATA_NOTA_RIF'||w_sep||
                      'UFFICIALE_PROV'||w_sep||
                      'PROTOCOLLO_PROV'||w_sep||'ANNO_PROTOCOLLO_PROV'||w_sep||
                      'DATA_PROTOCOLLO_PROV'||w_sep||
                      'ENTE_STRANIERO'||w_sep||'COMUNE_ENTE_STRANIERO'||w_sep||'STATO_ENTE_STRANIERO'||w_sep||
                      'DATA_ATTO_ENTE_STRANIERO'||w_sep||'TIPO_ATTO_ENTE_STRANIERO'||w_sep||'ESTREMI_ATTO_ENTE_STRANIERO'||w_sep||
                      'TERMINALISTA'||w_sep||'FIRMA_OMESSA'||w_sep||
                      'TERMINALISTA_ATTO'||w_sep||'FIRMA_OMESSA_TERM_ATTO'||w_sep||
                      'LOGO_CIV';

 elsif nvl(p_tipo_atto_nb,0) = 2 then
    w_riga_intesta:=  'UFFICIO'||w_sep||'ANNO'||w_sep||'ATTO'||w_sep||'PARTE'||w_sep||'PARTE_EDIT'||w_sep||
                      'SERIE'||w_sep||'SERIE_EDIT'||w_sep||
                      'NUMERO_ATTO_ANSC'||w_sep||
                      'UFFICIO_ORIG'||w_sep||'ANNO_ORIG'||w_sep||
                      'ATTO_ORIG'||w_sep||'PARTE_ORIG'||w_sep||'PARTE_ORIG_EDIT'||w_sep||'SERIE_ORIG'||w_sep||
                      'SERIE_ORIG_EDIT'||w_sep||
                      'NUMERO_ATTO_ANSC_ORIG'||w_sep||
                      'COMUNE_ATTO'||w_sep||'COGNOME_NOME'||w_sep||'COGNOME'||w_sep||
                      'NOME'||w_sep||'CODICE_FISCALE'||w_sep||'SECONDO_NOME'||w_sep||'TERZO_NOME'||w_sep||
                      'SESSO'||w_sep||'NAT_OA'||w_sep||'DATA_NASCITA'||w_sep||
                      'GIORNO_NASCITA'||w_sep||'GIORNO_NASCITA_LETTERE'||w_sep||'MESE_NASCITA'||w_sep||
                      'ANNO_NASCITA'||w_sep||'ANNO_NASCITA_LETTERE'||w_sep||
                      'COMUNE_NASCITA'||w_sep||'CAP_COMUNE_NASCITA'||w_sep||
                      'ORE'||w_sep||'ORE_LETTERE'||w_sep||'MINUTI'||w_sep||'MINUTI_LETTERE'||w_sep||
                      'E_MINUTI'||w_sep||'E_MINUTI_LETTERE'||w_sep||'DEL_LUOGO_NASCITA'||w_sep||
                      'DEL_LUOGO_NASCITA_TRUNC'||w_sep||'LUOGO_NASCITA'||w_sep||'LUOGO_NASCITA_TRUNC'||w_sep||
                      'PATERNITA'||w_sep||'PATERNITA_SOLO_NOME'||w_sep||'INDIRIZZO_ANA_PAT'||w_sep||
                      'DATA_NAS_PAT'||w_sep||
                      'MATERNITA'||w_sep||'MATERNITA_SOLO_NOME'||w_sep||'INDIRIZZO_ANA_MAT'||w_sep||
                      'DATA_NAS_MAT'||w_sep||
                      'RESIDENZA'||w_sep||'CAP_RESIDENZA'||w_sep||'COMUNE_DATA'||w_sep||'COMUNE'||w_sep||
                      'DATA'||w_sep||
                      'AUTORITA_PROV'||w_sep||'AUTORITA_PROV_DA'||w_sep||'AUTORITA_PROV_IN'||w_sep||'COMUNE_PROV'||w_sep||'AUTORITA_PROV_COMUNE'||w_sep||
                      'FRAZIONE_PROV'||w_sep||'AUTORITA_PROV_UFFICIO'||w_sep||
                      'NOTA_RIF'||w_sep||'ANNO_NOTA_RIF'||w_sep||'DATA_NOTA_RIF'||w_sep||
                      'UFFICIALE_PROV'||w_sep||
                      'PROTOCOLLO_PROV'||w_sep||'ANNO_PROTOCOLLO_PROV'||w_sep||'DATA_PROTOCOLLO_PROV'||w_sep||
                      'ENTE_STRANIERO'||w_sep||'COMUNE_ENTE_STRANIERO'||w_sep||'STATO_ENTE_STRANIERO'||w_sep||
                      'DATA_ATTO_ENTE_STRANIERO'||w_sep||'TIPO_ATTO_ENTE_STRANIERO'||w_sep||'ESTREMI_ATTO_ENTE_STRANIERO'||w_sep||
                      'ATTO_NOTARILE'||w_sep||'COMUNE_ATTO_NOTARILE'||w_sep||'DATA_ATTO_NOTARILE'||w_sep||
                      'ESTREMI_DOC_ATTO_NOTARILE'||w_sep||'CENTRO_NASCITA'||w_sep||'COMUNE_CENTRO_NASCITA'||w_sep||
                      'NUMERO_DICH_CENTRO_NASCITA'||w_sep||'ANNO_DICH_CENTRO_NASCITA'||w_sep||
                      'DATA_RICHIESTA_CENTRO_NASCITA'||w_sep||
                      'ADDETTO_CENTRO_NASCITA'||w_sep||'QUALIFICA_CENTRO_NASCITA'||w_sep||
                      'DATA_DICH_CENTRO_NASCITA'||w_sep||'ORE_DICH_CENTRO_NASCITA'||w_sep||'MINUTI_DICH_CENTRO_NASCITA'||w_sep||
                      'TERMINALISTA'||w_sep||'FIRMA_OMESSA'||w_sep||
                      'TERMINALISTA_ATTO'||w_sep||'FIRMA_OMESSA_TERM_ATTO'||w_sep||
                      'LOGO_CIV';

 elsif nvl(p_tipo_atto_nb,0) = 3 then
    w_riga_intesta := 'UFFICIO'||w_sep||'ANNO'||w_sep||'ATTO'||w_sep||'PARTE'||w_sep||'PARTE_EDIT'||w_sep||
                      'SERIE'||w_sep||'SERIE_EDIT'||w_sep||
                      'COGNOME_NOME_SPOSO'||w_sep||'NATO'||w_sep||'DATA_NASCITA_SPOSO'||w_sep||
                      'COMUNE_NASCITA_SPOSO'||w_sep||'CAP_COMUNE_NASCITA_SPOSO'||w_sep||
                      'RESIDENZA_SPOSO'||w_sep||'CAP_RESIDENZA_SPOSO'||w_sep||
                      'INDIRIZZO_ANA_SPOSO'||w_sep||
                      'COGNOME_NOME_SPOSA'||w_sep||'NATA'||w_sep||'DATA_NASCITA_SPOSA'||w_sep||
                      'COMUNE_NASCITA_SPOSA'||w_sep||'CAP_COMUNE_NASCITA_SPOSA'||w_sep||
                      'RESIDENZA_SPOSA'||w_sep||'CAP_RESIDENZA_SPOSA'||w_sep||
                      'INDIRIZZO_ANA_SPOSA'||w_sep||
                      'DATA_PUBBLICAZIONI'||w_sep||'COMUNE_DATA'||w_sep||'COMUNE'||w_sep||'DATA'||w_sep||
                      'ANNO_TESTATA'||w_sep||'GIORNO'||w_sep||'MESE'||w_sep||'ORE'||w_sep||'MINUTI'||w_sep||
                      'UFFICIALE'||w_sep||
                      'COMUNE_MATRIMONIO'||w_sep||'STATO_CIVILE_SPOSO'||w_sep||'PROFESSIONE_SPOSO'||w_sep||
                      'CITTADINANZA_SPOSO'||w_sep||'STATO_CIVILE_SPOSA'||w_sep||'PROFESSIONE_SPOSA'||w_sep||
                      'CITTADINANZA_SPOSA'||w_sep||'ATTO_NASCITA_SPOSO'||w_sep||'PARTE_NASCITA_SPOSO'||w_sep||
                      'SERIE_NASCITA_SPOSO'||w_sep||'ANNO_ATTO_NASCITA_SPOSO'||w_sep||'ATTO_NASCITA_SPOSO_EDIT'||w_sep||
                      'COMUNE_ATTO_NASCITA_SPOSO'||w_sep||
                      'ATTO_NASCITA_SPOSA'||w_sep||'PARTE_NASCITA_SPOSA'||w_sep||
                      'SERIE_NASCITA_SPOSA'||w_sep||'ANNO_ATTO_NASCITA_SPOSA'||w_sep||'ATTO_NASCITA_SPOSA_EDIT'||w_sep||
                      'COMUNE_ATTO_NASCITA_SPOSA'||w_sep||
                      'COMUNE_AFFISSIONE'||w_sep||'DA_DATA_AFFISSIONE'||w_sep||'A_DATA_AFFISSIONE'||w_sep||
                      'GIORNI_AFFISSIONE'||w_sep||
                      'COMUNE_AFFISSIONE_2'||w_sep||'DA_DATA_AFFISSIONE_2'||w_sep||'A_DATA_AFFISSIONE_2'||w_sep||
                      'DATA_RILASCIO'||w_sep||'STAT_OA'||w_sep||'RILASCIAT_OA'||w_sep||
                      'CERTIFICATO'||w_sep||'ARTICOLO'||w_sep||'LEGGE'||w_sep||'RIGA_DOCUMENTI_1'||w_sep||
                      'RIGA_DOCUMENTI_2'||w_sep||'RIGA_DOCUMENTI_3'||w_sep||'RIGA_DOCUMENTI_4'||w_sep||
                      'RIGA_DOCUMENTI_5'||w_sep||'RIGA_DOCUMENTI_6'||w_sep||'RIGA_DOCUMENTI_7'||w_sep||
                      'RIGA_DOCUMENTI_8'||w_sep||'RIGA_DOCUMENTI_9'||w_sep||'RIGA_DOCUMENTI_10'||w_sep||
                      'RIGA_DOCUMENTI_11'||w_sep||'RIGA_DOCUMENTI_12'||w_sep||'RIGA_DOCUMENTI_13'||w_sep||
                      'RIGA_DOCUMENTI_14'||w_sep||'RIGA_DOCUMENTI_15'||w_sep||'AUTORITA_PROV'||w_sep||'AUTORITA_PROV_DA'||w_sep||
					  'AUTORITA_PROV_IN'||w_sep||'COMUNE_PROV'||w_sep||'AUTORITA_PROV_COMUNE'||w_sep||
                      'FRAZIONE_PROV'||w_sep||'AUTORITA_PROV_UFFICIO'||w_sep||'NOTA_RIF'||w_sep||'ANNO_NOTA_RIF'||w_sep||
                      'DATA_NOTA_RIF'||w_sep||'UFFICIALE_PROV'||w_sep||'PROTOCOLLO_PROV'||w_sep||
                      'ANNO_PROTOCOLLO_PROV'||w_sep||'DATA_PROTOCOLLO_PROV'||w_sep||
                      'TERMINALISTA'||w_sep||'FIRMA_OMESSA'||w_sep||
                      'TERMINALISTA_ATTO'||w_sep||'FIRMA_OMESSA_TERM_ATTO'||w_sep||
                      'LOGO_CIV';

 elsif nvl(p_tipo_atto_nb,0) = 4 then
    w_riga_intesta := 'UFFICIO'||w_sep||'ANNO'||w_sep||'ATTO'||w_sep||'PARTE'||w_sep||'PARTE_EDIT'||w_sep||
                      'SERIE'||w_sep||'SERIE_EDIT'||w_sep||
                      'NUMERO_ATTO_ANSC'||w_sep||
                      'UFFICIO_ORIG'||w_sep||'ANNO_ORIG'||w_sep||
                      'ATTO_ORIG'||w_sep||
                      'PARTE_ORIG'||w_sep||'PARTE_ORIG_EDIT'||w_sep||'SERIE_ORIG'||w_sep||'SERIE_ORIG_EDIT'||w_sep||
                      'NUMERO_ATTO_ANSC_ORIG'||w_sep||
                      'COGNOME_NOME_SPOSO'||w_sep||'CODICE_FISCALE_SPOSO'||w_sep||'NATO_IL'||w_sep||
                      'DATA_NASCITA_SPOSO'||w_sep||
                      'COMUNE_NASCITA_SPOSO'||w_sep||'CAP_COMUNE_NASCITA_SPOSO'||w_sep||
                      'TRIBUNALE_NASCITA_SPOSO'||w_sep||'ATTO_NASCITA_SPOSO'||w_sep||
                      'PARTE_NASCITA_SPOSO'||w_sep||'SERIE_NASCITA_SPOSO'||w_sep||'ANNO_ATTO_NASCITA_SPOSO'||w_sep||
                      'NUMERO_ATTO_ANSC_NASCITA_SPOSO'||w_sep||
                      'ATTO_NASCITA_SPOSO_EDIT'||w_sep||'COMUNE_ATTO_NASCITA_SPOSO'||w_sep||'RESIDENZA_SPOSO'||w_sep||
                      'CAP_RESIDENZA_SPOSO'||w_sep||'INDIRIZZO_ANA_SPOSO'||w_sep||'COGNOME_NOME_SPOSA'||w_sep||
                      'CODICE_FISCALE_SPOSA'||w_sep||'NATA_IL'||w_sep||'DATA_NASCITA_SPOSA'||w_sep||
                      'COMUNE_NASCITA_SPOSA'||w_sep||'CAP_COMUNE_NASCITA_SPOSA'||w_sep||
                      'TRIBUNALE_NASCITA_SPOSA'||w_sep||'ATTO_NASCITA_SPOSA'||w_sep||'PARTE_NASCITA_SPOSA'||w_sep||
                      'SERIE_NASCITA_SPOSA'||w_sep||'ANNO_ATTO_NASCITA_SPOSA'||w_sep||
                      'NUMERO_ATTO_ANSC_NASCITA_SPOSA'||w_sep||
                      'ATTO_NASCITA_SPOSA_EDIT'||w_sep||
                      'COMUNE_ATTO_NASCITA_SPOSA'||w_sep||
                      'RESIDENZA_SPOSA'||w_sep||'CAP_RESIDENZA_SPOSA'||w_sep||
                      'INDIRIZZO_ANA_SPOSA'||w_sep||'DATA_MATRIMONIO'||w_sep||
                      'GIORNO_MATRIMONIO'||w_sep||'GIORNO_MATRIMONIO_LETTERE'||w_sep||
                      'MESE_MATRIMONIO'||w_sep||'ANNO_MATRIMONIO'||w_sep||'ANNO_MATRIMONIO_LETTERE'||w_sep||
                      'COMUNE_MATRIMONIO'||w_sep||'CAP_COMUNE_MATRIMONIO'||w_sep||'RITO'||w_sep||
                      'DATA_RICONCILIAZIONE'||w_sep||'DATA_CONFERMA_DIVORZIO'||w_sep||'DATA_ACCORDO_DIVORZIO'||w_sep||
                      'COMUNE_DATA'||w_sep||'COMUNE'||w_sep||'DATA'||w_sep||'AUTORITA_PROV'||w_sep||'AUTORITA_PROV_DA'||w_sep||
                      'AUTORITA_PROV_IN'||w_sep||'COMUNE_PROV'||w_sep||'AUTORITA_PROV_COMUNE'||w_sep||
                      'FRAZIONE_PROV'||w_sep||'AUTORITA_PROV_UFFICIO'||w_sep||
                      'NOTA_RIF'||w_sep||'ANNO_NOTA_RIF'||w_sep||'DATA_NOTA_RIF'||w_sep||'UFFICIALE_PROV'||w_sep||
                      'PROTOCOLLO_PROV'||w_sep||'ANNO_PROTOCOLLO_PROV'||w_sep||
                      'DATA_PROTOCOLLO_PROV'||w_sep||
                      'ENTE_STRANIERO'||w_sep||'COMUNE_ENTE_STRANIERO'||w_sep||'STATO_ENTE_STRANIERO'||w_sep||
                      'DATA_ATTO_ENTE_STRANIERO'||w_sep||'TIPO_ATTO_ENTE_STRANIERO'||w_sep||'ESTREMI_ATTO_ENTE_STRANIERO'||w_sep||
                      'TERMINALISTA'||w_sep||'FIRMA_OMESSA'||w_sep||
                      'TERMINALISTA_ATTO'||w_sep||'FIRMA_OMESSA_TERM_ATTO'||w_sep||
                      'LOGO_CIV';

 elsif nvl(p_tipo_atto_nb,0) = 5 then
    w_riga_intesta := 'UFFICIO'||w_sep||'ANNO'||w_sep||'ATTO'||w_sep||'PARTE'||w_sep||'PARTE_EDIT'||w_sep||
                      'SERIE'||w_sep||'SERIE_EDIT'||w_sep||
                      'NUMERO_ATTO_ANSC'||w_sep||
                      'UFFICIO_ORIG'||w_sep||'ANNO_ORIG'||w_sep||
                      'ATTO_ORIG'||w_sep||'PARTE_ORIG'||w_sep||'PARTE_ORIG_EDIT'||w_sep||
                      'SERIE_ORIG'||w_sep||'SERIE_ORIG_EDIT'||w_sep||
                      'NUMERO_ATTO_ANSC_ORIG'||w_sep||
                      'COGNOME_NOME'||w_sep||
                      'CODICE_FISCALE'||w_sep||'SESSO'||w_sep||'NAT_OA'||w_sep||'NAT_OA_IL'||w_sep||
                      'DATA_NASCITA'||w_sep||'COMUNE_NASCITA'||w_sep||'CAP_COMUNE_NASCITA'||w_sep||
                      'TRIBUNALE_NASCITA'||w_sep||'RESIDENZA'||w_sep||
                      'CAP_RESIDENZA'||w_sep||
                      'INDIRIZZO_ANA'||w_sep||'DECEDUT_OA'||w_sep||'MORT_OA'||w_sep||'DATA_MORTE'||w_sep||
                      'GIORNO_MORTE'||w_sep||'GIORNO_MORTE_LETTERE'||w_sep||
                      'MESE_MORTE'||w_sep||'ANNO_MORTE'||w_sep||'ANNO_MORTE_LETTERE'||w_sep||
                      'COMUNE_MORTE'||w_sep||'CAP_COMUNE_MORTE'||w_sep||
                      'ORE'||w_sep||'ORE_LETTERE'||w_sep||
                      'MINUTI'||w_sep||'MINUTI_LETTERE'||w_sep||'E_MINUTI'||w_sep||'E_MINUTI_LETTERE'||w_sep||
                      'MOTIVO_MORTE'||w_sep||'STATO_CIVILE'||w_sep||
                      'COGNOME_NOME_CONIUGE'||w_sep||'COMUNE_DATA'||w_sep||'COMUNE'||w_sep||'DATA'||w_sep||
                      'TRIBUNALE'||w_sep||'COMUNE_REGISTRO'||w_sep||'ANNO_NAS'||w_sep||'PARTE_NAS'||w_sep||
                      'SERIE_NAS'||w_sep||'ATTO_NAS'||w_sep||'UFFICIO_NAS'||w_sep||
                      'NUMERO_ATTO_ANSC_NAS'||w_sep||
                      'ATTO_NAS_EDIT'||w_sep||
                      'PADRE'||w_sep||'MADRE'||w_sep||
                      'PROFESSIONE'||w_sep||'LUOGO_MORTE'||w_sep||'AUTORITA_PROV'||w_sep||'AUTORITA_PROV_DA'||w_sep||
                      'AUTORITA_PROV_IN'||w_sep||'COMUNE_PROV'||w_sep||'AUTORITA_PROV_COMUNE'||w_sep||
                      'FRAZIONE_PROV'||w_sep||'AUTORITA_PROV_UFFICIO'||w_sep||'NOTA_RIF'||w_sep||'ANNO_NOTA_RIF'||w_sep||'DATA_NOTA_RIF'||w_sep||
                      'UFFICIALE_PROV'||w_sep||'PROTOCOLLO_PROV'||w_sep||'ANNO_PROTOCOLLO_PROV'||w_sep||
                      'DATA_PROTOCOLLO_PROV'||w_sep||
                      'ENTE_STRANIERO'||w_sep||'COMUNE_ENTE_STRANIERO'||w_sep||'STATO_ENTE_STRANIERO'||w_sep||
                      'DATA_ATTO_ENTE_STRANIERO'||w_sep||'TIPO_ATTO_ENTE_STRANIERO'||w_sep||'ESTREMI_ATTO_ENTE_STRANIERO'||w_sep||
                      'DATA_RICHIESTA_TRASPORTO'||w_sep||'RICHIEDENTE_TRASPORTO'||w_sep||
                      'DATA_TRASPORTO'||w_sep||'ORE_TRASPORTO'||w_sep||'MINUTI_TRASPORTO'||w_sep||
                      'INCARICATO_TRASPORTO'||w_sep||'COMUNE_DEST_TRASPORTO'||w_sep||
                      'INDIRIZZO_DEST_TRASPORTO'||w_sep||'CIMITERO_DEST_TRASPORTO'||w_sep||
                      'DATA_CREMAZIONE'||w_sep||'ORE_CREMAZIONE'||w_sep||'MINUTI_CREMAZIONE'||w_sep||
                      'COMUNE_CREMAZIONE'||w_sep||'DESTINAZIONE_CENERI'||w_sep||'NOTE_CREMAZIONE'||w_sep||
                      'DITTA_ONORANZE_FUNEBRI'||w_sep||'DATA_ONORANZE_FUNEBRI'||w_sep||
                      'ORE_ONORANZE_FUNEBRI'||w_sep||'MINUTI_ONORANZE_FUNEBRI'||w_sep||
                      'COMUNE_ONORANZE_FUNEBRI'||w_sep||'NOTE_TRASPORTO'||w_sep||
                      'PROTOCOLLO_TRASPORTO'||w_sep||'ANNO_PROTOCOLLO_TRASPORTO'||w_sep||'DATA_PROTOCOLLO_TRASPORTO'||w_sep||
                      'PROTOCOLLO_PERMESSO'||w_sep||'ANNO_PROTOCOLLO_PERMESSO'||w_sep||'DATA_PROTOCOLLO_PERMESSO'||w_sep||
                      'PROT_PERMESSO_ALTRO_COMUNE'||w_sep||'ANNO_PERMESSO_ALTRO_COMUNE'||w_sep||'DATA_PERMESSO_ALTRO_COMUNE'||w_sep||
                      'PROTOCOLLO_CREMAZIONE'||w_sep||'ANNO_PROTOCOLLO_CREMAZIONE'||w_sep||'DATA_PROTOCOLLO_CREMAZIONE'||w_sep||
                      'TERMINALISTA'||w_sep||'FIRMA_OMESSA'||w_sep||
                      'TERMINALISTA_ATTO'||w_sep||'FIRMA_OMESSA_TERM_ATTO'||w_sep||
                      'LOGO_CIV';

 elsif nvl(p_tipo_atto_nb,0) = -4 then
    w_riga_intesta := 'UFFICIO'||w_sep||'ANNO'||w_sep||'ATTO'||w_sep||'PARTE'||w_sep||'PARTE_EDIT'||w_sep||
                      'SERIE'||w_sep||'SERIE_EDIT'||w_sep||
                      'NUMERO_ATTO_ANSC'||w_sep||
                      'UFFICIO_ORIG'||w_sep||'ANNO_ORIG'||w_sep||
                      'ATTO_ORIG'||w_sep||
                      'PARTE_ORIG'||w_sep||'PARTE_ORIG_EDIT'||w_sep||'SERIE_ORIG'||w_sep||'SERIE_ORIG_EDIT'||w_sep||
                      'NUMERO_ATTO_ANSC_ORIG'||w_sep||
                      'COGNOME_NOME_1'||w_sep||'CODICE_FISCALE_1'||w_sep||'NAT_OA_IL_1'||w_sep||
                      'DATA_NASCITA_1'||w_sep||'COMUNE_NASCITA_1'||w_sep||'CAP_COMUNE_NASCITA_1'||w_sep||
                      'TRIBUNALE_NASCITA_1'||w_sep||'ATTO_NASCITA_1'||w_sep||
                      'PARTE_NASCITA_1'||w_sep||'SERIE_NASCITA_1'||w_sep||'ANNO_ATTO_NASCITA_1'||w_sep||
                      'NUMERO_ATTO_ANSC_NASCITA_1'||w_sep||
                      'ATTO_NASCITA_1_EDIT'||w_sep||'COMUNE_ATTO_NASCITA_1'||w_sep||'RESIDENZA_1'||w_sep||
                      'CAP_RESIDENZA_1'||w_sep||'INDIRIZZO_ANA_1'||w_sep||
                      'COGNOME_NOME_2'||w_sep||'CODICE_FISCALE_2'||w_sep||'NAT_OA_IL_2'||w_sep||
                      'DATA_NASCITA_2'||w_sep||'COMUNE_NASCITA_2'||w_sep||'CAP_COMUNE_NASCITA_2'||w_sep||
                      'TRIBUNALE_NASCITA_2'||w_sep||'ATTO_NASCITA_2'||w_sep||'PARTE_NASCITA_2'||w_sep||
                      'SERIE_NASCITA_2'||w_sep||'ANNO_ATTO_NASCITA_2'||w_sep||
                      'NUMERO_ATTO_ANSC_NASCITA_2'||w_sep||
                      'ATTO_NASCITA_2_EDIT'||w_sep||
                      'COMUNE_ATTO_NASCITA_2'||w_sep||
                      'RESIDENZA_2'||w_sep||'CAP_RESIDENZA_2'||w_sep||'INDIRIZZO_ANA_2'||w_sep||
                      'DATA_UNIONE'||w_sep||'GIORNO_UNIONE_LETTERE'||w_sep||
                      'MESE_UNIONE'||w_sep||'ANNO_UNIONE_LETTERE'||w_sep||
                      'COMUNE_UNIONE'||w_sep||'CAP_COMUNE_UNIONE'||w_sep||
                      'DATA_CONFERMA_SCIOGLIMENTO'||w_sep||'DATA_ACCORDO_SCIOGLIMENTO'||w_sep||
                      'COMUNE_DATA'||w_sep||'COMUNE'||w_sep||'DATA'||w_sep||'AUTORITA_PROV'||w_sep||'AUTORITA_PROV_DA'||w_sep||
                      'AUTORITA_PROV_IN'||w_sep||'COMUNE_PROV'||w_sep||'AUTORITA_PROV_COMUNE'||w_sep||
                      'FRAZIONE_PROV'||w_sep||'AUTORITA_PROV_UFFICIO'||w_sep||
                      'NOTA_RIF'||w_sep||'ANNO_NOTA_RIF'||w_sep||'DATA_NOTA_RIF'||w_sep||'UFFICIALE_PROV'||w_sep||
                      'PROTOCOLLO_PROV'||w_sep||'ANNO_PROTOCOLLO_PROV'||w_sep||
                      'DATA_PROTOCOLLO_PROV'||w_sep||
                      'ENTE_STRANIERO'||w_sep||'COMUNE_ENTE_STRANIERO'||w_sep||'STATO_ENTE_STRANIERO'||w_sep||
                      'DATA_ATTO_ENTE_STRANIERO'||w_sep||'TIPO_ATTO_ENTE_STRANIERO'||w_sep||'ESTREMI_ATTO_ENTE_STRANIERO'||w_sep||
                      'TERMINALISTA'||w_sep||'FIRMA_OMESSA'||w_sep||
                      'TERMINALISTA_ATTO'||w_sep||'FIRMA_OMESSA_TERM_ATTO'||w_sep||
                      'LOGO_CIV';
 end if;

 w_riga_intesta := 'DEP'||w_sep||
                   w_riga_intesta||w_sep||
                   f_SER_riga_intesta(w_sep,'CIV')||w_sep||
                   f_SER_riga_intesta(w_sep,'COM')||w_sep||
                   f_SER_riga_intesta(w_sep,'URP');

 return w_riga_intesta;

END;
/
