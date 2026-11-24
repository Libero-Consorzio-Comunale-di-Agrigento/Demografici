package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.*
import it.finmatica.de4gsdzk.anagrafe.AnaCittadinanza
import it.finmatica.de4gsdzk.anagrafe.AnaCittadinanzaService
import it.finmatica.de4gsdzk.ansc.AnscCasoUsoBaseDomain
import it.finmatica.de4gsdzk.ansc.AnscCasoUsoService
import it.finmatica.de4gsdzk.ansc.AnscConsolato
import it.finmatica.de4gsdzk.ansc.AnscEndPointServizioArchivioService
import it.finmatica.de4gsdzk.archivi.ArcComune
import it.finmatica.de4gsdzk.archivi.ArcParametro
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.export.ReportExportResult
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarAttoAttributes
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarDettaglioAttributes
import net.sf.jasperreports.engine.JREmptyDataSource
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.BindingParam
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.EventListener
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractDettaglioViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
abstract class AttoDettaglioParentViewModel extends AbstractDettaglioViewModel {

    List<Integer> listaUffici = []

    List<ENaturaAtto> listaNatura = []

    final List<ETipoSiNo> listaSiNo = [ETipoSiNo.SI, ETipoSiNo.NO]
    List<ESesso> listaSesso = []
    List<AnaCittadinanza> listaNazionalita = []
    List<CivTipoComprensione> listaTipiComprensione = []
    final List<ETipoPresentazioneDocumentiAnsc> listaPresentazioneDocumenti = [null] + Arrays.asList(ETipoPresentazioneDocumentiAnsc.values())
    final List<ETipoRichiestaTrascrizione> listaTipoRichiestaTrascrizione = [null] + Arrays.asList(ETipoRichiestaTrascrizione.values())
    final List<ETipoLuogoNascita> listaTipoLuogoNascita = [null] + Arrays.asList(ETipoLuogoNascita.values())

    final List<ESesso> listaSessoSoggettoCollegato = [null] + ESesso.values().toList()
    List<CivSoggettoCollegato> listaSoggettiCollegati = []

    List<Map> listaFirmatarioTrascr = []

    int statoFrammenti = 0 // 0 = frammenti non attivi, 1 = frammenti in attivazione, 2 = frammenti attivi

    CivDatiProvenienzaAtto datiProvenienza
    CivAnagrafe anagrafe

    CivMargine margine
    CivDocumentoPubblicazione documentoPubblicazione //PUB - PVU - UCI

    String attoStateHash
    String dpaStateHash
    String margineStateHash

    Boolean wPreviewOpen = Boolean.FALSE
    Boolean wPreviewComunicazioniOpen = Boolean.FALSE
    Boolean wPreviewAnnotazioniOpen = Boolean.FALSE
    Boolean wPreviewFascicoloOpen = Boolean.FALSE
    Boolean wPreviewModelloIstatOpen = Boolean.FALSE
    Boolean wPreviewANSCOpen = Boolean.FALSE

    Boolean previewModelloIstatOpenOn = Boolean.FALSE

    Map<String, CivFormulaTestoLibero> mapFormule = [:]
    Boolean composizioneTestoAttiva = Boolean.TRUE

    Map<String, CivAnnotazioneTestoLibero> mapAnnotazioniDaAtto = [:]

    ETipoOperazione tipoOperazione

    String additionalAttoToolbarbutton = null
    String tipoAttoLabel = ""
    String buttonConsolidamentoLabel = ""

    Map<String,Boolean> minuscole = [:]

    Boolean margineOn = Boolean.TRUE

    Boolean anscOn = Boolean.FALSE
    Boolean ricercaSoggettoInANPROn = Boolean.TRUE

    AnscCasoUsoBaseDomain casoUso

    @Delegate
    ControlBarDettaglioAttributes cbDettaglio = new ControlBarDettaglioAttributes()

    @Delegate
    ControlBarAttoAttributes cbAtto = new ControlBarAttoAttributes()

    @WireVariable
    private AnaCittadinanzaService anaCittadinanzaService

    @WireVariable
    private CivTestoLiberoService civTestoLiberoService

    @WireVariable
    private CivTipoAttoService civTipoAttoService

    @WireVariable
    private GsdService gsdService

    @WireVariable
    private CivFormulaTestoLiberoService civFormulaTestoLiberoService

    @WireVariable
    private CivAnnotazioneTestoLiberoService civAnnotazioneTestoLiberoService

    @WireVariable
    private CivAnnotazioneAttoService civAnnotazioneAttoService

    @WireVariable
    private CivNascitaService civNascitaService

    @WireVariable
    private CivArchivioComunicazioneService civArchivioComunicazioneService

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @WireVariable
    private StampaAttoService stampaAttoService

    @WireVariable
    private CivMargineService civMargineService

    @WireVariable
    protected ArcParametroService arcParametroService

    @WireVariable
    private CivTipoComprensioneService civTipoComprensioneService

    @WireVariable
    private CivSoggettoCollegatoService civSoggettoCollegatoService

    @WireVariable
    private CivFirmatarioAttoService civFirmatarioAttoService

    @WireVariable
    private CivAttoService civAttoService

    @WireVariable
    private AnscCasoUsoService anscCasoUsoService

    @WireVariable
    private AnscEndPointServizioArchivioService anscEndPointServizioArchivioService

    void doInitAllAtti(List<Map<String, String>> eList=[], boolean checkModelloIstat=true) {
        eList.addAll(etichetteDettaglioDefault)

        eList.addAll(etichetteAttoDettaglioDefault)

        eList.addAll(CivAttoBaseDomain.etichetteDomain)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarDettaglioAttributes.etichetteCbDettaglioDesc)

        // Aggiungo etichette della Controlbar specifica
        eList.addAll(ControlBarAttoAttributes.etichetteCbAttoDesc)

        // Aggiungo etichette tipo si no
        eList.addAll(ETipoSiNo.values()*.getEtichettaDesc())

        // Aggiungo etichette tipo presentazione documenti ansc
        eList.addAll(ETipoPresentazioneDocumentiAnsc.values()*.getEtichettaDesc())

        // Aggiungo etichette tipo dichiarazione
        eList.addAll(ETipoRichiestaTrascrizione.values()*.getEtichettaDesc())

        // Aggiungo etichette tipo luogo nascita
        eList.addAll(ETipoLuogoNascita.values()*.getEtichettaDesc())

        eList.addAll([Etichette.getEtichetta("Dichiarante"), Etichette.getEtichetta("Comparente"), Etichette.getEtichetta("Firmatario"),
                      Etichette.getEtichetta("Dati_Dichiarazione"), Etichette.getEtichetta("Presentazione_documenti"), Etichette.getEtichetta("Comune_Ente")])

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        Boolean istatOn = Boolean.FALSE
        anscOn = Boolean.FALSE
        ricercaSoggettoInANPROn = Boolean.TRUE
        margineOn = Boolean.TRUE
        caratteriSpecialiEnabled = Boolean.FALSE
        List<ArcParametro> lParams = arcParametroService.listAllByIdIn([ArcParametro.ANSC,
                                                                        ArcParametro.CIV_ANPR,
                                                                        ArcParametro.ATTI_MAR,
                                                                        ArcParametro.ISTATEL,
                                                                        ArcParametro.UNICODE])
        for (ArcParametro p: lParams){
            switch(p.id) {
                case ArcParametro.ANSC:
                    anscOn = (p?.valore?.trim()?.toUpperCase() == ETipoSN.S.name())
                    break
                case ArcParametro.CIV_ANPR:
                    ricercaSoggettoInANPROn = ((p?.valore?.trim()?.toUpperCase() ?: ETipoSN.S.name()) == ETipoSN.S.name())
                    break
                case ArcParametro.ATTI_MAR:
                    margineOn = ((p?.valore?.trim()?.toUpperCase() ?: ETipoSN.S.name()) != ETipoSN.N.name())
                    break
                case ArcParametro.ISTATEL:
                    istatOn = (p?.valore?.trim()?.toUpperCase() == ETipoSN.S.name())
                    break
                case ArcParametro.UNICODE:
                    caratteriSpecialiEnabled = (p?.valore?.trim()?.toUpperCase() == ETipoSN.S.name())
                    break
            }
        }
        if (checkModelloIstat && istatOn){
            additionalAttoToolbarbutton = "/restrict/afc/controlbar/toolbarbuttonIstat.zul"
        }

        caricaListaNazionalita()

        caricaListaUffici()

        caricaListaTipiComprensione()

