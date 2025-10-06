--liquibase formatted sql
--changeset amonopoli:202310261315_1 runOnChange:true stripComments:false
CREATE OR REPLACE procedure p_CERW_riga_intesta
(p_tipo_archivio        IN	number
,p_separatore           IN	varchar2
,w_riga_intesta_1	IN OUT	varchar2
,w_riga_intesta_2	IN OUT	varchar2)

--return varchar2

IS

w_sep           varchar2(255) := nvl(p_separatore,chr(9));

BEGIN
  if p_tipo_archivio in (0,6) then
     w_riga_intesta_1 := 'MATRICOLA'||w_sep||'COGNOME_NOME'||w_sep||'COGNOME'||w_sep||
                         'NOME'||w_sep||'COGNOME_NOME_ELE'||w_sep||'SESSO'||w_sep||'STATO_CIVILE'||w_sep||
                         'STATO_CIVILE_CDI'||w_sep||
                         'NAT_OA'||w_sep||'CITTADINO_ITALIANO'||w_sep||'CITTADINANZA'||w_sep||'INIZIO_CITTADINANZA'||w_sep||
                         'PATERNITA'||w_sep||'MATERNITA'||w_sep||'INDIRIZZO'||w_sep||
                         'INDIRIZZO_INT'||w_sep||'INIZIO_INDIRIZZO'||w_sep||'INIZIO_FAMIGLIA'||w_sep||
                         'RESIDENZA'||w_sep||'INIZIO_RESIDENZA'||w_sep||'VIA_AIRE'||w_sep||
                         'COMUNE_AIRE'||w_sep||'STATO_AIRE'||w_sep||
                         'ZIPCODE'||w_sep||'PROVINCIA_CONTEA'||w_sep||'PRESSO'||w_sep||
                         'TITOLO_STUDIO'||w_sep||'PROFESSIONE'||w_sep||'DATA_NASCITA'||w_sep||
                         'COMUNE_NASCITA'||w_sep||'COMUNE_ATTO_NASCITA'||w_sep||'CAP_COMUNE_ATTO_NASCITA'||w_sep||
                         'ATTO_NASCITA'||w_sep||'CONIUGAT_OA'||w_sep||'COGNOME_NOME_CONIUGE'||w_sep||
                         'COGNOME_NOME_CONIUGE_CN'||w_sep||
                         'ESTREMI_NASCITA_CONIUGE'||w_sep||'ESTREMI_NASCITA_CONIUGE_CN'||w_sep||
                         'ATTO_NASCITA_CONIUGE'||w_sep||
                         'INDIRIZZO_CONIUGE'||w_sep||'RESIDENZA_CONIUGE'||w_sep||
                         'INIZIO_RESIDENZA_CONIUGE'||w_sep||'DATA_MORTE_CONIUGE'||w_sep||
                         'ESTREMI_MAT_VED'||w_sep||'ATTO_MAT_VED'||w_sep||'DATA_MATRIMONIO'||w_sep||
                         'COMUNE_MATRIMONIO'||w_sep||
                         'COMUNE_ATTO_MATRIMONIO'||w_sep||'CAP_COMUNE_ATTO_MATRIMONIO'||w_sep||
                         'ATTO_MATRIMONIO'||w_sep||'DATA_VEDOVANZA'||w_sep||
                         'COMUNE_VEDOVANZA'||w_sep||
                         'COMUNE_ATTO_VEDOVANZA'||w_sep||'CAP_COMUNE_ATTO_VEDOVANZA'||w_sep||
                         'ATTO_VEDOVANZA'||w_sep||
                         'COGNOME_NOME_CV'||w_sep||'COGNOME_CV'||w_sep||'NOME_CV'||w_sep||
                         'ESTREMI_NASCITA_CV'||w_sep||'ATTO_NASCITA_CV'||w_sep||'CODICE_FISCALE_CV'||w_sep||
                         'DATA_INIZIO_CDF'||w_sep||'COMUNE_INIZIO_CDF'||w_sep||'PRATICA_INIZIO_CDF'||w_sep||
                         'DATA_FINE_CDF'||w_sep||'COMUNE_FINE_CDF'||w_sep||'PRATICA_FINE_CDF'||w_sep||
                         'CONTRATTO_CONVIVENZA'||w_sep||
                         'DECEDUT_OA'||w_sep||'MORT_OA'||w_sep||'DATA_MORTE'||w_sep||
                         'COMUNE_MORTE'||w_sep||'COMUNE_ATTO_MORTE'||w_sep||'CAP_COMUNE_ATTO_MORTE'||w_sep||'ATTO_MORTE'||w_sep||
                         'CODICE_FISCALE'||w_sep||'CODICE_FISCALE_VALIDATO'||w_sep||'CODICE_FAMIGLIA'||w_sep||
                         'ANNO_CENSIMENTO'||w_sep||'SEZIONE_CENSIMENTO'||w_sep||'FOGLIO_CENSIMENTO'||w_sep||
                         'INTESTATARIO_CONVIVENZA'||w_sep||
                         'ESTREMI_ULTIMO_EVENTO'||w_sep||'PRATICA_ULTIMO_EVENTO'||w_sep||'DATA_ULTIMO_EVENTO'||w_sep||
                         'DATA_RICOMPARSA'; 
     w_riga_intesta_2 := 'COMUNE_RICOMPARSA'||w_sep||'PRATICA_RICOMPARSA'||w_sep||'INDIRIZZO_PRECEDENTE'||w_sep||
                         'ISCRITT_OA'||w_sep||'INCORS_OA'||w_sep||
                         'SOTTOSCRITT_OA'||w_sep||'DIRITTI_POLITICI'||w_sep||'SEZIONE'||w_sep||'SEDE_SEZIONE'||w_sep||
                         'INDIRIZZO_SEZIONE'||w_sep||'PROGR_LISTA_GENERALE'||w_sep||
                         'PROGR_LISTA_SEZIONALE'||w_sep||'TESSERA_ELETTORALE'||w_sep||'DATA_TESSERA_ELETTORALE'||w_sep||
                         'INDIRIZZO_ELE'||w_sep||
                         'FASCICOLO_ELE'||w_sep||'VERBALE_ELE'||w_sep||'DATA_VERBALE_ELE'||w_sep||
                         'ISCRIZIONE_AIRE'||w_sep||'CLASSE_LEVA'||w_sep||'NUMERO_LISTA'||w_sep||'MATRICOLA_LEVA'||w_sep||
                         'DISTRETTO_LEVA'||w_sep||'FERMA'||w_sep||
                         'ARMA'||w_sep||'CORPO'||w_sep||'FORZA_1'||w_sep||'FORZA_2'||w_sep||'FORZA_3'||w_sep||
                         'GRADO'||w_sep||'COMUNE_LEVA'||w_sep||'DATA_ARRUOLAMENTO'||w_sep||
                         'DATA_CHIAMATA'||w_sep||'DATA_CONGEDO'||w_sep||'ESITO_LEVA'||w_sep||'NUMERO_CARTA'||w_sep||
                         'DATA_CARTA'||w_sep||'COMUNE_CARTA'||w_sep||
                         'SCADENZA_CARTA'||w_sep||'NUMERO_LIBRETTO_LAVORO'||w_sep||'DATA_LIBRETTO_LAVORO'||w_sep||
                         'COMUNE_LIBRETTO_LAVORO'||w_sep||'NUMERO_PATENTE'||w_sep||'NATURA_PATENTE'||w_sep||'DATA_PATENTE'||w_sep||
                         'COMUNE_PATENTE'||w_sep||'CATEGORIA_PATENTE'||w_sep||
                         'NUMERO_PERMESSO'||w_sep||'NATURA_PERMESSO'||w_sep||'DATA_PERMESSO'||w_sep||
                         'COMUNE_PERMESSO'||w_sep||'SCADENZA_PERMESSO'||w_sep||
                         'NUMERO_CARTA_SOGGIORNO'||w_sep||'NATURA_CARTA_SOGGIORNO'||w_sep||'DATA_CARTA_SOGGIORNO'||w_sep||
                         'COMUNE_CARTA_SOGGIORNO'||w_sep||'SCADENZA_CARTA_SOGGIORNO'||w_sep||
                         'NUMERO_ATTESTATO_U1'||w_sep||'NATURA_ATTESTATO_U1'||w_sep||'DATA_ATTESTATO_U1'||w_sep||
                         'COMUNE_ATTESTATO_U1'||w_sep||'SCADENZA_ATTESTATO_U1'||w_sep||
                         'NUMERO_ATTESTATO_U2'||w_sep||'NATURA_ATTESTATO_U2'||w_sep||'DATA_ATTESTATO_U2'||w_sep||
                         'COMUNE_ATTESTATO_U2'||w_sep||'SCADENZA_ATTESTATO_U2'||w_sep||
                         'NUMERO_CIE'||w_sep||'NATURA_CIE'||w_sep||'DATA_CIE'||w_sep||
                         'COMUNE_CIE'||w_sep||'SCADENZA_CIE'||w_sep||'FOTO_CIE'||w_sep||
                         'NUMERO_CI_CIE'||w_sep||'NATURA_CI_CIE'||w_sep||'DATA_CI_CIE'||w_sep||
                         'COMUNE_CI_CIE'||w_sep||'SCADENZA_CI_CIE'||w_sep||
                         'CAP_COMUNE_RESIDENZA'||w_sep||
                         'COMUNE_DATA'||w_sep||'COMUNE'||w_sep||'DATA'||w_sep||
                         'CAP_COMUNE_NASCITA'||w_sep||'CAP_COMUNE_ULT_EVE'||w_sep||'CAP_COMUNE_MORTE'||w_sep||
                         'FAMIGLIA_CONVIVENZA'||w_sep||
                         'DENOMINAZIONE_CONVIVENZA'||w_sep||
                         'NUMERO_CARTA_CONIUGE'||w_sep||'NATURA_CARTA_CONIUGE'||w_sep||'DATA_CARTA_CONIUGE'||w_sep||'COMUNE_CARTA_CONIUGE'||w_sep||
                         'SCADENZA_CARTA_CONIUGE'||w_sep||
                         'NUMERO_CIE_CONIUGE'||w_sep||'NATURA_CIE_CONIUGE'||w_sep||'DATA_CIE_CONIUGE'||w_sep||'COMUNE_CIE_CONIUGE'||w_sep||
                         'SCADENZA_CIE_CONIUGE'||w_sep||
                         'NUMERO_CI_CIE_CONIUGE'||w_sep||'NATURA_CI_CIE_CONIUGE'||w_sep||'DATA_CI_CIE_CONIUGE'||w_sep||'COMUNE_CI_CIE_CONIUGE'||w_sep||
                         'SCADENZA_CI_CIE_CONIUGE'||w_sep||
                         'TIPO_CONSOLATO'||w_sep||'INDIRIZZO_CONSOLATO'||w_sep||'SEDE_CONSOLATO'||w_sep||
                         'DATA_INIZIO_TEMP'||w_sep||'DATA_FINE_TEMP'||w_sep||'COMUNE_TEMP'||w_sep||
                         'INDIRIZZO_TEMP'||w_sep||
                         'TIPO_ALBERO'||w_sep||'UBICAZIONE_ALBERO'||w_sep||
                         'DIR_STATO_CIVILE'||w_sep||
                         'IMPORTO_STATO_CIVILE'||w_sep||'SEGRETERIA'||w_sep||
                         'IMPORTO_SEGRETERIA'||w_sep||'CARTA_IDENTITA'||w_sep||'IMPORTO_CARTA_IDENTITA'||w_sep||
                         'BOLLO'||w_sep||'IMPORTO_BOLLO'||w_sep||
                         'RIMBORSO_STAMPATI'||w_sep||'IMPORTO_RIMBORSO_STAMPATI'||w_sep||'FIRMA'||w_sep||
                         'TERMINALISTA'||w_sep||'QUALIFICA'||w_sep||
                         'MODALITA_1'||w_sep||'MODALITA_2'||w_sep||'VALIDITA_1'||w_sep||'VALIDITA_2'||w_sep||
                         'LOGO_CER'||w_sep||'FAM_1'||w_sep||'FAM_2'||w_sep||'FAM_3'||w_sep||
                         'FAM_4'||w_sep||'FAM_5'||w_sep||'FAM_6'||w_sep||'FAM_7'||w_sep||'FAM_8'||w_sep||
                         'FAM_9'||w_sep||'FAM_10'||w_sep||
                         'FAM_11'||w_sep||'FAM_12'||w_sep||'FAM_13'||w_sep||'FAM_14'||w_sep||
                         'FAM_15'||w_sep||'FAM_16'||w_sep||'FAM_17'||w_sep||'FAM_18'||w_sep||
                         'FAM_19'||w_sep||'FAM_1_MIN'||w_sep||'FAM_2_MIN'||w_sep||'FAM_3_MIN'||w_sep||
                         'FAM_4_MIN'||w_sep||'FAM_5_MIN'||w_sep||
                         'EVENTI_ANAGRAFE'||w_sep||'EVENTI_STATO_CIVILE'||w_sep||
                         'DOC_1'||w_sep||'PROGR_EMISSIONE'||w_sep||'DATA_CERT_STORICO'||w_sep||'DOC_PT_1'||w_sep||
                         'DOC_PT_2'||w_sep||'DOC_CC_1'||w_sep||'DOC_CC_2'||w_sep||'URNE_CINERARIE'||w_sep||
                         'RIGA_LIBERA_1'||w_sep||'RIGA_LIBERA_2'||w_sep||'RIGA_LIBERA_3';

  elsif p_tipo_archivio = 2 then
     w_riga_intesta_1 := 'UFFICIO'||w_sep||'ANNO'||w_sep||'ATTO'||w_sep||'PARTE'||w_sep||
                         'PARTE_EDIT'||w_sep||
                         'SERIE'||w_sep||'SERIE_EDIT'||w_sep||
                         'UFFICIO_ORIG'||w_sep||'ANNO_ORIG'||w_sep||'ATTO_ORIG'||w_sep||'PARTE_ORIG'||w_sep||
                         'PARTE_ORIG_EDIT'||w_sep||
                         'SERIE_ORIG'||w_sep||'SERIE_ORIG_EDIT'||w_sep||
                         'NUMERO_UNICO_COMUNALE'||w_sep||'NUMERO_ATTO_ANSC'||w_sep||
                         'COMUNE_ATTO'||w_sep||'COGNOME_NOME'||w_sep||'COGNOME'||w_sep||'NOME'||w_sep||
                         'CODICE_FISCALE'||w_sep||
                         'SECONDO_NOME'||w_sep||'TERZO_NOME'||w_sep||
                         'SESSO'||w_sep||'SESSO_M_F'||w_sep||'NAT_OA'||w_sep||'DATA_NASCITA'||w_sep||
                         'GIORNO_NASCITA'||w_sep||'GIORNO_NASCITA_LETTERE'||w_sep||'MESE_NASCITA'||w_sep||
                         'ANNO_NASCITA'||w_sep||'ANNO_NASCITA_LETTERE'||w_sep||
                         'COMUNE_NASCITA'||w_sep||
                         'ORE'||w_sep||'ORE_LETTERE'||w_sep||'MINUTI'||w_sep||'MINUTI_LETTERE'||w_sep||
                         'E_MINUTI'||w_sep||'E_MINUTI_LETTERE'||w_sep||
                         'DEL_LUOGO_NASCITA'||w_sep||
                         'DEL_LUOGO_NASCITA_TRUNC'||w_sep||'LUOGO_NASCITA'||w_sep||'LUOGO_NASCITA_TRUNC'||w_sep||
                         'PATERNITA'||w_sep||'PATERNITA_SOLO_NOME'||w_sep||'COGNOME_PADRE'||w_sep||
                         'NOME_PADRE'||w_sep||
                         'INDIRIZZO_ANA_PAT'||w_sep||'DATA_NAS_PAT'||w_sep||
                         'MATERNITA'||w_sep||'MATERNITA_SOLO_NOME'||w_sep||'COGNOME_MADRE'||w_sep||
                         'NOME_MADRE'||w_sep||
                         'INDIRIZZO_ANA_MAT'||w_sep||'DATA_NAS_MAT'||w_sep||
                         'RESIDENZA'||w_sep||'CAP_RESIDENZA'||w_sep||
                         'COMUNE_DATA'||w_sep||'COMUNE'||w_sep||'DATA';
     w_riga_intesta_2 := 'AUTORITA_PROV'||w_sep||'COMUNE_PROV'||w_sep||'FRAZIONE_PROV'||w_sep||
                         'NOTA_RIF'||w_sep||'ANNO_NOTA_RIF'||w_sep||'DATA_NOTA_RIF'||w_sep||
                         'UFFICIALE_PROV'||w_sep||'QUALIFICA_PROV'||w_sep||
                         'PROTOCOLLO_PROV'||w_sep||'ANNO_PROTOCOLLO_PROV'||w_sep||'DATA_PROTOCOLLO_PROV'||w_sep||
                         'DIR_STATO_CIVILE'||w_sep||'IMPORTO_STATO_CIVILE'||w_sep||'SEGRETERIA'||w_sep||
                         'IMPORTO_SEGRETERIA'||w_sep||'CARTA_IDENTITA'||w_sep||'IMPORTO_CARTA_IDENTITA'||w_sep||
                         'BOLLO'||w_sep||'IMPORTO_BOLLO'||w_sep||
                         'RIMBORSO_STAMPATI'||w_sep||'IMPORTO_RIMBORSO_STAMPATI'||w_sep||'FIRMA'||w_sep||
                         'TERMINALISTA'||w_sep||'QUALIFICA'||w_sep||
                         'MODALITA_1'||w_sep||'MODALITA_2'||w_sep||'VALIDITA_1'||w_sep||'VALIDITA_2'||w_sep||
                         'LOGO_CER'||w_sep||
                         'ANNOTAZIONI_1'||w_sep||'ANNOTAZIONI_2'||w_sep||'ANNOTAZIONI_3'||w_sep||
                         'PROGR_EMISSIONE'||w_sep||
                         'RIGA_LIBERA_1'||w_sep||'RIGA_LIBERA_2'||w_sep||'RIGA_LIBERA_3';

  elsif p_tipo_archivio = 4 then
     w_riga_intesta_1 := 'UFFICIO'||w_sep||'ANNO'||w_sep||'ATTO'||w_sep||'PARTE'||w_sep||
                         'PARTE_EDIT'||w_sep||
                         'SERIE'||w_sep||'SERIE_EDIT'||w_sep||
                         'UFFICIO_ORIG'||w_sep||'ANNO_ORIG'||w_sep||'ATTO_ORIG'||w_sep||'PARTE_ORIG'||w_sep||
                         'PARTE_ORIG_EDIT'||w_sep||
                         'SERIE_ORIG'||w_sep||'SERIE_ORIG_EDIT'||w_sep||
                         'NUMERO_UNICO_COMUNALE'||w_sep||'NUMERO_ATTO_ANSC'||w_sep||
                         'COMUNE_ATTO'||w_sep||
                         'COGNOME_NOME_SPOSO'||w_sep||'COGNOME_SPOSO'||w_sep||'NOME_SPOSO'||w_sep||
                         'CODICE_FISCALE_SPOSO'||w_sep||
                         'NATO_IL'||w_sep||'DATA_NASCITA_SPOSO'||w_sep||'COMUNE_NASCITA_SPOSO'||w_sep||
                         'TRIBUNALE_NASCITA_SPOSO'||w_sep||'ATTO_NASCITA_SPOSO'||w_sep||'PARTE_NASCITA_SPOSO'||w_sep||
                         'SERIE_NASCITA_SPOSO'||w_sep||'ANNO_ATTO_NASCITA_SPOSO'||w_sep||'ATTO_NASCITA_SPOSO_EDIT'||w_sep||
                         'COMUNE_ATTO_NASCITA_SPOSO'||w_sep||
                         'NAZIONALITA_SPOSO'||w_sep||
                         'RESIDENZA_SPOSO'||w_sep||'CAP_RESIDENZA_SPOSO'||w_sep||'INDIRIZZO_ANA_SPOSO'||w_sep||
                         'COGNOME_NOME_SPOSA'||w_sep||'COGNOME_SPOSA'||w_sep||'NOME_SPOSA'||w_sep||
                         'CODICE_FISCALE_SPOSA'||w_sep||
                         'NATA_IL'||w_sep||'DATA_NASCITA_SPOSA'||w_sep||'COMUNE_NASCITA_SPOSA'||w_sep||
                         'TRIBUNALE_NASCITA_SPOSA'||w_sep||'ATTO_NASCITA_SPOSA'||w_sep||'PARTE_NASCITA_SPOSA'||w_sep||
                         'SERIE_NASCITA_SPOSA'||w_sep||'ANNO_ATTO_NASCITA_SPOSA'||w_sep||'ATTO_NASCITA_SPOSA_EDIT'||w_sep||
                         'COMUNE_ATTO_NASCITA_SPOSA'||w_sep||
                         'NAZIONALITA_SPOSA'||w_sep||
                         'RESIDENZA_SPOSA'||w_sep||'CAP_RESIDENZA_SPOSA'||w_sep||'INDIRIZZO_ANA_SPOSA'||w_sep||
                         'DATA_MATRIMONIO'||w_sep||'GIORNO_MATRIMONIO'||w_sep||'GIORNO_MATRIMONIO_LETTERE'||w_sep||
                         'MESE_MATRIMONIO'||w_sep||'ANNO_MATRIMONIO'||w_sep||'ANNO_MATRIMONIO_LETTERE'||w_sep||
                         'COMUNE_MATRIMONIO'||w_sep||
                         'RITO'||w_sep||'COMUNE_DATA'||w_sep||'COMUNE'||w_sep||'DATA';
     w_riga_intesta_2 := 'CONVENZIONI'||w_sep||'AUTORITA_PROV'||w_sep||'COMUNE_PROV'||w_sep||
                         'FRAZIONE_PROV'||w_sep||
                         'NOTA_RIF'||w_sep||'ANNO_NOTA_RIF'||w_sep||'DATA_NOTA_RIF'||w_sep||
                         'UFFICIALE_PROV'||w_sep||'QUALIFICA_PROV'||w_sep||
                         'PROTOCOLLO_PROV'||w_sep||'ANNO_PROTOCOLLO_PROV'||w_sep||'DATA_PROTOCOLLO_PROV'||w_sep||
                         'DIR_STATO_CIVILE'||w_sep||'IMPORTO_STATO_CIVILE'||w_sep||'SEGRETERIA'||w_sep||
                         'IMPORTO_SEGRETERIA'||w_sep||'CARTA_IDENTITA'||w_sep||'IMPORTO_CARTA_IDENTITA'||w_sep||
                         'BOLLO'||w_sep||'IMPORTO_BOLLO'||w_sep||
                         'RIMBORSO_STAMPATI'||w_sep||'IMPORTO_RIMBORSO_STAMPATI'||w_sep||'FIRMA'||w_sep||
                         'TERMINALISTA'||w_sep||'QUALIFICA'||w_sep||
                         'MODALITA_1'||w_sep||'MODALITA_2'||w_sep||'VALIDITA_1'||w_sep||'VALIDITA_2'||w_sep||
                         'LOGO_CER'||w_sep||
                         'ANNOTAZIONI_1'||w_sep||'ANNOTAZIONI_2'||w_sep||'ANNOTAZIONI_3'||w_sep||
                         'PROGR_EMISSIONE'||w_sep||
                         'RIGA_LIBERA_1'||w_sep||'RIGA_LIBERA_2'||w_sep||'RIGA_LIBERA_3';

  elsif p_tipo_archivio = 5 then
     w_riga_intesta_1 := 'UFFICIO'||w_sep||'ANNO'||w_sep||'ATTO'||w_sep||'PARTE'||w_sep||'PARTE_EDIT'||w_sep||
                         'SERIE'||w_sep||'SERIE_EDIT'||w_sep||
                         'UFFICIO_ORIG'||w_sep||'ANNO_ORIG'||w_sep||'ATTO_ORIG'||w_sep||'PARTE_ORIG'||w_sep||
                         'PARTE_ORIG_EDIT'||w_sep||
                         'SERIE_ORIG'||w_sep||'SERIE_ORIG_EDIT'||w_sep||
                         'NUMERO_UNICO_COMUNALE'||w_sep||'NUMERO_ATTO_ANSC'||w_sep||
                         'COMUNE_ATTO'||w_sep||
                         'COGNOME_NOME'||w_sep||'COGNOME'||w_sep||'NOME'||w_sep||'CODICE_FISCALE'||w_sep||
                         'SESSO'||w_sep||'SESSO_M_F'||w_sep||'NAT_OA'||w_sep||'NAT_OA_IL'||w_sep||
                         'DATA_NASCITA'||w_sep||'COMUNE_NASCITA'||w_sep||'TRIBUNALE_NASCITA'||w_sep||
                         'RESIDENZA'||w_sep||
                         'CAP_RESIDENZA'||w_sep||'INDIRIZZO_ANA'||w_sep||
                         'DECEDUT_OA'||w_sep||'MORT_OA'||w_sep||'DATA_MORTE';
     w_riga_intesta_2 := 'GIORNO_MORTE'||w_sep||'GIORNO_MORTE_LETTERE'||w_sep||'MESE_MORTE'||w_sep||
                         'ANNO_MORTE'||w_sep||'ANNO_MORTE_LETTERE'||w_sep||
                         'COMUNE_MORTE'||w_sep||'ORE'||w_sep||'ORE_LETTERE'||w_sep||'MINUTI'||w_sep||
                         'MINUTI_LETTERE'||w_sep||'E_MINUTI'||w_sep||'E_MINUTI_LETTERE'||w_sep||
                         'MOTIVO_MORTE'||w_sep||'STATO_CIVILE'||w_sep||'COGNOME_NOME_CONIUGE'||w_sep||
                         'COGNOME_CONIUGE'||w_sep||'NOME_CONIUGE'||w_sep||'COMUNE_DATA'||w_sep||
                         'COMUNE'||w_sep||'DATA'||w_sep||'TRIBUNALE'||w_sep||'COMUNE_REGISTRO'||w_sep||
                         'ANNO_NAS'||w_sep||'PARTE_NAS'||w_sep||'SERIE_NAS'||w_sep||
                         'ATTO_NAS'||w_sep||'UFFICIO_NAS'||w_sep||'ATTO_NAS_EDIT'||w_sep||'PADRE'||w_sep||
                         'COGNOME_PADRE'||w_sep||'NOME_PADRE'||w_sep||
                         'MADRE'||w_sep||'COGNOME_MADRE'||w_sep||'NOME_MADRE'||w_sep||
                         'PROFESSIONE'||w_sep||'LUOGO_MORTE'||w_sep||
                         'AUTORITA_PROV'||w_sep||'COMUNE_PROV'||w_sep||'FRAZIONE_PROV'||w_sep||
                         'NOTA_RIF'||w_sep||'ANNO_NOTA_RIF'||w_sep||'DATA_NOTA_RIF'||w_sep||
                         'UFFICIALE_PROV'||w_sep||'PROTOCOLLO_PROV'||w_sep||'QUALIFICA_PROV'||w_sep||
                         'ANNO_PROTOCOLLO_PROV'||w_sep||'DATA_PROTOCOLLO_PROV'||w_sep||
                         'DIR_STATO_CIVILE'||w_sep||'IMPORTO_STATO_CIVILE'||w_sep||'SEGRETERIA'||w_sep||
                         'IMPORTO_SEGRETERIA'||w_sep||'CARTA_IDENTITA'||w_sep||'IMPORTO_CARTA_IDENTITA'||w_sep||
                         'BOLLO'||w_sep||'IMPORTO_BOLLO'||w_sep||
                         'RIMBORSO_STAMPATI'||w_sep||'IMPORTO_RIMBORSO_STAMPATI'||w_sep||'FIRMA'||w_sep||
                         'TERMINALISTA'||w_sep||'QUALIFICA'||w_sep||
                         'MODALITA_1'||w_sep||'MODALITA_2'||w_sep||'VALIDITA_1'||w_sep||'VALIDITA_2'||w_sep||
                         'LOGO_CER'||w_sep||
                         'ANNOTAZIONI_1'||w_sep||'ANNOTAZIONI_2'||w_sep||'ANNOTAZIONI_3'||w_sep||
                         'PROGR_EMISSIONE'||w_sep||
                         'RIGA_LIBERA_1'||w_sep||'RIGA_LIBERA_2'||w_sep||'RIGA_LIBERA_3';
   
  elsif p_tipo_archivio = -4 then
     w_riga_intesta_1 := 'UFFICIO'||w_sep||'ANNO'||w_sep||'ATTO'||w_sep||'PARTE'||w_sep||
                         'PARTE_EDIT'||w_sep||
                         'SERIE'||w_sep||'SERIE_EDIT'||w_sep||
                         'UFFICIO_ORIG'||w_sep||'ANNO_ORIG'||w_sep||'ATTO_ORIG'||w_sep||'PARTE_ORIG'||w_sep||
                         'PARTE_ORIG_EDIT'||w_sep||
                         'SERIE_ORIG'||w_sep||'SERIE_ORIG_EDIT'||w_sep||
                         'NUMERO_UNICO_COMUNALE'||w_sep||'NUMERO_ATTO_ANSC'||w_sep||
                         'COMUNE_ATTO'||w_sep||
                         'COGNOME_NOME_1'||w_sep||'COGNOME_1'||w_sep||'NOME_1'||w_sep||
                         'CODICE_FISCALE_1'||w_sep||
                         'NAT_OA_IL_1'||w_sep||'DATA_NASCITA_1'||w_sep||'COMUNE_NASCITA_1'||w_sep||
                         'TRIBUNALE_NASCITA_1'||w_sep||'ATTO_NASCITA_1'||w_sep||'PARTE_NASCITA_1'||w_sep||
                         'SERIE_NASCITA_1'||w_sep||'ANNO_ATTO_NASCITA_1'||w_sep||'ATTO_NASCITA_1_EDIT'||w_sep||
                         'COMUNE_ATTO_NASCITA_1'||w_sep||
                         'CITTADIN_OA_1'||w_sep||'NAZIONALITA_1'||w_sep||
                         'RESIDENZA_1'||w_sep||'CAP_RESIDENZA_1'||w_sep||'INDIRIZZO_ANA_1'||w_sep||
                         'COGNOME_NOME_2'||w_sep||'COGNOME_2'||w_sep||'NOME_2'||w_sep||
                         'CODICE_FISCALE_2'||w_sep||
                         'NAT_OA_IL_2'||w_sep||'DATA_NASCITA_2'||w_sep||'COMUNE_NASCITA_2'||w_sep||
                         'TRIBUNALE_NASCITA_2'||w_sep||'ATTO_NASCITA_2'||w_sep||'PARTE_NASCITA_2'||w_sep||
                         'SERIE_NASCITA_2'||w_sep||'ANNO_ATTO_NASCITA_2'||w_sep||'ATTO_NASCITA_2_EDIT'||w_sep||
                         'COMUNE_ATTO_NASCITA_2'||w_sep||
                         'CITTADIN_OA_2'||w_sep||'NAZIONALITA_2'||w_sep||
                         'RESIDENZA_2'||w_sep||'CAP_RESIDENZA_2'||w_sep||'INDIRIZZO_ANA_2'||w_sep||
                         'DATA_UNIONE'||w_sep||'GIORNO_UNIONE'||w_sep||'GIORNO_UNIONE_LETTERE'||w_sep||
                         'MESE_UNIONE'||w_sep||'ANNO_UNIONE'||w_sep||'ANNO_UNIONE_LETTERE'||w_sep||
                         'COMUNE_UNIONE'||w_sep||
                         'TESTIMONE_1'||w_sep||
                         'NAT_OA_IL_TESTIMONE_1'||w_sep||'COMUNE_NAS_TESTIMONE_1'||w_sep||
                         'DATA_NAS_TESTIMONE_1'||w_sep||'RESIDENZA_TESTIMONE_1'||w_sep||'CITTADIN_OA_TESTIMONE_1'||w_sep||
                         'NAZIONALITA_TESTIMONE_1'||w_sep||
                         'TESTIMONE_2'||w_sep||
                         'NAT_OA_IL_TESTIMONE_2'||w_sep||'COMUNE_NAS_TESTIMONE_2'||w_sep||'DATA_NAS_TESTIMONE_2'||w_sep||
                         'RESIDENZA_TESTIMONE_2'||w_sep||'CITTADIN_OA_TESTIMONE_2'||w_sep||'NAZIONALITA_TESTIMONE_2'||w_sep||
                         'COMUNE_DATA'||w_sep||'COMUNE'||w_sep||'DATA';
     w_riga_intesta_2 := 'CONVENZIONI'||w_sep||
                         'AUTORITA_PROV'||w_sep||'COMUNE_PROV'||w_sep||
                         'FRAZIONE_PROV'||w_sep||
                         'NOTA_RIF'||w_sep||'ANNO_NOTA_RIF'||w_sep||'DATA_NOTA_RIF'||w_sep||
                         'UFFICIALE_PROV'||w_sep||'QUALIFICA_PROV'||w_sep||
                         'PROTOCOLLO_PROV'||w_sep||'ANNO_PROTOCOLLO_PROV'||w_sep||'DATA_PROTOCOLLO_PROV'||w_sep||
                         'DIR_STATO_CIVILE'||w_sep||'IMPORTO_STATO_CIVILE'||w_sep||'SEGRETERIA'||w_sep||
                         'IMPORTO_SEGRETERIA'||w_sep||'CARTA_IDENTITA'||w_sep||'IMPORTO_CARTA_IDENTITA'||w_sep||
                         'BOLLO'||w_sep||'IMPORTO_BOLLO'||w_sep||
                         'RIMBORSO_STAMPATI'||w_sep||'IMPORTO_RIMBORSO_STAMPATI'||w_sep||'FIRMA'||w_sep||
                         'TERMINALISTA'||w_sep||'QUALIFICA'||w_sep||
                         'MODALITA_1'||w_sep||'MODALITA_2'||w_sep||'VALIDITA_1'||w_sep||'VALIDITA_2'||w_sep||
                         'LOGO_CER'||w_sep||
                         'ANNOTAZIONI_1'||w_sep||'ANNOTAZIONI_2'||w_sep||'ANNOTAZIONI_3'||w_sep||
                         'PROGR_EMISSIONE'||w_sep||
                         'RIGA_LIBERA_1'||w_sep||'RIGA_LIBERA_2'||w_sep||'RIGA_LIBERA_3';
   
  end if;

  if p_tipo_archivio in (0,6) then
     w_riga_intesta_2 := w_riga_intesta_2||w_sep||
                         f_SER_riga_intesta(w_sep,'ANA')||w_sep||
                         f_SER_riga_intesta(w_sep,'CER')||w_sep|| 
                         f_SER_riga_intesta(w_sep,'COM')||w_sep|| 
                         f_SER_riga_intesta(w_sep,'URP');
  else
     w_riga_intesta_2 := w_riga_intesta_2||w_sep||
                         f_SER_riga_intesta(w_sep,'CIV')||w_sep||
                         f_SER_riga_intesta(w_sep,'CER')||w_sep||
                         f_SER_riga_intesta(w_sep,'COM')||w_sep||
                         f_SER_riga_intesta(w_sep,'URP');
  end if;

<< fine >>
nulL;

--  return w_riga_intesta; 

END;
/
