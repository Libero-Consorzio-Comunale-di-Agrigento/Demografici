package restrict.certificazione.dizionari.generale

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anagrafe.AnaTipoDocumento
import it.finmatica.de4gsdzk.anpr.AnprTipoCertificatoEsterno
import it.finmatica.de4gsdzk.ansc.AnscTipoCertificatoEsterno
import it.finmatica.de4gsdzk.certificazione.*
import it.finmatica.de4gsdzk.certificazione.generazione.ETipoGenerazioneCertificato
import it.finmatica.de4gsdzk.errors.FileNameNonAttesoRuntimeException
import it.finmatica.de4gsdzk.statocivile.GestioneTestiModelloRelazioneService
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.zkutils.ETipoDocumentoAnagrafeFiltro
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.TraitCancellazioneCampi
import restrict.statocivile.DizionarioDettaglioViewModel
import restrict.statocivile.dizionari.comunicazione.TraitGestioneTestiModelloRelazione

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class TipoCertificatoDettaglioViewModel extends DizionarioDettaglioViewModel implements TraitCancellazioneCampi, TraitGestioneTestiModelloRelazione {

    final List<ETipoAtto> listaTipoAtto = TipoAttoUtils.listaTipiAttoCertificabili
    final ETipoDocumentoAnagrafeFiltro tipoDocumentoAnagrafeFiltro = ETipoDocumentoAnagrafeFiltro.ALLEGABILITA_CERTIFICAZIONE
    final List<EFormatoTesto> listaFormatiTesto = [null] + EFormatoTesto.values().toList()

    CerTipoCertificato dettaglio

    ETipoOperazione tipoOperazione

    List<CerCategoriaTipoCertificato> listaCategoriaTipoCertificato = []
    List<CerFirma> listaFirma = []
    List<CerFiltro> listaFiltro = []
    List<CerCodiceControllo> listaCodiceControllo = []
    List<CerValiditaCertificato> listaValidita = []

    @WireVariable
    private CerCategoriaTipoCertificatoService cerCategoriaTipoCertificatoService

    @WireVariable
    private CerFirmaService cerFirmaService

    @WireVariable
    private CerFiltroService cerFiltroService

    @WireVariable
    private CerCodiceControlloService cerCodiceControlloService

    @WireVariable
    private CerValiditaCertificatoService cerValiditaCertificatoService

    @WireVariable
    private CerTipoCertificatoService cerTipoCertificatoService

    @WireVariable
    private GestioneTestiModelloRelazioneService gestioneTestiModelloRelazioneService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") String id) {
        self = w

        saveRecordEnabled = true

        List<Map> eList = [Etichette.Tipo_Certificato]
        eList.addAll(CerTipoCertificato.etichetteDomain)

        // Aggiungo etichette tipo si no
        eList.addAll(ETipoSiNo.values()*.getEtichettaDesc())

        // Aggiungo etichette certificato
        eList.addAll(CerCategoriaTipoCertificato.etichetteDomain)

        // Aggiungo etichette competenze
        eList.addAll(ETipoCompetenzaCertificazioneOnLine.values()*.getEtichettaDesc())

        // Aggiungo etichette tipi atto
        eList.addAll(ETipoAtto.values()*.getEtichettaPluralDesc())

        eList.addAll(EtichetteMessaggi.Compilare_tipo_certificato_categoria, EtichetteMessaggi.Ask_Conferma_Salvataggio)

        // Aggiungo etichette per tipi generazione esterne
        eList.addAll(ETipoGenerazioneCertificato.values().findAll { it.isGenerazioneEsterna() }*.getEtichettaDesc())

        // Aggiungo eticchete FileUtils
        eList.addAll(FileUtils.etichetteFileUtils)

        doInitModelloRelazione(gestioneTestiModelloRelazioneService)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.Tipo_Certificato)

        formLabel = msgTitle?.toUpperCase()

        resize()

        caricaListaCategoriaTipoCertificato()
        caricaListaFirma()
        caricaListaCodiceControllo()
        caricaListaValidita()

        if (id != null) {
            caricaDettaglio(id)
        } else {
            creaDettaglio([categoriaTipoCertificato: listaCategoriaTipoCertificato.get(0)])
        }
    }

    void caricaListaCategoriaTipoCertificato() {
        listaCategoriaTipoCertificato = []
        List<CerCategoriaTipoCertificato> l = cerCategoriaTipoCertificatoService.listAll()
        if (l.size() > 0) {
            listaCategoriaTipoCertificato.addAll(l)
        }
    }

    void caricaListaFirma() {
        listaFirma = [null]
        PageRequest pr = new PageRequest(0, Integer.MAX_VALUE)
        List<CerFirma> l = cerFirmaService.listAllByDescrizioneLike('', pr).content
        if (l.size() > 0) {
            listaFirma.addAll(l)
        }
    }

    void caricaListaCodiceControllo() {
        listaCodiceControllo = [null]
        PageRequest pr = new PageRequest(0, Integer.MAX_VALUE, new Sort(SortUtils.idAsc))
        List<CerCodiceControllo> l = cerCodiceControlloService.listAll(pr).content
        if (l.size() > 0) {
            listaCodiceControllo.addAll(l)
        }
    }

    void caricaListaValidita() {
        listaValidita = [null]
        PageRequest pr = new PageRequest(0, Integer.MAX_VALUE, new Sort(SortUtils.idAsc))
        List<CerValiditaCertificato> l = cerValiditaCertificatoService.listAllByDescrizioneLike('', pr).content
        if (l.size() > 0) {
            listaValidita.addAll(l)
        }
    }

    void caricaDettaglio(def id) {
        if (id != null) {
            dettaglio = cerTipoCertificatoService.get(id as String)
            creaModelloRelazione(dettaglio)
            tipoOperazione = ETipoOperazione.UPD

            caricaListaFiltro()
        }
        refreshUi()
    }

    void creaDettaglio(Map params) {
        dettaglio = new CerTipoCertificato(params)
        creaModelloRelazione(dettaglio)
        tipoOperazione = ETipoOperazione.INS

        caricaListaFiltro()
    }

    void caricaListaFiltro() {
        listaFiltro = [null]
        if (dettaglio.categoriaTipoCertificato != null) {
            List<CerFiltro> l = cerFiltroService.listAllByTipoCompetenza(dettaglio.categoriaTipoCertificato.tipoCompetenzaOnline)
            if (l.size() > 0) {
                listaFiltro.addAll(l)
            }
        }

        resetFiltro()

    }

    void resetFiltro() {
        if (dettaglio.filtro == null) {
            return
        }

        List<String> l = listaFiltro.findAll { it != null }*.id
        if (dettaglio.filtro.id in l) {
            return
        }

        dettaglio.filtro = null
    }

    @Command
    void onSalvaRecord() {
        if (dettaglio) {
            salvaTipoCertificato()
        }
    }

    void salvaTipoCertificato(boolean force = false) {
        try {
            CerTipoCertificato c = cerTipoCertificatoService.save(tipoOperazione, dettaglio, modelloRelazione, force)
            Messagebox.show(getEtichetta(EtichetteMessaggi.Salvataggio_Completato), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        } catch (FileNameNonAttesoRuntimeException fnv) {
            log.warn(fnv.getMessage())
            Messagebox.show(fnv.getMessage() + "\n" + getEtichetta(EtichetteMessaggi.Ask_Conferma_Salvataggio), msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                    new org.zkoss.zk.ui.event.EventListener() {
                        void onEvent(Event e) {
                            if (Messagebox.ON_OK == e.getName()) {
                                salvaTipoCertificato(true)
                            }
                        }
                    }
            )
        }
    }

    @Command
    void onCancellaCampoDizionario(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        onCancellaCampo(e)
    }

    @Command
    void onSelectCategoria() {
        caricaListaFiltro()
        resetTipoCertificatoEsterno()
        refreshUi()
    }

    private void resetTipoCertificatoEsterno() {
        if (dettaglio.tipoCertificatoEsterno == null) {
            return
        }
        if (dettaglio.categoriaTipoCertificato.isStatoCivile() &&
                dettaglio.tipoCertificatoEsterno instanceof AnscTipoCertificatoEsterno) {
            return
        }
        if (dettaglio.categoriaTipoCertificato.isAnagrafe() &&
                dettaglio.tipoCertificatoEsterno instanceof AnprTipoCertificatoEsterno) {
            return
        }
        dettaglio.tipoCertificatoEsterno = null
    }

    @Command
    void onSelectTipoCertificatoEsterno(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
        if (event?.data instanceof CerTipoCertificatoEsternoBaseDomain) {
            dettaglio.tipoCertificatoEsterno = (CerTipoCertificatoEsternoBaseDomain) event.data
        } else {
            dettaglio.tipoCertificatoEsterno = null
        }
        refreshUi()
    }

    @Command
    void onSelectTipoDocumentoAnagrafe(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
        if (event?.data instanceof AnaTipoDocumento) {
            dettaglio.tipoDocumentoAnagrafe = (AnaTipoDocumento) event.data
        } else {
            dettaglio.tipoDocumentoAnagrafe = null
        }
        refreshUi()
    }

    String getEtichettaPluralEnum(Enum e, String etichettaDefault = null) {
        return e ? getEtichetta(e.getEtichettaPluralDesc()) : getEtichetta(etichettaDefault)
    }

    String getLabelTipoCertificatoEsterno() {
        if (dettaglio.categoriaTipoCertificato?.isStatoCivile()) {
            return String.format(getEtichetta(Etichette.Tipo_Certificato_esterno), getEtichettaEnum(ETipoGenerazioneCertificato.ANSC))
        }
        if (dettaglio.categoriaTipoCertificato?.isAnagrafe()) {
            return String.format(getEtichetta(Etichette.Tipo_Certificato_esterno), getEtichettaEnum(ETipoGenerazioneCertificato.ANPR))
        }
        return String.format(getEtichetta(Etichette.Tipo_Certificato_esterno), "${getEtichettaEnum(ETipoGenerazioneCertificato.ANPR)}/${getEtichettaEnum(ETipoGenerazioneCertificato.ANSC)}")
    }

}
