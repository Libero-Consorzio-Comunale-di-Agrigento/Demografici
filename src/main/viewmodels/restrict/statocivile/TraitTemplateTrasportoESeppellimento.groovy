package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ArcComuneBaseDomain
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafeBaseDomain
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.BindingParam
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Event
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window

/**
 * Trait-ViewModel corrispondente ai template templateSezioneEstremiTrasporto e templateSezioneEstremiCremazione
 */
@Slf4j
trait TraitTemplateTrasportoESeppellimento {

    CivTrasportoESeppellimento trasporto

    CivNumerazioneDocumentiUscita numerazioneDocumentoTrasporto
    CivNumerazioneDocumentiUscita numerazioneDocumentoSeppellimento
    CivNumerazioneDocumentiUscita numerazioneDocumentoCremazione

    List<CivRegistroDocumentiUscita> listaRegistriTrasporto = [null]
    List<CivRegistroDocumentiUscita> listaRegistriSeppellimento = [null]
    List<CivRegistroDocumentiUscita> listaRegistriCremazione = [null]

    abstract void refreshUi()

    abstract CivNumerazioneDocumentiUscitaService getCivNumerazioneDocumentiUscitaService()

    abstract boolean isMinuscole(String campo)

    abstract String getMsgTitle()

    abstract String getEtichetta(Map<String, String> etichetta)

    abstract Window getSelf()

    abstract void allineaTestoTrasportoMinuscole()

    abstract Boolean getRicercaSoggettoInANPROn()

    /**
     * Inizializza il trait. Chiamare dalla init del ViewModel
     *
     * @return le etichette necessarie per la sezione trasporto
     */
    void initTrasporto(CivRegistroDocumentiUscitaService civRegistroDocumentiUscitaService) {

        List<CivRegistroDocumentiUscita> listaRegistri = civRegistroDocumentiUscitaService.listAll()
        for (CivRegistroDocumentiUscita r: listaRegistri) {
            if (r.tipoRegistro.id == CivTipoRegistro.ID_TRASPORTO) {
                listaRegistriTrasporto.add(r)
            }
            if (r.tipoRegistro.id == CivTipoRegistro.ID_SEPPELLIMENTO) {
                listaRegistriSeppellimento.add(r)
            }
            listaRegistriCremazione.add(r)
        }
    }

    void initNumerazioneDocumenti(){
        if ( (trasporto.annoProtocolloTrasporto != null) && (trasporto.registroTrasporto != null) ) {
            numerazioneDocumentoTrasporto = civNumerazioneDocumentiUscitaService.getByAnnoAndRegistro(trasporto.annoProtocolloTrasporto, trasporto.registroTrasporto)
        } else {
            numerazioneDocumentoTrasporto = null
        }
        if ( (trasporto.annoProtocolloSeppellimento != null) && (trasporto.registroSeppellimento != null) ){
            numerazioneDocumentoSeppellimento = civNumerazioneDocumentiUscitaService.getByAnnoAndRegistro(trasporto.annoProtocolloSeppellimento, trasporto.registroSeppellimento)
        } else {
            numerazioneDocumentoSeppellimento = null
        }
        if ( (trasporto.annoProtocolloCremazione != null) && (trasporto.registroCremazione != null) ) {
            numerazioneDocumentoCremazione = civNumerazioneDocumentiUscitaService.getByAnnoAndRegistro(trasporto.annoProtocolloCremazione, trasporto.registroCremazione)
        } else {
            numerazioneDocumentoCremazione = null
        }
    }

    @Command void onSelectTrasporto(){
        BindUtils.postNotifyChange(null, null, this, "trasporto")
    }

    @Command void onSelectCremazione(){
        BindUtils.postNotifyChange(null, null, this, "trasporto")
    }

    @Command void onSelectCimitero(@ContextParam(ContextType.TRIGGER_EVENT) Event event){
        if (trasporto.trasporto == ETipoSiNo.SI) {
            String q = null
            if (event?.target?.selectedItem instanceof String) {
                q = event.target.selectedItem
            }
            trasporto.cimiteroDestinazione = q
            refreshUi()
        }
    }

    @Command void onAggiornaCaseTrasporto(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        String p = e?.target?.getAttribute("proprieta")
        if (p) {
            if (!isMinuscole(p)) {
                trasporto."$p" = trasporto."$p"?.toUpperCase()
            }
            refreshUi()
        }
    }

    @Command void onCancellaCimitero(){
        onSelectCimitero(null)
    }

