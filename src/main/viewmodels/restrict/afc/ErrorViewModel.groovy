package restrict.afc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.competenze.CompetenzeRuntimeException
import it.finmatica.de4gsdzk.errors.*
import org.hibernate.exception.ConstraintViolationException
import org.springframework.dao.DataIntegrityViolationException
import org.springframework.orm.ObjectOptimisticLockingFailureException
import org.springframework.orm.hibernate3.HibernateJdbcException
import org.springframework.transaction.HeuristicCompletionException
import org.springframework.transaction.UnexpectedRollbackException
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.UiException
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window

import java.sql.SQLException
import java.sql.SQLIntegrityConstraintViolationException

import static it.finmatica.de4gsdzk.utils.ErorrUtils.decodeSqlExceptionMessage
import static it.finmatica.de4gsdzk.utils.ErorrUtils.getSQLException
import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichetta
import it.finmatica.de4gsdzk.utils.Etichette

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class ErrorViewModel {
    Window self

    String title
    String stacktrace

    boolean showDetails = false

    boolean autoClosable = false
    def autoTime = 2500

    Map<String, String> etichette = [:]

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        List<Map> eList = [Etichette.getEtichetta("Errore_Db_Modifiche_Concorrenti"), Etichette.getEtichetta("Errore_Db_Integrity"), Etichette.getEtichetta("Errore_serie"), Etichette.getEtichetta("Errore_parte"),
                           Etichette.getEtichetta("Errore_Ricerca_ANPR_No_Result"),
                           Etichette.getEtichetta("Errore_consolidamento_atto_provvisorio"), Etichette.getEtichetta("Errore_natura_vs_tipo_atto"), Etichette.getEtichetta("Errore_natura_vs_categoria"),
                           Etichette.getEtichetta("Errore_valore_ora"), Etichette.getEtichetta("Errore_valore_minuti"), Etichette.getEtichetta("Errore_nome_file"), Etichette.getEtichetta("Errore_Lunghezza_Campo"),
                           Etichette.getEtichetta("Errore_cancellazione_tipo_atto"), Etichette.getEtichetta("Errore_sesso_contraenti"), Etichette.getEtichetta("Errore_tipo_divorzio"),
                           Etichette.getEtichetta("Errore_comune_nascita_vs_parte_serie"), Etichette.getEtichetta("Errore_comune_residenza_vs_parte_serie"),
                           Etichette.getEtichetta("Errore_atto_nascita_sposo_non_presente_in_archivio"), Etichette.getEtichetta("Errore_atto_nascita_sposa_non_presente_in_archivio"),
                           Etichette.getEtichetta("Errore_atto_nascita_contraente_1_non_presente_in_archivio"), Etichette.getEtichetta("Errore_atto_nascita_contraente_2_non_presente_in_archivio"),
                           Etichette.getEtichetta("Errore_atto_nascita_deceduto_non_presente_in_archivio"), Etichette.getEtichetta("Errore_atto_nascita_intestatario_non_presente_in_archivio"),
                           Etichette.getEtichetta("Errore_atto_nascita_soggetto_non_compatibile"),
                           Etichette.getEtichetta("Errore_atto_matrimonio_non_presente_in_archivio"), Etichette.getEtichetta("Errore_atto_unione_civile_non_presente_in_archivio"),
                           Etichette.getEtichetta("Errore_modifica_comunicazioni_protocollate"), Etichette.getEtichetta("Errore_modifica_comunicazioni_inviate_albo"),
                           Etichette.getEtichetta("Errore_salvataggio_testo_comunicazione"), Etichette.getEtichetta("Errore_modifica_comunicazioni_eseguite"), Etichette.getEtichetta("Errore_Numero_Protocollo"),
                           Etichette.getEtichetta("Errore_invio_pec_comunicazione_non_protocollata"), Etichette.getEtichetta("Errore_protocollazione_comunicazioni_provvisorie"),
                           Etichette.getEtichetta("Errore_Inserimento_Formula_Duplicata"), Etichette.getEtichetta("Errore_Inserimento_Minuta_Duplicata"),
                           Etichette.getEtichetta("Errore_Inserimento_Comunicazione_Duplicata"), Etichette.getEtichetta("Errore_Inserimento_Ente_Duplicato"), Etichette.getEtichetta("Errore_Inserimento_Registro_Duplicato"),
                           Etichette.getEtichetta("Errore_formula_libretto_internazionale"), Etichette.getEtichetta("Errore_Operazione_non_consentita"),
                           Etichette.getEtichetta("Errore_Consenso_Disponente"), Etichette.getEtichetta("Errore_Consenso_Fiduciario_1"), Etichette.getEtichetta("Errore_Consenso_Fiduciario_2"),
                           Etichette.getEtichetta("Errore_Sottoscrizione_DAT_Fiduciario_1"), Etichette.getEtichetta("Errore_Sottoscrizione_DAT_Fiduciario_2"), Etichette.getEtichetta("Errore_Disponente_DAT"),
                           Etichette.getEtichetta("Errore_Consenso_Invio_DAT"), Etichette.getEtichetta("Errore_Reperibilita_DAT"), Etichette.getEtichetta("Errore_Db_Constraint_Violation"),
                           Etichette.getEtichetta("Errore_inserimento_annotazione_su_provvisorio"),
                           Etichette.getEtichetta("Compilare_campi_obbligatori_comunicazione"),
                           Etichette.getEtichetta("Compilare_campi_obbligatori_padre"), Etichette.getEtichetta("Compilare_campi_obbligatori_madre"),
                           Etichette.getEtichetta("Compilare_campo_dichiarante"),
                           Etichette.getEtichetta("Compilare_campi_obbligatori_sposo"), Etichette.getEtichetta("Compilare_campi_obbligatori_sposa"),
                           Etichette.getEtichetta("Compilare_campi_obbligatori_contraente_1"), Etichette.getEtichetta("Compilare_campi_obbligatori_contraente_2"),
                           Etichette.getEtichetta("Compilare_campi_obbligatori_anagrafe"), Etichette.getEtichetta("Compilare_campi_obbligatori_occhiello"),
                           Etichette.getEtichetta("Compilare_campi_obbligatori_deceduto_a"), Etichette.getEtichetta("Compilare_campi_obbligatori_coniuge"),
                           Etichette.getEtichetta("Compilare_campi_documenti_presentati"), Etichette.getEtichetta("Compilare_campi_obbligatori_trasporto"),
                           Etichette.getEtichetta("Compilare_campi_obbligatori_atto"), Etichette.getEtichetta("Compilare_campi_obbligatori"), Etichette.getEtichetta("Compilare_campi_ANPR"),
                           Etichette.getEtichetta("Compilare_campi_obbligatori_tipo_divorzio"), Etichette.getEtichetta("Compilare_campi_obbligatori_tipo_accordo"),
                           Etichette.getEtichetta("Compilare_campi_obbligatori_atto_matrimonio"), Etichette.getEtichetta("Compilare_campi_obbligatori_atto_unione_civile"),
                           Etichette.getEtichetta("Compilare_campi_obbligatori_atto_nascita_sposo"), Etichette.getEtichetta("Compilare_campi_obbligatori_atto_nascita_sposa"),
                           Etichette.getEtichetta("Compilare_campi_obbligatori_atto_nascita_contraente_1"), Etichette.getEtichetta("Compilare_campi_obbligatori_atto_nascita_contraente_2"),
                           Etichette.getEtichetta("Compilare_campi_obbligatori_atto_nascita_deceduto_a"), Etichette.getEtichetta("Compilare_campi_obbligatori_atto_nascita_intestatario"),
                           Etichette.getEtichetta("Compilare_campi_obbligatori_convenzioni_patrimoniali"),
                           Etichette.getEtichetta("Compilare_campi_obbligatori_modello_istat"), Etichette.getEtichetta("Compilare_tipo_atto"),
                           Etichette.getEtichetta("Errore_ora_imprecisata"), Etichette.getEtichetta("Errore_minuti_imprecisati"),
                           Etichette.getEtichetta("Errore_data_futura"), Etichette.getEtichetta("Errore_dati_parto_plurimo"), Etichette.getEtichetta("Errore_natura_vs_certificazione"),
                           Etichette.getEtichetta("Errore_modifica_comunicazione"), Etichette.getEtichetta("Errore_recupero_file_documentale")]
        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        Throwable exception = (Throwable) Executions.getCurrent().getAttribute("javax.servlet.error.exception")

        def cause = (exception instanceof UiException ? exception.cause : null)
        if (cause != null) {
            checkException(cause)
        } else {
            checkException(exception)
        }
    }

    private void checkException(Throwable e) {

        if (e instanceof HeuristicCompletionException && e.cause != null) {
            e = e.cause
        }

        if (e instanceof UnexpectedRollbackException && e.cause != null) {
            e = e.cause
        }

        stacktrace = e.message + "\n" + e.getStackTrace().toString().replace(')', ')\n')

        if (e instanceof De4gsdzkRuntimeException){
            autoClosable = true
            stacktrace = null
            title = e.message
            if ((e instanceof NumeroProtocolloException) ||
                (e instanceof ErroreLunghezzaCampiRuntimeException) ||
                (e instanceof ErroreOrarioRuntimeException) ||
                (e instanceof ErroreValoreParteSerieException) ||
                (e instanceof ErroreDatiComunicazioneRuntimeException) ||
                (e instanceof ErroreDatiAnnotazioneRuntimeException) ||
                (e instanceof ErroreDatiAttoRuntimeException) ||
                (e instanceof ErroreTipoAttoRuntimeException) ||
                (e instanceof CompetenzeRuntimeException) ||
                (e instanceof CampoMandatoryRuntimeException) ||
                (e instanceof FileNonValidoRuntimeException) ||
                (e instanceof RecordDuplicatoRuntimeException) ||
                (e instanceof NoRecordFoundRuntimeException) ||
                (e instanceof EmptyReportException) ||
                (e instanceof StampaAttoProvvisorioException) ||
                (e instanceof AnscRuntimeException) ||
                (e instanceof ErroreCaricamentoDatiRuntimeException) ){
                String etiMsg = getEtichetta(etichette, e.getEtichetta())
                if (etiMsg){
                    title = etiMsg + " " + (e.getAdditionalInfo()?:"")
                } else {
                    title = e.getMessage()
                }
            } else if (e instanceof SqlRuntimeException) {
                SQLException sqlException = getSQLException(e)
                if (sqlException != null) {
                    title = decodeSqlExceptionMessage(e.message, sqlException, etichette)
                }
            }
        } else if (e instanceof DataIntegrityViolationException) {
            if (e.cause instanceof ConstraintViolationException && e.cause.constraintName == null) {
                title = getEtichetta(etichette, Etichette.getEtichetta("Compilare_campi_obbligatori"))
            } else {
                if ( (e.cause instanceof ConstraintViolationException) && (getSQLException(e) instanceof SQLIntegrityConstraintViolationException)) {
                    title = getEtichetta(etichette, Etichette.getEtichetta("Errore_Db_Constraint_Violation"))
                } else {
                    title = getEtichetta(etichette, Etichette.getEtichetta("Errore_Db_Integrity"))
                }
            }
        } else if (e instanceof ObjectOptimisticLockingFailureException) {
            title = getEtichetta(etichette, Etichette.getEtichetta("Errore_Db_Modifiche_Concorrenti"))
        } else if (e instanceof HibernateJdbcException) {
            title = e.getSQLException().message
        } else {
            SQLException sqlException = getSQLException(e)

            if (sqlException != null) {
                e = sqlException
            }

            String detailMsg = decodeSqlExceptionMessage(e.message, sqlException, etichette)

            title = "Errore applicativo:\n\n " + detailMsg
        }
    }


    @Command void onClose() {
        showDetails = false
        Events.postEvent("onClose", self, null)
    }

}