package restrict.anagrafe.pratiche

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.anagrafe.*
import it.finmatica.de4gsdzk.anagrafe.pratiche.*
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaEnteService
import it.finmatica.de4gsdzk.archivi.ArcDatiNumerazioneCivicoService
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.archivi.ArcVia
import it.finmatica.de4gsdzk.certificazione.CerTerminalistaService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.IndirizzoCivico
import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.famiglia.IndirizzoResidenteFamiglia
import it.finmatica.de4gsdzk.utils.*
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.TraitGestioneCaseCampi

import javax.persistence.criteria.JoinType

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class PraticaRettificaResDettaglioViewModel extends AbstractPraticaDettaglioViewModel implements TraitGestioneIndividuo, TraitGestioneCaseCampi, TraitGestioneCivico {

    private final Integer RETTIFICA_PER_MORTE = 50
    private final Integer RETTIFICA_RAPPORTO_PARENTELA = 10

    @WireVariable
    AnaDichiarazioneRettificaService anaDichiarazioneRettificaService
    @WireVariable
    AnaCittadinanzaService anaCittadinanzaService
    @WireVariable
    AnaStatoCivileService anaStatoCivileService
    @WireVariable
    AnaTitoloStudioService anaTitoloStudioService
    @WireVariable
    AnaProfessioneService anaProfessioneService
    @WireVariable
    AnaAttivitaService anaAttivitaService
    @WireVariable
    AnaPosizioneProfessionaleService anaPosizioneProfessionaleService
    @WireVariable
    AnaMotivoProvvedimentoService anaMotivoProvvedimentoService
    @WireVariable
    AnaTipoProvvedimentoService anaTipoProvvedimentoService
    @WireVariable
    AnaEnteService anaEnteService
    @WireVariable
    AnaRapportoParentelaService anaRapportoParentelaService
    @WireVariable
    AnaDocumentoService anaDocumentoService
    @WireVariable
    AnaDocumentoAllegatoService anaDocumentoAllegatoService
    @WireVariable
    AnaTipoDocumentoService anaTipoDocumentoService
    @WireVariable
    AnaUrnaCinerariaService anaUrnaCinerariaService
    @WireVariable
    AnaDettaglioProvvedimentoService anaDettaglioProvvedimentoService
    @WireVariable
    AnaTipoRecapitoService anaTipoRecapitoService
    @WireVariable
    AnaConvivenzaDiFattoService anaConvivenzaDiFattoService
    @WireVariable
    CerTerminalistaService cerTerminalistaService
    @WireVariable
    ArcDatiNumerazioneCivicoService arcDatiNumerazioneCivicoService

    @Override
    AnaCittadinanzaService getAnaCittadinanzaService() {
        return anaCittadinanzaService
    }

    @Override
    AnaStatoCivileService getAnaStatoCivileService() {
        return anaStatoCivileService
    }

    @Override
    AnaTitoloStudioService getAnaTitoloStudioService() {
        return anaTitoloStudioService
    }

    @Override
    AnaProfessioneService getAnaProfessioneService() {
        return anaProfessioneService
    }

    @Override
    AnaAttivitaService getAnaAttivitaService() {
        return anaAttivitaService
    }

    @Override
    AnaPosizioneProfessionaleService getAnaPosizioneProfessionaleService() {
        return anaPosizioneProfessionaleService
    }

    //Questa notazione viene usata perché sono service definiti nella classe abstract
    @Override
    GsdService getGsdService() {
        return this.@gsdService
    }

    @Override
    ArcParametroService getArcParametroService() {
        return this.@arcParametroService
    }

    @Override
    AnaAnagrafeService getAnaAnagrafeService() {
        return this.@anaAnagrafeService
    }

    @Override
    AnaTipoProvvedimentoService getAnaTipoProvvedimentoService() {
        return anaTipoProvvedimentoService
    }

    @Override
    AnaMotivoProvvedimentoService getAnaMotivoProvvedimentoService() {
        return anaMotivoProvvedimentoService
    }

    @Override
    AnaEnteService getAnaEnteService() {
        return anaEnteService
    }

    @Override
    AnaRapportoParentelaService getAnaRapportoParentelaService() {
        return anaRapportoParentelaService
    }

    @Override
    AnaDocumentoService getAnaDocumentoService() {
        return anaDocumentoService
    }

    @Override
    AnaDocumentoAllegatoService getAnaDocumentoAllegatoService() {
        return anaDocumentoAllegatoService
    }

    @Override
    AnaTipoDocumentoService getAnaTipoDocumentoService() {
        return anaTipoDocumentoService
    }

    @Override
    AnaUrnaCinerariaService getAnaUrnaCinerariaService() {
        return anaUrnaCinerariaService
    }

    @Override
    AnaTipoRecapitoService getAnaTipoRecapitoService() {
        return anaTipoRecapitoService
    }

    @Override
    AnaDettaglioProvvedimentoService getAnaDettaglioProvvedimentoService() {
        return anaDettaglioProvvedimentoService
    }

    @Override
    AnaConvivenzaDiFattoService getAnaConvivenzaDiFattoService() {
        return anaConvivenzaDiFattoService
    }

    @Override
    CerTerminalistaService getCerTerminalistaService() {
        return cerTerminalistaService
    }

    @Override
    ArcDatiNumerazioneCivicoService getArcDatiNumerazioneCivicoService() {
        return arcDatiNumerazioneCivicoService
    }

    AnaDichiarazioneRettifica dichiarazioneRettifica
    AnaSoggettoRettifica soggettoDummy = new AnaSoggettoRettifica(numeroOrdine: 9, anagrafe: new AnaAnagrafe(nome: "DICHIARANTE", cognome: "ALTRO"))

    final List<ETipoRettifica> listaTipoRettifica = Arrays.asList(ETipoRettifica.values())

    String individuoHash
    String indirizzoHash


    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long id, @ExecutionArgParam("modifica") boolean modifica,
         @ExecutionArgParam("readOnly") boolean readOnly) {

        doInit(w, id, modifica, readOnly)
        saveRecordEnabled = false

        List<Map<String, String>> eList = []
        eList.addAll(AnaDichiarazioneRettifica.etichetteDomain)
        eList.addAll(ETipoRettifica.values()*.getEtichettaDesc())
        eList.addAll(Etichette.getEtichetta("Tipo_Rettifica_Scorretto"), Etichette.getEtichetta("Sezione_Rettifica_Pratica"),
                Etichette.getEtichetta("Sezione_Individuo_Pratica"), Etichette.getEtichetta("Sezione_Rapporti_Parentela_Pratica"),
                Etichette.getEtichetta("Sezione_Indirizzo_Pratica"),
                Etichette.getEtichetta("Salva_Chiudi_Pratica"), Etichette.getEtichetta("Cambiare_Rapporto_Parentela"),
                Etichette.getEtichetta("Nessuna_Variazione_Indirizzo"), Etichette.getEtichetta("Nessuna_Variazione_Individuo"))
        eList.addAll(etichetteGestioneIndividuo)
        eList.addAll(etichetteGestioneCivico)

        doInitEtichette(eList)


    }

    @Override
    void caricaDettaglio(Object id) {
        caricaPratica(id as Long)
        dichiarazioneRettifica = anaDichiarazioneRettificaService.findByPratica(pratica as AnaPratica)
        if (dichiarazioneRettifica == null) {
            //Entro in questo caso solo se arrivo da un recupero pratica
            creaDettaglio([:])
            dichiarazioneRettifica.tipoRettifica = ETipoRettifica.I
        } else {
            if (dichiarazioneRettifica.soggettiRettifica.size() > 0) {
                popolaListaDichiaranti()
                selectedDichiarante = listaDichiaranti.find { it.numeroOrdine == dichiarazioneRettifica.sottoscritto }
                switch (dichiarazioneRettifica.tipoRettifica) {
                    case ETipoRettifica.R:
                        inizializzazioneRP()
                        break
                    case ETipoRettifica.F:
                        inizializzazioneFamiglia()
                        break
                    case ETipoRettifica.I:
                        inizializzazioneIndividuo()
                        break
                }
            }
        }
    }

    void inizializzazioneRP() {
        popolaRapportoParentelaLists(dichiarazioneRettifica.famiglia.convivenza ? ETipoFamiglia.CONVIVENZA : ETipoFamiglia.FAMIGLIA)
        for (AnaSoggettoRettifica s : dichiarazioneRettifica.soggettiRettifica) {
            if (s.anagrafe.sesso == ESesso.M) {
                s.rapportoParentelaPrecedente = rapportoParentelaMList.find { it.codiceRapportoParentela == s.codRpPrecedente }
                s.rapportoParentelaNuovo = rapportoParentelaMList.find { it.codiceRapportoParentela == s.nuovoCodRp }
            } else {
                s.rapportoParentelaPrecedente = rapportoParentelaMList.find { it.codiceRapportoParentela == s.codRpPrecedente }
                s.rapportoParentelaNuovo = rapportoParentelaFList.find { it.codiceRapportoParentela == s.nuovoCodRp }
            }

        }
    }

    void inizializzazioneFamiglia() {
        popolaRapportoParentelaLists(dichiarazioneRettifica.famiglia.convivenza ? ETipoFamiglia.CONVIVENZA : ETipoFamiglia.FAMIGLIA)
        for (AnaSoggettoRettifica s : dichiarazioneRettifica.soggettiRettifica) {
            if (s.anagrafe.sesso == ESesso.M) {
                s.rapportoParentelaPrecedente = rapportoParentelaMList.find { it.codiceRapportoParentela == s.codRpPrecedente }
            } else {
                s.rapportoParentelaPrecedente = rapportoParentelaFList.find { it.codiceRapportoParentela == s.codRpPrecedente }
            }

        }
        caricaElementiCivico(dichiarazioneRettifica?.indirizzo?.via?.id)
        dichiarazioneRettifica.tipoFamiglia = dichiarazioneRettifica.famiglia.convivenza ? ETipoFamiglia.CONVIVENZA : ETipoFamiglia.FAMIGLIA
        if (dichiarazioneRettifica.tipoFamiglia == ETipoFamiglia.CONVIVENZA) {
            dichiarazioneRettifica.tipoConvivenza = listaTipoConvivenza.find { it.id == dichiarazioneRettifica.famiglia.tipoConvivenza?.id }
            dichiarazioneRettifica.convivenza = dichiarazioneRettifica.famiglia.descrizioneConvivenza
            dichiarazioneRettifica.cognomeIntestatarioConvivenza = dichiarazioneRettifica.famiglia.cognomeIntestatario
            dichiarazioneRettifica.nomeIntestatarioConvivenza = dichiarazioneRettifica.famiglia.nomeIntestatario
            dichiarazioneRettifica.intestatarioConvivenza = dichiarazioneRettifica.famiglia.intestatarioConvivenza
            dichiarazioneRettifica.dataIntestatarioConvivenza = dichiarazioneRettifica.famiglia.dataIntestatarioConvivenza
            dichiarazioneRettifica.dataIstituzioneConvivenza = dichiarazioneRettifica.famiglia.dataIstituzioneConvivenza
        }
    }

    @Override
    void creaDettaglio(Map params) {
        dichiarazioneRettifica = new AnaDichiarazioneRettifica()
        dichiarazioneRettifica.pratica = pratica
        dichiarazioneRettifica.idPratica = pratica.idPratica

        caricaElementiCivico()
    }

    @Override
    ISoggettoPratica getNewSoggetto() {
        return new AnaSoggettoRettifica()
    }

    @Override
    void checkDatiAggiuntiviPratica() {
        if (pratica.flagPerfezionamento || pratica.flagAnnullamento) {
            return
        }
        String sezione = "Rettifica"
        if (dichiarazioneRettifica.tipoRettifica == null) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezione)
        }
        if ((dichiarazioneRettifica.tipoRettifica == ETipoRettifica.R) != (selectedVariazione.codiceMovimento == RETTIFICA_RAPPORTO_PARENTELA)) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Tipo_Rettifica_Scorretto"))
        }
    }


    @Override
    void checkSoggettiPratica() {
        if (pratica.flagPerfezionamento || pratica.flagAnnullamento) {
            return
        }
        checkAlmenoUnSoggettoInserito()
        switch (dichiarazioneRettifica.tipoRettifica) {
            case ETipoRettifica.R:
                checkSoggettiRP()
                break
            case ETipoRettifica.F:
                checkIndirizzoFamiglia()
                break
            case ETipoRettifica.I:
                checkIndividuo()
                break
        }

    }

    private void checkSoggettiRP() {
        boolean variato = false
        for (AnaSoggettoRettifica s : dichiarazioneRettifica.soggettiRettifica) {
            if (s.rapportoParentelaPrecedente.id != s.rapportoParentelaNuovo.id) {
                variato = true
                break
            }
        }
        if (!variato) {
            throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("Cambiare_Rapporto_Parentela")))
        }

        if (!dichiarazioneRettifica.famiglia.convivenza) { // Famiglia
            checkCapoFamiglia()
        } else { // Convivenza
            checkCapoConvivenza()
        }
    }

    void checkCapoFamiglia() {
        if (dichiarazioneRettifica.soggettiRettifica.count { (it.rapportoParentelaNuovo?.codiceRapportoParentela == CAPO_FAMIGLIA) } != 1) {
            throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("IS_Creazione")))
        }
    }

    void checkCapoConvivenza() {
        if (dichiarazioneRettifica.soggettiRettifica.count { (it.rapportoParentelaNuovo?.codiceRapportoParentela == CAPO_CONVIVENZA) } > 1) {
            throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("CC_Creazione")))
        }

    }

    private checkIndirizzoFamiglia() {
        civico.copyTo(dichiarazioneRettifica.indirizzo)
        if (indirizzoHash == HashUtils.computeStateHash(dichiarazioneRettifica.indirizzo)) {
            throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("Nessuna_Variazione_Indirizzo")))
        }
    }


    void checkAlmenoUnSoggettoInserito() {
        if (dichiarazioneRettifica.soggettiRettifica.size() < 1) {
            throw new CampoMandatoryRuntimeException(getEtichetta(Etichette.getEtichetta("Inserire_Soggetti")))
        }
    }

    private void checkIndividuo() {
        if (individuoHash == HashUtils.computeStateHash(soggetto)) {
            throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("Nessuna_Variazione_Individuo")))
        }
        checkDatiObbligatoriIndividuo()
    }

    @Override
    void salvaSoggetto(ISoggettoPratica soggetto) {

    }

    @Override
    void salvaDichiarazione() {

        if (dichiarazioneRettifica.id == null) {
            dichiarazioneRettifica.id = gsdService.getIntegerIdFromSequence(dichiarazioneRettifica, dichiarazioneRettifica.getTableName())
        }

        dichiarazioneRettifica.annoPratica = pratica.anno
        dichiarazioneRettifica.numeroPratica = pratica.numero
        dichiarazioneRettifica.dataDecorrenza = pratica.dataDecorrenza
        dichiarazioneRettifica.sottoscritto = selectedDichiarante?.numeroOrdine

        for (AnaSoggettoRettifica s : dichiarazioneRettifica.soggettiRettifica) {
            if (s.id == null) {
                s.id = gsdService.getIntegerIdFromSequence(s, s.getTableName())
            }
            s.annoPratica = pratica.anno
            s.numeroPratica = pratica.numero

            if (dichiarazioneRettifica.tipoRettifica == ETipoRettifica.R) {
                s.nuovoCodRp = s.rapportoParentelaNuovo.codiceRapportoParentela
                s.nuovaSequenzaRp = s.rapportoParentelaNuovo.sequenza
            }
        }

        switch (dichiarazioneRettifica.tipoRettifica) {
            case ETipoRettifica.F:
                if (dichiarazioneRettifica?.indirizzo != null) {
                    civico.copyTo(dichiarazioneRettifica.indirizzo)
                }
                break
            case ETipoRettifica.I:
                if (soggetto != null) {
                    salvaIndividuo()
                }
                break
        }

        anaDichiarazioneRettificaService.saveOrUpdate(dichiarazioneRettifica)

    }

    @Override
    void annullaDichiarazione() {
        //Non esiste il concetto di annullamento per questo tipo di pratica
    }

    @Override
    void inserisciSoggettiFamiglia(AnaFamiglia famiglia, Boolean interoNucleo) {
        dichiarazioneRettifica.codFamiglia = famiglia.codice
        dichiarazioneRettifica.famiglia = famiglia

        List<AnaAnagrafe> famigliari = anaAnagrafeService.listAllFamigliariAttiviByFamiglia(famiglia)
        popolaRapportoParentelaLists(famiglia.convivenza ? ETipoFamiglia.CONVIVENZA : ETipoFamiglia.FAMIGLIA)

        for (AnaAnagrafe f : famigliari) {
            AnaSoggettoRettifica sogg = new AnaSoggettoRettifica()
            sogg.anagrafe = f
            sogg.dichiarazioneRettifica = dichiarazioneRettifica
            sogg.flagSoggetto = interoNucleo
            sogg.numeroOrdine = dichiarazioneRettifica.soggettiRettifica.size() + 1
            sogg.pratica = pratica
            sogg.idPratica = pratica.idPratica
            sogg.annoPratica = pratica.anno
            sogg.numeroPratica = pratica.numero
            sogg.archivioAnagrafe = archivioAnagrafe
            sogg.tipoPratica = tipoPratica

            sogg.rapportoParentelaPrecedente = f.rapportoParentela
            sogg.codRpPrecedente= f.rapportoParentela.codiceRapportoParentela
            sogg.sequenzaRpPrecedente = f.rapportoParentela.sequenza

            sogg.rapportoParentelaNuovo = f.rapportoParentela
            if (dichiarazioneRettifica.tipoRettifica == ETipoRettifica.F) {
                sogg.nuovoCodRp= f.rapportoParentela.codiceRapportoParentela
                sogg.nuovaSequenzaRp = f.rapportoParentela.sequenza
            }

            dichiarazioneRettifica.soggettiRettifica.add(sogg)

        }

        if (dichiarazioneRettifica.tipoRettifica == ETipoRettifica.F) {
            popolaIndirizzo(famiglia)
        }


    }

    private void popolaIndirizzo(AnaFamiglia f) {
        AnaFamiglia famiglia = anaFamigliaService.get(f.id, [fetch: [[campo: 'indirizzoResidente.indirizzo.via', tipo: JoinType.LEFT], [campo: 'tipoConvivenza', tipo: JoinType.LEFT], [campo: 'intestatarioConvivenza', tipo: JoinType.LEFT]]])
        IndirizzoCivico indirizzoFamiglia = (famiglia.indirizzo as IndirizzoResidenteFamiglia).indirizzo
        indirizzoHash = HashUtils.computeStateHash(indirizzoFamiglia)
        copiaDatiIndirizzo(dichiarazioneRettifica.indirizzo, indirizzoFamiglia)
        dichiarazioneRettifica.tipoFamiglia = famiglia.convivenza ? ETipoFamiglia.CONVIVENZA : ETipoFamiglia.FAMIGLIA

        if (dichiarazioneRettifica.tipoFamiglia == ETipoFamiglia.CONVIVENZA) {
            dichiarazioneRettifica.tipoConvivenza = listaTipoConvivenza.find { it.id == famiglia.tipoConvivenza?.id }
            dichiarazioneRettifica.convivenza = famiglia.descrizioneConvivenza
            dichiarazioneRettifica.cognomeIntestatarioConvivenza = famiglia.cognomeIntestatario
            dichiarazioneRettifica.nomeIntestatarioConvivenza = famiglia.nomeIntestatario
            dichiarazioneRettifica.intestatarioConvivenza = famiglia.intestatarioConvivenza
            dichiarazioneRettifica.dataIntestatarioConvivenza = famiglia.dataIntestatarioConvivenza
            dichiarazioneRettifica.dataIstituzioneConvivenza = famiglia.dataIstituzioneConvivenza
        }

        caricaElementiCivico(dichiarazioneRettifica?.indirizzo?.via?.id)

    }

    private void svuotaIndirizzo() {

        if (dichiarazioneRettifica.tipoFamiglia == ETipoFamiglia.CONVIVENZA) {
            dichiarazioneRettifica.tipoConvivenza = null
            dichiarazioneRettifica.convivenza = null
            dichiarazioneRettifica.cognomeIntestatarioConvivenza = null
            dichiarazioneRettifica.nomeIntestatarioConvivenza = null
            dichiarazioneRettifica.intestatarioConvivenza = null
            dichiarazioneRettifica.dataIntestatarioConvivenza = null
            dichiarazioneRettifica.dataIstituzioneConvivenza = null
        }

        copiaDatiIndirizzo(dichiarazioneRettifica.indirizzo, null)
        dichiarazioneRettifica.tipoFamiglia = null
    }


    @Override
    AnaFamiglia inserisciFamiglia() {
        //Non necessario per questo tipo di pratica
        return null
    }

    @Override
    AnaFamiglia updateFamiglia(String id) {
        //Non necessario per questo tipo di pratica
        return null
    }

    @Override
    void perfezionaSoggetti(AnaStato stato, Integer fascia, AnaFamiglia famiglia) {

    }

    @Override
    void annullaSoggetti() {

    }

    @Override
    void popolaDefault() {
        if (selectedVariazione?.codiceMovimento == RETTIFICA_RAPPORTO_PARENTELA) {
            dichiarazioneRettifica.tipoRettifica = ETipoRettifica.R
        }
    }

    @Override
    void popolaRapportoParentelaLists(ETipoFamiglia tipoFamiglia = null) {
        rapportoParentelaFList = anaRapportoParentelaService.findAllBySessoAndTipoFamiglia(ESesso.F, tipoFamiglia ?: ETipoFamiglia.FAMIGLIA)
        rapportoParentelaMList = anaRapportoParentelaService.findAllBySessoAndTipoFamiglia(ESesso.M, tipoFamiglia ?: ETipoFamiglia.FAMIGLIA)
    }

    @Override
    void selezionaRapportoParentela(ISoggettoPratica sogg, String rapporto, boolean mostraMessaggio = true) {

    }

    @Override
    IDichiarazionePratica getDichiarazione() {
        return dichiarazioneRettifica
    }

    @Override
    List<ISoggettoPratica> getSoggetti() {
        dichiarazioneRettifica.soggettiRettifica.sort { it.numeroOrdine }
        return dichiarazioneRettifica.soggettiRettifica
    }

    @Override
    List<ISoggettoPratica> getSoggettiNonOrdinati() {
        return dichiarazioneRettifica.soggettiRettifica
    }

    @Override
    EFascia getFascia() {
        return archivioAnagrafe == ETipoAnagrafe.RESIDENTI ? EFascia.ISCRITTO_APR : null
    }

    @Override
    ETipoAnagrafe getArchivioAnagrafe() {
        return ETipoAnagrafe.RESIDENTI
    }

    @Override
    ETipoPratica getTipoPratica() {
        return ETipoPratica.RET
    }

    @Override
    void eliminaFamiglia() {
        dichiarazioneRettifica.soggettiRettifica = new ArrayList<>()
        dichiarazioneRettifica.codFamiglia = null
        dichiarazioneRettifica.famiglia = null
        if (dichiarazioneRettifica.tipoRettifica == ETipoRettifica.F) {
            svuotaIndirizzo()
        }
    }

    @Override
    Object getDettaglio() {
        return soggetto
    }

    @Override
    void filtraVariazioni() {
        listaVariazioni.removeAll { it.evento.id == RETTIFICA_PER_MORTE }
    }

    @Override
    boolean isRettificaIndividuo() {
        return dichiarazioneRettifica.tipoRettifica == ETipoRettifica.I
    }

    @Override
    boolean isRettificaFamiglia() {
        return dichiarazioneRettifica.tipoRettifica != ETipoRettifica.I
    }

    AnaAnagrafe getSoggetto() {
        if (dichiarazioneRettifica.tipoRettifica == ETipoRettifica.I && dichiarazioneRettifica.soggettiRettifica.size() > 0) {
            //Sicuramente avrò uno ed un solo soggetto
            return dichiarazioneRettifica.soggettiRettifica.get(0)?.anagrafe
        }
        return null
    }

    void setSoggetto(AnaAnagrafe soggetto) {
        if (dichiarazioneRettifica.tipoRettifica == ETipoRettifica.I && dichiarazioneRettifica.soggettiRettifica.size() > 0) {
            //Sicuramente avrò uno ed un solo soggetto
            dichiarazioneRettifica.soggettiRettifica.get(0)?.anagrafe = soggetto
        }
    }

    @Override
    void inizializzazioneIndividuo() {
        initMinuscole()
        caricaListaNazionalita()
        initListeLookup(soggetto.famiglia.convivenza ? ETipoFamiglia.CONVIVENZA : ETipoFamiglia.FAMIGLIA)
        //Per caricare tutte le strutture necessarie
        soggetto = anaAnagrafeService.findByIdSoggetto(soggetto.id)
        if (soggetto.sesso == ESesso.M) {
            selectedRapportoParentela = rapportoParentelaMList.find { it?.id == soggetto.rapportoParentela.id }

        } else {
            selectedRapportoParentela = rapportoParentelaFList.find { it?.id == soggetto.rapportoParentela.id }
        }
        caricaListaStatoCivile()
        caricaProfessioni()

        //Provvedimento
        provvedimentoDivorzio = anaDettaglioProvvedimentoService.findByPraticaAndSoggetto(pratica, soggetto)
        if (provvedimentoDivorzio == null) {
            provvedimentoDivorzio = anaDettaglioProvvedimentoService.findBySoggettoANPR(soggetto)
            if (provvedimentoDivorzio != null) {
                provvedimentoDivorzio.pratica = pratica
                provvedimentoDivorzio.archivioAnagrafe = pratica.archivioAnagrafe.id
                provvedimentoDivorzio.tipoPratica = pratica.tipoPratica
                provvedimentoDivorzio.annoPratica = pratica.anno
                provvedimentoDivorzio.numeroPratica = pratica.numero
            }
        }
        provvedimento = provvedimentoDivorzio != null ? ETipoSiNo.SI : ETipoSiNo.NO

        //CdF
        if (soggetto.convivenzaDiFatto) {
            convivenzaDiFatto = ETipoSiNo.SI
        } else {
            convivenzaDiFatto = ETipoSiNo.NO
        }
        //Urne
        soggetto.urneCinerarie = anaAnagrafeService.getUrneCinerarie(soggetto)
        affidamentoUrneCinerarie = (soggetto.urneCinerarie && !soggetto.urneCinerarie.isEmpty()) ? ETipoSiNo.SI : ETipoSiNo.NO

        individuoHash = HashUtils.computeStateHash(soggetto)
    }

    @Command
    void onModificaDatiSoggetto(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        return //Non serve in questo caso
    }

    @Override
    void selezionaVia(ArcVia c) {
        dichiarazioneRettifica.indirizzo.via = c
        caricaElementiCivico(c?.id, true)
    }

    @Override
    @Command
    void onCancellaCampoPratica(@BindingParam("sezione") String sezione, @ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        String p = e?.target?.getAttribute("proprieta")?.trim()
        super.onCancellaCampoPratica(sezione, e)
        if (sezione == 'F' && p == 'indirizzo.via') {
            caricaElementiCivico()
        }
    }

    @Override
    @Command
    void onRicercaFamiglia() {
        return //Non serve in questo caso
    }

    @Command
    void onSelectTitoloStudio() {
        return
    }

}