    @Command void onSelectDittaOnoranze(@ContextParam(ContextType.TRIGGER_EVENT) Event event){
        if (trasporto.trasporto == ETipoSiNo.SI) {
            String q = null
            if (event?.target?.selectedItem instanceof String) {
                q = event.target.selectedItem
            }
            trasporto.dittaOnoranze = q
            refreshUi()
        }
    }

    @Command void onCancellaDittaOnoranze(){
        onSelectDittaOnoranze(null)
    }

    @Command void onCancellaCampoTrasporto(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        String p = e.getTarget().getAttribute("proprieta")
        for (String s:p.split(","))
            trasporto."$s" = null
        refreshUi()
    }

    @Command void onSelectRegistroTrasporto() {
        if ( (trasporto.registroTrasporto != null) && (trasporto.annoProtocolloTrasporto == null) && (trasporto.dataProtocolloTrasporto == null) ){
            trasporto.annoProtocolloTrasporto = Calendar.getInstance().get(Calendar.YEAR)
            trasporto.dataProtocolloTrasporto = (new Date()).clearTime()
        }
        refreshUi()
    }

    @Command void onNumeraProtocolloTrasporto() {
        if ( (trasporto.numeroProtocolloTrasporto == null) ) {
            if ( (trasporto.registroTrasporto != null) && (trasporto.annoProtocolloTrasporto != null) ){
                numerazioneDocumentoTrasporto = civNumerazioneDocumentiUscitaService.getOrCreateByAnnoAndRegistro(trasporto.annoProtocolloTrasporto, trasporto.registroTrasporto)
                numerazioneDocumentoTrasporto.numero = numerazioneDocumentoTrasporto.numero+1
                trasporto.numeroProtocolloTrasporto = numerazioneDocumentoTrasporto.numero
            } else {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Compilare_campi_obbligatori_protocollazione")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
        refreshUi()
    }

    @Command void onSelectRegistroSeppellimento() {
        if ( (trasporto.registroSeppellimento != null) && (trasporto.annoProtocolloSeppellimento == null) && (trasporto.dataProtocolloSeppellimento == null) ){
            trasporto.annoProtocolloSeppellimento = Calendar.getInstance().get(Calendar.YEAR)
            trasporto.dataProtocolloSeppellimento = (new Date()).clearTime()
        }
        refreshUi()
    }

    @Command void onNumeraProtocolloSeppellimento() {
        if ( (trasporto.numeroProtocolloSeppellimento == null) ) {
            if ( (trasporto.registroSeppellimento != null) && (trasporto.annoProtocolloSeppellimento != null) ){
                numerazioneDocumentoSeppellimento = civNumerazioneDocumentiUscitaService.getOrCreateByAnnoAndRegistro(trasporto.annoProtocolloSeppellimento, trasporto.registroSeppellimento)
                numerazioneDocumentoSeppellimento.numero = numerazioneDocumentoSeppellimento.numero+1
                trasporto.numeroProtocolloSeppellimento = numerazioneDocumentoSeppellimento.numero
            } else {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Compilare_campi_obbligatori_protocollazione")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
        refreshUi()
    }

    @Command void onSelectRegistroCremazione() {
        if ( (trasporto.registroCremazione != null) && (trasporto.annoProtocolloCremazione == null) && (trasporto.dataProtocolloCremazione == null) ){
            trasporto.annoProtocolloCremazione = Calendar.getInstance().get(Calendar.YEAR)
            trasporto.dataProtocolloCremazione = (new Date()).clearTime()
        }
        refreshUi()
    }

    @Command void onNumeraProtocolloCremazione() {
        if ( (trasporto.numeroProtocolloCremazione == null) ) {
            if ( (trasporto.registroCremazione != null) && (trasporto.annoProtocolloCremazione != null) ){
                numerazioneDocumentoCremazione = civNumerazioneDocumentiUscitaService.getOrCreateByAnnoAndRegistro(trasporto.annoProtocolloCremazione, trasporto.registroCremazione)
                numerazioneDocumentoCremazione.numero = numerazioneDocumentoCremazione.numero+1
                trasporto.numeroProtocolloCremazione = numerazioneDocumentoCremazione.numero
            } else {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Compilare_campi_obbligatori_protocollazione")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
        refreshUi()
    }

    String checkEstremiProtocollo(){
        String msg = ""
        // Tutti pieni o tutti vuoti
        if (!( (trasporto.registroTrasporto && trasporto.annoProtocolloTrasporto && trasporto.numeroProtocolloTrasporto) ||
                ((!trasporto.registroTrasporto) && (!trasporto.annoProtocolloTrasporto) && (!trasporto.numeroProtocolloTrasporto) ) ) ){
            msg += " - Trasporto"
        }
        if (!( (trasporto.registroSeppellimento && trasporto.annoProtocolloSeppellimento && trasporto.numeroProtocolloSeppellimento) ||
                ((!trasporto.registroSeppellimento) && (!trasporto.annoProtocolloSeppellimento) && (!trasporto.numeroProtocolloSeppellimento) ) ) ){
            msg += " - Seppellimento"
        }
        if (!( (trasporto.registroCremazione && trasporto.annoProtocolloCremazione && trasporto.numeroProtocolloCremazione) ||
                ((!trasporto.registroCremazione) && (!trasporto.annoProtocolloCremazione) && (!trasporto.numeroProtocolloCremazione) ) ) ){
            msg += " - Cremazione"
        }
        if (msg){
            return getEtichetta(Etichette.getEtichetta("Warn_dati_protocollo_incompleti")) + msg
        }
        return null
    }

    @Command void onSelectComuneTrasporto(@ContextParam(ContextType.TRIGGER_EVENT) Event event, @BindingParam("campoRiferimento") String campoRiferimento){
        ArcComuneBaseDomain c = null
        if (event?.target?.selectedItem instanceof ArcComuneBaseDomain) {
            c = event.target.selectedItem
        }

        ETipoComuneAtto tca = ETipoComuneAtto.valueOf(campoRiferimento)
        switch (tca) {
            case ETipoComuneAtto.CD_DEC_TRAS:
                trasporto.codiceComuneDestinazione = c?.codiceComune
                trasporto.descrizioneComuneDestinazione = c?.descrizioneComune
                trasporto.codiceProvinciaDestinazione = c?.codiceProvincia
                trasporto.siglaProvinciaDestinazione = c?.siglaProvincia
                break
            case ETipoComuneAtto.CC_DEC_CREM:
                trasporto.codiceComuneCremazione = c?.codiceComune
                trasporto.descrizioneComuneCremazione = c?.descrizioneComune
                trasporto.codiceProvinciaCremazione = c?.codiceProvincia
                trasporto.siglaProvinciaCremazione = c?.siglaProvincia
                break
            case ETipoComuneAtto.CN_RIC:
                trasporto.codiceComuneNascitaRichiedente = c?.codiceComune
                trasporto.descrizioneComuneNascitaRichiedente = c?.descrizioneComune
                trasporto.codiceProvinciaNascitaRichiedente = c?.codiceProvincia
                trasporto.siglaProvinciaNascitaRichiedente = c?.siglaProvincia
                break
            case ETipoComuneAtto.CR_RIC:
                trasporto.codiceComuneResidenzaRichiedente = c?.codiceComune
                trasporto.descrizioneComuneResidenzaRichiedente = c?.descrizioneComune
                trasporto.codiceProvinciaResidenzaRichiedente = c?.codiceProvincia
                trasporto.siglaProvinciaResidenzaRichiedente = c?.siglaProvincia
                break
            case ETipoComuneAtto.CN_INC:
                trasporto.codiceComuneNascitaIncaricatoTrasporto = c?.codiceComune
                trasporto.descrizioneComuneNascitaIncaricatoTrasporto = c?.descrizioneComune
                trasporto.codiceProvinciaNascitaIncaricatoTrasporto = c?.codiceProvincia
                trasporto.siglaProvinciaNascitaIncaricatoTrasporto = c?.siglaProvincia
                break
            case ETipoComuneAtto.CR_INC:
                trasporto.codiceComuneResidenzaIncaricatoTrasporto = c?.codiceComune
                trasporto.descrizioneComuneResidenzaIncaricatoTrasporto = c?.descrizioneComune
                trasporto.codiceProvinciaResidenzaIncaricatoTrasporto = c?.codiceProvincia
                trasporto.siglaProvinciaResidenzaIncaricatoTrasporto = c?.siglaProvincia
                break
        }
        refreshUi()
    }

    @Command void onCancellaComuneTrasporto(@BindingParam("campoRiferimento") String campoRiferimento) {
        onSelectComuneTrasporto(null, campoRiferimento)
    }

    @Command void onCaricaSoggettiTrasporto(@BindingParam("tipoSoggetto") String tipoSoggetto){
        ETipoSoggetto ts = ETipoSoggetto.valueOf(tipoSoggetto)

        Map params
        switch (ts) {
            case ETipoSoggetto.RICHIEDENTE:
                params = [cognome: trasporto.cognomeRichiedente, nome: trasporto.nomeRichiedente, sesso : trasporto.sessoRichiedente, dataNascita: trasporto.dataNascitaRichiedente]
                break
            case ETipoSoggetto.INCARICATO:
                params = [cognome: trasporto.cognomeIncaricatoTrasporto, nome: trasporto.nomeIncaricatoTrasporto, sesso : trasporto.sessoIncaricatoTrasporto, dataNascita: trasporto.dataNascitaIncaricatoTrasporto]
                break
        }
        if (params) {
            Window w = (Window) Executions.createComponents(FormUtils.getUriAnagrafeSelect(ricercaSoggettoInANPROn), self, params)
            w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
                if (event.data instanceof AnaAnagrafeBaseDomain) {
                    AnaAnagrafeBaseDomain ana = (AnaAnagrafeBaseDomain)event.data
                    switch (ts) {
                        case ETipoSoggetto.RICHIEDENTE:
                            caricaDatiRichiedente(ana)
                            break
                        case ETipoSoggetto.INCARICATO:
                            caricaDatiIncaricatoTrasporto(ana)
                            break
                    }
                    refreshUi()
                }
            })
            w.doModal()
        }
    }

    private void caricaDatiRichiedente(AnaAnagrafeBaseDomain ana){
        trasporto.cognomeRichiedente = ana.cognome
        trasporto.nomeRichiedente = ana.nome
        trasporto.sessoRichiedente = ana.sesso
        trasporto.dataNascitaRichiedente = ana.dataNascita
        trasporto.codiceComuneNascitaRichiedente = ana.codiceComuneNascita
        trasporto.descrizioneComuneNascitaRichiedente = ana.descrizioneComuneNascita
        trasporto.codiceProvinciaNascitaRichiedente = ana.codiceProvinciaNascita
        trasporto.siglaProvinciaNascitaRichiedente = ana.siglaProvinciaNascita
        trasporto.codiceComuneResidenzaRichiedente = ana.comuneResidenza?.codice
        trasporto.descrizioneComuneResidenzaRichiedente = ana.comuneResidenza?.descrizione
        trasporto.codiceProvinciaResidenzaRichiedente = ana.comuneResidenza?.codiceProvincia
        trasporto.siglaProvinciaResidenzaRichiedente = ana.comuneResidenza?.siglaProvincia

        allineaTestoTrasportoMinuscole()
    }

    private void caricaDatiIncaricatoTrasporto(AnaAnagrafeBaseDomain ana){
        trasporto.cognomeIncaricatoTrasporto = ana.cognome
        trasporto.nomeIncaricatoTrasporto = ana.nome
        trasporto.sessoIncaricatoTrasporto = ana.sesso
        trasporto.dataNascitaIncaricatoTrasporto = ana.dataNascita
        trasporto.codiceComuneNascitaIncaricatoTrasporto = ana.codiceComuneNascita
        trasporto.descrizioneComuneNascitaIncaricatoTrasporto = ana.descrizioneComuneNascita
        trasporto.codiceProvinciaNascitaIncaricatoTrasporto = ana.codiceProvinciaNascita
        trasporto.siglaProvinciaNascitaIncaricatoTrasporto = ana.siglaProvinciaNascita
        trasporto.codiceComuneResidenzaIncaricatoTrasporto = ana.comuneResidenza?.codice
        trasporto.descrizioneComuneResidenzaIncaricatoTrasporto = ana.comuneResidenza?.descrizione
        trasporto.codiceProvinciaResidenzaIncaricatoTrasporto = ana.comuneResidenza?.codiceProvincia
        trasporto.siglaProvinciaResidenzaIncaricatoTrasporto = ana.comuneResidenza?.siglaProvincia

        allineaTestoTrasportoMinuscole()
    }

    List<Map> etichetteTsDefault = [Etichette.getEtichetta("Trasporto"), Etichette.getEtichetta("Dati_Trasporto"),
                                    Etichette.getEtichetta("Cremazione"), Etichette.getEtichetta("Dati_Cremazione"), Etichette.getEtichetta("Estremi_Onoranze_Funebri"), Etichette.getEtichetta("Minuscole"),
                                    Etichette.getEtichetta("Compilare_campi_obbligatori_protocollazione"), Etichette.getEtichetta("Warn_dati_protocollo_incompleti")]

}
