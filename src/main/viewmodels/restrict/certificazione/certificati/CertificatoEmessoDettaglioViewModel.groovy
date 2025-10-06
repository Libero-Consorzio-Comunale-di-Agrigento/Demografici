package restrict.certificazione.certificati

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ArcComuneBaseDomain
import it.finmatica.de4gsdzk.GsdAnagrafeBaseDomain
import it.finmatica.de4gsdzk.certificazione.*
import it.finmatica.de4gsdzk.utils.*
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.TraitCancellazioneCampi
import restrict.TraitComune
import restrict.statocivile.DizionarioDettaglioViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class CertificatoEmessoDettaglioViewModel extends DizionarioDettaglioViewModel implements TraitCancellazioneCampi, TraitComune {
    List<CerTipoPagamento> listaTipoPagamento = []
    CerCertificatoEmesso dettaglio
    DirittiViewState diritti

    @WireVariable
    private CerCertificatoEmessoService cerCertificatoEmessoService

    @WireVariable
    private CerTipoPagamentoService cerTipoPagamentoService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w,
         @ExecutionArgParam("id") Long id) {
        self = w

        saveRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.Certificato, Etichette.Motivo, Etichette.CERTIFICATO_EMESSO, Etichette.CERTIFICATO_ANNULLATO,
                                           Etichette.SEZIONE_BENEFICIARIO, Etichette.SEZIONE_RICHIEDENTE, Etichette.SEZIONE_DATI_CERTIFICATO]
        eList.addAll([Etichette.Anno_emissione, Etichette.Progressivo_emissione])
        eList.addAll([Etichette.Tipo_Certificato, Etichette.Modalita_rilascio, Etichette.Firma_Emissione, Etichette.Altri_Dati, Etichette.Dati_Annullamento])
        eList.addAll([Etichette.annulla_certificato_tooltip, Etichette.ripristina_certificato_tooltip, Etichette.scarica_allegato_tooltip, EtichetteMessaggi.Ask_Ripristino_Certificato])
        eList.addAll(GsdAnagrafeBaseDomain.etichetteDomain)
        eList.addAll(CerCertificatoEmesso.etichetteDomain)
        eList.addAll(CerCategoriaTipoCertificato.etichetteDomain)
        eList.addAll(CerTerminalista.etichetteDomain)

        eList.addAll(ESesso.values()*.getEtichettaDesc())
        eList.addAll(ETipoSiNo.values()*.getEtichettaDesc())
        eList.addAll(EDiritto.values()*.getEtichettaDesc())

        eList.addAll([EtichetteMessaggi.Errore_salvataggio_file_documentale, EtichetteMessaggi.Errore_modello_testo_non_trovato, EtichetteMessaggi.Ask_Conferma_Salvataggio_Documento])

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.Certificato)

        resize()

        caricaListaTipiPagamento()

        if (id) {
            caricaDettaglio(id)
        } else {
            creaDettaglio([:])
        }
    }

    void caricaListaTipiPagamento() {
        listaTipoPagamento = [null] + cerTipoPagamentoService.listAll()
    }

    void caricaDettaglio(def id) {
        if (id == null) {
            throw new IllegalArgumentException("id non specificato")
        }
        dettaglio = cerCertificatoEmessoService.get(id as Long)

        Map<EDiritto, CerTariffaDiritto> tariffeDirittoTipoCertificato = [:]
        if(dettaglio?.tipoCertificato?.tipoCertificatoTariffaDirittoList){
            dettaglio.tipoCertificato.tipoCertificatoTariffaDirittoList*.tariffaDiritto.each {
                if (tariffeDirittoTipoCertificato.containsKey(it.diritto)) {
                    throw new IllegalStateException("TariffaDiritto duplicato per il diritto ${it.diritto} e per tipo certificato ${dettaglio.tipoCertificato.id}")
                }
                tariffeDirittoTipoCertificato.put(it.diritto, it)
            }
        }

        diritti = new DirittiViewState()
        diritti.segreteria.descrizione = tariffeDirittoTipoCertificato[EDiritto.SEGRETERIA]?.descrizione
        diritti.statoCivile.descrizione = tariffeDirittoTipoCertificato[EDiritto.STATO_CIVILE]?.descrizione
        diritti.cartaIdentita.descrizione = tariffeDirittoTipoCertificato[EDiritto.CARTA_IDENTITA]?.descrizione
        diritti.rimborsoStampati.descrizione = tariffeDirittoTipoCertificato[EDiritto.RIMBORSO_STAMPATI]?.descrizione
        diritti.bollo.descrizione = tariffeDirittoTipoCertificato[EDiritto.BOLLO]?.descrizione
        refreshUi()
    }

    void creaDettaglio(Map params) {
        throw new IllegalStateException("Non implementato")
    }

    @Command
    void onDownloadAllegato() {
        cerCertificatoEmessoService.downloadAllegato(dettaglio)
    }

    @Override
    void selezionaComune(ETipoComuneAtto tc, ArcComuneBaseDomain c) {
        throw new IllegalStateException("Non implementato")
    }

    @Command
    void onAnnullaCertificato() {
        Window popupScansione = (Window) Executions.createComponents('/restrict/certificazione/popupAnnullaCertificato.zul', self,
                [showCertificatoEsternoWarning: dettaglio.generazioneEsterna])
        popupScansione.addEventListener(CustomEvents.ON_NULLIFY_CERTIFICATO, { event ->
            if (event.data) {
                String noteAnnullamento = event.data.noteAnnullamento
                cerCertificatoEmessoService.annullaCertificato(dettaglio, noteAnnullamento)
                caricaDettaglio(dettaglio.id)
            }
        })
        popupScansione.doModal()
    }

    @Command
    void onRipristinaCertificato() {
        String errMsg = getEtichetta(EtichetteMessaggi.Ask_Ripristino_Certificato)
        Messagebox.show(errMsg, msgTitle,
                Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION, { e ->
            if (Messagebox.ON_OK.equals(e.getName())) {
                cerCertificatoEmessoService.ripristinaCertificato(dettaglio)
                caricaDettaglio(dettaglio.id)
            }
        })
    }

    @Command
    void onSalvaRecord() {
        cerCertificatoEmessoService.save(dettaglio)
        caricaDettaglio(dettaglio.id)
    }
}
