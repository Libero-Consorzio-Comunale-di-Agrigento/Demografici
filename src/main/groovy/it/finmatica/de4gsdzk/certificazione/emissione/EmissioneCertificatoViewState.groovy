package it.finmatica.de4gsdzk.certificazione.emissione

import it.finmatica.de4gsdzk.anagrafe.AnaDocumento
import it.finmatica.de4gsdzk.certificazione.*

class EmissioneCertificatoViewState {
    CerTipoRichiedente tipoRichiedente
    BeneficiarioViewState beneficiarioState
    RichiedenteViewState richiedenteState
    List<CerCategoriaTipoCertificato> listaCategoriaTipoCertificato = [null]
    CerCategoriaTipoCertificato categoriaTipoCertificatoSelezionata
    CerTipoCertificato tipoCertificato
    boolean dataStoricoMandatory = false
    Date dataStorico
    CerModalitaRilascio modalitaRilascio
    String descrizioneModalitaStampaLibera
    CerTipoPagamento tipoPagamento
    DirittiViewState diritti
    CerTerminalista terminalista
    String cognomeNomeTerminalista
    String qualificaTerminalista
    Boolean flagInStampaTerminalista
    Boolean forceGenerazioneGte
    Boolean flagForzaturaAnpr
    EDocumentoAnagraficoSource documentoAnagraficoSource
    AnaDocumento documentoAnagrafico

    void resetCascade() {
        setListaCategoriaTipoCertificato([null])
    }

    void setListaCategoriaTipoCertificato(List<CerCategoriaTipoCertificato> listaCategoriaTipoCertificato) {
        this.listaCategoriaTipoCertificato = listaCategoriaTipoCertificato
        if (listaCategoriaTipoCertificato == null ||
                listaCategoriaTipoCertificato.size() == 0 ||
                listaCategoriaTipoCertificato.every { it == null }) {
            setCategoriaTipoCertificatoSelezionata(null)
        }
    }

    void setCategoriaTipoCertificatoSelezionata(CerCategoriaTipoCertificato categoriaTipoCertificatoSelezionata) {
        this.categoriaTipoCertificatoSelezionata = categoriaTipoCertificatoSelezionata
        setTipoCertificato(null)
    }

    void setTipoCertificato(CerTipoCertificato tipoCertificato) {
        this.tipoCertificato = tipoCertificato
        if (tipoCertificato == null) {
            setModalitaRilascio(null)
            setForceGenerazioneGte(Boolean.FALSE)
            setDocumentoAnagraficoSource(null)
            setDocumentoAnagrafico(null)
            setDataStorico(null)
            setDataStoricoMandatory(false)
        } else {
            Boolean forceGenerazioneGte = !tipoCertificato.isGenerazioneEsterna()
            setForceGenerazioneGte(forceGenerazioneGte)
        }
    }

    void setModalitaRilascio(CerModalitaRilascio modalitaRilascio) {
        this.modalitaRilascio = modalitaRilascio
        setDescrizioneModalitaStampaLibera(null)
        if (modalitaRilascio == null) {
            setTipoPagamento(null)
            diritti.resetImporto()
        }
    }

    void setForceGenerazioneGte(Boolean forceGenerazioneGte) {
        this.forceGenerazioneGte = forceGenerazioneGte
        if (forceGenerazioneGte) {
            setFlagForzaturaAnpr(Boolean.FALSE)
        }else{
            setTerminalistaInStampa(this.terminalista)
        }
    }

    void setTerminalistaInStampa(CerTerminalista terminalista) {
        if (terminalista == null) {
            setCognomeNomeTerminalista(null)
            setQualificaTerminalista(null)
            setFlagInStampaTerminalista(null)
        } else {
            setCognomeNomeTerminalista(terminalista.cognomeNome)
            setQualificaTerminalista(terminalista.qualifica)
            setFlagInStampaTerminalista(terminalista.flagInStampa)
        }
    }
}
