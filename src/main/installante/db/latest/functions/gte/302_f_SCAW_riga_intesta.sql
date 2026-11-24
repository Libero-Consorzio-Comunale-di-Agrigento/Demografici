--liquibase formatted sql
--changeset amonopoli:202503250850_2 runOnChange:true stripComments:false
create or replace function f_SCAW_riga_intesta
(p_separatore           IN            varchar2)

return varchar2                                                             

IS

w_sep           varchar2(255) := nvl(p_separatore,chr(9));

w_riga_intesta  varchar2(4000);

BEGIN
  w_riga_intesta := 'MATRICOLA'||w_sep||'COD_MOV'||w_sep||'COD_EVE'||w_sep||
                    'COGNOME_NOME_PREC'||w_sep||'PATERNITA_PREC'||w_sep||'MATERNITA_PREC'||w_sep||
                    'COD_VIA_PREC'||w_sep||'DES_COD_VIA_PREC'||w_sep||
                    'TIT_STUDIO_PREC'||w_sep||'TITOLO_STUDIO_PREC'||w_sep||'COD_PROF_PREC'||w_sep||
                    'DES_COD_PROF_PREC'||w_sep||'NAZIONALITA_PREC'||w_sep||'STATO_CIV_PREC'||w_sep||
                    'DATA_NAS_PREC'||w_sep||'DATA_NAS_PREC_EDIT'||w_sep||'DES_COM_NAS_PREC'||w_sep||
                    'SESSO_PREC'||w_sep||'COGNOME_NOME_CN_PREC'||w_sep||
                    'VIA_AIRE_PREC'||w_sep||'DES_VIA_AIRE_PREC'||w_sep||'DES_COM_AIRE_PREC'||w_sep||
                    'ZIPCODE_PREC'||w_sep||'PROVINCIA_CONTEA_PREC'||w_sep||'PRESSO_PREC'||w_sep||
                    'DES_CONSOLATO_1_PREC'||w_sep||'DES_CONSOLATO_2_PREC'||w_sep||'DES_CONSOLATO_3_PREC'||w_sep||
                    'DES_NAZIONALITA_PREC'||w_sep||'DATA_INIZIO_NAZ_PREC'||w_sep||
                    'DES_STATO_CIV_PREC'||w_sep||
                    'COD_FISCALE_PREC'||w_sep||'DES_COD_FISCALE_PREC'||w_sep||'STATO_CIVILE'||w_sep||                    
                    'COGNOME_NOME_CN'||w_sep||'DATA_MAT_VED'||w_sep||'ATTO_MAT_VED'||w_sep||
                    'DATA_EVE'||w_sep||'DES_COM_EVE'||w_sep||'PRATICA_EDIT'||w_sep||'COGNOME_NOME'||w_sep||
                    'SESSO'||w_sep||'DI_SESSO'||w_sep||'DATA_NAS_EDIT'||w_sep||'DES_COM_NAS'||w_sep||
                    'ATTO_NAS'||w_sep||'RAPPORTO_PAR'||w_sep||'NAZIONALITA'||w_sep||'STATO_CIV'||w_sep||
                    'PATERNITA'||w_sep||'MATERNITA'||w_sep||
                    'COD_VIA'||w_sep||'DES_COD_VIA_CHIUSURA'||w_sep||'DES_COD_VIA'||w_sep||
                    'INDIRIZZO_EMI'||w_sep||
                    'TIT_STUDIO'||w_sep||'TITOLO_STUDIO'||w_sep||'COD_PROF'||w_sep||
                    'DES_COD_PROF'||w_sep||'DES_NAZIONALITA'||w_sep||'DATA_INIZIO_NAZ'||w_sep||
                    'DES_STATO_CIV'||w_sep||
                    'PRATICA_EVE'||w_sep||'ANNO_PRATICA_EVE'||w_sep||'DATA_REG'||w_sep||'TESSERA_ELE'||w_sep||
                    'VECCHIA_SEZIONE'||w_sep||'NUOVO_COD_VIA'||w_sep||'NUOVO_NUM_CIV'||w_sep||
                    'NUOVO_SUFFISSO'||w_sep||'NUOVO_INTERNO'||w_sep||'NUOVO_SCALA'||w_sep||
                    'NUOVO_PIANO'||w_sep||'DATA_REG_EDIT'||w_sep||'COD_FISCALE'||w_sep||'DES_COD_FISCALE'||w_sep||
                    'INTESTATARIO'||w_sep||'COD_VARIAZIONE'||w_sep||'DES_COD_VARIAZIONE'||w_sep||
                    'VARIAZIONE'||w_sep||'ISCRITTO_ASC_V'||w_sep||'ISCRITTO_ASC_R'||w_sep||
                    'ISCRITTO_AGP_S'||w_sep||'ISCRITTO_AGP_P'||w_sep||'ISCRITTO_APS'||w_sep||
                    'ZIPCODE_IAI'||w_sep||
                    'DES_CONSOLATO_1_MOV'||w_sep||'DES_CONSOLATO_2_MOV'||w_sep||'DES_CONSOLATO_3_MOV'||w_sep||
                    'DES_COM_ISCR_AIRE'||w_sep||'DES_COM_ISCR_AIRE_LEV'||w_sep||
                    'VIA_AIRE'||w_sep||'DES_VIA_AIRE'||w_sep||'DES_COM_AIRE_IAI'||w_sep||
                    'DES_COM_AIRE'||w_sep||'PROVINCIA_CONTEA'||w_sep||'PRESSO'||w_sep||'STATO_ELE'||w_sep||
                    'LISTA_GEN'||w_sep||'SEZIONE'||w_sep||'LISTA_SEZ'||w_sep||'FASCICOLO'||w_sep||
                    'ANNO'||w_sep||'DES_TIPO_LISTA'||w_sep||
                    'LISTA_AGG_C'||w_sep||'LISTA_GEN_C'||w_sep||'SEZIONE_C'||w_sep||'LISTA_SEZ_C'||w_sep||
                    'FASCICOLO_C'||w_sep||'ANNO_C'||w_sep||'TESSERA_ELE_C'||w_sep||
                    'LISTA_AGG_E'||w_sep||'LISTA_GEN_E'||w_sep||'SEZIONE_E'||w_sep||'LISTA_SEZ_E'||w_sep||
                    'FASCICOLO_E'||w_sep||'ANNO_E'||w_sep||'TESSERA_ELE_E'||w_sep||
                    'LISTA_AGG_T'||w_sep||'LISTA_GEN_T'||w_sep||'SEZIONE_T'||w_sep||'LISTA_SEZ_T'||w_sep||
                    'FASCICOLO_T'||w_sep||'ANNO_T'||w_sep||'TESSERA_ELE_T'||w_sep||
                    'LISTA_AGG_V'||w_sep||'LISTA_GEN_V'||w_sep||'SEZIONE_V'||w_sep||'LISTA_SEZ_V'||w_sep||
                    'FASCICOLO_V'||w_sep||'ANNO_V'||w_sep||'TESSERA_ELE_V'||w_sep||
                    'LISTA_AGG_B'||w_sep||'LISTA_GEN_B'||w_sep||'SEZIONE_B'||w_sep||'LISTA_SEZ_B'||w_sep||
                    'FASCICOLO_B'||w_sep||'ANNO_B'||w_sep||'TESSERA_ELE_B'||w_sep||
                    'ENTE_EMISSIONE'||w_sep||
                    'DES_ENTE_EMISSIONE'||w_sep||'INDIRIZZO_ENTE'||w_sep||'DES_COM_ENTE'||w_sep||'CAP_COMUNE_ENTE'||w_sep||
                    'INTESTAZIONE_INPS'||w_sep||'PROTOCOLLO_AIRE'||w_sep||'DES_PROTOCOLLO_AIRE'||w_sep||
                    'INIZIATIVA_AIRE'||w_sep||'DES_CONSOLATO_1'||w_sep||'DES_CONSOLATO_2'||w_sep||
                    'DES_CONSOLATO_3'||w_sep||'CAP'||w_sep||'COMUNE'||w_sep||'COMUNE_DATA'||w_sep||
                    'PROVINCIA'||w_sep||'DES_ENTE_EMISSIONE_INPS'||w_sep||'INDIRIZZO_ENTE_INPS'||w_sep||
                    'CAP_COMUNE_ENTE_INPS'||w_sep||'FINE_MESE_ELE'||w_sep||'ANNO_CORRENTE'||w_sep||
                    'MATRICOLA_AIRE'||w_sep||'COD_FAM_AIRE'||w_sep||
                    'MATRICOLA_MILITARE'||w_sep||'CLASSE_LEVA'||w_sep||'NUMERO_LISTA'||w_sep||
                    'DES_ESITO'||w_sep||'DES_COM_LEVA'||w_sep||'DES_COM_DISTRETTO'||w_sep||      
                    'DATA_ARRUOLAMENTO'||w_sep||'DATA_CHIAMATA'||w_sep||'DATA_CONGEDO'||w_sep||
                    'DES_ARMA'||w_sep||'DES_CORPO'||w_sep||'FORZA'||w_sep||'DES_GRADO'||w_sep||
                    'OGGETTO'||w_sep||'EVENTO'||w_sep||
                    'DA_A'||w_sep||'DATI_RICOMPARSA'||w_sep||'UFFICIO_POSTALE'||w_sep||
                    'DES_UFFICIO_POSTALE'||w_sep||'COD_CONTRIBUENTE'||w_sep||'NUOVA_SEZIONE'||w_sep||
                    'CAP_COMUNE_DST'||w_sep||'PRATICA'||w_sep||'ANNO_PRATICA'||w_sep||'AL_SIG'||w_sep||
                    'AL_SIGNOR'||w_sep||'CAP_COMUNE'||w_sep||'ENTE_DEST'||w_sep||'INDIRIZZO_ENTE_DEST'||w_sep||
                    'CAP_COMUNE_ENTE_DEST'||w_sep||'INDIVIDUI'||w_sep||'INTEST_IAI'||w_sep||'DATA_NAS0_EDIT'||w_sep||
                    'TERMINALISTA'||w_sep||'FIRMA_OMESSA'||w_sep||
                    'TERMINALISTA_MOV'||w_sep||'FIRMA_OMESSA_TERM_MOV'||w_sep||
                    'LOGO_ANA'||w_sep||
                    'FAM_1'||w_sep||'FAM_2'||w_sep||'FAM_3'||w_sep||'FAM_4'||w_sep||'FAM_5'||w_sep||
                    'DOC_1'||w_sep||'DOC_CI_1'||w_sep||'DOC_LP_1'||w_sep||'DOC_PS_1'||w_sep||'DOC_PT_1'||w_sep||
                    'URNE_CINERARIE';

  w_riga_intesta := w_riga_intesta||w_sep||f_SER_riga_intesta(w_sep,'ANA')||w_sep||f_SER_riga_intesta(w_sep,'COM')||w_sep||f_SER_riga_intesta(w_sep,'URP');

  return w_riga_intesta; 

END;
/
