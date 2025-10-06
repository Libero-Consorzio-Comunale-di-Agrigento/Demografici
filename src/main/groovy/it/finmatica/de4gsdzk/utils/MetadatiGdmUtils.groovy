package it.finmatica.de4gsdzk.utils

import it.finmatica.de4gsdzk.IRiferimentoAttoDomain
import it.finmatica.de4gsdzk.IRiferimentoCertificatoDomain
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.anagrafe.AnaDocumento
import it.finmatica.de4gsdzk.anagrafe.AnaFamiglia
import it.finmatica.smartdoc.api.struct.Campo

class MetadatiGdmUtils {

    static final String METADATO_GDM_ID_ATTO = "ID_ATTO"
    static final String METADATO_GDM_TIPO_ATTO = "TIPO_ATTO"
    static final String METADATO_GDM_UFFICIO_ATTO = "UFFICIO"
    static final String METADATO_GDM_ANNO_ATTO = "ANNO"
    static final String METADATO_GDM_ATTO_ATTO = "ATTO"
    static final String METADATO_GDM_PARTE_ATTO = "PARTE"
    static final String METADATO_GDM_SERIE_ATTO = "SERIE"

    static final String METADATO_GDM_ID_EMISSIONE_CERTIFICATO = "ID_EMISSIONE_CERTIFICATO"
    static final String METADATO_GDM_ANNO_EMISSIONE_CERTIFICATO = "ANNO_EMISSIONE_CERTIFICATO"
    static final String METADATO_GDM_PROGRESSIVO_EMISSIONE_CERTIFICATO = "PROGR_EMISSIONE_CERTIFICATO"

    static final String METADATO_GDM_NUMERO_DOCUMENTO_ANAGRAFICO = "NUMERO_%s"
    static final String METADATO_GDM_MATRICOLA = "MATRICOLA"
    static final String METADATO_GDM_DATA_RILASCIO = "DATA_RILASCIO"

    static final String METADATO_GDM_CODICE_FAMIGLIA = "COD_FAM"
    static final String METADATO_GDM_TIPO_RESIDENTE = "TIPO_RESIDENTE"


    static List<Campo> listMetadatiAtto(IRiferimentoAttoDomain doce, String identificativoAtto){
        List<Campo> metadati = []
        metadati.add(new Campo(METADATO_GDM_ID_ATTO, identificativoAtto))
        metadati.add(new Campo(METADATO_GDM_TIPO_ATTO, doce.tipoAtto))
        metadati.add(new Campo(METADATO_GDM_UFFICIO_ATTO, doce.ufficio))
        metadati.add(new Campo(METADATO_GDM_ANNO_ATTO, doce.anno))
        metadati.add(new Campo(METADATO_GDM_ATTO_ATTO, doce.atto))
        metadati.add(new Campo(METADATO_GDM_PARTE_ATTO, doce.parte))
        metadati.add(new Campo(METADATO_GDM_SERIE_ATTO, doce.serie))
        return metadati
    }

    static List<Campo> listMetadatiCertificazione(IRiferimentoCertificatoDomain doce, String identificativoAtto) {
        List<Campo> metadati = []
        metadati.add(new Campo(METADATO_GDM_ID_EMISSIONE_CERTIFICATO, identificativoAtto))
        metadati.add(new Campo(METADATO_GDM_ANNO_EMISSIONE_CERTIFICATO, doce.annoEmissione))
        metadati.add(new Campo(METADATO_GDM_PROGRESSIVO_EMISSIONE_CERTIFICATO, doce.progressivoEmissione))
        return metadati
    }

    static List<Campo> listMetadatiDocumentoAnagrafico(AnaDocumento documento) {
        List<Campo> metadati = []
        String codiceCampoNumeroDocumento = String.format(METADATO_GDM_NUMERO_DOCUMENTO_ANAGRAFICO, documento.tipoDocumento.id)
        metadati.add(new Campo(codiceCampoNumeroDocumento, documento.numero))
        metadati.add(new Campo(METADATO_GDM_MATRICOLA, documento.anagrafe.matricola))
        metadati.add(new Campo(METADATO_GDM_DATA_RILASCIO, DataUtils.fromDateToString(documento.dataEmissione)))
        return metadati
    }

    static List<Campo> listMetadatiFamiglia(AnaFamiglia famiglia) {
        List<Campo> metadati = []
        metadati.add(new Campo(METADATO_GDM_CODICE_FAMIGLIA, famiglia.codice))
        metadati.add(new Campo(METADATO_GDM_TIPO_RESIDENTE, famiglia.tipoAnagrafe.id))
        return metadati
    }

    static List<Campo> listMetadatiIndividuo(AnaAnagrafe anagrafe) {
        List<Campo> metadati = []
        metadati.add(new Campo(METADATO_GDM_MATRICOLA, anagrafe.id))
        return metadati
    }

}
