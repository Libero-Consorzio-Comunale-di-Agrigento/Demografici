package restrict.anagrafe.pratiche

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.AnagrafeBaseDomain
import it.finmatica.de4gsdzk.ArcComuneBaseDomain
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafeBaseDomain
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafeService
import it.finmatica.de4gsdzk.anagrafe.ETipoFamiglia
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaRapportoParentela
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaRapportoParentelaService
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaUrnaCineraria
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaUrnaCinerariaService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.utils.CustomEvents
import it.finmatica.de4gsdzk.utils.DataUtils
import it.finmatica.de4gsdzk.utils.ESesso
import it.finmatica.de4gsdzk.utils.ETipoComuneAtto
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.FormUtils
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.AbstractDettaglioViewModel
import restrict.TraitCancellazioneCampi
import restrict.TraitComune
import restrict.TraitGestioneCaseCampi

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class GestioneUrnaViewModel extends AbstractDettaglioViewModel implements TraitCancellazioneCampi, TraitComune {

    @WireVariable
    private GsdEtichettaService gsdEtichettaService
    @WireVariable
    private AnaUrnaCinerariaService anaUrnaCinerariaService
    @WireVariable
    private AnaAnagrafeService anaAnagrafeService
    @WireVariable
    private AnaRapportoParentelaService anaRapportoParentelaService
    @WireVariable
    private GsdService gsdService

    AnaUrnaCineraria urna
    Boolean modifica
    //Per compatibilità con i templeate utilizzati nello zul
    Boolean readOnly = false

    List<ESesso> listaSesso
    List<AnaRapportoParentela> rapportoParentelaList

    Integer matricola

    Date dataRiferimentoComuneNascita
    Date dataRiferimentoComuneMorte
    Date dataRiferimentoComuneAttoMorte

    Boolean ricercaSoggettoInANPROn = Boolean.TRUE

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w,
         @ExecutionArgParam("id") Long id,
         @ExecutionArgParam("matricola") Integer matr) {
        self = w
        matricola = matr


        listaSesso = [null] + ESesso.values().toList()

        List<Map<String, String>> eList = [Etichette.getEtichetta("Estremi_Urna")]
        eList.addAll(AnaUrnaCineraria.etichetteDomain)
        eList.addAll(ESesso.values()*.getEtichettaDesc())
        eList.addAll([Etichette.getEtichetta("Cancella"), Etichette.getEtichetta("Chiudi"),
                      Etichette.getEtichetta("Aggiungi"), Etichette.getEtichetta("Salva"),
                      Etichette.getEtichetta("Seleziona"), Etichette.getEtichetta("Genera_Numero")])


        if (id) {
            caricaDettaglio(id)
            modifica = true
        } else {
            creaDettaglio([:])
            modifica = false
        }

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Estremi_Urna"))
        formLabel = msgTitle?.toUpperCase()
    }

    void popolaRapportoParentelaLists() {
        rapportoParentelaList = anaRapportoParentelaService.findBySessoConCodiceIstat(urna.anagrafe.sesso)
    }


    @Override
    void caricaDettaglio(Object id) {
        urna = anaUrnaCinerariaService.get(id as Long)
        dataRiferimentoComuneNascita = urna.dataNascitaMorto
        dataRiferimentoComuneMorte = urna.dataMorte
        dataRiferimentoComuneAttoMorte = DataUtils.getDataAttoRif(urna.dataMorte, urna.estremiAttoMorte.anno)
        popolaRapportoParentelaLists()
        urna.rapportoParentela = rapportoParentelaList.find { it.codiceRapportoParentela == urna.codRp }

    }

    @Override
    void creaDettaglio(Map params) {
        urna = new AnaUrnaCineraria()
        urna.anagrafe = anaAnagrafeService.findById(matricola)
        popolaRapportoParentelaLists()
    }

    @Override
    Object getDettaglio() {
        return urna
    }

    @Command
    void onChiudi() {
        Events.postEvent(Events.ON_CLOSE, self, [:])
    }

    @Command
    void onSalva() {
        if (checkDatiObbligatori()) {
            urna.codRp = urna.rapportoParentela.codiceRapportoParentela
            anaUrnaCinerariaService.save(urna)
            onChiudi()
        } else {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori"))
        }
    }

    private boolean checkDatiObbligatori() {
        if (urna.cognomeMorto == null || urna.nomeMorto == null || urna.sessoMorto == null ||
                urna.dataNascitaMorto == null || urna.comuneNascitaMorto.codice == null ||
                urna.rapportoParentela == null || urna.dataMorte == null || urna.comuneMorte.codice == null) {
            return false
        }
        return true
    }

    @Override
    void selezionaComune(ETipoComuneAtto tc, ArcComuneBaseDomain c) {
        switch (tc) {
            case ETipoComuneAtto.URNA_NAS:
                riempiComune(urna.comuneNascitaMorto, c)
                break
            case ETipoComuneAtto.URNA_MOR:
                riempiComune(urna.comuneMorte, c)
                break
            case ETipoComuneAtto.URNA_ATTO_MOR:
                riempiComune(urna.comuneAttoMorte, c)
                break
        }
    }

    @Command
    void onAggiornaDataRiferimento(@BindingParam("campoRiferimento") String campoRiferimento) {
        switch (ETipoComuneAtto.valueOf(campoRiferimento)) {
            case ETipoComuneAtto.URNA_NAS:
                dataRiferimentoComuneNascita = urna.dataNascitaMorto
                break
            case ETipoComuneAtto.URNA_MOR:
                dataRiferimentoComuneMorte = urna.dataMorte
                dataRiferimentoComuneAttoMorte = DataUtils.getDataAttoRif(urna.dataMorte, urna.estremiAttoMorte.anno)
                break
            case ETipoComuneAtto.URNA_ATTO_MOR:
                dataRiferimentoComuneAttoMorte = DataUtils.getDataAttoRif(urna.dataMorte, urna.estremiAttoMorte.anno)
                break
        }
        refreshUi()
    }

    @Command
    void onGeneraNumeroRegistrazione() {
        if (urna.numeroRegistro == null) {
            urna.annoRegistro = urna.annoRegistro ?: DataUtils.getAnnoCorrente()
            urna.numeroRegistro = gsdService.getNumeroRegistro(urna.annoRegistro)
            refreshUi()
        }
    }

    @Command
    void onRicercaSoggetto() {
        Map params = [cognome: urna.cognomeMorto?.toUpperCase(), nome: urna.nomeMorto?.toUpperCase(), sessoEnabled: Boolean.TRUE, anagrafeEstesa: Boolean.TRUE, flagInserimento: Boolean.TRUE]

        Window w = (Window) Executions.createComponents(FormUtils.getUriAnagrafeSelect(ricercaSoggettoInANPROn), self, params)
        w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
            if (event.data instanceof AnagrafeBaseDomain) {
                AnagrafeBaseDomain ana = (AnagrafeBaseDomain) event.data
                urna.cognomeMorto = ana.cognome
                urna.nomeMorto = ana.nome
                urna.dataNascitaMorto = ana.dataNascita
                urna.comuneNascitaMorto.descrizione = ana.comuneNascita.descrizione
                urna.comuneNascitaMorto.codice = ana.comuneNascita.codice
                urna.comuneNascitaMorto.siglaProvincia = ana.comuneNascita.siglaProvincia
                urna.comuneNascitaMorto.codiceProvincia = ana.comuneNascita.codiceProvincia
                urna.sessoMorto = ana.sesso

                refreshUi()
            }
        })
        w.doModal()
    }


}