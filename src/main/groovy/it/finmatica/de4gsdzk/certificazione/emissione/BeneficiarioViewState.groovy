package it.finmatica.de4gsdzk.certificazione.emissione

import it.finmatica.de4gsdzk.AnagrafeBaseDomain
import it.finmatica.de4gsdzk.anagrafe.AnaMessaggio
import it.finmatica.de4gsdzk.anagrafe.AnaCittadinanza
import it.finmatica.de4gsdzk.certificazione.CerAnagrafeFiltro
import it.finmatica.de4gsdzk.certificazione.embed.Beneficiario
import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.EArchivioSorgenteSoggetto
import it.finmatica.de4gsdzk.utils.ESesso

class BeneficiarioViewState {
    private Beneficiario beneficiario
    private AnagrafeBaseDomain anagrafe

    private Boolean selected = Boolean.FALSE
    private List<CerAnagrafeFiltro> anagrafeFiltroList = []
    private List<AnaMessaggio> messaggioList = []

    private List<IBeneficiarioCertificatoListener> listeners = new ArrayList<>()

    BeneficiarioViewState() {
        this.beneficiario = new Beneficiario()
    }

    /*** Listeners per notificare le modifiche del beneficiario ***/

    void addListener(IBeneficiarioCertificatoListener listener) {
        listeners.add(listener);
    }

    private void notifyBeneficiarioChanged(EBeneficiarioCertificatoEvent event) {
        for (IBeneficiarioCertificatoListener listener : listeners) {
            listener.onChange(event)
        }
    }

    void setAnagrafe(AnagrafeBaseDomain anagrafe) {
        this.anagrafe = anagrafe
    }

    void setBeneficiario(Beneficiario beneficiario) {
        this.beneficiario = beneficiario
    }

    void setLoaded(){
        this.selected = Boolean.TRUE
        notifyBeneficiarioChanged(EBeneficiarioCertificatoEvent.LOAD)
    }

    /*** Resetta il beneficiario senza rimuovere i listeners ***/

    void reset() {
        this.beneficiario = new Beneficiario()
        this.selected = Boolean.FALSE
        this.anagrafe = null
        this.anagrafeFiltroList.clear()
        this.messaggioList.clear()
        notifyBeneficiarioChanged(EBeneficiarioCertificatoEvent.PROPERTY_CHANGED)
    }

    /*** Check per avviare o meno le ricerche collegate al beneficiario ***/

    Boolean hasRequiredDataForMessaggiSearch() {
        return this.anagrafe?.matricola != null
    }

    Boolean hasRequiredDataForAnagrafeFiltroSearch() {
        Boolean hasMinimumDataForStatoCivile = (this.beneficiario.cognome && this.beneficiario.nome && this.beneficiario.sesso)
        Boolean hasMinimumDataForAnagrafe = this.anagrafe?.matricola != null
        return hasMinimumDataForStatoCivile || hasMinimumDataForAnagrafe
    }

    // Used by zul
    Boolean hasRequiredDataForTipoCertificatoSearch() {
        return anagrafeFiltroList != null && anagrafeFiltroList.size() > 0
    }

    /*** Messaggi Individuo ***/

    void loadMessaggioList(List<AnaMessaggio> messaggioList) {
        this.messaggioList.clear()
        this.messaggioList.addAll(messaggioList)
    }

    List<AnaMessaggio> getMessaggioList() {
        return messaggioList
    }

    /*** AnagrafeFiltroList ***/

    void loadAnagrafeFiltroList(List<CerAnagrafeFiltro> anagrafeFiltroList) {
        this.anagrafeFiltroList.clear()
        this.anagrafeFiltroList.addAll(anagrafeFiltroList)
    }

    List<CerAnagrafeFiltro> getAnagrafeFiltroList() {
        return anagrafeFiltroList
    }

    /*** Beneficiario Wrap ***/

    Beneficiario getBeneficiario() {
        return beneficiario
    }

    void setNome(String nome) {
        this.beneficiario.nome = nome
        runPropertyChangeFlow()
    }

    String getNome() {
        return this.beneficiario.nome
    }

    void setCognome(String cognome) {
        this.beneficiario.cognome = cognome
        runPropertyChangeFlow()
    }

    String getCognome() {
        return this.beneficiario.cognome
    }

    void setSesso(ESesso sesso) {
        this.beneficiario.sesso = sesso
        runPropertyChangeFlow()
    }

    ESesso getSesso() {
        return this.beneficiario.sesso
    }

    void setComuneNascita(Comune comuneNascita) {
        this.beneficiario.comuneNascita = comuneNascita
        runPropertyChangeFlow()
    }

    Comune getComuneNascita() {
        return this.beneficiario.comuneNascita
    }

    void setCodiceFiscale(String codiceFiscale) {
        this.beneficiario.codiceFiscale = codiceFiscale
        runPropertyChangeFlow()
    }

    String getCodiceFiscale() {
        return this.beneficiario.codiceFiscale
    }

    void setDataNascita(Date dataNascita) {
        this.beneficiario.dataNascita = dataNascita
        runPropertyChangeFlow()
    }

    Date getDataNascita() {
        return this.beneficiario.dataNascita
    }

    /*** Anagrafe wrap ***/

    AnagrafeBaseDomain getAnagrafe() {
        return this.anagrafe
    }

    Integer getMatricola() {
        return this.anagrafe?.matricola
    }

    Long getIdSoggettoAnpr() {
        return this.anagrafe?.idSoggettoAnpr
    }

    EArchivioSorgenteSoggetto getArchivio() {
        return this.anagrafe?.archivio
    }

    AnaCittadinanza getNazionalita() {
        return this.anagrafe?.nazionalita
    }

    private runPropertyChangeFlow() {
        resetSearchedValues()
        // Notify the listeners
        notifyBeneficiarioChanged(EBeneficiarioCertificatoEvent.PROPERTY_CHANGED)
    }

    private resetSearchedValues() {
        // Reset the anagrafe
        this.anagrafe = null
        // Reset anagrafe filtro list
        this.anagrafeFiltroList.clear()
        // Reset messaggio list
        this.messaggioList.clear()
    }
}
