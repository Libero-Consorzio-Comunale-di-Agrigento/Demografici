package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.*
import it.finmatica.de4gsdzk.anagrafe.AnaNazionalita
import it.finmatica.de4gsdzk.anagrafe.AnaNazionalitaService
import it.finmatica.de4gsdzk.errors.ErroreCaricamentoDatiRuntimeException
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarDettaglioAttributes
import org.zkoss.bind.annotation.BindingParam
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import restrict.AbstractDettaglioViewModel
import restrict.TraitCancellazioneCampi
import restrict.TraitComune

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
abstract class IstatDettaglioParentViewModel extends AbstractDettaglioViewModel implements TraitCancellazioneCampi, TraitComune {

    IstBaseDomain dettaglio

    CivAttoBaseDomain atto

    ETipoAtto tipoAttoEnum
    String tipoAttoLabel = ""

    List<ArchivioIstat> listaSesso = []

    List<AnaNazionalita> listaNazionalita = []

    List<ArchivioIstat> listaStatoCivileM = []
    List<ArchivioIstat> listaStatoCivileF = []
    List<ArchivioIstat> listaStatoCivile1 = []
    List<ArchivioIstat> listaStatoCivile2 = []

    List<ArchivioIstat> listaGradoIstruzione = []
    List<ArchivioIstat> listaPosizioneProfessione = []
    List<ArchivioIstat> listaPosizioneProfessioneSC = []
    List<ArchivioIstat> listaCondizioneProfessionale = []
    List<ArchivioIstat> listaCondizioneProfessionaleSC = []
    List<ArchivioIstat> listaRamoAttivita = []
    List<ArchivioIstat> listaRito = []
    List<ArchivioIstat> listaRegimePatrimoniale = []
    List<ArchivioIstat> listaTipoCittadinanza = []

    List<ArchivioIstat> listaTipiAccordoMatrimonio = []
    List<ArchivioIstat> listaTipiAccordoScioglimentoUci = []
    List<ArchivioIstat> listaCauseScioglimento = []
    List<ArchivioIstat> listaAssegnamentoAbitazione = []
    List<ArchivioIstat> listaSostentamentoConiuge = []
    List<ArchivioIstat> listaSostentamentoConiugeChi = []
    List<ArchivioIstat> listaPresenzaFigli = []
    List<ArchivioIstat> listaTitoliStudio = []
    List<ArchivioIstat> listaTipoAffidamento = []
    List<ArchivioIstat> listaTipoMantenimentoFigli = []
    List<ArchivioIstat> listaSostentamentoFigliChi = []
    List<ArchivioIstat> listaTipoMantenimentoFigliMaggiorenni = []
    List<ArchivioIstat> listaTipoProvvedimentoDivorzio = []
    List<ArchivioIstat> listaTipoProvvedimentoScioglimento = []
    List<ArchivioIstat> listaTipoProvvedimento = []
    List<ArchivioIstat> listaTipoProcedura = []

    ETipoModelloIstat tipoModelloIstat

    @Delegate
    ControlBarDettaglioAttributes cbDettaglio = new ControlBarDettaglioAttributes()

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @WireVariable
    private AnaNazionalitaService anaNazionalitaService

    @WireVariable
    private StatoCivileService statoCivileService

    @WireVariable
    private CivAttoService civAttoService

    @WireVariable
    private IstService istService

    void doInit(List<Map<String, String>> eList, ETipoAtto tipoAttoEnum, ETipoModelloIstat tipoModelloIstat, Map<String, String> msgTitleLabel) {

        this.tipoAttoEnum = tipoAttoEnum
        this.tipoModelloIstat = tipoModelloIstat

        eList.addAll(etichetteDettaglioDefault)

        eList.addAll(IstBaseDomain.etichetteDomain)

        eList.addAll([Etichette.Provvisorio, Etichette.Atto_Divorzio, Etichette.Atto_Scioglimento,
                      Etichette.Calcolo_Codice_Fiscale])
        // Aggiungo messaggi
        eList.addAll([EtichetteMessaggi.Compilare_campi_cf, EtichetteMessaggi.Ask_Conferma_Salvataggio])

        // Aggiungo etichette sesso
        eList.addAll(Arrays.asList(ESesso.values())*.etichettaDesc)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarDettaglioAttributes.etichetteCbDettaglioDesc)