        caricaListaFirmatarioTrascr()
    }

    @Override
    @Command
    void onBackFromRecord() {
        askModificheInSospeso(getEtichetta(Etichette.getEtichetta("Chiusura")), {
            Events.postEvent(CustomEvents.ON_BACK_FROM_RECORD, self, [:])
            onChiudi()
        })
    }

    Boolean getCasiUsoEnabled(){
        if (getAtto() instanceof IAttoAnsc){
            return TestoUtils.isVuoto(getAtto().getIdAttoAnsc())
        }
        return Boolean.FALSE
    }

    @Command void onChangeNumeroAtto(){
        if (tipoOperazione.isInsert()) {
            String s = gsdService.checkEstremiAtto(atto)
            if ((s?.trim() ?: "") != "") {
                Messagebox.show(s, msgTitle, Messagebox.OK, Messagebox.ERROR)
            }
        }
    }

    Boolean isUpdatable(){
        if (tipoOperazione.isUpdate()){
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Errore_Operazione_non_consentita")), msgTitle, Messagebox.OK, Messagebox.ERROR)
            onChiudi()
            return Boolean.FALSE
        }
        return Boolean.TRUE
    }

    void caricaListaFirmatarioTrascr(){
        listaFirmatarioTrascr = [[label:getEtichetta(Etichette.getEtichetta("SI")), value: "RT"],
                                 [label:getEtichetta(Etichette.getEtichetta("NO")), value: "NE"]]
    }

    void resetFirmatarioToNE() {
        datiProvenienza.tipoFirmatario = "NE"
    }

    void caricaListaNazionalita(){
        listaNazionalita = [null]
        List<AnaCittadinanza> l = anaCittadinanzaService.listAll()
        if (l.size()>0){
            listaNazionalita.addAll(l)
        }
    }

    void caricaListaTipiComprensione(){
        listaTipiComprensione = []
        List<CivTipoComprensione> l = civTipoComprensioneService.listAll()
        if (l.size() > 0){
            listaTipiComprensione.addAll(l)
        }
    }

    CivTipoComprensione getDefaultComprensione(){
        return civTipoComprensioneService.getDefault()
    }

    protected void caricaListaSoggettiCollegati(){
        listaSoggettiCollegati = civSoggettoCollegatoService.listAllByUkAtto(getAtto().idAtto)
        for (CivSoggettoCollegato sc: listaSoggettiCollegati){
            DomainUtils.allineaTestoMinuscole(sc, minuscole)
        }
    }

    void caricaListaUffici(){
        listaUffici = gsdService.listUffici(Boolean.TRUE)
    }

    Boolean isMargineMandatory(){
        String gestioneMargine = civMargineService.getGestioneMargine(getAtto())
        return ( (gestioneMargine != CivMargine.N) || ( (gestioneMargine == CivMargine.N) && (statoFrammenti == 2) ) )
    }

    Boolean isDaConsolidareOBloccare(){
        if (tipoOperazione.isInsert() || getAtto().getBloccato()){
            return Boolean.FALSE
        }
        return Boolean.TRUE
    }

    boolean isMinuscole(String campo) {
        return minuscole[campo]
    }

    protected String calcolaCf(String cognome, String nome, ESesso sesso, Date dataNascita, Integer codiceProvinciaNascita, Integer codiceComuneNascita) {
        return gsdService.calcolaCf(cognome, nome, sesso, dataNascita, codiceProvinciaNascita, codiceComuneNascita)
    }

    @Command void onSelectComune(@ContextParam(ContextType.TRIGGER_EVENT) Event event, @BindingParam("campoRiferimento") String campoRiferimento){
        ArcComuneBaseDomain c = null
        if (event?.target?.selectedItem instanceof ArcComuneBaseDomain) {
            c = event.target.selectedItem
        }
        selezionaComune(ETipoComuneAtto.valueOf(campoRiferimento), c)
    }

    @Command void onCancellaComune(@BindingParam("campoRiferimento") String campoRiferimento){
        onSelectComune(null, campoRiferimento)
    }

    protected void selezionaComune(ETipoComuneAtto tca, ArcComuneBaseDomain c){
        switch (tca) {
            case ETipoComuneAtto.CN_DIC:
                riempiComune(datiProvenienza.comuneNascitaDichiarante, c)
                break
            case ETipoComuneAtto.CR_DIC:
                riempiComune(datiProvenienza.comuneResidenzaDichiarante, c)
                break
            case ETipoComuneAtto.CA_ORIG:
                riempiComune(datiProvenienza.comuneAttoOriginale, c)
                break
            case ETipoComuneAtto.CN_SOGG_1:
                if (getAtto() instanceof ISoggettoAtto1) {
                    ISoggettoAtto1 sa = (ISoggettoAtto1) getAtto()
                    sa.codiceComuneNascita1 = c?.codiceComune
                    sa.descrizioneComuneNascita1 = c?.descrizioneComune
                    sa.codiceProvinciaNascita1 = c?.codiceProvincia
                    sa.siglaProvinciaNascita1 = c?.siglaProvincia
                }
                break
            case ETipoComuneAtto.CR_SOGG_1:
                if (getAtto() instanceof ISoggettoAtto1) {
                    ISoggettoAtto1 sa = (ISoggettoAtto1) getAtto()
                    sa.codiceComuneResidenza1 = c?.codiceComune
                    sa.descrizioneComuneResidenza1 = c?.descrizioneComune
                    sa.codiceProvinciaResidenza1 = c?.codiceProvincia
                    sa.siglaProvinciaResidenza1 = c?.siglaProvincia
                }
                break
            case ETipoComuneAtto.CN_SOGG_2:
                if (getAtto() instanceof ISoggettoAtto2) {
                    ISoggettoAtto2 sa = (ISoggettoAtto2) getAtto()
                    sa.codiceComuneNascita2 = c?.codiceComune
                    sa.descrizioneComuneNascita2 = c?.descrizioneComune
                    sa.codiceProvinciaNascita2 = c?.codiceProvincia
                    sa.siglaProvinciaNascita2 = c?.siglaProvincia
                }
                break
            case ETipoComuneAtto.CR_SOGG_2:
                if (getAtto() instanceof ISoggettoAtto2) {
                    ISoggettoAtto2 sa = (ISoggettoAtto2) getAtto()
                    sa.codiceComuneResidenza2 = c?.codiceComune
                    sa.descrizioneComuneResidenza2 = c?.descrizioneComune
                    sa.codiceProvinciaResidenza2 = c?.codiceProvincia
                    sa.siglaProvinciaResidenza2 = c?.siglaProvincia
                }
                break
            case ETipoComuneAtto.CA_SOGG_1_NAS:
                if (getEstremiAttoNascitaDomain() instanceof IEstremiAttoNascitaSoggetto1Domain) {
                    IEstremiAttoNascitaSoggetto1Domain sa = (IEstremiAttoNascitaSoggetto1Domain) getEstremiAttoNascitaDomain()
                    sa.codiceComuneAttoNascita1 = c?.codiceComune
                    sa.descrizioneComuneAttoNascita1 = c?.descrizioneComune
                    sa.codiceProvinciaAttoNascita1 = c?.codiceProvincia
                    sa.siglaProvinciaAttoNascita1 = c?.siglaProvincia
                }
                break
            case ETipoComuneAtto.CA_SOGG_2_NAS:
                if (getEstremiAttoNascitaDomain() instanceof IEstremiAttoNascitaSoggetto2Domain) {
                    IEstremiAttoNascitaSoggetto2Domain sa = (IEstremiAttoNascitaSoggetto2Domain) getEstremiAttoNascitaDomain()
                    sa.codiceComuneAttoNascita2 = c?.codiceComune
                    sa.descrizioneComuneAttoNascita2 = c?.descrizioneComune
                    sa.codiceProvinciaAttoNascita2 = c?.codiceProvincia
                    sa.siglaProvinciaAttoNascita2 = c?.siglaProvincia
                }
                break
            case ETipoComuneAtto.CA_MATR:
                if (getEstremiAttoMatrimonioDomain() != null) {
                    IEstremiAttoMatrimonioDomain sa = getEstremiAttoMatrimonioDomain()
                    sa.codiceComuneAttoMatrimonio = c?.codiceComune
                    sa.descrizioneComuneAttoMatrimonio = c?.descrizioneComune
                    sa.codiceProvinciaAttoMatrimonio = c?.codiceProvincia
                    sa.siglaProvinciaAttoMatrimonio = c?.siglaProvincia
                }
                break
            case ETipoComuneAtto.CC_MATR_ACC: // comune di matrimonio da valorizzare nell'accordo di divorzio
                if (getEstremiAttoMatrimonioDomain() != null) {
                    IEstremiAttoMatrimonioDomain sa = getEstremiAttoMatrimonioDomain()
                    riempiComune(sa.comuneMatrimonio, c)
                }
                break
            case ETipoComuneAtto.CA_ACC:
                riempiComune(datiProvenienza.comuneAccordo, c)
                break
            case ETipoComuneAtto.CC_MATR:
                if ( getAtto() instanceof IAttoMatPubUciPvuBase) {
                    IAttoMatPubUciPvuBase sa = (IAttoMatPubUciPvuBase) getAtto()
                    sa.codiceComuneMatrimonio = c?.codiceComune
                    sa.descrizioneComuneMatrimonio = c?.descrizioneComune
                    sa.codiceProvinciaMatrimonio = c?.codiceProvincia
                    sa.siglaProvinciaMatrimonio = c?.siglaProvincia
                }
                break
            case ETipoComuneAtto.CA_SEP:
                if (getAtto() instanceof CivMatrimonio){
                    riempiComune(datiProvenienza.comuneAttoSeparazione, c)
                }
                break
            case ETipoComuneAtto.CA_CONF_SEP:
                if (getAtto() instanceof CivMatrimonio){
                    riempiComune(datiProvenienza.comuneConfermaAccordoSeparazione, c)
                }
                break
            case ETipoComuneAtto.CM_DEC:
                if ( getAtto() instanceof CivMorte) {
                    CivMorte m = (CivMorte) getAtto()
                    riempiComune(m.comuneMorte, c)
                }
                break
            case ETipoComuneAtto.CA_PUBB1:
                if ( (getAtto() instanceof CivMatrimonio) || ( getAtto() instanceof CivPubblicazione) ){
                    riempiComune(margine.comuneAffissione1, c)
                }
                break
            case ETipoComuneAtto.CA_PUBB2:
                if ( (getAtto() instanceof CivMatrimonio) || ( getAtto() instanceof CivPubblicazione) ) {
                    riempiComune(margine.comuneAffissione2, c)
                }
                break
            case ETipoComuneAtto.CA_FOP:
                if ( getAtto() instanceof IAttoMatUci) {
                    riempiComune(datiProvenienza.comuneFineOpposizione, c)
                }
                break
            case ETipoComuneAtto.CC_SOGG_1_EST:
                riempiComune(documentoPubblicazione.comuneEstratto1, c)
                break
            case ETipoComuneAtto.CC_SOGG_2_EST:
                riempiComune(documentoPubblicazione.comuneEstratto2, c)
                break
            case ETipoComuneAtto.CC_SOGG_1_CCU:
                riempiComune(documentoPubblicazione.comuneCumulativo1, c)
                break
            case ETipoComuneAtto.CC_SOGG_2_CCU:
                riempiComune(documentoPubblicazione.comuneCumulativo2, c)
                break
            case ETipoComuneAtto.CC_SOGG_1_CUCI:
                if (getAtto() instanceof CivUnioneCivile){
                    riempiComune(datiProvenienza.comuneRichiestaCostituzione1, c)
                }
                break
            case ETipoComuneAtto.CC_SOGG_2_CUCI:
                if (getAtto() instanceof CivUnioneCivile) {
                    riempiComune(datiProvenienza.comuneRichiestaCostituzione2, c)
                }
                break
            case ETipoComuneAtto.CA_NOT:
                riempiComune(datiProvenienza.comuneAttoNotarile, c)
                break
            case ETipoComuneAtto.CE_STRA:
                riempiComune(datiProvenienza.comuneEnteStraniero, c)
                break
            case ETipoComuneAtto.CA_PROV:
                riempiComune(datiProvenienza.comuneProvenienza, c)
                break
            case ETipoComuneAtto.CA_AUT:
                riempiComune(datiProvenienza.comuneAutoritaGiudiziaria, c)
                break
            case ETipoComuneAtto.CA_PIM:
                riempiComune(datiProvenienza.comunePubblicoImpiego, c)
                break
            case ETipoComuneAtto.CA_RIC_1:
                riempiComune(datiProvenienza.comuneAttoRiconoscimento1, c)
                break
            case ETipoComuneAtto.CA_RIC_2:
                riempiComune(datiProvenienza.comuneAttoRiconoscimento2, c)
                break
            case ETipoComuneAtto.CA_ASS:
                riempiComune(datiProvenienza.comuneAttoAssenso, c)
                break
            case ETipoComuneAtto.CA_ETA:
                riempiComune(datiProvenienza.comuneAttoImpedimentoEta, c)
                break
            case ETipoComuneAtto.CA_PAR:
                riempiComune(datiProvenienza.comuneAttoImpedimentoParentela, c)
                break
            case ETipoComuneAtto.CA_TMP:
                riempiComune(datiProvenienza.comuneAttoDivietoTemporaneo, c)
                break
            case ETipoComuneAtto.CA_DCA:
                riempiComune(datiProvenienza.comuneAccertamento, c)
                break
            case ETipoComuneAtto.CA_GIU:
                riempiComune(datiProvenienza.comuneGiuramento, c)
                break
            case ETipoComuneAtto.CA_CERT:
                riempiComune(datiProvenienza.comuneCertificato, c)
                break
        }
        refreshUi()
    }

    void riempiComune(Comune comuneTarget, ArcComuneBaseDomain comuneSource) {
        comuneTarget.codice = comuneSource?.codiceComune
        comuneTarget.descrizione = comuneSource?.descrizioneComune
        comuneTarget.codiceProvincia = comuneSource?.codiceProvincia
        comuneTarget.siglaProvincia = comuneSource?.siglaProvincia
    }

    void initMinuscole(ETipoAtto ta, Boolean divorzio=Boolean.FALSE){
        // usare nomi di proprietà univoci cioè non condivisi da più domain
        switch (ta) {
            case ETipoAtto.NAS:
                minuscole = [cognome:Boolean.FALSE, nome: Boolean.FALSE, cognomePadre:Boolean.FALSE, nomePadre: Boolean.FALSE,
                             cognomeMadre:Boolean.FALSE, nomeMadre: Boolean.FALSE, secondoNome: Boolean.FALSE, terzoNome: Boolean.FALSE,
                             cognomeDichiarante:Boolean.FALSE, nomeDichiarante: Boolean.FALSE,
                             cognomeSanitario:Boolean.FALSE, nomeSanitario:Boolean.FALSE,
                             cognomeInterprete:Boolean.FALSE, nomeInterprete:Boolean.FALSE,
                             cognomeProcuratorePadre:Boolean.FALSE, nomeProcuratorePadre:Boolean.FALSE,
                             cognomeProcuratoreMadre:Boolean.FALSE, nomeProcuratoreMadre:Boolean.FALSE]
                break
            case ETipoAtto.MOR:
                minuscole = [cognome1:Boolean.FALSE, nome1: Boolean.FALSE, cognomePadre:Boolean.FALSE, nomePadre:Boolean.FALSE,
                             cognomeMadre:Boolean.FALSE, nomeMadre:Boolean.FALSE, cognomeConiuge:Boolean.FALSE, nomeConiuge:Boolean.FALSE,
                             cognomeInterprete:Boolean.FALSE, nomeInterprete:Boolean.FALSE,
                             cognomeDichiarante:Boolean.FALSE, nomeDichiarante: Boolean.FALSE,
                             cognomeRichiedente:Boolean.FALSE, nomeRichiedente: Boolean.FALSE,
                             cognomeIncaricatoTrasporto:Boolean.FALSE, nomeIncaricatoTrasporto: Boolean.FALSE]
                break
            case ETipoAtto.PUB:
                minuscole = [cognome1:Boolean.FALSE, nome1: Boolean.FALSE, cognome2:Boolean.FALSE, nome2: Boolean.FALSE]
                break
            case ETipoAtto.PVU:
                minuscole = [cognome1:Boolean.FALSE, nome1: Boolean.FALSE, cognome2:Boolean.FALSE, nome2: Boolean.FALSE]
                break
            case ETipoAtto.MAT:
                if (divorzio){
                    minuscole = [cognome1:Boolean.FALSE, nome1: Boolean.FALSE, cognome2:Boolean.FALSE, nome2: Boolean.FALSE,
                                 avvocato1: Boolean.FALSE, cognomeAvvocato1: Boolean.FALSE, nomeAvvocato1: Boolean.FALSE,
                                 avvocato2: Boolean.FALSE, cognomeAvvocato2: Boolean.FALSE, nomeAvvocato2: Boolean.FALSE ]
                } else {
                    minuscole = [cognome1:Boolean.FALSE, nome1: Boolean.FALSE, cognome2:Boolean.FALSE, nome2: Boolean.FALSE,
                                 cognomeTestimone1:Boolean.FALSE, nomeTestimone1: Boolean.FALSE,
                                 cognomeTestimone2:Boolean.FALSE, nomeTestimone2: Boolean.FALSE,
                                 cognomeTestimone3:Boolean.FALSE, nomeTestimone3: Boolean.FALSE,
                                 cognomeTestimone4:Boolean.FALSE, nomeTestimone4: Boolean.FALSE,
                                 cognomeInterprete:Boolean.FALSE, nomeInterprete:Boolean.FALSE,
                                 cognomeDichiarante:Boolean.FALSE, nomeDichiarante: Boolean.FALSE]
                }
                break
            case ETipoAtto.UCI:
                if (divorzio){
                    minuscole = [cognome1:Boolean.FALSE, nome1: Boolean.FALSE, cognome2:Boolean.FALSE, nome2: Boolean.FALSE,
                                 avvocato1: Boolean.FALSE, cognomeAvvocato1: Boolean.FALSE, nomeAvvocato1: Boolean.FALSE,
                                 avvocato2: Boolean.FALSE, cognomeAvvocato2: Boolean.FALSE, nomeAvvocato2: Boolean.FALSE ]
                } else {
                    minuscole = [cognome1:Boolean.FALSE, nome1: Boolean.FALSE, cognomeComune1: Boolean.FALSE,
                                 cognome2:Boolean.FALSE, nome2: Boolean.FALSE, cognomeComune2: Boolean.FALSE,
                                 cognomeTestimone1:Boolean.FALSE, nomeTestimone1: Boolean.FALSE,
                                 cognomeTestimone2:Boolean.FALSE, nomeTestimone2: Boolean.FALSE,
                                 cognomeTestimone3:Boolean.FALSE, nomeTestimone3: Boolean.FALSE,
                                 cognomeTestimone4:Boolean.FALSE, nomeTestimone4: Boolean.FALSE,
                                 cognomeInterprete:Boolean.FALSE, nomeInterprete:Boolean.FALSE,
                                 cognomeDichiarante:Boolean.FALSE, nomeDichiarante: Boolean.FALSE]
                }
                break
            case ETipoAtto.CIT:
                minuscole = [cognome1:Boolean.FALSE, nome1: Boolean.FALSE,
                             cognomeDichiarante:Boolean.FALSE, nomeDichiarante: Boolean.FALSE,
                             cognomeInterprete:Boolean.FALSE, nomeInterprete:Boolean.FALSE,
                             cognomeAscendente:Boolean.FALSE, nomeAscendente:Boolean.FALSE,
                             cognomeSoggettoCollegatoPadre:Boolean.FALSE, nomeSoggettoCollegatoPadre: Boolean.FALSE,
                             cognomeSoggettoCollegatoMadre:Boolean.FALSE, nomeSoggettoCollegatoMadre: Boolean.FALSE,
                             cognomeIntestatarioNuovo:Boolean.FALSE, nomeIntestatarioNuovo: Boolean.FALSE]
                break
        }

        arcParametroService.checkMinuscoleOn(minuscole)
    }

    ////////////////////////////////////////// COPIA CONFORME /////////////////////////////////////

    @Command void onGeneraCopiaConforme() {
        Map options = [dataSource: new JREmptyDataSource(), checkSinglePage: false, cia:true, fascicola:true]

        ReportExportResult ret = stampaAttoService.downloadReportAtto(getAtto(), null, margine, null, null, null, etichette, options)
        if  (ret.errorCode == 0){
            Messagebox.show(getEtichetta(Etichette.getEtichetta("CIA_fascicolata")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
        } else
        if  (ret.errorCode == 2){
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Errore_no_tipo_documento_fascicolazione_CIA")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Errore_fascicolazione_CIA")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    ////////////////////////////////////////// ANSC /////////////////////////////////////

    @Command void onPreviewANSC(){
        if (wPreviewANSCOpen || tipoOperazione.isInsert() || (!anscEnabled)){
            return
        }
        askModificheInSospeso(getEtichetta(Etichette.getEtichetta("ANSC")), { goToNextAnscPage() })
    }

    void goToNextAnscPage() {
        if (getAtto() && tipoOperazione.isUpdate() && (!(wPreviewANSCOpen)) && anscEnabled) {
            // ricarica l'atto per non passare la versione temporanea che potrebbe non essere stata salvata
            caricaDettaglio(getAtto().id)
            casoUso = anscCasoUsoService.findByAtto(atto, datiProvenienza)
            String uriANSC = "firmatariANSCLista.zul"
            if (skipFirmatariPage()) {
                uriANSC = "/restrict/statocivile/allegatiANSCLista.zul"
                if (skipAllegatiPage()) {
                    uriANSC = FormUtils.getUriPreviewANSC(atto)
                }
            }
            if (uriANSC) {
                try {
                    wPreviewANSCOpen = Boolean.TRUE
                    Window w = (Window) Executions.createComponents(uriANSC, self.parent, [pkAtto: getAtto().id, tipoAttoEnum: getAtto().getTipoAttoEnum(), casoUso: casoUso, anscFlow: true])
                    self.setVisible(false)
                    w.addEventListener(Events.ON_CLOSE, { event ->
                        caricaDettaglio(getAtto().id)
                        self.setVisible(true)
                        wPreviewANSCOpen = Boolean.FALSE
                    })
                    w.doEmbedded()
                } catch (Exception ex) {
                    log.error("Errore apertura preview dati per integrazione con ANSC", ex)
                    wPreviewANSCOpen = Boolean.FALSE
                    throw ex
                }
            }
        }
    }

    Boolean skipFirmatariPage() {
        if ((atto instanceof IAttoAnsc) && ((IAttoAnsc) atto).getFlagFirmatoUscAnsc()) {
            return true
        }

        // TODO: move inserimento firmatari to salvataggio atto
        gsdService.inserisciFirmatari(atto.tipoAtto, atto.idAtto)

        if (!civFirmatarioAttoService.existsFirmatarioNonValido(atto.idAtto)) {
            return true
        }

        return false
    }

    Boolean skipAllegatiPage() {
        if (casoUso == null) {
            return true
        }
        return anscEndPointServizioArchivioService.listAllServiziAttoAllegatiByAndCasoUsoAndAtto(casoUso.id, atto).isEmpty() || civAttoService.isInviatoAnsc(atto.getTipoAttoEnum(), atto.id)
    }

    ////////////////////////////////////////// COMUNICAZIONI /////////////////////////////////////

    @Command void onPreviewComunicazioni(@BindingParam("priorita") Boolean priorita){
        if (wPreviewComunicazioniOpen || tipoOperazione.isInsert()){
            return
        }

        askModificheInSospeso(getEtichetta(Etichette.getEtichetta("Comunicazioni")), { apriPreviewComunicazioni(priorita) })
    }

    void apriPreviewComunicazioni(Boolean priorita){
        if (getAtto() && tipoOperazione.isUpdate() && (!(wPreviewComunicazioniOpen)) ) {
            try {
                wPreviewComunicazioniOpen = Boolean.TRUE
                Window w = (Window) Executions.createComponents("/restrict/statocivile/comunicazioniAttoLista.zul", self.parent, [pkAtto: getAtto().id, tipoAttoEnum: getAtto().getTipoAttoEnum(), priorita: priorita])
                self.setVisible(false)
                w.addEventListener(Events.ON_CLOSE, { event ->
                    if (event.data?.ricarica){
                        caricaDettaglio(getAtto().id)
                    } else {
                        onChiudi()
                    }
                    self.setVisible(true)
                    wPreviewComunicazioniOpen = Boolean.FALSE
                })
                w.doEmbedded()
            } catch (Exception ex) {
                log.error("Errore apertura form comunicazioni atto", ex)
                wPreviewComunicazioniOpen = Boolean.FALSE
                throw ex
            }
        }
    }

    ////////////////////////////////////////// FASCICOLO ///////////////////////////////////////

    @Command void onPreviewFascicolo(){
        if (wPreviewFascicoloOpen || tipoOperazione.isInsert()){
            return
        }

        askModificheInSospeso(getEtichetta(Etichette.getEtichetta("Fascicolo")), { apriPreviewFascicolo() })
    }

    void apriPreviewFascicolo(){
        if (getAtto() && tipoOperazione.isUpdate() && (!(wPreviewFascicoloOpen)) ) {
            try{
                wPreviewFascicoloOpen = Boolean.TRUE
                Window w = (Window) Executions.createComponents("/restrict/statocivile/fascicoloAttoLista.zul", self.parent, [pkAtto: getAtto().id, tipoAttoEnum: getAtto().getTipoAttoEnum()])
                self.setVisible(false)
                w.addEventListener(Events.ON_CLOSE, { event ->
                    if (event.data?.ricarica){
                        caricaDettaglio(getAtto().id)
                    } else {
                        onChiudi()
                    }
                    self.setVisible(true)
                    wPreviewFascicoloOpen = Boolean.FALSE
                })
                w.doEmbedded()
            } catch (Exception ex){
                log.error("Errore apertura form fascicolo atto", ex)
                wPreviewFascicoloOpen = Boolean.FALSE
                throw ex
            }
        }
    }

    ////////////////////////////////////////// ANNOTAZIONI /////////////////////////////////////

    @Command void onPreviewAnnotazioni(){
        if (wPreviewAnnotazioniOpen || tipoOperazione.isInsert()){
            return
        }

        askModificheInSospeso(getEtichetta(Etichette.getEtichetta("Annotazioni")), { apriPreviewAnnotazioni() })
    }

    void apriPreviewAnnotazioni(){
        if (getAtto() && tipoOperazione.isUpdate() && (!(wPreviewAnnotazioniOpen)) ) {
            try{
                wPreviewAnnotazioniOpen = Boolean.TRUE
                Window w = (Window) Executions.createComponents("/restrict/statocivile/annotazioniAttoLista.zul", self.parent, [pkAtto: getAtto().id, tipoAttoEnum: getAtto().getTipoAttoEnum()])
                self.setVisible(false)
                w.addEventListener(Events.ON_CLOSE, { event ->
                    if ( (event.data?.ricarica) || (event.data?.goToComunicazioni) ){
                        caricaDettaglio(getAtto().id)
                        self.setVisible(true)
                        wPreviewAnnotazioniOpen = Boolean.FALSE
                        if (event.data?.goToComunicazioni){
                            apriPreviewComunicazioni(null)
                        }
                    } else {
                        onChiudi()
                        self.setVisible(true)
                        wPreviewAnnotazioniOpen = Boolean.FALSE
                    }
                })
                w.doEmbedded()
            } catch (Exception ex){
                log.error("Errore apertura form annotazioni atto", ex)
                wPreviewAnnotazioniOpen = Boolean.FALSE
                throw ex
            }
        }
    }

    ////////////////////////////////////////// ANTEPRIMA TESTO /////////////////////////////////////

    @Command void onPreviewRecord(){
        if (wPreviewOpen || tipoOperazione.isInsert()){
            return
        }
        Boolean testoEsistente = (civTestoLiberoService.getByUkAtto(getAtto().idAtto) != null)
        if (testoEsistente){
            Messagebox.Button[] buttons = [Messagebox.Button.YES, Messagebox.Button.NO, Messagebox.Button.CANCEL] as Messagebox.Button[]
            String[] buttonsLabel = [getEtichetta(Etichette.getEtichetta("Apri")), getEtichetta(Etichette.getEtichetta("Rigenera")), getEtichetta(Etichette.getEtichetta("Annulla"))] as String[]
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Ask_Aggiornamento_Testo")), msgTitle, buttons, buttonsLabel , Messagebox.QUESTION, null,
                new org.zkoss.zk.ui.event.EventListener(){
                    void onEvent(Event e){
                        switch (e.getName()) {
                            case Messagebox.ON_YES:
                                apriPreview()
                                break
                            case Messagebox.ON_NO:
                                apriPreview([rigeneraTesto: Boolean.TRUE])
                                break
                            default:
                                break
                        }
                    }
                }
            )
        } else {
            apriPreview([rigeneraTesto: Boolean.TRUE])
        }
    }

    void apriPreview(Map params = null){
        if (getAtto() && tipoOperazione.isUpdate() && (!(wPreviewOpen)) ) {
            try{
                salvaAtto(Boolean.FALSE)

                wPreviewOpen = Boolean.TRUE

                String uri = FormUtils.getUriTestoAtto(getAtto())
                Window w = (Window) Executions.createComponents(uri, self.parent, [pkAtto: getAtto().id, tipoAttoEnum: getAtto().getTipoAttoEnum(), rigeneraTesto: params?.rigeneraTesto])
                self.setVisible(false)
                w.addEventListener(Events.ON_CLOSE, { event ->
                    caricaDettaglio(getAtto().id)
                    self.setVisible(true)
                    wPreviewOpen = Boolean.FALSE
                })
                w.doEmbedded()
            } catch (Exception ex){
                log.error("Errore apertura preview testo atto", ex)
                wPreviewOpen = Boolean.FALSE
                throw ex
            }
        }
    }

    ////////////////////////////////////////// MODELLI ISTAT /////////////////////////////////////

    @Command void onPreviewModelloIstat(){
        if (wPreviewModelloIstatOpen || tipoOperazione.isInsert() || (!previewModelloIstatOpenOn) ){
            return
        }

        askModificheInSospeso(msgTitle, { apriPreviewModelloIstat() })
    }

    void apriPreviewModelloIstat(){
        if (getAtto() && tipoOperazione.isUpdate() && (!(wPreviewModelloIstatOpen)) ) {
            String uriModelloIstat = FormUtils.getUriModelloIstat(getAtto())
            if (uriModelloIstat) {
                try {
                    wPreviewModelloIstatOpen = Boolean.TRUE
                    Window w = (Window) Executions.createComponents(uriModelloIstat, self.parent, [pkAtto: getAtto().id, tipoAttoEnum: getAtto().getTipoAttoEnum()])
                    self.setVisible(false)
                    w.addEventListener(Events.ON_CLOSE, { event ->
                        if (event.data?.ricarica) {
                            caricaDettaglio(getAtto().id)
                        } else {
                            onChiudi()
                        }
                        self.setVisible(true)
                        wPreviewModelloIstatOpen = Boolean.FALSE
                    })
                    w.doEmbedded()
                } catch (Exception ex) {
                    log.error("Errore apertura form modello istat", ex)
                    wPreviewModelloIstatOpen = Boolean.FALSE
                    throw ex
                }
            }
        }
    }

    ////////////////////////////////////////// AUTORITA /////////////////////////////////////

    @Command void onSelectAutorita(@ContextParam(ContextType.TRIGGER_EVENT) Event event){
        String a = null
        String c = null
        if (event?.target?.selectedItem instanceof Map) {
            a = event.target.selectedItem.AUTORITA
            c = event.target.selectedItem.COMUNE
        }
        datiProvenienza.autorita = a
        if (c){
            datiProvenienza.comune = c
        }
        refreshUi()
    }

    ////////////////////////////////////////// UFFICIALE /////////////////////////////////////

    @Command void onSelectUfficiale(@ContextParam(ContextType.TRIGGER_EVENT) Event event){
        CivUfficiale c = null
        if (event?.target?.selectedItem instanceof CivUfficiale) {
            c = event.target.selectedItem
        }
        datiProvenienza.ufficialeUtente = c?.cognomeNome
        if (c){
            datiProvenienza.qualificaUtente = c.qualifica
        }
        refreshUi()
    }

    ////////////////////////////////////////// QUALIFICA /////////////////////////////////////

    @Command void onSelectQualifica(@ContextParam(ContextType.TRIGGER_EVENT) Event event){
        String q = null
        if (event?.target?.selectedItem instanceof String) {
            q = event.target.selectedItem
        }
        datiProvenienza.qualificaUtente = q
        refreshUi()
    }

    ////////////////////////////////////////// CONSOLATO /////////////////////////////////////

    @Command
    void onSelectConsolato(@ContextParam(ContextType.TRIGGER_EVENT) Event event, @BindingParam("campoRiferimento") String campoRiferimento) {
        AnscConsolato c = null
        if (event?.target?.selectedItem instanceof AnscConsolato) {
            c = event.target.selectedItem
        }
        ETipoConsolato tipoConsolato = ETipoConsolato.valueOf(campoRiferimento)
        switch (tipoConsolato) {
            case ETipoConsolato.PROVENIENZA:
                datiProvenienza.consolato = c
                break
            case ETipoConsolato.AFFISSIONE1:
                margine.consolatoAffisione1 = c
                break
            case ETipoConsolato.AFFISSIONE2:
                margine.consolatoAffisione2 = c
                break
        }
        refreshUi()
    }

    ////////////////////////////////////////// ATTO ////////////////////////////////////////

    @Command void onSelectNatura() {
        Boolean tipoOk = civTipoAttoService.checkTipoAttoAndParteAndSerieAndNatura(getAtto(), getAtto().tipoAttoDomain?.categoriaDomain)
        if (!tipoOk){
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Errore_natura_vs_tipo_atto")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    @Command void onSelectNumera(){
        if (tipoOperazione.isUpdate() && ( !( getAtto().isProvvisorio() ) ) ){
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Errore_Operazione_non_consentita")), msgTitle, Messagebox.OK, Messagebox.ERROR)
            onChiudi()
        } else {
            if (getAtto().isCodRec0()){
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Errore_Operazione_non_consentita")), msgTitle, Messagebox.OK, Messagebox.ERROR)
                onChiudi()
                return
            }
            if (tipoOperazione.isInsert()){
                numera()
            } else {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Ask_Numerazione_Record")), msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                        new org.zkoss.zk.ui.event.EventListener(){
                            void onEvent(Event e){
                                if (Messagebox.ON_OK.equals(e.getName())){
                                    Integer annoCorrente = new Integer (Calendar.getInstance().get(Calendar.YEAR))
                                    if (annoCorrente.compareTo(getAtto().anno) != 0){
                                        getAtto().anno = annoCorrente
                                    }
                                    numera()
                                    if (getAtto().hasMargine() && (margine?.tipoMargineLaterale != null) && getAtto().atto.compareTo(new Integer(0)) > 0 ){
                                        ETipoMargineLaterale tml = civMargineService.getMargineLateraleDefault(getAtto())
                                        if ( (tml != null)  && (tml != margine.tipoMargineLaterale) ){
                                            margine.tipoMargineLaterale = tml
                                            refreshUi()
                                        }
                                    }
                                }
                            }
                        }
                )
            }
        }
    }

    void numera(){}

    abstract CivAttoBaseDomain getAtto()

    protected void cancellaCampoEntita(Object entita, String p){
        if (entita && p) {
            if (p.indexOf(",") >= 0){
                String[] sa = p.split(",")
                for (String s:sa){
                    entita."$s" = null
                }
            } else {
                if (p.indexOf(".") >= 0){
                    List<String> sa = p.tokenize(".")
                    String sa0 = sa[0]
                    String sa1 = sa[1]
                    entita."$sa0"?."$sa1" = null
                } else {
                    entita."$p" = null
                }
            }
            refreshUi()
        }
    }

    @Command void onCancellaCampoAtto(@ContextParam(ContextType.TRIGGER_EVENT) Event e, @BindingParam("campoAnagrafe") String campoAnagrafe){
        log.info("Sto lavorando su " + (campoAnagrafe?:"--"))
        String p = e?.target?.getAttribute("proprieta")
        cancellaCampoEntita(getAtto(), p)
    }

    @Command void onCancellaCampoProvenienza(@ContextParam(ContextType.TRIGGER_EVENT) Event e){
        String p = e?.target?.getAttribute("proprieta")
        cancellaCampoEntita(datiProvenienza, p)
    }

    @Command void onCancellaCampoMargine(@ContextParam(ContextType.TRIGGER_EVENT) Event e){
        String p = e?.target?.getAttribute("proprieta")
        cancellaCampoEntita(margine, p)
    }

    @Command void onCancellaCampoDocumentoPubblicazione(@ContextParam(ContextType.TRIGGER_EVENT) Event e){
        String p = e?.target?.getAttribute("proprieta")
        cancellaCampoEntita(documentoPubblicazione, p)
    }

    protected void aggiornaCaseEntita(Object entita, String p){
        if (p) {
            Boolean upper = (!(minuscole[p]))
            if (upper) {
                if (entita.hasProperty("minuscoleProperties")){
                    Map<String, String> mp = entita.minuscoleProperties
                    String mpProp = mp.get(p)
                    if (mpProp){
                        entita."$mpProp" = entita."$mpProp"?.toUpperCase()
                    }
                } else {
                    entita."$p" = entita."$p"?.toUpperCase()
                }
            }
            refreshUi()
        }
    }

    @Command void onAggiornaCase(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        String p = e?.target?.getAttribute("proprieta")
        aggiornaCaseEntita(getAtto(), p)
    }

    @Command void onAggiornaCaseDatiProvenienza(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        String p = e?.target?.getAttribute("proprieta")
        aggiornaCaseEntita(datiProvenienza, p)
    }

    Boolean isUserModifyEnabled(){
        //FIXME competenze
        //return competenzaService.hasRuolo(ConfigurazioneUtils.RUOLO_CIV_SU)
        return true
    }

    @Command void onSalvaRecord() {
        if (getAtto().natura == ENaturaAtto.N){
            annullaAtto()
        } else {
            Boolean alertOn = arcParametroService.isSegnalazioneModificaAttoAttiva()
            salvaAtto(alertOn)
        }
    }

    abstract protected void salvaAtto(Boolean showAlert=Boolean.TRUE, EGestioneConsolidamento gc=null)

    abstract void eliminaAtto()

    @Command void onEliminaRecord() {
        if (userModifyEnabled) {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Ask_Cancellazione_Record")), msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                    new org.zkoss.zk.ui.event.EventListener() {
                        void onEvent(Event e) {
                            if (Messagebox.ON_OK.equals(e.getName())) {
                                eliminaAtto()
                                onChiudi()
                            }
                        }
                    }
            )
        }
    }

    void annullaAtto(){
        Messagebox.show(getEtichetta(Etichette.getEtichetta("Ask_Annullamento_Atto")), msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                new org.zkoss.zk.ui.event.EventListener(){
                    void onEvent(Event e){
                        if (Messagebox.ON_OK.equals(e.getName())){
                            salvaAtto(Boolean.FALSE, EGestioneConsolidamento.ANNULLAMENTO)
                            onChiudi()
                        }
                    }
                }
        )
    }

    void bloccaAtto(){
        Messagebox.show(getEtichetta(Etichette.getEtichetta("Ask_Blocco_Atto")), msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                new org.zkoss.zk.ui.event.EventListener(){
                    void onEvent(Event e){
                        if (Messagebox.ON_OK.equals(e.getName())){
                            salvaAtto(Boolean.FALSE, EGestioneConsolidamento.BLOCCO)
                            onChiudi()
                        }
                    }
                }
        )
    }

    void selezionaConsolidamentoAtto(EGestioneConsolidamento gcConsolidamento, EGestioneConsolidamento gcBlocco){
        Messagebox.Button[] buttons = [Messagebox.Button.YES, Messagebox.Button.NO, Messagebox.Button.CANCEL] as Messagebox.Button[]
        String[] buttonsLabel = [getEtichetta(Etichette.getEtichetta("Consolida")), getEtichetta(Etichette.getEtichetta("Blocca")), getEtichetta(Etichette.getEtichetta("Annulla"))] as String[]
        Messagebox.show(getEtichetta(Etichette.getEtichetta("Ask_Chiusura_Atto")), msgTitle, buttons, buttonsLabel , Messagebox.QUESTION, null,
                new org.zkoss.zk.ui.event.EventListener(){
                    void onEvent(Event e){
                        if (Messagebox.ON_YES.equals(e.getName())){
                            consolidaAtto(gcConsolidamento)
                        } else if (Messagebox.ON_NO.equals(e.getName())){
                            consolidaAtto(gcBlocco)
                        }
                    }
                }
        )
    }

    void consolidaAtto (EGestioneConsolidamento gc){
        log.info ("punto di estensione solo per atti in inserimento: gestione consolidamento di tipo " + (gc?.name()?:"nullo") )
    }

    void checkComunicazioniDaAnnotazione(){
        List<CivArchivioComunicazione> ll = (civArchivioComunicazioneService.listAllComunicazioniDaAnnotazioneByUkAtto(getAtto(), datiProvenienza, null)?:[])
        if (ll.size() > 0){
            if (anscOn){
                Messagebox.show("Attenzione! Sono presenti nuove comunicazioni automatiche da elaborare", msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            } else {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Ask_Comunicazioni_Atto")), msgTitle, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                        new org.zkoss.zk.ui.event.EventListener() {
                            void onEvent(Event e) {
                                if (Messagebox.ON_YES.equals(e.getName())) {
                                    onChiudi()
                                }
                            }
                        }
                )
            }
        } else {
            if (!anscOn){
                onChiudi()
            }
        }
    }

    String getAttoSclass() {
        return ( (getAtto()?.getBloccato() || ( (getAtto()?.natura == ENaturaAtto.N) && getAtto().isCodRec0()) )?"grassettoRedText":"formTitle")
    }

    @Command void onAttivaComposizioneStandard() {
        if (getAtto().isCodRec3()){
            statoFrammenti = 1
            salvaAtto(Boolean.FALSE)
        }
    }

    @Command void onAttivaComposizionePregresso() {
        if (composizioneTestoAttiva && (getAtto().natura != ENaturaAtto.N)) {
            statoFrammenti = 1
            salvaAtto(Boolean.FALSE)
        }
    }

    /////////////////////////////////// ANNOTAZIONI A SEGUITO DI ATTO /////////////////////////////////////

    abstract List<ETipoFormulaAnnotazioneDaAtto> getChiaviAnnotazioni()

    abstract IEstremiAttoNascitaSoggettiDomain getEstremiAttoNascitaDomain()

    abstract IEstremiAttoMatrimonioDomain getEstremiAttoMatrimonioDomain()

    abstract Boolean isCaricamentoFormuleAnnotazioneAbilitato()

    abstract Boolean isCaricamentoAnnotazioniAbilitato()

    void caricaListaAnnotazioniDaAtto(){
        mapAnnotazioniDaAtto = [:]
        if ( isCaricamentoAnnotazioniAbilitato() ){
            List<CivAnnotazioneTestoLibero> latl = civAnnotazioneTestoLiberoService.listAllByUkAttoAndTipoAttoAndTipoFormulaIn(getAtto().idAtto, getAtto().getTipoAttoEnum(), getChiaviAnnotazioni())
            for (CivAnnotazioneTestoLibero a:latl){
                mapAnnotazioniDaAtto[a.tipoFormula.name()] = a
            }
            // Provo a popolare le annotazioni non ancora valorizzate
            for (ETipoFormulaAnnotazioneDaAtto chiave : getChiaviAnnotazioni()){
                searchAnnotazioneDefault(chiave, Boolean.FALSE)
            }
        }
    }

    void searchAnnotazioneDefault(ETipoFormulaAnnotazioneDaAtto chiave, Boolean forceSave) {
        if ( isCaricamentoAnnotazioniAbilitato() ){
            CivAnnotazioneTestoLibero ann = mapAnnotazioniDaAtto[chiave.name()]
            if (ann == null){
                ann = new CivAnnotazioneTestoLibero(tipoFormula: chiave, sequenza: chiave.sequenza)
                DomainUtils.initFromAtto(ann, getAtto())
                mapAnnotazioniDaAtto[chiave.name()] = ann
            }
            if ( ( (ann.testo?:"") == "") || forceSave ){
                switch (ann.tipoFormula) {
                    case ETipoFormulaAnnotazioneDaAtto.NAS_1:
                        ann.formula = datiProvenienza.formulaDfaAnnotazioneNascita1
                        try {
                            IEstremiAttoNascitaSoggetto1Domain ead1 = (IEstremiAttoNascitaSoggetto1Domain)getEstremiAttoNascitaDomain()
                            ann.testo = civAnnotazioneAttoService.getTestoAnnotazioneSuAttoNascitaSoggetto1(getAtto(), ead1, datiProvenienza)
                        } catch (De4gsdzkRuntimeException ex) {
                            ann.testo = ""
                        }
                        break
                    case ETipoFormulaAnnotazioneDaAtto.NAS_2:
                        ann.formula = datiProvenienza.formulaDfaAnnotazioneNascita2
                        try {
                            IEstremiAttoNascitaSoggetto2Domain ead2 = (IEstremiAttoNascitaSoggetto2Domain)getEstremiAttoNascitaDomain()
                            ann.testo = civAnnotazioneAttoService.getTestoAnnotazioneSuAttoNascitaSoggetto2(getAtto(), ead2, datiProvenienza)
                        } catch (De4gsdzkRuntimeException ex) {
                            ann.testo = ""
                        }
                        break
                    case ETipoFormulaAnnotazioneDaAtto.MAT:
                        ann.formula = datiProvenienza.formulaDfaAnnotazioneMatrimonio
                        try {
                            ann.testo = civAnnotazioneAttoService.getTestoAnnotazioneSuAttoMatrimonio( ((IAttoMatUci)getAtto()), getEstremiAttoMatrimonioDomain(), datiProvenienza)
                        } catch (De4gsdzkRuntimeException ex) {
                            ann.testo = ""
                        }
                        break
                }
            }
            if (forceSave){
                CivAnnotazioneTestoLibero saved = civAnnotazioneTestoLiberoService.save(ann, getAtto().tipoAttoEnum)
                mapAnnotazioniDaAtto[chiave.name()] = saved
            }
            refreshUi()
        }
    }

    private String checkEstremiAttoAnnotazione(ETipoFormulaAnnotazioneDaAtto chiave){
        String errorString = null
        try{
            switch (chiave) {
                case ETipoFormulaAnnotazioneDaAtto.NAS_1:
                    IEstremiAttoNascitaSoggetto1Domain ead1 = (IEstremiAttoNascitaSoggetto1Domain)getEstremiAttoNascitaDomain()
                    civAnnotazioneAttoService.validaDatiAttoNascitaSoggetto1(getAtto(), ead1, datiProvenienza.formulaDfaAnnotazioneNascita1)
                    break
                case ETipoFormulaAnnotazioneDaAtto.NAS_2:
                    IEstremiAttoNascitaSoggetto2Domain ead2 = (IEstremiAttoNascitaSoggetto2Domain)getEstremiAttoNascitaDomain()
                    civAnnotazioneAttoService.validaDatiAttoNascitaSoggetto2(getAtto(), ead2, datiProvenienza.formulaDfaAnnotazioneNascita2)
                    break
                case ETipoFormulaAnnotazioneDaAtto.MAT:
                    civAnnotazioneAttoService.validaDatiAttoMatUci(getAtto(), getEstremiAttoMatrimonioDomain(), datiProvenienza.formulaDfaAnnotazioneMatrimonio)
                    break
            }
        } catch (CampoMandatoryRuntimeException ce) {
            errorString = (getEtichetta(ce.getEtichetta())?:ce.getMessage())
        } catch (De4gsdzkRuntimeException ex) {
            errorString = "Errore in compilazione testo annotazione"
        }
        return errorString
    }

    @Command void onRefreshAllAnnotazioni() {
        if ( isCaricamentoAnnotazioniAbilitato() ){
            Boolean almenoUnaCompleta = Boolean.FALSE
            for (ETipoFormulaAnnotazioneDaAtto tfa : getChiaviAnnotazioni()){
                String s = checkEstremiAttoAnnotazione(tfa)
                if (s) {
                    Messagebox.show(s, msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
                } else {
                    almenoUnaCompleta = Boolean.TRUE
                }
            }
            if (almenoUnaCompleta){
                salvaAtto(Boolean.FALSE)
                for (ETipoFormulaAnnotazioneDaAtto chiave : getChiaviAnnotazioni()){
                    searchAnnotazioneDefault(chiave, Boolean.TRUE)
                }
            }
        }
    }

    @Command void onRefreshAnnotazione(@BindingParam("chiave") String chiave) {
        if ( isCaricamentoAnnotazioniAbilitato() ){
            ETipoFormulaAnnotazioneDaAtto tfa = ETipoFormulaAnnotazioneDaAtto.valueOf(chiave)
            String s = checkEstremiAttoAnnotazione(tfa)
            if (s) {
                Messagebox.show(s, msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            } else {
                salvaAtto(Boolean.FALSE)
                searchAnnotazioneDefault(tfa, Boolean.TRUE)
            }
        }
    }

    @Command void onSelectFormulaAnnotazione(@ContextParam(ContextType.TRIGGER_EVENT) Event e){
        if ( isCaricamentoAnnotazioniAbilitato() ){
            String p = e?.target?.getAttribute("proprieta")
            if (datiProvenienza."$p" == null){
                String tf = e?.target?.getAttribute("tipoFormula")
                CivAnnotazioneTestoLibero ann = mapAnnotazioniDaAtto[tf]
                if (ann){
                    ann.formula = null
                    ann.testo = ""
                    refreshUi()
                }
            }
        }
    }

    @Command void onCancellaFormulaAnnotazione(@ContextParam(ContextType.TRIGGER_EVENT) Event e){
        onCancellaCampoProvenienza(e)
        onSelectFormulaAnnotazione(e)
    }

    String getLabelAnnotazione(ETipoFormulaAnnotazioneDaAtto tipoFormula){
        Map<String, String> ec = FormUtils.getAttoCustomLabels(getAtto().tipoAttoEnum, etichette)
        String s = ec.get(tipoFormula.name())
        if ((getAtto().tipoAttoEnum == ETipoAtto.UCI) &&
            (tipoFormula == ETipoFormulaAnnotazioneDaAtto.MAT) &&
            ((CivUnioneCivile) getAtto()).isUnioneCivileConiugi() ){
            s = getEtichetta(Etichette.getEtichetta("Annotazione_su_atto_matrimonio"))
        }
        return s
    }

    ////////////////////////////////////////// FORMULE /////////////////////////////////////

    abstract List<String> getChiaviFormule()

    protected void caricaFormuleAtto(){
        if ( tipoOperazione.isUpdate() && (statoFrammenti == 2) ){
            mapFormule = [:]
            List<CivFormulaTestoLibero> formule = civFormulaTestoLiberoService.listAllByUkAttoAndTipoAtto(getAtto().idAtto, getAtto().getTipoAtto())
            log.info("Recuperate ${formule.size()} formule per il record ${getAtto().getTipoAttoEnum().name()} con id ${getAtto().id}")
            for (String chiave : getChiaviFormule()){
                mapFormule[chiave] = FormulaUtils.getFormula(formule, chiave)
                // Provo a popolare le formule non ancora valorizzate con i valori di default
                if ( mapFormule[chiave] == null ){
                    searchFormulaDefault(chiave, Boolean.FALSE)
                }
            }
        }
    }

    abstract void searchFormulaDefault(String chiave, Boolean salva)

    @Command void onRefreshAllFormule() {
        salvaAtto(Boolean.FALSE)
        for ( Map.Entry<String, CivFormulaTestoLibero> e : mapFormule ) {
            searchFormulaDefault(e.getKey(), Boolean.TRUE)
        }
    }

    @Command void onRefreshFormula(@BindingParam("chiave") String chiave) {
        if (getChiaviFormule().contains(chiave)){
            salvaAtto()
            searchFormulaDefault(chiave, Boolean.TRUE)
        }
    }

    abstract void searchFormuleFrammento(String chiave)

    @Command void onCaricaFormuleFrammento(@BindingParam("chiave") String chiave) {
        if (getChiaviFormule().contains(chiave)){
            searchFormuleFrammento(chiave)
        }
    }

    protected void creaFormulaDefault(String chiave, Integer richiamo, Map params){
        if ( getChiaviFormule().contains(chiave) && (mapFormule[chiave] == null) ){
            Integer progressivo = null
            if (params.progressivo != null){
                if (params.searchEqual){
                    progressivo = params.progressivo
                }
                if (params.searchGreater){
                    progressivo = new Integer(params.progressivo.intValue() + 1)
                }
            }
            mapFormule[chiave] = new CivFormulaTestoLibero(richiamo : richiamo, progressivo: progressivo)
        }
    }

    //Viene invocata a seguito di selezione da popup o dopo caricamento default
    protected void aggiornaFormulaFrammento(String chiave, List<Map<String, Object>> formule, Boolean salva, Boolean popupSetting=Boolean.TRUE){
        if (getChiaviFormule().contains(chiave)) {
            CivFormulaTestoLibero f = mapFormule[chiave]
            if (f == null) {
                f = new CivFormulaTestoLibero()
            }
            // Se selezionata da popup o se da impostare come default perché unica con default a 'S'
            if (popupSetting || (formule?.size() == 1)) {
                gsdService.aggiornaFormulaFrammento(formule, getAtto(), f)
            }
            mapFormule[chiave] = f
            if (salva) {
                DomainUtils.initFromAtto(f, getAtto())
                mapFormule[chiave] = civFormulaTestoLiberoService.save(f, getAtto().getTipoAttoEnum())
            }
            refreshUi()
        }
    }

    //////////////////////////////// SOGGETTI DA ANNOTARE ///////////////////////////////////

    abstract void onAggiornaAna(String campoAnagrafe)

    // Soggetto 1
    Date dataRiferimentoComuneAttoNascitaSoggetto1

    @Command void onRecuperaEstremiSoggetto1DaAttoDiNascita() {
        if (getAtto() instanceof ISoggettoAtto1) {
            ISoggettoAtto1 sa = (ISoggettoAtto1) getAtto()
            if ( sa.getDataNascita1() && sa.getCognome1()?.trim() && sa.getNome1()?.trim() && sa.getSesso1() ){
                int retVal = recuperaEstremiAttoNascitaSoggetto1DaAttoDiNascita()
                if ( retVal == 0 ){
                    Messagebox.show(getEtichetta(Etichette.getEtichetta("Nessun_record_trovato")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
                }
                if ( retVal == -1 ){
                    Messagebox.show(getEtichetta(Etichette.getEtichetta("Warn_Estremi_Atto_Parziali")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
                }
            } else {
                Map<String, String> ec = FormUtils.getAttoCustomLabels(getAtto().tipoAttoEnum, etichette)
                String s = ec.get('campi_obbligatori_soggetto_1')?:"Compilare i campi obbligatori dell'intestario dell'atto"
                Messagebox.show(s, msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
    }

    protected int recuperaEstremiAttoNascitaSoggetto1DaAttoDiNascita(){
        IEstremiAttoNascitaSoggetto1Domain d = (IEstremiAttoNascitaSoggetto1Domain) getEstremiAttoNascitaDomain()
        if ( (d.getAttoAttoNascita1() == null) && ( d.getParteAttoNascita1() == null ) && (d.getAnnoAttoNascita1() == null) && ( (d.getDescrizioneComuneAttoNascita1()?:"") == "") ){
            CivNascita nascita = civNascitaService.getXDatiAnagraficiSoggetto1(getAtto())
            if (nascita){
                ArcComune comune = gsdService.getComuneCliente()
                if (arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva()) {
                    DomainUtils.initEstremiAttoNascita1FromAttoNascitaNuovaGestioneAnnotazioni(d, nascita, comune)
                } else {
                    DomainUtils.initEstremiAttoNascita1FromAttoNascita(d, nascita, comune)
                }
                aggiornaDatiSupplementariEstremiAttoNascitaSoggetto1DaAttoDiNascita(nascita)
                onAggiornaDataRiferimentoComuneAttoNascitaSoggetto1()
                refreshUi()
                return 1
            } else {
                return 0
            }
        }
        return -1
    }

    void aggiornaDatiSupplementariEstremiAttoNascitaSoggetto1DaAttoDiNascita(CivNascita nascita) {
        // Do Nothing (Implemented in child)
    }

    @Command void onAggiornaDataRiferimentoComuneAttoNascitaAndAnaSoggetto1(@ContextParam(ContextType.TRIGGER_EVENT) Event e, @BindingParam("campoAnagrafe") String campoAnagrafe) {
        onAggiornaDataRiferimentoComuneAttoNascitaSoggetto1()
        onAggiornaAna(campoAnagrafe)
    }

    @Command void onAggiornaDataRiferimentoComuneAttoNascitaSoggetto1(){
        IEstremiAttoNascitaSoggetto1Domain d = (IEstremiAttoNascitaSoggetto1Domain) getEstremiAttoNascitaDomain()
        dataRiferimentoComuneAttoNascitaSoggetto1 = DataUtils.getDataAttoRif(getAtto().getDataNascita1(), d.getAnnoAttoNascita1())
        BindUtils.postNotifyChange(null, null, this, "dataRiferimentoComuneAttoNascitaSoggetto1")
    }

    @Command void onCancellaCampoAttoSoggetto1(@ContextParam(ContextType.TRIGGER_EVENT) Event e, @BindingParam("campoAnagrafe") String campoAnagrafe){
        onCancellaCampoAtto(e, campoAnagrafe)
        onAggiornaDataRiferimentoComuneAttoNascitaSoggetto1()
    }

    // Soggetto 2
    Date dataRiferimentoComuneAttoNascitaSoggetto2

    @Command void onRecuperaEstremiSoggetto2DaAttoDiNascita() {
        if (getAtto() instanceof ISoggettoAtto2){
            ISoggettoAtto2 sa = (ISoggettoAtto2) getAtto()
            if ( sa.getDataNascita2() && sa.getCognome2()?.trim() && sa.getNome2()?.trim() && sa.getSesso2() ){
                int retVal = recuperaEstremiAttoNascitaSoggetto2DaAttoDiNascita()
                if ( retVal == 0 ){
                    Messagebox.show(getEtichetta(Etichette.getEtichetta("Nessun_record_trovato")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
                }
                if ( retVal == -1 ){
                    Messagebox.show(getEtichetta(Etichette.getEtichetta("Warn_Estremi_Atto_Parziali")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
                }
            } else {
                Map<String, String> ec = FormUtils.getAttoCustomLabels(getAtto().tipoAttoEnum, etichette)
                String s = ec.get('campi_obbligatori_soggetto_2')?:"Compilare i campi obbligatori degli intestari dell'atto"
                Messagebox.show(s, msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
    }

    protected int recuperaEstremiAttoNascitaSoggetto2DaAttoDiNascita(){
        IEstremiAttoNascitaSoggetto2Domain d = (IEstremiAttoNascitaSoggetto2Domain) getEstremiAttoNascitaDomain()
        if ( (d.getAttoAttoNascita2() == null) && ( d.getParteAttoNascita2() == null ) && (d.getAnnoAttoNascita2() == null) && ( (d.getDescrizioneComuneAttoNascita2()?:"") == "") ){
            CivNascita nascita = civNascitaService.getXDatiAnagraficiSoggetto2(getAtto())
            if (nascita){
                ArcComune comune = gsdService.getComuneCliente()
                if (arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva()) {
                    DomainUtils.initEstremiAttoNascita2FromAttoNascitaNuovaGestioneAnnotazioni(d, nascita, comune)
                } else {
                    DomainUtils.initEstremiAttoNascita2FromAttoNascita(d, nascita, comune)
                }
                onAggiornaDataRiferimentoComuneAttoNascitaSoggetto2()
                refreshUi()
                return 1
            } else {
                return 0
            }
        }
        return -1
    }

    @Command void onAggiornaDataRiferimentoComuneAttoNascitaAndAnaSoggetto2(@ContextParam(ContextType.TRIGGER_EVENT) Event e, @BindingParam("campoAnagrafe") String campoAnagrafe) {
        onAggiornaDataRiferimentoComuneAttoNascitaSoggetto2()
        onAggiornaAna(campoAnagrafe)
    }

    @Command void onAggiornaDataRiferimentoComuneAttoNascitaSoggetto2(){
        IEstremiAttoNascitaSoggetto2Domain d = (IEstremiAttoNascitaSoggetto2Domain) getEstremiAttoNascitaDomain()
        dataRiferimentoComuneAttoNascitaSoggetto2 = DataUtils.getDataAttoRif(getAtto().getDataNascita2(), d.getAnnoAttoNascita2())
        BindUtils.postNotifyChange(null, null, this, "dataRiferimentoComuneAttoNascitaSoggetto2")
    }

    @Command void onCancellaCampoAttoSoggetto2(@ContextParam(ContextType.TRIGGER_EVENT) Event e, @BindingParam("campoAnagrafe") String campoAnagrafe){
        onCancellaCampoAtto(e, campoAnagrafe)
        onAggiornaDataRiferimentoComuneAttoNascitaSoggetto2()
    }

    @Command void onSelectFirmatario(){
        BindUtils.postNotifyChange(null, null, this, "datiProvenienza")
    }

    protected Map getDCFItem(Enum tdn){
        return [label:getEtichettaEnum(tdn), value: tdn.name() ]
    }

    void updateStateHash() {
        CivAttoBaseDomain atto = getAtto()

        attoStateHash = atto != null ? HashUtils.computeStateHash(atto) : null
        dpaStateHash = datiProvenienza != null ? HashUtils.computeStateHash(datiProvenienza) : null
        margineStateHash = margine != null ? HashUtils.computeStateHash(margine) : null
    }

    boolean hasStateHashChanged() {
        return hasAttoStateHashChanged() ||
                dpaStateHash != HashUtils.computeStateHash(datiProvenienza) ||
                margineStateHash != HashUtils.computeStateHash(margine)
    }

    boolean hasAttoStateHashChanged() {
        return attoStateHash != HashUtils.computeStateHash(getAtto())
    }

    private void askModificheInSospeso(String title, Closure onSuccess) {
        if (hasStateHashChanged()) {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Ask_Modifiche_In_Sospeso")), title, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                    new EventListener() {
                        void onEvent(Event e) {
                            if (Messagebox.ON_YES.equals(e.getName())) {
                                onSuccess.call()
                            }
                        }
                    }
            )
        } else {
            onSuccess.call()
        }
    }

    protected void askStoricizzazione(ISalvaAttoOperation operation) {
        if (tipoOperazione.isUpdate() && getAtto().isCodRec0() && hasAttoStateHashChanged()) {
            Messagebox.show("Vuoi storicizzare la versione precedente?", msgTitle, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                    { Event e ->
                        try {
                            if (Messagebox.ON_YES == e.getName()) {
                                storicizzaAtto(getAtto().id)
                                operation.execute(true)
                            } else {
                                operation.execute(false)
                            }
                        } catch (Exception ex) {
                            // Chiude la messagebox corrente prima di rilanciare l'eccezione
                            e.getTarget().detach()
                            throw ex
                        }

                    })
        } else {
            operation.execute(false)
        }
    }

    @Command
    void onOpenCaratteriSpeciali() {
        Window w = (Window) Executions.createComponents("/restrict/gestioneCaratteriSpeciali.zul", self, [gruppo: EGruppo.CIV, dettaglio: dettaglio])
        w.doModal()
    }

    abstract GsdBaseDomain getDettaglio()

    abstract void storicizzaAtto(Long pkAtto)

    ////////////////////////////////////////// GENERALI /////////////////////////////////////

    static List<Map> etichetteAttoDettaglioDefault = [Etichette.getEtichetta("ATTO_ANNULLATO"), Etichette.getEtichetta("ATTO_BLOCCATO"), Etichette.getEtichetta("ATTO_IN_INSERIMENTO"),
                                                      Etichette.getEtichetta("ATTO_PREGRESSO_IN_INSERIMENTO"), Etichette.getEtichetta("ATTO_CONSOLIDATO"), Etichette.getEtichetta("Provvisorio"),
                                                      Etichette.getEtichetta("Consolida"), Etichette.getEtichetta("Blocca"), Etichette.getEtichetta("Annulla"), Etichette.getEtichetta("Cancella"), Etichette.getEtichetta("Fascicolo"),
                                                      Etichette.getEtichetta("Chiudi_atto"), Etichette.getEtichetta("Blocca_atto"), Etichette.getEtichetta("Preview"), Etichette.getEtichetta("ANSC"),
                                                      Etichette.getEtichetta("Numera"), Etichette.getEtichetta("Imprecisati"), Etichette.getEtichetta("Giorno"), Etichette.getEtichetta("Mese"), Etichette.getEtichetta("Nel"),
                                                      Etichette.getEtichetta("Testata"), Etichette.getEtichetta("Testata_Trascrizione"), Etichette.getEtichetta("Chiusura"), Etichette.getEtichetta("Testo_Libero"), Etichette.getEtichetta("Testo_Libero_placeholder"), Etichette.getEtichetta("Firma"),
                                                      Etichette.getEtichetta("Seleziona_Formula"), Etichette.getEtichetta("Aggiorna_Formula"), Etichette.getEtichetta("Aggiorna_Formule"),
                                                      Etichette.getEtichetta("Nessun_record_trovato"), Etichette.getEtichetta("Minuscole"), Etichette.getEtichetta("Seleziona"), Etichette.getEtichetta("Annotazioni"), Etichette.getEtichetta("Comunicazioni"),
                                                      Etichette.getEtichetta("Attiva_Composizione"), Etichette.getEtichetta("Accedi_Composizione"), Etichette.getEtichetta("Apri"), Etichette.getEtichetta("Rigenera"),
                                                      Etichette.getEtichetta("Dati_Redazione"), Etichette.getEtichetta("Data"), Etichette.getEtichetta("Riepilogo_Atto"), Etichette.getEtichetta("Margine"),
                                                      Etichette.getEtichetta("Calcolo_Codice_Fiscale"), Etichette.getEtichetta("Non_Validato"),
                                                      Etichette.getEtichetta("Estremi_Atto_Nascita"), Etichette.getEtichetta("Estremi_Atto_Nascita_Sposo"), Etichette.getEtichetta("Estremi_Atto_Nascita_Sposa"),
                                                      Etichette.getEtichetta("Estremi_Atto_Nascita_Contraente_1"), Etichette.getEtichetta("Estremi_Atto_Nascita_Contraente_2"), Etichette.getEtichetta("Recupera_Estremi_Atto_Nascita"),
                                                      Etichette.getEtichetta("Annotazione_su_atto_nascita_sposo"), Etichette.getEtichetta("Annotazione_su_atto_nascita_sposa"),
                                                      Etichette.getEtichetta("Annotazione_su_atto_nascita_intestatario"), Etichette.getEtichetta("Annotazione_su_atto_nascita_deceduto"),
                                                      Etichette.getEtichetta("Annotazione_su_atto_nascita_contraente_1"), Etichette.getEtichetta("Annotazione_su_atto_nascita_contraente_2"),
                                                      Etichette.getEtichetta("Annotazione_su_atto_matrimonio"), Etichette.getEtichetta("Annotazione_su_atto_unione_civile"),
                                                      Etichette.getEtichetta("Ask_Comunicazioni_Atto"), Etichette.getEtichetta("Ask_Cancellazione_Record"), Etichette.getEtichetta("Ask_Aggiornamento_Testo"),
                                                      Etichette.getEtichetta("Ask_Blocco_Atto"), Etichette.getEtichetta("Ask_Chiusura_Atto"), Etichette.getEtichetta("Ask_Annullamento_Atto"),
                                                      Etichette.getEtichetta("Ask_Numerazione_Record"), Etichette.getEtichetta("Ask_Collegamento_Anagrafe"), Etichette.getEtichetta("Ask_Nuova_Ricerca_Anagrafe"),
                                                      Etichette.getEtichetta("Warn_Estremi_Atto_Parziali"), Etichette.getEtichetta("Warn_Aggiornamento_Formule"), Etichette.getEtichetta("CIA_fascicolata"),
                                                      Etichette.getEtichetta("Compilare_campi_obbligatori_atto"), Etichette.getEtichetta("Compilare_campi_cf"),
                                                      Etichette.getEtichetta("Compilare_campi_obbligatori_nato"), Etichette.getEtichetta("Compilare_campi_obbligatori_sposo"), Etichette.getEtichetta("Compilare_campi_obbligatori_sposa"),
                                                      Etichette.getEtichetta("Compilare_campi_obbligatori_deceduto_a"), Etichette.getEtichetta("Compilare_campi_obbligatori_intestatario"),
                                                      Etichette.getEtichetta("Compilare_campi_obbligatori_contraente_1"), Etichette.getEtichetta("Compilare_campi_obbligatori_contraente_2"),
                                                      Etichette.getEtichetta("Compilare_campi_obbligatori_atto_nascita_sposo"), Etichette.getEtichetta("Compilare_campi_obbligatori_atto_nascita_sposa"),
                                                      Etichette.getEtichetta("Compilare_campi_obbligatori_atto_nascita_deceduto_a"), Etichette.getEtichetta("Compilare_campi_obbligatori_atto_nascita_intestatario"),
                                                      Etichette.getEtichetta("Compilare_campi_obbligatori_atto_nascita_contraente_1"), Etichette.getEtichetta("Compilare_campi_obbligatori_atto_nascita_contraente_2"),
                                                      Etichette.getEtichetta("Compilare_campi_obbligatori_atto_unione_civile"), Etichette.getEtichetta("Compilare_campi_obbligatori_atto_matrimonio"),
                                                      Etichette.getEtichetta("Errore_natura_vs_tipo_atto"), Etichette.getEtichetta("Errore_caricamento_formule"), Etichette.getEtichetta("Errore_Competenze_Ufficio_Utente"),
                                                      Etichette.getEtichetta("Errore_apertura_record"), Etichette.getEtichetta("Errore_testo_atto"), Etichette.getEtichetta("Errore_Operazione_non_consentita"),
                                                      Etichette.getEtichetta("Errore_no_tipo_documento_fascicolazione_CIA"), Etichette.getEtichetta("Errore_fascicolazione_CIA")]

}