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
import static it.finmatica.de4gsdzk.utils.EtichetteMessaggi.*
import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichetta

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

        List<Map> eList = [Errore_Db_Modifiche_Concorrenti, Errore_Db_Integrity, Errore_serie, Errore_parte,
                           Errore_Ricerca_ANPR_No_Result,
                           Errore_consolidamento_atto_provvisorio, Errore_natura_vs_tipo_atto, Errore_natura_vs_categoria,
                           Errore_valore_ora, Errore_valore_minuti, Errore_nome_file, Errore_Lunghezza_Campo,
                           Errore_cancellazione_tipo_atto, Errore_sesso_contraenti, Errore_tipo_divorzio,
                           Errore_comune_nascita_vs_parte_serie, Errore_comune_residenza_vs_parte_serie,
                           Errore_atto_nascita_sposo_non_presente_in_archivio, Errore_atto_nascita_sposa_non_presente_in_archivio,
                           Errore_atto_nascita_contraente_1_non_presente_in_archivio, Errore_atto_nascita_contraente_2_non_presente_in_archivio,
                           Errore_atto_nascita_deceduto_non_presente_in_archivio, Errore_atto_nascita_intestatario_non_presente_in_archivio,
                           Errore_atto_nascita_soggetto_non_compatibile,
                           Errore_atto_matrimonio_non_presente_in_archivio, Errore_atto_unione_civile_non_presente_in_archivio,
                           Errore_modifica_comunicazioni_protocollate, Errore_modifica_comunicazioni_inviate_albo,
                           Errore_salvataggio_testo_comunicazione, Errore_modifica_comunicazioni_eseguite, Errore_Numero_Protocollo,
                           Errore_invio_pec_comunicazione_non_protocollata, Errore_protocollazione_comunicazioni_provvisorie,
                           Errore_Inserimento_Formula_Duplicata, Errore_Inserimento_Minuta_Duplicata,
                           Errore_Inserimento_Comunicazione_Duplicata, Errore_Inserimento_Ente_Duplicato, Errore_Inserimento_Registro_Duplicato,
                           Errore_formula_libretto_internazionale, Errore_Operazione_non_consentita,
                           Errore_Consenso_Disponente, Errore_Consenso_Fiduciario_1, Errore_Consenso_Fiduciario_2,
                           Errore_Sottoscrizione_DAT_Fiduciario_1, Errore_Sottoscrizione_DAT_Fiduciario_2, Errore_Disponente_DAT,
                           Errore_Consenso_Invio_DAT, Errore_Reperibilita_DAT, Errore_Db_Constraint_Violation,
                           Errore_inserimento_annotazione_su_provvisorio,
                           Compilare_campi_obbligatori_comunicazione,
                           Compilare_campi_obbligatori_padre, Compilare_campi_obbligatori_madre,
                           Compilare_campo_dichiarante,
                           Compilare_campi_obbligatori_sposo, Compilare_campi_obbligatori_sposa,
                           Compilare_campi_obbligatori_contraente_1, Compilare_campi_obbligatori_contraente_2,
                           Compilare_campi_obbligatori_anagrafe, Compilare_campi_obbligatori_occhiello,
                           Compilare_campi_obbligatori_deceduto_a, Compilare_campi_obbligatori_coniuge,
                           Compilare_campi_documenti_presentati, Compilare_campi_obbligatori_trasporto,
                           Compilare_campi_obbligatori_atto, Compilare_campi_obbligatori, Compilare_campi_ANPR,
                           Compilare_campi_obbligatori_tipo_divorzio, Compilare_campi_obbligatori_tipo_accordo,
                           Compilare_campi_obbligatori_atto_matrimonio, Compilare_campi_obbligatori_atto_unione_civile,
                           Compilare_campi_obbligatori_atto_nascita_sposo, Compilare_campi_obbligatori_atto_nascita_sposa,
                           Compilare_campi_obbligatori_atto_nascita_contraente_1, Compilare_campi_obbligatori_atto_nascita_contraente_2,
                           Compilare_campi_obbligatori_atto_nascita_deceduto_a, Compilare_campi_obbligatori_atto_nascita_intestatario,
                           Compilare_campi_obbligatori_convenzioni_patrimoniali,
                           Compilare_campi_obbligatori_modello_istat, Compilare_tipo_atto,
                           Errore_ora_imprecisata, Errore_minuti_imprecisati,
                           Errore_data_futura, Errore_dati_parto_plurimo, Errore_natura_vs_certificazione,
                           Errore_modifica_comunicazione, Errore_recupero_file_documentale]
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
                title = getEtichetta(etichette, Compilare_campi_obbligatori)
            } else {
                if ( (e.cause instanceof ConstraintViolationException) && (getSQLException(e) instanceof SQLIntegrityConstraintViolationException)) {
                    title = getEtichetta(etichette, Errore_Db_Constraint_Violation)
                } else {
                    title = getEtichetta(etichette, Errore_Db_Integrity)
                }
            }
        } else if (e instanceof ObjectOptimisticLockingFailureException) {
            title = getEtichetta(etichette, Errore_Db_Modifiche_Concorrenti)
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