        // Aggiungo etichette tipo atto
        eList.addAll(Arrays.asList(ETipoAtto.values())*.etichettaDesc)

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        etichetteCustom = FormUtils.getAttoCustomLabels(tipoAttoEnum, etichette)

        msgTitle = getEtichetta(msgTitleLabel)

        formLabel = msgTitle?.toUpperCase()
    }

    void creaDettaglio(Map params) {
        log.info("Parametri (e metodo) non gestiti per i modelli ISTAT " + params?.size())
    }

    void caricaDettaglio(def id) {
        if (id != null){
            dettaglio = istService.get(tipoAttoEnum, tipoModelloIstat, id)
        } else {
            dettaglio = istService.getByUkAtto(tipoAttoEnum, tipoModelloIstat, atto.idAtto)
        }
        refreshUi()
    }

    @Command void onSalvaRecord() {
        if (dettaglio) {
            try{
                salvaModello()
            } catch (ErroreCaricamentoDatiRuntimeException dre){
                Messagebox.show(dre.getMessage() + "\n" + getEtichetta(EtichetteMessaggi.Ask_Conferma_Salvataggio), msgTitle, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                    new org.zkoss.zk.ui.event.EventListener() {
                        void onEvent(Event e) {
                            if (Messagebox.ON_YES == e.getName()) {
                                salvaModello(true)
                            }
                        }
                    }
                )
            }
        }
    }

    void salvaModello(boolean force=false) {
        IstBaseDomain c = istService.save(tipoAttoEnum, tipoModelloIstat, dettaglio, atto.id, force)
        Messagebox.show(getEtichetta(EtichetteMessaggi.Salvataggio_Completato), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
        caricaDettaglio(c.id)
    }

    void caricaAtto(ETipoAtto tipoAttoEnum, Long pkAtto, Map params) {
        atto = civAttoService.getAtto(tipoAttoEnum, pkAtto, params)
        tipoAttoLabel = getEtichettaEnum(tipoAttoEnum)
        if ( (atto instanceof IAttoMatUci) && ( ((IAttoMatUci)atto).divorzio) ){
            tipoAttoLabel = etichetteCustom.get("AttoDivorzio")
        }
    }

    void caricaListaNazionalita() {
        listaNazionalita = [null]
        List<AnaNazionalita> l = anaNazionalitaService.listAll()
        if (l.size() > 0) {
            listaNazionalita.addAll(l)
        }
    }

    List<Long> caricaListaIdModelliDaAnnotazione(Long idAnnotazione){
        return istService.listAllIdByIdAnnotazione(tipoAttoEnum, tipoModelloIstat, idAnnotazione)
    }

    List<ArchivioIstat> caricaListeArchivi(String viewName, Integer anno){
        listaGradoIstruzione = [null]
        listaPosizioneProfessione = [null]
        listaPosizioneProfessioneSC = []
        listaCondizioneProfessionale = [null]
        listaCondizioneProfessionaleSC = []
        listaRamoAttivita = [null]
        listaRito = []
        listaRegimePatrimoniale = []
        listaTipoCittadinanza = []
        listaStatoCivileM = [null]
        listaStatoCivileF = [null]
        listaTipiAccordoMatrimonio = []
        listaTipiAccordoScioglimentoUci = []
        listaAssegnamentoAbitazione = []
        listaCauseScioglimento = []
        listaSostentamentoConiuge = []
        listaSostentamentoConiugeChi = []
        listaPresenzaFigli = []
        listaTitoliStudio = []
        listaTipoAffidamento = []
        listaTipoMantenimentoFigli = [null]
        listaSostentamentoFigliChi = [null]
        listaTipoMantenimentoFigliMaggiorenni = [null]
        listaTipoProvvedimentoDivorzio = []
        listaTipoProvvedimentoScioglimento = []
        listaTipoProcedura = []
        listaSesso = [null]

        List<ArchivioIstat> l = statoCivileService.listArchivioIstat(viewName, anno)
        for (ArchivioIstat m:l){
            switch (m.archivioIstat) {
                case ETipoArchivioIstat.GDI:
                    listaGradoIstruzione.add(m)
                    break
                case ETipoArchivioIstat.PNP:
                    listaPosizioneProfessione.add(m)
                    break
                case ETipoArchivioIstat.CNP:
                    listaCondizioneProfessionale.add(m)
                    break
                case ETipoArchivioIstat.RDA:
                    listaRamoAttivita.add(m)
                    break
                case ETipoArchivioIstat.RDM:
                    listaRito.add(m)
                    break
                case ETipoArchivioIstat.RPA:
                    listaRegimePatrimoniale.add(m)
                    break
                case ETipoArchivioIstat.TCI:
                    listaTipoCittadinanza.add(m)
                    break
                case ETipoArchivioIstat.SCM:
                    listaStatoCivileM.add(m)
                    break
                case ETipoArchivioIstat.SCF:
                    listaStatoCivileF.add(m)
                    break
                case ETipoArchivioIstat.TAC:
                    listaTipiAccordoMatrimonio.add(m)
                    break
                case ETipoArchivioIstat.TAS:
                    listaTipiAccordoScioglimentoUci.add(m)
                    break
                case ETipoArchivioIstat.CDI:
                    listaCauseScioglimento.add(m)
                    break
                case ETipoArchivioIstat.ABI:
                    listaAssegnamentoAbitazione.add(m)
                    break
                case ETipoArchivioIstat.SCN:
                    listaSostentamentoConiuge.add(m)
                    break
                case ETipoArchivioIstat.CCN:
                    listaSostentamentoConiugeChi.add(m)
                    break
                case ETipoArchivioIstat.PFG:
                    listaPresenzaFigli.add(m)
                    break
                case ETipoArchivioIstat.TST:
                    listaTitoliStudio.add(m)
                    break
                case ETipoArchivioIstat.PSC:
                    listaPosizioneProfessioneSC.add(m)
                    break
                case ETipoArchivioIstat.CSC:
                    listaCondizioneProfessionaleSC.add(m)
                    break
                case ETipoArchivioIstat.TAF:
                    listaTipoAffidamento.add(m)
                    break
                case ETipoArchivioIstat.MFG:
                    listaTipoMantenimentoFigli.add(m)
                    break
                case ETipoArchivioIstat.CFG:
                    listaSostentamentoFigliChi.add(m)
                    break
                case ETipoArchivioIstat.MFM:
                    listaTipoMantenimentoFigliMaggiorenni.add(m)
                    break
                case ETipoArchivioIstat.PRO:
                    listaTipoProvvedimentoDivorzio.add(m)
                    break
                case ETipoArchivioIstat.PRS:
                    listaTipoProvvedimentoScioglimento.add(m)
                    break
                case ETipoArchivioIstat.SEX:
                    listaSesso.add(m)
                    break
                case ETipoArchivioIstat.TPR:
                    listaTipoProcedura.add(m)
                    break
            }
        }
        return l
    }

    protected void caricaListeStatoCivile() {
        listaStatoCivile1 = []
        listaStatoCivile2 = []
        if ( (atto instanceof CivNascita) || (atto instanceof CivMatrimonio) || (atto instanceof CivPubblicazione) ){
            listaStatoCivile1 = listaStatoCivileM
            listaStatoCivile2 = listaStatoCivileF
        }
        if ( (atto instanceof CivMorte) || (atto instanceof CivUnioneCivile) || (atto instanceof CivProcessoVerbale) ){
            if (((ISoggettoAtto1)atto).sesso1 == ESesso.M){
                listaStatoCivile1 = listaStatoCivileM
                listaStatoCivile2 = listaStatoCivileM
            }
            if (((ISoggettoAtto1)atto).sesso1 == ESesso.F){
                listaStatoCivile1 = listaStatoCivileF
                listaStatoCivile2 = listaStatoCivileF
            }
        }
    }

    protected void caricaListaTipoProvvedimento(){
        listaTipoProvvedimento = []
        if (atto instanceof CivMatrimonio){
            listaTipoProvvedimento = listaTipoProvvedimentoDivorzio
        }
        if (atto instanceof CivUnioneCivile){
            listaTipoProvvedimento = listaTipoProvvedimentoScioglimento
        }
    }

    @Command void onCancellaCampoIstat(@ContextParam(ContextType.TRIGGER_EVENT) Event e){
        onCancellaCampo(e)
    }

    void selezionaComune(ETipoComuneAtto tca, ArcComuneBaseDomain c){
        switch (tca) {
            case ETipoComuneAtto.CR_SOGG_1:
                riempiComune(dettaglio.comuneResidenza1, c)
                break
            case ETipoComuneAtto.CR_SOGG_2:
                riempiComune(dettaglio.comuneResidenza2, c)
                break
            case ETipoComuneAtto.CC_MATR:
                if (dettaglio instanceof IstMscMsuBaseDomain) {
                    riempiComune(dettaglio.comuneMatUci, c)
                }
                break
            case ETipoComuneAtto.CR_MADRE:
                if (dettaglio instanceof IstMd4Bis) {
                    riempiComune(((IstMd4Bis) dettaglio).comuneResidenzaMadre, c)
                }
                break
            case ETipoComuneAtto.CA_AVV1:
                if (dettaglio instanceof IstMscDivorzio) {
                    riempiComune(((IstMscDivorzio) dettaglio).comuneAlboAvvocato1, c)
                }
                break
            case ETipoComuneAtto.CA_AVV2:
                if (dettaglio instanceof IstMscDivorzio) {
                    riempiComune(((IstMscDivorzio) dettaglio).comuneAlboAvvocato2, c)
                }
                break
            case ETipoComuneAtto.CC_TRIB:
                if (dettaglio instanceof IstMscMsuBaseDomain) {
                    riempiComune(((IstMscMsuBaseDomain) dettaglio).comuneTribCda, c)
                }
                break
        }
    }

    @Command void onChiudi () {
        Integer codiceRecord = civAttoService.getCodiceRecord(tipoAttoEnum, atto.id)
        Events.postEvent(Events.ON_CLOSE, self, [ricarica:( (codiceRecord != null) && (codiceRecord?.intValue() == 3) ) ])
    }

    @Command void onCalcolaCf(@BindingParam("tipoSoggetto") String tipoSoggetto) {
        calcolaCf(ETipoSoggetto.valueOf(tipoSoggetto))
    }

    protected void calcolaCf(ETipoSoggetto ts){
        String cf = null
        switch (ts) {
            case ETipoSoggetto.SOGGETTO_1:
                if (atto instanceof ISoggettoAtto1) {
                    ISoggettoAtto1 sa = (ISoggettoAtto1) atto
                    cf = statoCivileService.calcolaCf(sa.cognome1, sa.nome1, sa.sesso1, sa.dataNascita1, sa.codiceProvinciaNascita1, sa.codiceComuneNascita1)
                }
                break
            case ETipoSoggetto.SOGGETTO_2:
                if (atto instanceof ISoggettoAtto2){
                    ISoggettoAtto2 sa = (ISoggettoAtto2) atto
                    cf = statoCivileService.calcolaCf(sa.cognome2, sa.nome2, sa.sesso2, sa.dataNascita2, sa.codiceProvinciaNascita2, sa.codiceComuneNascita2)
                }
                break
        }
        if ( (cf?:StatoCivileService.ERRORE_CAMPI_CF) == StatoCivileService.ERRORE_CAMPI_CF ){
            Messagebox.show(getEtichetta(EtichetteMessaggi.Compilare_campi_cf), getEtichetta(Etichette.Calcolo_Codice_Fiscale), Messagebox.OK, Messagebox.EXCLAMATION)
        } else {
            switch (ts) {
                case ETipoSoggetto.SOGGETTO_1:
                    if (atto instanceof ISoggettoAtto1 && dettaglio instanceof IstMscMsuBaseDomain) {
                        dettaglio.codiceFiscale1 = cf
                    }
                    break
                case ETipoSoggetto.SOGGETTO_2:
                    if (atto instanceof ISoggettoAtto2 && dettaglio instanceof IstMscMsuBaseDomain) {
                        dettaglio.codiceFiscale2 = cf
                    }
                    break
            }
            refreshUi()
        }
    }

}
