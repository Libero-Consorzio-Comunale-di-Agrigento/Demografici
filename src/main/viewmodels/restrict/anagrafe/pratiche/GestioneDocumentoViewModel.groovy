package restrict.anagrafe.pratiche

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ArcComuneBaseDomain
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.anagrafe.*
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaEnte
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaEnteService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.utils.ENaturaDocumento
import it.finmatica.de4gsdzk.utils.ETipoComuneAtto
import it.finmatica.de4gsdzk.utils.ETipoSN
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.SortUtils
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.AbstractDettaglioViewModel
import restrict.TraitCancellazioneCampi
import restrict.TraitComune

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class GestioneDocumentoViewModel extends AbstractDettaglioViewModel implements TraitCancellazioneCampi, TraitComune {

    @WireVariable
    private GsdEtichettaService gsdEtichettaService
    @WireVariable
    private AnaTipoDocumentoService anaTipoDocumentoService
    @WireVariable
    private AnaDocumentoService anaDocumentoService
    @WireVariable
    private AnaEnteService anaEnteService
    @WireVariable
    private AnaAnagrafeService anaAnagrafeService
    @WireVariable
    private AnaCategoriaService anaCategoriaService
    @WireVariable
    private GsdService gsdService
    @WireVariable
    private AnaMotivoRilascioService anaMotivoRilascioService

    AnaDocumento documento

    List<AnaTipoDocumento> tipoDocumentoList
    List<ENaturaDocumento> naturaDocumentoList
    List<AnaEnte> entiList
    List<ETipoSN> listaSN
    List<AnaCategoria> listaCategorie = []
    List<AnaMotivoRilascio> listaMotiviRilascio

    boolean modifica
    String tipologia
    Integer matricola

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long id, @ExecutionArgParam("tipologia") String t, @ExecutionArgParam("matricola") Integer matr) {
        self = w
        tipologia = t
        matricola = matr

        List<Map<String, String>> eList = [Etichette.getEtichetta("Inserisci_Documento"), Etichette.getEtichetta("Modifica_Documento")]
        eList.addAll(AnaDocumento.etichetteDomain)
        eList.addAll(ENaturaDocumento.values()*.getEtichettaDesc())
        eList.addAll([Etichette.getEtichetta("Valida"),Etichette.getEtichetta("Non_Valida_Inibizione"),Etichette.getEtichetta("Non_Valida_Scelta")])
        eList.addAll([Etichette.getEtichetta("Cancella"), Etichette.getEtichetta("Chiudi"),
                      Etichette.getEtichetta("Aggiungi"), Etichette.getEtichetta("Salva")])

        if (id) {
            caricaDettaglio(id)
            modifica = true
        } else {
            creaDettaglio([:])
            modifica = false
        }

        if(tipologia.equals("CDF")){
            tipoDocumentoList = anaTipoDocumentoService.findAllByFlagConvivenzaDiFattoNotNull()
        } else { //Standard
            tipoDocumentoList = anaTipoDocumentoService.findAllByFlagConvivenzaDiFattoNull()
        }

        naturaDocumentoList = ENaturaDocumento.values().toList()
        entiList = [null] + anaEnteService.listAll(new Sort(SortUtils.descrizioneAsc)) as List<AnaEnte>
        listaSN = ETipoSN.values().toList() + [null]
        listaMotiviRilascio = anaMotivoRilascioService.findAll()


        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = modifica ? getEtichetta(Etichette.getEtichetta("Modifica_Documento")) : getEtichetta(Etichette.getEtichetta("Inserisci_Documento"))
        formLabel = msgTitle?.toUpperCase()
    }

    @Override
    void caricaDettaglio(Object id) {
        documento = anaDocumentoService.get(id as Long)
        listaCategorie = [null]
        listaCategorie.addAll(anaCategoriaService.findAllByTipoDocumento(documento.tipoDocumento))
    }

    @Override
    void creaDettaglio(Map params) {
        documento = new AnaDocumento()
        documento.anagrafe = anaAnagrafeService.findById(matricola)
        documento.natura = ENaturaDocumento.O
    }

    @Override
    Object getDettaglio() {
        return documento
    }

    @Command
    void onChiudi() {
        Events.postEvent(Events.ON_CLOSE, self, [:])
    }

    @Command
    void onSalva() {
        if(checkDatiObbligatori()){
            anaDocumentoService.save(documento)
            onChiudi()
        } else {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori"))
        }

    }

    private boolean checkDatiObbligatori() {
        if(documento.tipoDocumento == null || (documento.dataEmissione == null && !documento.tipoDocumento.isCartaCircolazione()) ||
            documento.numero == null || documento.ente == null || documento.comuneEnte.codice == null) {
            return false
        }
        if(documento.tipoDocumento.hasCategoria() && documento.categoria == null) {
            return false
        }
        if (!tipologia.equals("CDF") && !documento.tipoDocumento.isCartaCircolazione() && documento.dataScadenza == null) {
            //controllo scadenza illimitata solo per documento di soggiorno
            return documento.tipoDocumento.isDocumentoSoggiorno() && documento.scadenzaIllimitata
        }
        return true
    }

    @Override
    void selezionaComune(ETipoComuneAtto tc, ArcComuneBaseDomain c) {
        switch (tc) {
            case ETipoComuneAtto.DOC_ENTE:
                riempiComune(documento.comuneEnte, c)
                break
        }
    }

    @Command
    void onSelectTipoDocumento() {
        listaCategorie = [null]
        documento.categoria = null
        documento.espatrio = null
        documento.ente = null
        documento.scadenzaIllimitata = null
        documento.dataScadenza = null

        if (!tipologia.equals("CDF") && documento.tipoDocumento) {
            listaCategorie.addAll(anaCategoriaService.findAllByTipoDocumento(documento.tipoDocumento))
            if(documento.tipoDocumento.id.equals("CE") || documento.tipoDocumento.id.equals("CI")) {
                documento.ente = anaEnteService.get(AnaEnte.COMUNE)
                if(documento.dataEmissione){
                    documento.dataScadenza = gsdService.calcolaDataScadenza(documento.tipoDocumento, documento.dataEmissione, matricola)
                }
            }
        }
        refreshUi()
    }

    @Command
    void onChangeDataEmissione(){
        if(documento.dataEmissione && (documento.tipoDocumento.id.equals("CE") || documento.tipoDocumento.id.equals("CI"))){
            documento.dataScadenza = gsdService.calcolaDataScadenza(documento.tipoDocumento, documento.dataEmissione, matricola)
        }
        refreshUi()
    }
}
