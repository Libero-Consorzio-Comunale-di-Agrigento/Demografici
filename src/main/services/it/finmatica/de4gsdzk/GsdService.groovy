package it.finmatica.de4gsdzk

import groovy.sql.Sql
import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anagrafe.AnaTipoDocumento
import it.finmatica.de4gsdzk.anagrafe.EFascia
import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaAvanzamentoPratica
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaPratica
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaArchivioComunicazione
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaModello
import it.finmatica.de4gsdzk.ansc.AnscCredenziali
import it.finmatica.de4gsdzk.ansc.AnscUtils
import it.finmatica.de4gsdzk.archivi.ArcComune
import it.finmatica.de4gsdzk.archivi.ArcComuneBaseService
import it.finmatica.de4gsdzk.archivi.ArcParametro
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.certificazione.AnprRichiestaCertificatoResult
import it.finmatica.de4gsdzk.certificazione.CerCertificatoEmesso
import it.finmatica.de4gsdzk.competenze.CompetenzeRuntimeException
import it.finmatica.de4gsdzk.elettorale.EleTimbro
import it.finmatica.de4gsdzk.elettorale.EleTipoListaService
import it.finmatica.de4gsdzk.elettorale.SpecificheListaGenerale
import it.finmatica.de4gsdzk.elettorale.SpecificheListaSezionale
import it.finmatica.de4gsdzk.errors.*
import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
import it.finmatica.de4gsdzk.pagamento.EServizioPagamento
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import oracle.sql.BLOB
import oracle.sql.CLOB
import org.springframework.jdbc.BadSqlGrammarException
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate
import org.springframework.jdbc.datasource.DataSourceUtils
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

import javax.sql.DataSource
import java.sql.Connection
import java.sql.SQLException

@Slf4j
@Transactional
@Service
class GsdService {

    static final String ERRORE_CAMPI_CF = "errore_calcolo_cf_campi_mancanti"

    private final UtenteCustomService utenteCustomService

    private final ArcComuneBaseService arcComuneBaseService

    private final ArcParametroService arcParametroService

    private final DataSource dataSource

    GsdService(DataSource dataSource,
               UtenteCustomService utenteCustomService, ArcComuneBaseService arcComuneBaseService, ArcParametroService arcParametroService) {

        this.dataSource = dataSource
        this.utenteCustomService = utenteCustomService
        this.arcComuneBaseService = arcComuneBaseService
        this.arcParametroService = arcParametroService
    }

    Integer getLoggedUserUfficio() {
        Map<String, Integer> lm
        //try {
        NamedParameterJdbcTemplate np = new NamedParameterJdbcTemplate(dataSource)

        String sql = "SELECT MIN(UFFICIO) UFFICIO FROM CIVUFF WHERE TERMINALISTA = :utente"

        MapSqlParameterSource sqlparams = new MapSqlParameterSource("utente", utenteCustomService.loggedUserId)

        lm = np.queryForMap(sql, sqlparams)
        /*
        } catch (IncorrectResultSizeDataAccessException e) {
            // refs #60821
            log.info("Utente censito più volte in civuff")
            lm = [UFFICIO: new Integer(1)]
        }
        */
        if ((lm == null) || (lm.UFFICIO == null)) {
            throw new CompetenzeRuntimeException(Etichette.getEtichetta("Errore_Competenze_Ufficio_Utente"))
        }
        return lm.UFFICIO.intValueExact()
    }

    List<Integer> listUffici(Boolean checkUtente = Boolean.FALSE) {
        NamedParameterJdbcTemplate np = new NamedParameterJdbcTemplate(dataSource)
        // refs #60821
        MapSqlParameterSource sqlparams = new MapSqlParameterSource()
        StringBuilder sql = new StringBuilder("SELECT DISTINCT UFFICIO FROM CIVUFF")
        if (checkUtente) {
            sql.append(" WHERE TERMINALISTA = :utente ")
            sqlparams.addValue("utente", utenteCustomService.loggedUserId)
        }

        List<Integer> listaUffici = np.queryForList(sql.toString(), sqlparams, Integer.class)
        return listaUffici
    }

    List<String> listRiti() {
        NamedParameterJdbcTemplate np = new NamedParameterJdbcTemplate(dataSource)
        String sql = "SELECT DISTINCT(RITO) AS RITO FROM CIVMAT_RITI_V WHERE RITO IS NOT NULL ORDER BY RITO"
        List<String> listaRiti = np.queryForList(sql, new MapSqlParameterSource(), String.class)
        return listaRiti
    }

    List<ArchivioIstat> listArchivioIstat(String viewName, Integer anno, ETipoArchivioIstat ta = null) {
        NamedParameterJdbcTemplate np = new NamedParameterJdbcTemplate(dataSource)

        MapSqlParameterSource sqlparams = new MapSqlParameterSource()

        StringBuilder sql = new StringBuilder("SELECT V.CODICE_ISTAT, V.DESCRIZIONE, V.CODICE_ADS, V.COD_ARCHIVIO FROM ${viewName} V WHERE 1 = 1 ")

        if (ta != null) {
            sql.append(" AND V.COD_ARCHIVIO = :archivio ")
            sqlparams.addValue("archivio", ta.name())
        }

        if (anno != null) {
            sql.append(" AND :anno BETWEEN V.DA_ANNO AND V.A_ANNO")
            sqlparams.addValue("anno", anno)
        }

        sql.append(" ORDER BY V.CODICE_ISTAT")

        String sqlStatement = sql.toString()
        List<Map> lm = np.queryForList(sqlStatement, sqlparams)
        List<ArchivioIstat> lRet = []
        for (Map m : lm) {
            lRet.add(new ArchivioIstat(m.CODICE_ISTAT.intValueExact(), m.DESCRIZIONE, m.CODICE_ADS, ETipoArchivioIstat.valueOf(m.COD_ARCHIVIO)))
        }
        return lRet
    }

    List<Map<String, String>> listAutorita(Integer tipoAtto, Map params) {
        NamedParameterJdbcTemplate np = new NamedParameterJdbcTemplate(dataSource)
        StringBuilder sql = new StringBuilder("SELECT DISTINCT AUTORITA, COMUNE FROM CIVDPA_V_AUTORITA WHERE TIPO_ATTO = :tipoAtto ")

        MapSqlParameterSource sqlparams = new MapSqlParameterSource("tipoAtto", tipoAtto)

        checkForAddParteParams(sql, sqlparams, params)

        checkForAddSerieParams(sql, sqlparams, params)

        if (params.categoria != null) {
            sql.append(" AND UPPER(CATEGORIA) = UPPER(:categoria) ")
            sqlparams.addValue("categoria", params.categoria)
        }
        if (params.filtro != null) {
            sql.append(" AND UPPER(AUTORITA) LIKE UPPER(:filtro) ")
            sqlparams.addValue("filtro", params.filtro)
        }
        sql.append(" ORDER BY AUTORITA")

        String sqlStatement = sql.toString()
        List<Map<String, String>> lm = np.queryForList(sqlStatement, sqlparams)
        return lm
    }

    List<Map<String, Object>> listVociMenuTipiAttoByTipoAtto(Integer tipoAtto, Map params = null) {
        NamedParameterJdbcTemplate np = new NamedParameterJdbcTemplate(dataSource)

        StringBuilder sql = new StringBuilder("""SELECT ID, PARTE, SERIE, TIPO, ID_CATEGORIA, CATEGORIA, DESCRIZIONE_VOCE   
 													   FROM CIVDTA_V_CATEGORIE WHERE TIPO_ATTO = :tipoAtto """)

        MapSqlParameterSource sqlparams = new MapSqlParameterSource("tipoAtto", tipoAtto)

        if (arcParametroService.isIntegrazioneAnscAttiva()) {
            sql.append(" AND FLAG_ANSC = 'S' ")
        } else {
            sql.append(" AND FLAG_ANSC IS NULL ")
        }

        if (params?.flagPregresso) {
            sql.append(" AND FLAG_PREGRESSO = 'S' ")
        } else {
            sql.append(" AND FLAG_PREGRESSO IS NULL ")
        }

        if (params?.flagDivorzio) {
            sql.append(" AND FLAG_DIVORZIO = 'S' ")
        } else {
            sql.append(" AND FLAG_DIVORZIO IS NULL ")
        }

        if (params?.flagVerbale) {
            sql.append(" AND FLAG_VERBALE = 'S' ")
        } else {
            sql.append(" AND FLAG_VERBALE IS NULL ")
        }

        if (params?.tipo) {
            sql.append(" AND TIPO = :tipo ")
            sqlparams.addValue("tipo", params.tipo)
        }

        sql.append(" ORDER BY SEQUENZA ")

        String sqlStatement = sql.toString()
        List<Map<String, Object>> lm = np.queryForList(sqlStatement, sqlparams)
        return lm
    }

    /**
     * Elenca tutte le variabili associate a una data tabella (entity)
     *
     * @param entity l'entity di cui si richiedono le variabili associate
     * @param tipoAtto filtro per tipologia di atto
     * @param filtro filtro aggiuntivo (sul nome della variabile)
     * @return la lista delle variabili (key->value)
     */
    List<String> listVariabili(Object entity, Integer tipoAtto, String filtro = null, String campo = "VARIABILE") {
        String tableName = DomainUtils.getTableName(entity) + "_VAR"
        NamedParameterJdbcTemplate np = new NamedParameterJdbcTemplate(dataSource)
        StringBuilder sql = new StringBuilder("SELECT " + campo + " AS VAR FROM " + tableName + " WHERE TIPO_ATTO = :tipoAtto ")

        MapSqlParameterSource sqlparams = new MapSqlParameterSource("tipoAtto", tipoAtto)

        if ((filtro ?: "") != "") {
            sql.append(" AND UPPER(" + campo + ") LIKE UPPER(:filtro) ")
            sqlparams.addValue("filtro", filtro)
        }
        sql.append(" AND " + campo + " IS NOT NULL ")

        sql.append(" ORDER BY 1 ")

        String sqlStatement = sql.toString()
        List<String> lm = np.queryForList(sqlStatement, sqlparams, String.class)
        return lm
    }

    List<String> listFormuleAnnotazione(Integer tipoAtto, Map params) {
        NamedParameterJdbcTemplate np = new NamedParameterJdbcTemplate(dataSource)

        StringBuilder sql = new StringBuilder(""" SELECT DISTINCT FORMULA FROM CIVCTA_V_FORMULE_ANN WHERE TIPO_ATTO = :tipoAtto """)

        MapSqlParameterSource sqlparams = new MapSqlParameterSource("tipoAtto", tipoAtto)

        if (params?.categoria != null) {
            sql.append(" AND SIGLA_CATEGORIA = :categoria ")
            sqlparams.addValue("categoria", params.categoria)
        }

        if (params?.flagDivorzio) {
            sql.append(" AND FLAG_DIVORZIO = :flagDivorzio ")
            sqlparams.addValue("flagDivorzio", ETipoSN.S.name())
        } else {
            sql.append(" AND FLAG_DIVORZIO IS NULL ")
        }

        if (params?.tipoAttoAnnotazione) {
            sql.append(" AND TIPO_ATTO_ANN = :tipoAttoAnnotazione ")
            sqlparams.addValue("tipoAttoAnnotazione", params.tipoAttoAnnotazione)
        }

        if (params?.tipoDivorzio) {
            sql.append(" AND TIPO_DIVORZIO = :tipoDivorzio ")
            sqlparams.addValue("tipoDivorzio", params.tipoDivorzio.name())
        }

        String sqlStatement = sql.toString()
        List<String> lm = np.queryForList(sqlStatement, sqlparams, String.class)
        return lm
    }

    int countMinorenni(String identificativoAtto) {
        List<Map<String, Object>> result = listMinorenni(identificativoAtto, "C")
        Map<String, Object> countMinorenni = result?.size() > 0 ? result.get(0) : null
        if (countMinorenni) {
            return countMinorenni.TOT.intValueExact()
        }
        return 0
    }

    List<Map<String, Object>> listMinorenni(String identificativoAtto, String tipoQuery = "D") {
        NamedParameterJdbcTemplate np = new NamedParameterJdbcTemplate(dataSource)

        String campiQuery = """ MATRICOLA, COGNOME_NOME, D_DATA_NAS, SESSO, DES_RAPPORTO_PAR, COD_COM_RES, COD_PRO_RES, 
                                DES_NAZIONALITA, ANNO_FG, ATTO_FG, ID_CIVDTA  """
        if (tipoQuery == "C") {
            campiQuery = "COUNT(*) AS TOT"
        }
        StringBuilder sql = new StringBuilder(""" SELECT ${campiQuery} FROM CIVCIT_FG_RECUPERO WHERE ID_ATTO = :identificativoAtto """)

        MapSqlParameterSource sqlparams = new MapSqlParameterSource("identificativoAtto", identificativoAtto)

        String sqlStatement = sql.toString()
        List<Map<String, Object>> lm = np.queryForList(sqlStatement, sqlparams)
        return lm
    }

    private void checkForAddListParams(StringBuilder sql, MapSqlParameterSource sqlparams, Map params) {
        if (params?.flagDefault) {
            sql.append(" AND FLAG_DEFAULT = :flagDefault ")
            sqlparams.addValue("flagDefault", ETipoSN.S.name())
        }
        if (params?.flagRicorrente) {
            sql.append(" AND FLAG_RICORRENTE = :flagRicorrente ")
            sqlparams.addValue("flagRicorrente", ETipoSN.S.name())
        }
        if (params?.flagTestoFisso) {
            sql.append(" AND FLAG_TESTO_FISSO = :flagTestoFisso ")
            sqlparams.addValue("flagTestoFisso", ETipoSN.S.name())
        }
        /*
        if (params?.flagDb){
            sql.append(" AND FLAG_DB = :flagDb ")
            sqlparams.addValue("flagDb", ETipoSN.S.name())
        }
        */
    }

    private void checkForAddParteParams(StringBuilder sql, MapSqlParameterSource sqlparams, Map params) {
        if (params?.parte != null) {
            sql.append(" AND PARTE = :parte ")
            sqlparams.addValue("parte", params.parte)
        }
    }

    private void checkForAddSerieParams(StringBuilder sql, MapSqlParameterSource sqlparams, Map params) {
        if ((params?.serie ?: "") != "") {
            sql.append("AND SERIE = :serie ")
            sqlparams.addValue("serie", params.serie)
        }
    }

    private void checkForAddNaturaParams(StringBuilder sql, MapSqlParameterSource sqlparams, Map params) {
        if (params?.natura) {
            sql.append(" AND COALESCE(NATURA, :natura) = :natura ")
            sqlparams.addValue("natura", params.natura.name())
        }
    }

    private void checkForAddMinutaParams(StringBuilder sql, MapSqlParameterSource sqlparams, Map params) {
        if (params?.codiceMinuta != null) {
            sql.append(" AND COALESCE(COD_MINUTA, :codiceMinuta) = :codiceMinuta ")
            sqlparams.addValue("codiceMinuta", params.codiceMinuta)
        }
    }

    private void checkForAddCategoriaParams(StringBuilder sql, MapSqlParameterSource sqlparams, Map params) {
        if ((params?.categoria ?: "") != "") {
            sql.append(" AND SIGLA_CATEGORIA = :categoria ")
            sqlparams.addValue("categoria", params.categoria)
        }
    }

    private void checkForAddTipoRichiestaParams(StringBuilder sql, MapSqlParameterSource sqlparams, Map params) {
        if ((params?.tipoRichiesta ?: "") != "") {
            sql.append(" AND TIPO_RICHIESTA = :tipoRichiesta OR TIPO_RICHIESTA IS NULL")
            sqlparams.addValue("tipoRichiesta", params.tipoRichiesta)
        }
    }

    private void checkForAddFiltroParams(StringBuilder sql, MapSqlParameterSource sqlparams, Map params) {
        if ((params?.filtro ?: "") != "") {
            sql.append(" AND LOWER(DES_FORMULA) LIKE :filtro ")
            sqlparams.addValue("filtro", "%" + params.filtro.toLowerCase() + "%")
        }
    }

    private void checkForAddProgressivoParams(StringBuilder sql, MapSqlParameterSource sqlparams, Map params) {
        if (params?.progressivo != null) {
            if (params?.searchEqual) {
                sql.append(" AND PROGR_DETTAGLIO = :progressivo ")
            }
            if (params?.searchGreater) {
                sql.append(" AND PROGR_DETTAGLIO > :progressivo ")
            }
            sqlparams.addValue("progressivo", params.progressivo)
        }
    }

    private void checkForAddNatoMortoParams(StringBuilder sql, MapSqlParameterSource sqlparams, Map params) {
        if (params?.natoMorto) {
            switch (params.natoMorto) {
                case EStatoNascita.Nato_morto:
                    sql.append(" AND NATO_MORTO = :natoMorto ")
                    sqlparams.addValue("natoMorto", ETipoSiNo.SI.name())
                    break
                case EStatoNascita.Vivo_morto:
                    sql.append(" AND NATO_MORTO = :natoMorto ")
                    sqlparams.addValue("natoMorto", ETipoSiNo.NO.name())
                    break
                default:
                    sql.append(" AND NATO_MORTO IS NULL ")
                    break
            }
        }
    }

    private void checkForAddTipoFiliazioneParams(StringBuilder sql, MapSqlParameterSource sqlparams, Map params) {
        if (params?.tipoFiliazione) {
            sql.append(" AND COALESCE(TIPO_FILIAZIONE, :tipoFiliazione ) = :tipoFiliazione ")
            sqlparams.addValue("tipoFiliazione", params.tipoFiliazione)
        }
    }

    private void checkForAddTipoConsensoParams(StringBuilder sql, MapSqlParameterSource sqlparams, Map params) {
        if (params?.tipoConsenso) {
            sql.append(" AND TIPO_CONSENSO = :tipoConsenso ")
            sqlparams.addValue("tipoConsenso", params.tipoConsenso?.name())
        } else {
            sql.append(" AND TIPO_CONSENSO IS NULL ")
        }
    }

    private void checkForAddTipoRiconoscimentoParams(StringBuilder sql, MapSqlParameterSource sqlparams, Map params) {
        if (params?.tipoRiconoscimento) {
            sql.append(" AND TIPO_RICONOSCIMENTO LIKE :tipoRiconoscimento ")
            sqlparams.addValue("tipoRiconoscimento", (params.tipoRiconoscimento.name() + "%"))
        } else {
            sql.append(" AND TIPO_RICONOSCIMENTO IS NULL ")
        }
    }

    private void checkForAddComprensioneDichiaranteParams(StringBuilder sql, MapSqlParameterSource sqlparams, Map params) {
        if (params?.comprensioneDichiarante) {
            sql.append(" AND COALESCE(COMPRENSIONE_DIC, :comprensioneDichiarante ) LIKE :comprensioneDichiarante ")
            sqlparams.addValue("comprensioneDichiarante", ("%" + params.comprensioneDichiarante + "%"))
        }
    }

    private String getSqlBase(String viewName) {
        /* refs  #64681
        return """ SELECT DISTINCT RICHIAMO, PROGR_DETTAGLIO, FORMULA, TESTO_FORMULA, DES_FORMULA, NUM_RIGHE, NUM_COLONNE
                        , FLAG_TESTO_FISSO, FLAG_RICORRENTE, FLAG_AGGIUNTA_A_CAPO, FLAG_AGGIUNTA_RICHIAMO, FLAG_DEFAULT
                    FROM ${viewName} WHERE RICHIAMO = :richiamo """
        */
        return """ SELECT DISTINCT RICHIAMO, PROGR_DETTAGLIO, FORMULA, TABELLA_RIF, ID_RIF, DES_FORMULA, NUM_RIGHE, NUM_COLONNE  
						, FLAG_TESTO_FISSO, FLAG_RICORRENTE, FLAG_AGGIUNTA_A_CAPO, FLAG_AGGIUNTA_RICHIAMO, FLAG_DEFAULT, TIPO_RICHIESTA 
					FROM ${viewName} WHERE RICHIAMO = :richiamo """
    }

    private List<Map<String, Object>> listFormule(String sqlStatement, MapSqlParameterSource sqlparams) {
        NamedParameterJdbcTemplate np = new NamedParameterJdbcTemplate(dataSource)

        List<Map<String, Object>> lm
        try {
            lm = np.queryForList(sqlStatement, sqlparams)
        } catch (BadSqlGrammarException ex) {
            log.error("Errore in sql: " + sqlStatement, ex)
            throw new ErroreCaricamentoDatiRuntimeException(Etichette.getEtichetta("Errore_caricamento_formule"))
        }
        List<Map<String, Object>> orderedList
        try {
            orderedList = lm?.sort { a, b ->
                int nullTrA = (a.TIPO_RICHIESTA == null) ? 1 : 0
                int nullTrB = (b.TIPO_RICHIESTA == null) ? 1 : 0
                int nullTrcmp = nullTrA <=> nullTrB
                if (nullTrcmp != 0) return nullTrcmp

                String subA = descrFormulaSubstring(a.DES_FORMULA as String)
                String subB = descrFormulaSubstring(b.DES_FORMULA as String)
                return subA <=> subB
            }
        } catch (Exception ex) {
            log.error("Errore in ordinamento formule", ex)
            orderedList = lm
        }
        return orderedList
    }

    private String descrFormulaSubstring(String string) {
        int idx = string.indexOf(")") ?: 0
        return string.substring(idx)
    }

    List<Map<String, Object>> listFormuleCittadinanza(Integer richiamo, Map params) {
        StringBuilder sql = new StringBuilder(getSqlBase("CIVDRF_V_CIT"))

        MapSqlParameterSource sqlparams = new MapSqlParameterSource("richiamo", richiamo)

        checkForAddListParams(sql, sqlparams, params)

        checkForAddNaturaParams(sql, sqlparams, params)

        checkForAddMinutaParams(sql, sqlparams, params)

        checkForAddCategoriaParams(sql, sqlparams, params)

        checkForAddProgressivoParams(sql, sqlparams, params)

        checkForAddFiltroParams(sql, sqlparams, params)

        checkForAddTipoRichiestaParams(sql, sqlparams, params)

        return listFormule(sql.toString(), sqlparams)
    }

    List<Map<String, Object>> listFormuleScioglimento(Integer richiamo, Map params) {
        StringBuilder sql = new StringBuilder(getSqlBase("CIVDRF_V_SCI"))

        MapSqlParameterSource sqlparams = new MapSqlParameterSource("richiamo", richiamo)

        checkForAddParteParams(sql, sqlparams, params)

        checkForAddListParams(sql, sqlparams, params)

        checkForAddNaturaParams(sql, sqlparams, params)

        checkForAddMinutaParams(sql, sqlparams, params)

        checkForAddCategoriaParams(sql, sqlparams, params)

        checkForAddProgressivoParams(sql, sqlparams, params)

        checkForAddFiltroParams(sql, sqlparams, params)
        /*
        if (params?.tipoDichiarante){
            sql.append(" AND COALESCE(TIPO_DICHIARANTE, :tipoDichiarante) = :tipoDichiarante ")
            sqlparams.addValue("tipoDichiarante", params.tipoDichiarante)
        }
        */

        if (params?.avvocati != null) {
            sql.append(" AND PRESENZA_AVVOCATI LIKE :avvocati ")
            sqlparams.addValue("avvocati", ("%" + params.avvocati + "%"))
        }

        return listFormule(sql.toString(), sqlparams)
    }

    List<Map<String, Object>> listFormuleUnioneCivile(Integer richiamo, Map params) {
        StringBuilder sql = new StringBuilder(getSqlBase("CIVDRF_V_UCI"))

        MapSqlParameterSource sqlparams = new MapSqlParameterSource("richiamo", richiamo)

        checkForAddParteParams(sql, sqlparams, params)

        checkForAddListParams(sql, sqlparams, params)

        checkForAddNaturaParams(sql, sqlparams, params)

        checkForAddMinutaParams(sql, sqlparams, params)

        checkForAddCategoriaParams(sql, sqlparams, params)

        checkForAddProgressivoParams(sql, sqlparams, params)

        checkForAddFiltroParams(sql, sqlparams, params)

        if (params?.sceltaCognome) {
            sql.append(" AND SCELTA_COGNOME = :sceltaCognome ")
            sqlparams.addValue("sceltaCognome", params.sceltaCognome)
        }

        if (params?.sceltaCognome1) {
            sql.append(" AND SCELTA_COGNOME_1 = :sceltaCognome1 ")
            sqlparams.addValue("sceltaCognome1", params.sceltaCognome1)
        }

        if (params?.sceltaCognome2) {
            sql.append(" AND SCELTA_COGNOME_2 = :sceltaCognome2 ")
            sqlparams.addValue("sceltaCognome2", params.sceltaCognome2)
        }

        if (params?.documentoPresentatoPubblicazione) {
            sql.append(" AND DOCUMENTI_PRESENTATI_UCI = :documentoPresentatoPubblicazione ")
            sqlparams.addValue("documentoPresentatoPubblicazione", params.documentoPresentatoPubblicazione.name())
        }

        if (params?.convenzioni) {
            sql.append(" AND CONVENZIONI_PATRIMONIALI = :convenzioni ")
            sqlparams.addValue("convenzioni", params.convenzioni)
        }

        return listFormule(sql.toString(), sqlparams)
    }

    List<Map<String, Object>> listFormuleProcessoVerbale(Integer richiamo, Map params) {
        StringBuilder sql = new StringBuilder(getSqlBase("CIVDRF_V_PVU"))

        MapSqlParameterSource sqlparams = new MapSqlParameterSource("richiamo", richiamo)

        checkForAddListParams(sql, sqlparams, params)

        checkForAddNaturaParams(sql, sqlparams, params)

        checkForAddMinutaParams(sql, sqlparams, params)

        checkForAddCategoriaParams(sql, sqlparams, params)

        checkForAddProgressivoParams(sql, sqlparams, params)

        checkForAddFiltroParams(sql, sqlparams, params)

        if (params?.documentoPresentatoPubblicazione) {
            sql.append(" AND DOCUMENTI_PRESENTATI_PUB LIKE :documentoPresentatoPubblicazione ")
            sqlparams.addValue("documentoPresentatoPubblicazione", ("%" + params.documentoPresentatoPubblicazione.name() + "%"))
        }

        return listFormule(sql.toString(), sqlparams)
    }

    List<Map<String, Object>> listFormuleDecesso(Integer richiamo, Map params) {
        StringBuilder sql = new StringBuilder(getSqlBase("CIVDRF_V_MOR"))

        MapSqlParameterSource sqlparams = new MapSqlParameterSource("richiamo", richiamo)

        checkForAddParteParams(sql, sqlparams, params)

        checkForAddSerieParams(sql, sqlparams, params)

        checkForAddListParams(sql, sqlparams, params)

        checkForAddNaturaParams(sql, sqlparams, params)

        checkForAddMinutaParams(sql, sqlparams, params)

        if (params?.tipoComparente) {
            sql.append(" AND COALESCE(TIPO_COMPARENTE, :tipoComparente ) = :tipoComparente ")
            sqlparams.addValue("tipoComparente", params.tipoComparente)
        }
        if (params?.tipoFirmatario) {
            sql.append(" AND COALESCE(TIPO_FIRMATARIO, :tipoFirmatario ) = :tipoFirmatario ")
            sqlparams.addValue("tipoFirmatario", params.tipoFirmatario)
        }

        checkForAddComprensioneDichiaranteParams(sql, sqlparams, params)

        checkForAddCategoriaParams(sql, sqlparams, params)

        checkForAddProgressivoParams(sql, sqlparams, params)

        checkForAddFiltroParams(sql, sqlparams, params)

        return listFormule(sql.toString(), sqlparams)
    }

    List<Map<String, Object>> listFormuleDivorzio(Integer richiamo, Map params) {
        StringBuilder sql = new StringBuilder(getSqlBase("CIVDRF_V_MAT"))

        MapSqlParameterSource sqlparams = new MapSqlParameterSource("richiamo", richiamo)

        checkForAddParteParams(sql, sqlparams, params)

        checkForAddSerieParams(sql, sqlparams, params)

        checkForAddListParams(sql, sqlparams, params)

        checkForAddNaturaParams(sql, sqlparams, params)

        checkForAddMinutaParams(sql, sqlparams, params)

        checkForAddCategoriaParams(sql, sqlparams, params)

        checkForAddProgressivoParams(sql, sqlparams, params)

        checkForAddFiltroParams(sql, sqlparams, params)

        if (params?.avvocati != null) {
            sql.append(" AND PRESENZA_AVVOCATI LIKE :avvocati ")
            sqlparams.addValue("avvocati", ("%" + params.avvocati + "%"))
        }

        if (params?.tipoDivorzio != null) {
            sql.append(" AND TIPO_DIVORZIO LIKE :tipoDivorzio ")
            sqlparams.addValue("tipoDivorzio", ("%" + params.tipoDivorzio + "%"))
        }

        return listFormule(sql.toString(), sqlparams)
    }

    List<Map<String, Object>> listFormulePubblicazione(Integer richiamo, Map params) {
        StringBuilder sql = new StringBuilder(getSqlBase("CIVDRF_V_PUB"))

        MapSqlParameterSource sqlparams = new MapSqlParameterSource("richiamo", richiamo)

        checkForAddParteParams(sql, sqlparams, params)

        checkForAddSerieParams(sql, sqlparams, params)

        checkForAddNaturaParams(sql, sqlparams, params)

        checkForAddMinutaParams(sql, sqlparams, params)

        checkForAddCategoriaParams(sql, sqlparams, params)

        checkForAddProgressivoParams(sql, sqlparams, params)

        checkForAddFiltroParams(sql, sqlparams, params)

        if (params?.tipoDichiarante) {
            sql.append(" AND TIPO_DICHIARANTE = :tipoDichiarante ")
            sqlparams.addValue("tipoDichiarante", params.tipoDichiarante)
        }
        if (params?.documentoPresentatoMatrimonio) {
            sql.append(" AND COALESCE(DOCUMENTI_PRESENTATI_MAT, :documentoPresentatoMatrimonio ) LIKE :documentoPresentatoMatrimonio ")
            sqlparams.addValue("documentoPresentatoMatrimonio", ("%" + params.documentoPresentatoMatrimonio + "%"))
        }
        if (params?.documentoPresentatoPubblicazione) {
            sql.append(" AND DOCUMENTI_PRESENTATI_PUB = :documentoPresentatoPubblicazione ")
            sqlparams.addValue("documentoPresentatoPubblicazione", params.documentoPresentatoPubblicazione.name())
        }

        checkForAddListParams(sql, sqlparams, params)

        if (params?.flagDb) {
            sql.append(" AND FLAG_DB = :flagDb ")
            sqlparams.addValue("flagDb", ETipoSN.S.name())
        }

        return listFormule(sql.toString(), sqlparams)
    }

    List<Map<String, Object>> listFormuleMatrimonio(Integer richiamo, Map params) {
        StringBuilder sql = new StringBuilder(getSqlBase("CIVDRF_V_MAT"))

        MapSqlParameterSource sqlparams = new MapSqlParameterSource("richiamo", richiamo)

        checkForAddParteParams(sql, sqlparams, params)

        checkForAddSerieParams(sql, sqlparams, params)

        checkForAddListParams(sql, sqlparams, params)

        checkForAddNaturaParams(sql, sqlparams, params)

        checkForAddMinutaParams(sql, sqlparams, params)

        checkForAddCategoriaParams(sql, sqlparams, params)

        checkForAddProgressivoParams(sql, sqlparams, params)

        checkForAddFiltroParams(sql, sqlparams, params)

        if (params?.tipoDichiarante) {
            sql.append(" AND TIPO_DICHIARANTE = :tipoDichiarante ")
            sqlparams.addValue("tipoDichiarante", params.tipoDichiarante)
        }
        if (params?.documentoPresentatoMatrimonio) {
            sql.append(" AND COALESCE(DOCUMENTI_PRESENTATI_MAT, :documentoPresentatoMatrimonio ) LIKE :documentoPresentatoMatrimonio ")
            sqlparams.addValue("documentoPresentatoMatrimonio", ("%" + params.documentoPresentatoMatrimonio + "%"))
        }
        if (params?.convenzioni) {
            sql.append(" AND CONVENZIONI_PATRIMONIALI = :convenzioni ")
            sqlparams.addValue("convenzioni", params.convenzioni)
        }

        return listFormule(sql.toString(), sqlparams)
    }

    List<Map<String, Object>> listFormuleNascita(Integer richiamo, Map params) {
        StringBuilder sql = new StringBuilder(getSqlBase("CIVDRF_V_NAS"))

        MapSqlParameterSource sqlparams = new MapSqlParameterSource("richiamo", richiamo)

        checkForAddParteParams(sql, sqlparams, params)

        checkForAddSerieParams(sql, sqlparams, params)

        checkForAddListParams(sql, sqlparams, params)

        checkForAddNaturaParams(sql, sqlparams, params)

        checkForAddMinutaParams(sql, sqlparams, params)

        checkForAddCategoriaParams(sql, sqlparams, params)

        checkForAddProgressivoParams(sql, sqlparams, params)

        checkForAddFiltroParams(sql, sqlparams, params)

        checkForAddTipoRichiestaParams(sql, sqlparams, params)

        checkForAddNatoMortoParams(sql, sqlparams, params)

        if (params?.partoPlurimo) {
            sql.append(" AND PARTO_PLURIMO = :partoPlurimo ")
            sqlparams.addValue("partoPlurimo", ETipoSiNo.SI.name())
            sql.append(" AND PARTO_PLURIMO_FLAG_PRIMO = :primo ")
            if (params?.numeroGemello?.intValue() == 1) {
                sqlparams.addValue("primo", ETipoSN.S.name())
            } else {
                sqlparams.addValue("primo", ETipoSN.N.name())
            }
            sql.append(" AND PARTO_PLURIMO_FLAG_ULTIMO = :ultimo ")
            if (params?.numeroGemello?.compareTo(params.totaleGemelli) == 0) {
                sqlparams.addValue("ultimo", ETipoSN.S.name())
            } else {
                sqlparams.addValue("ultimo", ETipoSN.N.name())
            }
            sql.append(" AND PARTO_PLURIMO_FLAG_BIGEMINO = :bigemino ")
            if (params?.totaleGemelli?.intValue() == 2) {
                sqlparams.addValue("bigemino", ETipoSN.S.name())
            } else {
                sqlparams.addValue("bigemino", ETipoSN.N.name())
            }
        }

        checkForAddTipoFiliazioneParams(sql, sqlparams, params)

        checkForAddTipoConsensoParams(sql, sqlparams, params)

        checkForAddTipoRiconoscimentoParams(sql, sqlparams, params)

        if (params?.tipoDichiarante) {
            sql.append(" AND COALESCE(TIPO_DICHIARANTE, :tipoDichiarante ) LIKE :tipoDichiarante ")
            sqlparams.addValue("tipoDichiarante", ("%" + params.tipoDichiarante + "%"))
        }
        if (params?.tipoComparente) {
            sql.append(" AND COALESCE(TIPO_COMPARENTE, :tipoComparente ) = :tipoComparente ")
            sqlparams.addValue("tipoComparente", params.tipoComparente)
        }
        if (params?.tipoFirmatario) {
            sql.append(" AND COALESCE(TIPO_FIRMATARIO, :tipoFirmatario ) = :tipoFirmatario ")
            sqlparams.addValue("tipoFirmatario", params.tipoFirmatario)
        }

        checkForAddComprensioneDichiaranteParams(sql, sqlparams, params)

        if (params?.tipoAddettoDichiarazione) {
            sql.append(" AND COALESCE(TIPO_ADDETTO_DICHIARAZIONE_CNA, :tipoAddettoDichiarazione) LIKE :tipoAddettoDichiarazione ")
            sqlparams.addValue("tipoAddettoDichiarazione", ("%" + params.tipoAddettoDichiarazione + "%"))
        }

        return listFormule(sql.toString(), sqlparams)
    }

    List<Map<String, ?>> anscQuery(Map<String, String> mCampi, String vista, String parametro, Boolean flagOtpFirma,
                                   Long idRif, Long pkAtto, Long idOperazione, AnscCredenziali cre, IRicercaAnsc ricerca = null, IAnscPaginazione paginazione = null, IRicercaEventoAnsc ricercaEvento = null) {
        List<Map<String, ?>> lVal = []
        Set<String> campiDb = mCampi.keySet()
        List<String> campiQuery = []
        NamedParameterJdbcTemplate np = new NamedParameterJdbcTemplate(dataSource)
        MapSqlParameterSource sqlparamsFinal = new MapSqlParameterSource()

        StringBuilder sqlFinal = new StringBuilder("SELECT ")
        for (String c : campiDb) {
            if (c.equalsIgnoreCase(AnscUtils.parametroIdOperazione) && (parametro.equals(AnscUtils.parametroIdOperazione)) && (idOperazione != null)) {
                campiQuery.add("${idOperazione} ${c}")

            } else if (c.equalsIgnoreCase(AnscUtils.parametroFirma1) && flagOtpFirma && (cre != null)) {
                campiQuery.add("'${cre.getUtenteFirmaRemota()}' ${c}")
            } else if (c.equalsIgnoreCase(AnscUtils.parametroFirma2) && flagOtpFirma && (cre != null)) {
                campiQuery.add("'${cre.getPwdFirmaRemota()}' ${c}")
            } else if (c.equalsIgnoreCase(AnscUtils.parametroFirma3) && flagOtpFirma && (cre != null)) {
                campiQuery.add("'${cre.getOtpFirmaRemota()}' ${c}")

            } else if (c.equalsIgnoreCase(AnscUtils.parametroDataInizioRicercaNot) && (ricerca != null)) {
                if (ricerca?.getDal() != null) {
                    String dataInizioRicercaNotString = DataUtils.fromDateToString(ricerca.dal, "yyyy-MM-dd")
                    campiQuery.add("'${dataInizioRicercaNotString}' AS ${c}")
                }

            } else if (c.equalsIgnoreCase(AnscUtils.parametroDataFineRicercaNot) && (ricerca != null)) {
                Date dataFineRicercaNot = (ricerca.al ?: new Date())
                String dataFineRicercaNotString = DataUtils.fromDateToString(dataFineRicercaNot, "yyyy-MM-dd")
                campiQuery.add("'${dataFineRicercaNotString}' AS ${c}")

            } else if (c.equalsIgnoreCase(AnscUtils.parametroIdTipoEventoRicercaNot) && (ricerca != null)) {
                if (ricerca?.getTipoEventoAnsc() != null) {
                    campiQuery.add("${ricerca.getTipoEventoAnsc().valore} AS ${c}")
                }

            } else if (c.equalsIgnoreCase(AnscUtils.parametroIdGenereRicercaNot) && (ricerca != null)) {
                if (ricerca?.getGenereNotifica() != null) {
                    campiQuery.add("${ricerca.getGenereNotifica().valore} AS ${c}")
                }

            } else if (c.equalsIgnoreCase(AnscUtils.parametroIdStatoFlussoRicercaNot) && (ricerca != null)) {
                if (ricerca?.getStatoNotifica() != null) {
                    campiQuery.add("${ricerca.getStatoNotifica().valore} AS ${c}")
                }

            } else if (c.equalsIgnoreCase(AnscUtils.parametroIdTipoContenutoRicercaNot) && (ricerca != null)) {
                if (ricerca?.getTipoContenutoNotifica() != null) {
                    campiQuery.add("${ricerca.getTipoContenutoNotifica().valore} AS ${c}")
                }

            } else if (c.equalsIgnoreCase(AnscUtils.parametroCognomeSoggettoPar) && (ricerca != null)) {
                if (ricerca?.getCognome() != null) {
                    campiQuery.add("'${ricerca.getCognome().replaceAll("'", "''")}' AS ${c}")
                }

            } else if (c.equalsIgnoreCase(AnscUtils.parametroNomeSoggettoPar) && (ricerca != null)) {
                if (ricerca?.getNome() != null) {
                    campiQuery.add("'${ricerca.getNome().replaceAll("'", "''")}' AS ${c}")
                }

            } else if (c.equalsIgnoreCase(AnscUtils.parametroDataNascitaSoggettoPar) && (ricerca != null)) {
                if (ricerca?.getDataNascita() != null) {
                    String dataNascitaString = DataUtils.fromDateToString(ricerca.dataNascita, "yyyy-MM-dd")
                    campiQuery.add("'${dataNascitaString}' AS ${c}")
                }

            } else if (c.equalsIgnoreCase(AnscUtils.parametroSessoSoggettoPar) && (ricerca != null)) {
                if (ricerca?.getSesso() != null) {
                    campiQuery.add("'${ricerca.getSesso().name()}' AS ${c}")
                }

            } else if (c.equalsIgnoreCase(AnscUtils.parametroNumPaginaRicercaNot) && (paginazione != null)) {
                if (paginazione?.getNumeroPagina() != null) {
                    def value = paginazione.getNumeroPagina()
                    campiQuery.add("$value AS ${c}")
                }
            } else if (c.equalsIgnoreCase(AnscUtils.parametroNumRecordPaginaRicercaNot) && (paginazione != null)) {
                if (paginazione?.getNumeroRecordPagina() != null) {
                    def value = paginazione.getNumeroRecordPagina()
                    campiQuery.add("$value AS ${c}")
                }
            } else if (c.equalsIgnoreCase(AnscUtils.parametroNumRecordTotaliRicercaNot) && (paginazione != null)) {
                if (paginazione?.getNumeroRecordTotali() != null) {
                    def value = paginazione.getNumeroRecordTotali()
                    campiQuery.add("$value AS ${c}")
                }
            } else if (c.equalsIgnoreCase(AnscUtils.parametroIdAnscRicercaEve) && (ricercaEvento != null)) {
                if (ricercaEvento?.getIdAnsc() != null) {
                    campiQuery.add("'${ricercaEvento.getIdAnsc()}' AS ${c}")
                }
            } else {
                campiQuery.add(c)
            }
        }
        sqlFinal.append(campiQuery.join(","))
        sqlFinal.append(" FROM ")
        sqlFinal.append(vista)
        sqlFinal.append(" WHERE 1 = 1 ")

        if ((parametro.equals(AnscUtils.parametroIdRif) && (idRif != null)) || (parametro.equals(AnscUtils.parametroPkAtto) && (pkAtto != null))) {
            sqlFinal.append(" AND ID = :id ")
            if (parametro.equals(AnscUtils.parametroIdRif) && (idRif != null)) {
                sqlparamsFinal.addValue("id", idRif)
            } else if (parametro.equals(AnscUtils.parametroPkAtto) && (pkAtto != null)) {
                sqlparamsFinal.addValue("id", pkAtto)
            }
        }
        String sqlStatement = sqlFinal.toString()
        List<Map<String, ?>> lq = np.queryForList(sqlStatement, sqlparamsFinal)
        for (Map<String, ?> mq : lq) {
            Map<String, ?> mVal = [:]
            for (Map.Entry<String, ?> m : mq.entrySet()) {
                String s = mCampi.get(m.getKey().toUpperCase())
                if (m.getValue() instanceof BigDecimal) {
                    mVal.put(s, m.getValue()?.longValueExact())
                } else {
                    mVal.put(s, m.getValue())
                }
            }
            lVal.add(mVal)
        }
        return lVal
    }

    List<Map<String, Object>> listXPMO(Boolean ricercaPerAtto, RicercaAttoStampa ricerca) {
        // errori bloccanti
        if (!ricercaPerAtto && (!((RicercaAttoStampa) ricerca).dataRegistrazioneDa || !((RicercaAttoStampa) ricerca).dataRegistrazioneA)) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_estremi_data_registrazione"))
        } else if (ricercaPerAtto && ((RicercaAttoStampa) ricerca).isEmptyAtto()) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_estremi_atto"))
        }
        /*
        if ( (ricercaPerAtto && ricerca.isEmptyAtto()) || (!ricercaPerAtto && (!ricerca.dataRegistrazioneDa || !ricerca.dataRegistrazioneA)) ) {
            throw new CampoMandatoryRuntimeException()
        }
        */

        StringBuilder sql = new StringBuilder("SELECT * FROM CIVXPMO_V_ZK WHERE 1 = 1 ")
        MapSqlParameterSource sqlparams = new MapSqlParameterSource()
        if (ricercaPerAtto) {
            if (ricerca.ufficio != null) {
                sql.append(" AND UFFICIO_RIC = :ufficio ")
                sqlparams.addValue("ufficio", ricerca.ufficio)
            }
            if (ricerca.anno != null) {
                sql.append(" AND ANNO_RIC = :anno ")
                sqlparams.addValue("anno", ricerca.anno)
            }
            if (ricerca.atto != null) {
                sql.append(" AND ATTO_RIC = :atto ")
                sqlparams.addValue("atto", ricerca.atto)
            }
            if (ricerca.parte != null) {
                sql.append(" AND PARTE_RIC = :parte ")
                sqlparams.addValue("parte", ricerca.parte)
            }
            if ((ricerca?.serie ?: "") != "") {
                sql.append(" AND SERIE_RIC = :serie ")
                sqlparams.addValue("serie", ricerca.serie)
            }
        } else {
            sqlparams.addValues(dal: ricerca.dataRegistrazioneDa, al: ricerca.dataRegistrazioneA)
            sql.append("AND D_DATA_REG_RIC BETWEEN :dal AND :al")
        }
        NamedParameterJdbcTemplate np = new NamedParameterJdbcTemplate(dataSource)
        return np.queryForList(sql.toString(), sqlparams)
    }

    List<ProspettoAtti> listProspettoAtti(RicercaAttoStampa ricerca) {
        if ((ricerca.annoDa != null) || (ricerca.annoA != null) || (ricerca.dataRegistrazioneDa) || (ricerca.dataRegistrazioneA)) {
            NamedParameterJdbcTemplate np = new NamedParameterJdbcTemplate(dataSource)

            StringBuilder sql = new StringBuilder("""SELECT PRA.ANNO AS ANNO, PRA.UFFICIO AS UFFICIO,
                                                                SUM(PRA.NAS1A) NAS1A, SUM(PRA.NAS1B) NAS1B, SUM(PRA.NAS2A) NAS2A, SUM(PRA.NAS2B) NAS2B,
                                                                SUM(PRA.PUB1) PUB1, SUM(PRA.PUB2A) PUB2A, SUM(PRA.PUB2B) PUB2B,
                                                                SUM(PRA.MAT1) MAT1, SUM(PRA.MAT2A) MAT2A, SUM(PRA.MAT2B) MAT2B, SUM(PRA.MAT2C) MAT2C,
                                                                SUM(PRA.MOR1) MOR1, SUM(PRA.MOR2A) MOR2A, SUM(PRA.MOR2B) MOR2B, SUM(PRA.MOR2C) MOR2C, SUM(PRA.MOR2BB) MOR2BB,
                                                                SUM(PRA.CIT) CIT,
                                                                SUM(PRA.UCI_V) UCI_V,
                                                                SUM(PRA.UCI_A) UCI_A
                                                                FROM CIVPRA PRA WHERE 1 = 1 """)

            MapSqlParameterSource sqlparams = new MapSqlParameterSource()
            if (ricerca?.annoDa != null) {
                sql.append(" AND ANNO >= :annoDa ")
                sqlparams.addValue("annoDa", ricerca.annoDa)
            }
            if (ricerca?.annoA != null) {
                sql.append(" AND ANNO <= :annoA ")
                sqlparams.addValue("annoA", ricerca.annoA)
            }
            if (ricerca?.dataRegistrazioneDa != null) {
                sql.append(" AND D_DATA_REG >= :dataRegistrazioneDa ")
                sqlparams.addValue("dataRegistrazioneDa", ricerca.dataRegistrazioneDa)
            }
            if (ricerca?.dataRegistrazioneA != null) {
                sql.append(" AND D_DATA_REG <= :dataRegistrazioneA ")
                sqlparams.addValue("dataRegistrazioneA", ricerca.dataRegistrazioneA)
            }
            if (ricerca.stato == EStatoAtto.IN_INSERIMENTO) {
                sql.append(" AND COD_REC = 3 ")
            } else if (ricerca.stato == EStatoAtto.CONSOLIDATO) {
                sql.append(" AND COD_REC = 0 ")
            }

            sql.append(" GROUP BY PRA.ANNO, PRA.UFFICIO ")

            sql.append(" ORDER BY PRA.ANNO ASC")

            String sqlStatement = sql.toString()
            List<Map<String, Object>> lm = np.queryForList(sqlStatement, sqlparams)
            List<ProspettoAtti> res = []
            for (Map<String, Object> m : lm) {
                res.add(new ProspettoAtti(m))
            }
            return res
        } else {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_prospetto"))
        }
    }

    List<Map<String, Object>> listDocumentoDAT(Integer matricola) {
        if (matricola != null) {
            NamedParameterJdbcTemplate np = new NamedParameterJdbcTemplate(dataSource)

            StringBuilder sql = new StringBuilder("""SELECT WDI.TIPO_DI, DDO.DESCRIZIONE AS DESCRIZIONE_DI,
                                                                WDI.NUMERO_DI, WDI.ENTE_EMISSIONE_DI, DEN.DESCRIZIONE AS DESCRIZIONE_ENTE_EMISSIONE_DI,
                                                                WDI.COD_PRO_ENTE_DI, WDI.COD_COM_ENTE_DI, 
                                                                F_COMUNE_AL(WDI.COD_PRO_ENTE_DI,WDI.COD_COM_ENTE_DI,WDI.DATA_EMISSIONE_DI) AS DESCRIZIONE_COM_ENTE_DI, 
                                                                F_PROVINCIA_STATO_AL(WDI.COD_PRO_ENTE_DI,WDI.COD_COM_ENTE_DI,'','S','',WDI.DATA_EMISSIONE_DI) AS SIGLA_PRO_ENTE_DI, 
                                                                D_DATA_EMISSIONE_DI, D_DATA_SCADENZA_DI
                                                           FROM ANADDO DDO, ANADEN DEN, ANAWDI WDI 
                                                          WHERE DDO.COD_DO = WDI.TIPO_DI AND DEN.COD_EN = WDI.ENTE_EMISSIONE_DI AND WDI.TIPO_DI IS NOT NULL 
                                                            AND WDI.MATRICOLA = :matricola """)

            MapSqlParameterSource sqlparams = new MapSqlParameterSource("matricola", matricola)

            String sqlStatement = sql.toString()
            List<Map<String, Object>> lm = np.queryForList(sqlStatement, sqlparams)
            return lm
        } else {
            return []
        }
    }

    ArcComune checkComuneNascitaAuto() {
        String comuneNascitaAuto = getValoreParametro(ArcParametro.ANAS_COM)
        if (comuneNascitaAuto == ETipoSN.S.name()) {
            return getComuneCliente()
        }
        return null
    }

    ArcComune checkComuneResidenzaAuto() {
        return getComuneCliente()
    }

    ArcComune checkComuneDecessoAuto() {
        return getComuneCliente()
    }

    ArcComune checkComuneMatrimonioAuto() {
        return getComuneCliente()
    }

    ArcComune getComuneCliente() {
        ArcComune comune = arcComuneBaseService.getComuneCliente()
        return comune
    }

    String getValoreParametro(String parametro, int limit = 3999) {
        String valore
        Integer posizione = new Integer(1)
        Integer numeroCaratteri
        String tipo = "X"
        String upperCase = "S"
        String defaultValue
        switch (parametro) {
            case ArcParametro.ATTI_MAR:
                numeroCaratteri = new Integer(1)
                defaultValue = ETipoSN.S.name()
                break
            case ArcParametro.ANAS_COM:
                numeroCaratteri = new Integer(3999)
                defaultValue = ETipoSN.N.name()
                break
            default:
                numeroCaratteri = new Integer(limit)
                defaultValue = null
                break
        }
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_VALORE_INP(?, ?, ?, ?, ?) ; END; ",
                    [Sql.VARCHAR, parametro, posizione, numeroCaratteri, tipo, upperCase]) {
                result -> valore = (result?.trim() ?: defaultValue)
            }
        } catch (SQLException e) {
            log.error("Errore in recupero parametro di configurazione", e)
            throw new ErroreCaricamentoDatiRuntimeException(Etichette.getEtichetta("Errore_parametro"))
        }
        return valore
    }

    String getDataSourceXmlComunicazione(CivArchivioComunicazione c) {
        String ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)

        // Use StringBuilder to collect chunks of data
        StringBuilder stringBuilder = new StringBuilder()
        Reader reader
        try {
            sql.call(" BEGIN ? := F_SCSW_DATA_SOURCE_XML(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ; END; ",
                    [Sql.CLOB, c.tipoAtto, c.ufficio, c.anno, c.atto, c.parte, c.serie, c.formula, DataUtils.fromDateToString(c.dataRegistrazione),
                     c.sequenza, c.comunicazione.id, utenteCustomService.loggedUserId]) { CLOB clob ->
                reader = clob.getCharacterStream()
                String line

                // Read the CLOB stream line by line
                while ((line = reader.readLine()) != null) {
                    stringBuilder.append(line).append('\n') // Append each line to the StringBuilder
                }
            }

            // Convert StringBuilder to String and assign to ret
            ret = stringBuilder.toString()
        } catch (SQLException e) {
            log.error("Errore in recupero dati comunicazione", e)
            throw new De4gsdzkRuntimeException("Errore in recupero dati comunicazione")
        } finally {
            // Close resources in the finally block to ensure they're always closed
            if (reader != null) {
                reader.close()
            }
        }
        return ret?.trim()
    }

    String getDataSourceXmlCertificato(CerCertificatoEmesso c) {
        String ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)

        // Use StringBuilder to collect chunks of data
        StringBuilder stringBuilder = new StringBuilder()
        Reader reader
        try {
            sql.call(" BEGIN ? := F_CERW_DATA_SOURCE_XML(?) ; END; ",
                    [Sql.CLOB, c.idEmissione]) { CLOB clob ->
                reader = clob.getCharacterStream()
                String line

                // Read the CLOB stream line by line
                while ((line = reader.readLine()) != null) {
                    stringBuilder.append(line).append('\n') // Append each line to the StringBuilder
                }
            }

            // Convert StringBuilder to String and assign to ret
            ret = stringBuilder.toString()
        } catch (SQLException e) {
            log.error("Errore in recupero dati certificato", e)
            throw new De4gsdzkRuntimeException("Errore in recupero dati certificato")
        } finally {
            // Close resources in the finally block to ensure they're always closed
            if (reader != null) {
                reader.close()
            }
        }
        return ret?.trim()
    }

    String getDataSourceXmlAdempimentoPratica(AnaArchivioComunicazione c) {
        String ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)

        // Use StringBuilder to collect chunks of data
        StringBuilder stringBuilder = new StringBuilder()
        Reader reader
        try {
            sql.call(" BEGIN ? := F_SAPW_DATA_SOURCE_XML (?, ?, ?, ?, ?, ?) ; END; ",
                    [Sql.CLOB, c.archivioAnagrafe.id, c.tipoPratica.id, c.annoPratica, c.numeroPratica, c?.anagrafe?.matricola ?: null, utenteCustomService.loggedUserId]) { CLOB clob ->
                reader = clob.getCharacterStream()
                String line

                // Read the CLOB stream line by line
                while ((line = reader.readLine()) != null) {
                    stringBuilder.append(line).append('\n') // Append each line to the StringBuilder
                }
            }

            // Convert StringBuilder to String and assign to ret
            ret = stringBuilder.toString()
        } catch (SQLException e) {
            log.error("Errore in recupero dati adempimenti pratica", e)
            throw new De4gsdzkRuntimeException("Errore in recupero dati adempimenti pratica")
        } finally {
            // Close resources in the finally block to ensure they're always closed
            if (reader != null) {
                reader.close()
            }
        }
        return ret?.trim()
    }

    String getDataSourceXmlComunicazionePratica(AnaArchivioComunicazione c) {
        String ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)

        // Use StringBuilder to collect chunks of data
        StringBuilder stringBuilder = new StringBuilder()
        Reader reader
        try {
            sql.call(" BEGIN ? := F_SCAW_DATA_SOURCE_XML (?, ?, ?, ?, ?, ?) ; END; ",
                    [Sql.CLOB, c.archivioAnagrafe.id, c.tipoPratica.id, c.annoPratica, c.numeroPratica, c.id, utenteCustomService.loggedUserId]) { CLOB clob ->
                reader = clob.getCharacterStream()
                String line

                // Read the CLOB stream line by line
                while ((line = reader.readLine()) != null) {
                    stringBuilder.append(line).append('\n') // Append each line to the StringBuilder
                }
            }

            // Convert StringBuilder to String and assign to ret
            ret = stringBuilder.toString()
        } catch (SQLException e) {
            log.error("Errore in recupero dati comunicazione pratica", e)
            throw new De4gsdzkRuntimeException("Errore in recupero dati comunicazione pratica")
        } finally {
            // Close resources in the finally block to ensure they're always closed
            if (reader != null) {
                reader.close()
            }
        }
        return ret?.trim()
    }

    String getIdentificativoAtto(Integer tipoAtto, Integer ufficio, Integer anno, Integer parte, String serie, Integer atto) {
        String ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_CIV_GET_ID_ATTO(?, ?, ?, ?, ?, ?) ; END; ",
                    [Sql.VARCHAR, tipoAtto, ufficio, anno, parte, serie, atto]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in recupero identificativo atto", e)
            throw new De4gsdzkRuntimeException("Errore in recupero identificativo atto")
        }
        return ret?.trim()
    }

    String getIdComunicazioneAtto(CivComunicazioneAtto c) {
        String ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_CIVDCA_NR(?,?) ; END; ", [Sql.VARCHAR, c.tipoAtto, c.comunicazione.id]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in recupero identificativo comunicazione atto", e)
            throw new De4gsdzkRuntimeException("Errore in recupero identificativo comunicazione atto")
        }
        return ret?.trim()
    }

    Long ricercaSoggettoANPR(String cognome, String nome, String codiceFiscale, Date dataNascita, Long idSoggettoAnpr, String idUnicoAnpr, Date dataRiferimento = null, boolean flagInserimento = false) {
        Long ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_ANPR_RICERCA_SOGGETTO(NULL, ?, ?, ?, ?, ?, ?, ?, ?) ; END; ",
                    [Sql.NUMERIC, codiceFiscale, cognome, nome, DataUtils.fromDateToString(dataNascita), DataUtils.fromDateToString(dataRiferimento), utenteCustomService.loggedUserId, idUnicoAnpr ?: idSoggettoAnpr, flagInserimento ? 'S' : null]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in ricerca ANPR", e)
            throw new SqlRuntimeException(e.message, e)
        }
        return ret
    }

    Long ricercaComponentiANPR(Long idFamigliaAnpr, Long tipoSchedaAnpr, Date dataRiferimento = null) {
        Long ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_ANPR_RICERCA_COMPONENTI(NULL, NULL, ?, ?, NULL, ?, ?) ; END; ",
                    [Sql.NUMERIC, DataUtils.fromDateToString(dataRiferimento), utenteCustomService.loggedUserId, idFamigliaAnpr, tipoSchedaAnpr]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in ricerca ANPR (componenti)", e)
            throw new SqlRuntimeException(e.message, e)
        }
        return ret
    }

    /**
     * Genera un nuovo id per una entity in base alla sequence Oracle stabilita per l'entity
     *
     * @param entity l'entity
     * @param tableName (opzionale) nome tabella, se non ricavabile dalla entity
     * @return l'id generato dalla sequence
     */
    Long getIdFromSequence(Object entity, String tableName = null) {
        tableName = tableName ?: DomainUtils.getTableName(entity)
        return getIdFromFunction("F_" + tableName + "_NR", entity?.id)
    }

    /**
     * Genera un nuovo id per una entity dalla funzione specificata
     *
     * @param fn nome della function PL-SQL
     * @param id (opzionale) l'id
     * @return l'id generato (o se passato, quello passato)
     */
    private Long getIdFromFunction(String fn, Object id = null) {
        Long ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := " + fn + " (?) ; END; ", [Sql.NUMERIC, id]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in recupero id", e)
            throw new De4gsdzkRuntimeException("Errore in recupero id")
        }
        return ret
    }

    Integer getIntegerIdFromSequence(Object entity, String tableName = null) {
        Integer ret = null
        String t = (tableName ?: DomainUtils.getTableName(entity))
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_" + t + "_NR (?) ; END; ", [Sql.INTEGER, entity.id]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in recupero id per tabella/vista " + t, e)
            throw new De4gsdzkRuntimeException("Errore in recupero id per tabella/vista " + t)
        }
        return ret
    }

    String decodificaTestoFormulaCia(ETipoFormulaAggiuntiva tipoFormula, CivAttoBaseDomain atto) {
        if ((atto.natura == ENaturaAtto.O) && (tipoFormula != null)) {
            String ret = null
            Integer tipoAtto = atto.tipoAtto
            Integer ufficio = atto.ufficio
            Integer anno = atto.anno
            Integer parte = atto.parte
            String serie = atto.serie
            Integer numero = atto.atto
            String natura = atto.natura.name()

            Connection conn = DataSourceUtils.getConnection(dataSource)
            Sql sql = new Sql(conn)
            try {
                sql.call(" BEGIN ? := F_CIV_TESTO_FORMULA_CIA(?, ?, ?, ?, ?, ?, ?, ?, ?) ; END; ",
                        [Sql.VARCHAR, tipoFormula.name(), tipoAtto, ufficio, anno, parte, serie, numero, natura, utenteCustomService.loggedUserId]) {
                    result -> ret = result
                }
            } catch (SQLException e) {
                log.error("Errore in decodifica testo copia integrale dell'atto", e)
                throw new De4gsdzkRuntimeException("Errore in decodifica testo copia integrale dell'atto")
            }
            return ret
        } else {
            throw new ErroreDatiAttoRuntimeException(Etichette.getEtichetta("Errore_natura_stampa_CIA"))
        }
    }

    String decodificaTestoFormulaChiusura(String formula, int tipoAtto, Integer anno, Integer parte, String serie, FormulaChiusuraAtti fa, RichiestaFormulaChiusura richiesta) {
        if (formula == null) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_formula"))
        }
        String ret = null
        Date dataOrdinanza = (Date) richiesta.dataOrdinanza
        Date dataRestituzione = (Date) richiesta.dataRestituzione
        Date dataChiusura = (Date) richiesta.dataChiusura
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_CIV_TESTO_FORMULA_CHIUSURA(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ; END; ",
                    [Sql.VARCHAR, formula, tipoAtto, anno, parte, serie, fa.totAtti,
                     fa.attoMinAtto, DataUtils.fromDateToString(fa.attoMinData), fa.attoMaxAtto, DataUtils.fromDateToString(fa.attoMaxData),
                     richiesta.autorita, richiesta.ordinanzaDel, DataUtils.fromDateToString(dataOrdinanza), DataUtils.fromDateToString(dataRestituzione),
                     DataUtils.fromDateToString(dataChiusura)]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in decodifica formula di chiusura", e)
            throw new De4gsdzkRuntimeException("Errore in decodifica formula di chiusura")
        }
        return ret
    }

    String decodificaTestoFormula(CivAttoBaseDomain atto, String testoOriginale, String formula, Integer richiamo, String aggiuntaRichiamo, String tabellaRif, String idRif) {
        String ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_CIV_CAMBIA_TESTO_FORMULA(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ; END; ",
                    [Sql.VARCHAR, testoOriginale, atto.tipoAtto, atto.anno, atto.ufficio, atto.atto, atto.parte, atto.serie, formula, richiamo, aggiuntaRichiamo, tabellaRif, idRif]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in decodifica frammento", e)
            throw new De4gsdzkRuntimeException("Errore in decodifica frammento")
        }
        return ret
    }

    String decodificaTestoAnnotazione(int tipoAttoTarget, String formula, CivAttoBaseDomain attoSource, CivDatiProvenienzaAtto dpaSource, int numSoggetto) {
        String cognomeNome1 = null
        String cognomeNome2 = null
        String dataEvento = null
        String comuneEvento = null
        Integer codiceProvinciaEvento = null
        String sesso1 = null
        String tipoDivorzio = null
        String dataAccordoDivorzio = null
        Integer parteAccordoDivorzio = null
        String serieAccordoDivorzio = null
        Integer attoAccordoDivorzio = null
        Integer annoAccordoDivorzio = null
        String avvocato1 = null
        String avvocato2 = null
        String numeroSentenzaDivorzio = null
        String imprecisatoMorte = null
        String tribunaleSentenza = null
        String dataSentenza = null
        String numeroSentenza = null
        String testoRiassunto = null
        switch (attoSource.getTipoAttoEnum()) {
            case ETipoAtto.MAT:
            case ETipoAtto.UCI:
                if (attoSource instanceof IAttoMatUci) {
                    IAttoMatUci am = attoSource
                    cognomeNome1 = am.getNominativo1()
                    cognomeNome2 = am.getNominativo2()
                    dataEvento = DataUtils.fromDateToString(am.dataMatrimonio)
                    comuneEvento = am.descrizioneComuneMatrimonio
                    codiceProvinciaEvento = am.codiceProvinciaMatrimonio
                    if (am.divorzio) {
                        tipoDivorzio = dpaSource.tipoDivorzio?.name()
                        dataAccordoDivorzio = DataUtils.fromDateToString(dpaSource.dataAccordo)
                        parteAccordoDivorzio = dpaSource.parteAccordo
                        serieAccordoDivorzio = dpaSource.serieAccordo
                        attoAccordoDivorzio = dpaSource.attoAccordo
                        annoAccordoDivorzio = dpaSource.annoAccordo
                        avvocato1 = dpaSource.getAvvocato1()
                        avvocato2 = dpaSource.getAvvocato2()
                    }
                    if ((attoSource instanceof CivUnioneCivile) && attoSource.isUnioneCivileConiugi()) {
                        tribunaleSentenza = dpaSource.tribunaleSentenza
                        numeroSentenza = dpaSource.numeroSentenza
                        dataSentenza = DataUtils.fromDateToString(dpaSource.dataSentenza)
                    }
                }
                break
            case ETipoAtto.MOR:
                CivMorte m = (CivMorte) attoSource
                cognomeNome1 = m.nominativo
                dataEvento = DataUtils.fromDateToString(m.dataMorte)
                comuneEvento = m.comuneMorte?.descrizione
                codiceProvinciaEvento = m.comuneMorte?.codiceProvincia
                sesso1 = m.sesso?.name()
                imprecisatoMorte = ((m.giornoMorteImprecisato ? ETipoSN.S.name() : ETipoSN.N.name()) + (m.meseMorteImprecisato ? ETipoSN.S.name() : ETipoSN.N.name()) + (m.annoMorteImprecisato ? ETipoSN.S.name() : ETipoSN.N.name()))
                break
            case ETipoAtto.CIT:
                CivCittadinanza c = (CivCittadinanza) attoSource
                cognomeNome1 = c.nominativo
                dataEvento = DataUtils.fromDateToString(c.dataDecorrenza)
                sesso1 = c.sesso?.name()
                testoRiassunto = dpaSource.testoRiassunto
                break
        }
        String ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_CIV_TESTO_ANNOTAZIONE_AUTO" +
                    "( ?, ?, ?, ?, ?" +
                    ", ?, ?, ?, ?, ?" +
                    ", ?, ?, ?, ?, ?" +
                    ", ?, ?, ?, ?, ?" +
                    ", ?, ?, ?, ?, ?" +
                    ", ?, ?, ?, ?, ?)" +
                    " ; END; ",
                    [Sql.VARCHAR
                     , new Integer(tipoAttoTarget), formula, attoSource.getTipoAtto(), attoSource.idAtto, numSoggetto
                     , attoSource.natura.name(), attoSource.anno, attoSource.atto, attoSource.parte, attoSource.serie
                     , dataEvento, comuneEvento, codiceProvinciaEvento, cognomeNome1, sesso1
                     , cognomeNome2, tipoDivorzio, dataAccordoDivorzio, parteAccordoDivorzio, serieAccordoDivorzio
                     , attoAccordoDivorzio, avvocato1, avvocato2, numeroSentenzaDivorzio, imprecisatoMorte
                     , tribunaleSentenza, numeroSentenza, dataSentenza, annoAccordoDivorzio, testoRiassunto]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in recupero testo formula", e)
            throw new De4gsdzkRuntimeException("Errore in recupero testo formula")
        }
        return ret
    }

    void aggiornaFormulaFrammento(List<Map<String, Object>> formule, CivAttoBaseDomain atto, CivFormulaTestoLibero f) {
        if (formule?.size() > 0) {
            f.testo = ""
            StringBuilder sb = new StringBuilder("")
            for (int i = 0; i < formule.size(); i++) {
                Map m = formule[i]
                f.ACapo = (m.FLAG_AGGIUNTA_A_CAPO == ETipoSN.S.name())
                f.numeroRighe = ((m.NUM_RIGHE != null) ? new Integer(m.NUM_RIGHE.intValueExact()) : null)
                f.numeroColonne = ((m.NUM_COLONNE != null) ? new Integer(m.NUM_COLONNE.intValueExact()) : null)
                f.richiamo = new Integer(m.RICHIAMO.intValueExact())
                f.progressivo = new Integer(m.PROGR_DETTAGLIO.intValueExact())

                String codFormula = m.FORMULA
                String tabellaRif = m.TABELLA_RIF
                String idRif = m.ID_RIF
                String aggiuntaRichiamo = m.FLAG_AGGIUNTA_RICHIAMO
                /* refs #64681
                if (m.FLAG_TESTO_FISSO == ETipoSN.S.name()){
                    sb.append((m.TESTO_FORMULA?:""))
                } else {
                    sb.append((decodificaTestoFormula(atto, m.TESTO_FORMULA, m.FORMULA, f.richiamo, m.FLAG_AGGIUNTA_RICHIAMO)?:""))
                }
                */
                sb.append((decodificaTestoFormula(atto, "", codFormula, f.richiamo, aggiuntaRichiamo, tabellaRif, idRif) ?: ""))
                if (i < (formule.size() - 1)) {
                    sb.append((f.ACapo ? TestoUtils.aCapo : TestoUtils.spazio))
                }
            }
            f.testo = sb.toString()
        }
    }

    List<Long> listBuchiNumerazione(Integer anno) {
        if (anno != null) {
            NamedParameterJdbcTemplate np = new NamedParameterJdbcTemplate(dataSource)
            StringBuilder sql = new StringBuilder("""SELECT v.n 
                                                       FROM (SELECT rownum n
                                                               FROM dual CONNECT BY LEVEL <= (SELECT MAX(numero) FROM CIVN01 WHERE ANNO = :anno) ) v
													  WHERE NOT exists (SELECT NUMERO_UNICO FROM ANSALL_V 
																				 WHERE ANNO = :anno AND NUMERO_UNICO = v.n) 
                                                        AND EXISTS (SELECT 1 FROM CIVN01 WHERE ANNO = :anno) 
                                                      ORDER BY 1 ASC""")
            MapSqlParameterSource sqlparams = new MapSqlParameterSource("anno", anno)
            String sqlStatement = sql.toString()
            List<Long> lm = np.queryForList(sqlStatement, sqlparams, Long.class)
            return lm
        } else {
            return []
        }
    }

    String verificaAllegatoAnsc(ETipoArchivioAnsc tipoArchivio, Long idRif, String nomeFile = null) {
        String ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_ANSC_CTR_ALLEGATO(?, ?, ?) ; END; ",
                    [Sql.VARCHAR, tipoArchivio?.name(), idRif, nomeFile]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in verifica allegato", e)
            throw new De4gsdzkRuntimeException("Errore in verifica allegato")
        }
        return ret?.trim()
    }

    Long getNumeroUnico(Integer anno) {
        Long ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := f_CIV_numero_unico(?, ?) ; END; ",
                    [Sql.NUMERIC, anno, "S"]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in recupero numero unico", e)
            throw new De4gsdzkRuntimeException("Errore in recupero numero unico")
        }
        return ret
    }

    Integer getNumeroPagamento(Integer anno) {
        Long ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := f_WSPA_numero(?) ; END; ",
                    [Sql.NUMERIC, anno]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in recupero numero unico", e)
            throw new De4gsdzkRuntimeException("Errore in recupero numero unico")
        }
        return ret
    }

    String gestisciAnscResponse(String servizio, Long idOp, String archivio, Long idRif, String response, String terminalista, String idAtto) {
        String ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := f_ANSC_ctr_response(?, ?, ?, ?, ?, ?, ?) ; END; ",
                    [Sql.VARCHAR, servizio, idOp, archivio, idRif, response, terminalista, idAtto]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in gestione response ANSC", e)
            throw new De4gsdzkRuntimeException("Errore in gestione response ANSC")
        }
        return ret?.trim()
    }

    String get_prot_indirizzo_pec(String archivioRiferimento, Integer idCivDen, Integer codiceProvincia, Integer codiceComune) {
        String ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_PROT_INDIRIZZO_PEC(?, ?, ?, ?, ?, ?, ?) ; END; ",
                    [Sql.VARCHAR, archivioRiferimento, idCivDen, codiceProvincia, codiceComune, null, null, null]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in recupero indirizzo pec", e)
            throw new De4gsdzkRuntimeException("Errore in recupero indirizzo pec")
        }
        return ret?.trim()
    }

    // Il tipo di atto deve essere passato per retrocompatibilità (la fk verso civdta è stata introdotta in questa implementazione)
    Integer getNumeroAtto(CivAttoBaseDomain atto, ETipoSiNo val) {
        Integer ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_CIV_NUMERA_ATTO(?, ?, ?, ?, ?, ?) ; END; ",
                    [Sql.INTEGER, atto.tipoAtto, atto.ufficio, atto.anno, atto.parte, atto.serie, ((val ?: ETipoSiNo.SI) == ETipoSiNo.SI ? null : ETipoSiNo.NO.name())]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in numerazione atto", e)
            throw new De4gsdzkRuntimeException("Errore in numerazione atto")
        }
        return ret
    }

    Integer getProgressivoCertificato(Integer annoCertificato) {
        Integer ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_CER_GET_PROGR_EMISSIONE(?) ; END; ",
                    [Sql.INTEGER, annoCertificato]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in numerazione certificato", e)
            throw new De4gsdzkRuntimeException("Errore in numerazione certificato")
        }
        return ret
    }

    String calcolaCf(String cognome, String nome, ESesso sesso, Date dataNascita, Integer codiceProvinciaNascita, Integer codiceComuneNascita) {
        if (cognome && nome && (sesso != null) && (dataNascita != null) && (codiceComuneNascita != null) && (codiceProvinciaNascita != null)) {
            String ret = null
            Connection conn = DataSourceUtils.getConnection(dataSource)
            Sql sql = new Sql(conn)
            try {
                sql.call(" BEGIN ? := F_CALCOLO_COD_FISCALE(?, ?, ?, ?, ?, ?) ; END; ",
                        [Sql.VARCHAR, cognome, nome, sesso.name(), DataUtils.fromDateToString(dataNascita), codiceProvinciaNascita, codiceComuneNascita]) {
                    result -> ret = result
                }
            } catch (SQLException e) {
                log.error("Errore in calcolo codice fiscale", e)
                throw new De4gsdzkRuntimeException("Errore in calcolo codice fiscale")
            }
            return ret?.trim()
        } else {
            return ERRORE_CAMPI_CF
        }
    }

    String firmaComunicazione(String idsArcCom, Long idAlle, String codUte, String otp) {
        String ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_CIV_FIRMA_REMOTA(?, ?, ?, ?) ; END; ",
                    [Sql.VARCHAR, idsArcCom, idAlle, codUte, otp]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in fase di firma comunicazione", e)
            throw new De4gsdzkRuntimeException("Errore in fase di firma comunicazione")
        }
        return ret?.trim()
    }

    String recuperaOtp(String codUte) {
        String ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_CIV_FIRMA_REMOTA_OTP(?) ; END; ", [Sql.VARCHAR, codUte]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in fase di recupero otp", e)
            throw new De4gsdzkRuntimeException("Errore in fase di recupero otp")
        }
        return ret
    }

    String protocollaComunicazioneCiv(Long idArcCom) {
        String ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_CIV_ESEGUI_PROT(?, ?) ; END; ", [Sql.VARCHAR, idArcCom, utenteCustomService.loggedUserId]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in fase di protocollazione", e)
            throw new De4gsdzkRuntimeException("Errore in fase di protocollazione")
        }
        return ret?.trim()
    }


    String protocollaComunicazioneAna(Long idArcCom) {
        String ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_ANA_ESEGUI_PROT(?, ?) ; END; ", [Sql.VARCHAR, idArcCom, utenteCustomService.loggedUserId]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in fase di protocollazione", e)
            throw new De4gsdzkRuntimeException("Errore in fase di protocollazione")
        }
        return ret?.trim()
    }

    String inviaAlboComunicazioneCiv(CivArchivioComunicazione obj) {
        String ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_CIV_INVIA_ALBO(?, ?, ?, ?, ?, ?) ; END; ",
                    [Sql.VARCHAR, obj.ufficio, obj.anno, obj.atto, obj.parte, obj.serie, obj.id]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in fase di invio all'albo", e)
            throw new De4gsdzkRuntimeException("Errore in fase di invio all'albo")
        }
        return ret?.trim()
    }

    String inviaAlboComunicazioneAna(AnaArchivioComunicazione obj) {
        /*String ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_ANA_INVIA_ALBO(?, ?, ?, ?, ?, ?) ; END; ",
                    [Sql.VARCHAR, obj.ufficio, obj.anno, obj.atto, obj.parte, obj.serie, obj.id]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error ("Errore in fase di invio all'albo", e)
            throw new De4gsdzkRuntimeException("Errore in fase di invio all'albo")
        }
        return ret?.trim()*/
        return ""
    }

    String inviaPecComunicazione(Long idArcCom, Long idDest) {
        if ((idArcCom != null) && (idDest != null)) {
            String ret = null
            Connection conn = DataSourceUtils.getConnection(dataSource)
            Sql sql = new Sql(conn)
            try {
                sql.call(" BEGIN ? := F_CIV_INVIA_MAIL(?, ?) ; END; ", [Sql.VARCHAR, idArcCom, idDest]) {
                    result -> ret = result
                }
            } catch (SQLException e) {
                log.error("Errore in invio pec", e)
                throw new De4gsdzkRuntimeException("Errore in invio pec")
            }
            return ret?.trim()
        } else {
            throw new De4gsdzkRuntimeException("Errore in invio pec: destinatari o comunicazione non precisati")
        }
    }

    String checkEstremiAtto(CivAttoBaseDomain atto) {
        if (atto != null) {
            String ret = null
            Connection conn = DataSourceUtils.getConnection(dataSource)
            Sql sql = new Sql(conn)
            try {
                sql.call(" BEGIN ? := F_CIV_ESISTE_ATTO(?, ?, ?, ?, ?, ?, ?, ?, ?) ; END; ", [Sql.VARCHAR, atto.tipoAtto, atto.natura.name(), atto.codiceRecord,
                                                                                              atto.ufficio, atto.anno, atto.atto, atto.parte, atto.serie, 0]) {
                    result -> ret = result
                }
            } catch (SQLException e) {
                log.error("Errore in verifica estremi atto", e)
                throw new De4gsdzkRuntimeException("Errore in verifica estremi atto")
            }
            return ret?.trim()
        } else {
            throw new De4gsdzkRuntimeException("Errore in verifica estremi atto")
        }
    }

    // Vale solo per gli atti zk
    String existsAttoXIdTipoAtto(Integer tipoAtto, Long idTipoAtto) {
        String ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_CIV_ESISTE_ATTO_X_TIPO_ATTO(?, ?) ; END; ",
                    [Sql.VARCHAR, tipoAtto, idTipoAtto]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in cancellazione tipo atto", e)
            throw new De4gsdzkRuntimeException("Errore in cancellazione tipo atto")
        }
        return ret?.trim()
    }

    Boolean checkComuneEstero(Integer codiceProvincia, Integer codiceComune) {
        Boolean ret = Boolean.FALSE
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_FLAG_COMUNE_ESTERO(?, ?) ; END; ",
                    [Sql.VARCHAR, codiceProvincia, codiceComune]) {
                result -> ret = (result == 'S')
            }
        } catch (SQLException e) {
            log.error("Errore in controllo comune estero", e)
            throw new De4gsdzkRuntimeException("Errore in controllo comune estero")
        }
        return ret
    }

    Integer inserisciFirmatari(Integer tipoAtto, String identificativoAtto) {
        Integer ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_ANSC_POPOLA_CIVFIR(?, ?) ; END; ",
                    [Sql.INTEGER, tipoAtto, identificativoAtto]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in inserimento firmatari atto", e)
            throw new De4gsdzkRuntimeException("Errore in inserimento firmatari atto")
        }
        return ret
    }


    Boolean flagComparente(String tipoComparente, String codice, String tipoAvv = null) {
        Boolean ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_ANSC_flag_comparente(?, ?, ?) ; END; ",
                    [Sql.VARCHAR, tipoComparente, codice, tipoAvv]) {
                result -> ret = Boolean.valueOf(result as String)
            }
        } catch (SQLException e) {
            log.error("Errore in ricerca flag comparente", e)
            throw new De4gsdzkRuntimeException("Errore in ricerca flag comparente")
        }
        return ret
    }

    AnprRichiestaCertificatoResult anprRichiestaCertificato(String idEmissione, Boolean flagForzatura) {
        AnprRichiestaCertificatoResult ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ANPR_richiesta_certificato (?, ?, ?, ?, ?) ; END; ",
                    [idEmissione, flagForzatura ? 'S' : 'N', Sql.CLOB, Sql.BLOB, Sql.VARCHAR]) {
                CLOB clob, BLOB blob, String error ->
                    byte[] blobBytes = null
                    if (blob != null) {
                        InputStream inputStream = blob.getBinaryStream()
                        ByteArrayOutputStream outputStream = new ByteArrayOutputStream()
                        byte[] buffer = new byte[1024]
                        int bytesRead
                        while ((bytesRead = inputStream.read(buffer)) != -1) {
                            outputStream.write(buffer, 0, bytesRead)
                        }
                        blobBytes = outputStream.toByteArray()
                        inputStream.close()
                        outputStream.close()
                    }
                    ret = new AnprRichiestaCertificatoResult(blobBytes, error)
            }
        } catch (SQLException e) {
            log.error("Errore in richiesta certificato Anpr", e)
            throw new De4gsdzkRuntimeException("Errore in richiesta certificato Anpr")
        }
        return ret
    }

    String getNumeroDocumentoAnagrafico(AnaTipoDocumento tipoDocumento) {
        String ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_DOC_NUMERO(?) ; END; ",
                    [Sql.VARCHAR, tipoDocumento.id]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in recupero numero unico", e)
            throw new De4gsdzkRuntimeException("Errore in recupero numero unico")
        }
        return ret
    }

    /**
     * Inserisce i parametri su WS_PAGAMENTI_INP in base al servizio pagamento passato
     *
     * @param servizioPagamento Il servizio di pagamento per cui popolare i parametri
     * @return 0 se la popolazione non ha inserito alcun parametro, 1 se la popolazione ha inserito i parametri, -1 in caso di errore
     */
    Integer popolaParametriWspa(EServizioPagamento servizioPagamento) {
        Integer ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_WSPA_POPOLA_INP(?) ; END; ",
                    [Sql.INTEGER, servizioPagamento.name()]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in popolazione parametri", e)
            throw new De4gsdzkRuntimeException("Errore in popolazione parametri")
        }
        return ret
    }

    /**
     * Inserisce le voci di costo su WS_PAGAMENTI_VSC in base alle tariffe diritti di CERDTD
     *
     * @return 0 se la popolazione non ha inserito alcun parametro, 1 se la popolazione ha inserito i parametri, -1 in caso di errore
     */
    Integer popolaVociCostoWspa() {
        Integer ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_WSPA_POPOLA_VDC() ; END; ",
                    [Sql.INTEGER]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in popolazione parametri", e)
            throw new De4gsdzkRuntimeException("Errore in popolazione parametri")
        }
        return ret
    }

    /**
     * Inserisce i servizi sulla tabella WS_PAGAMENTI_SER
     *
     * @return 0 se la popolazione non ha inserito alcun parametro, 1 se la popolazione ha inserito i parametri, -1 in caso di errore
     */
    Integer popolaServiziWspa() {
        Integer ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_WSPA_POPOLA_SER() ; END; ",
                    [Sql.INTEGER]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in popolazione parametri", e)
            throw new De4gsdzkRuntimeException("Errore in popolazione parametri")
        }
        return ret
    }

    /**
     * Inserisce i documenti sulla tabella WS_PAGAMENTI_DOC
     *
     * @return 0 se la popolazione non ha inserito alcun parametro, 1 se la popolazione ha inserito i parametri, -1 in caso di errore
     */
    Integer popolaDocumentiWspa() {
        Integer ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_WSPA_POPOLA_DOC() ; END; ",
                    [Sql.INTEGER]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in popolazione parametri", e)
            throw new De4gsdzkRuntimeException("Errore in popolazione parametri")
        }
        return ret
    }

    String getUrlWspa(String chiaveServizioEsterno) {
        String ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := f_WSPA_get_url(?) ; END; ",
                    [Sql.VARCHAR, chiaveServizioEsterno]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in ottenimento url", e)
            throw new De4gsdzkRuntimeException("Errore in ottenimento url")
        }
        return ret
    }

    String invioPagamentoWspa(Number annoPagamento, Number numeroPagamento, String terminalista) {
        String ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := f_WSPA_invio_pagamento (?, ?, ?) ; END; ",
                    [Sql.VARCHAR, annoPagamento, numeroPagamento, terminalista]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in invio pagamento", e)
            throw new De4gsdzkRuntimeException("Errore in invio pagamento")
        }
        return ret
    }

    String verificaPagamentoWspa(String chiaveServizioEsterno, String terminalista) {
        String ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := f_WSPA_verifica_pagamento(?, ?) ; END; ",
                    [Sql.VARCHAR, chiaveServizioEsterno, terminalista]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in verifica pagamento", e)
            throw new De4gsdzkRuntimeException("Errore in verifica pagamento")
        }
        return ret
    }

    String annullaPagamentoWspa(String chiaveServizioEsterno, String terminalista) {
        String ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := f_WSPA_annulla_pagamento(?, ?) ; END; ",
                    [Sql.VARCHAR, chiaveServizioEsterno, terminalista]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in annullamento pagamento", e)
            throw new De4gsdzkRuntimeException("Errore in annullamento pagamento")
        }
        return ret
    }

    void compilaOggettiDb() {
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call("""DECLARE
							BEGIN
								utilitypackage.compile_all;
							END;""")
        } catch (SQLException e) {
            log.error("Errore in compilazione oggetti database", e)
            throw new De4gsdzkRuntimeException("Errore in compilazione oggetti database")
        }
    }

    String getCognomeNome(String tabella, String idRif, String campo) {
        String ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := f_GSD_get_campo_x_unicode(?, ?, ?) ; END; ",
                    [Sql.VARCHAR, tabella, idRif, campo]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in recupero Cognome/Nome", e)
            throw new De4gsdzkRuntimeException("Errore in recupero Cognome/Nome")
        }
        return ret
    }

    Integer getNumeroPratica(ETipoAnagrafe anagrafe, Integer annoPratica, ETipoPratica tipoPratica, ETipoSiNo definitivo) {
        Integer ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_TPR_NUMERA_PRATICA(?, ?, ?, ?) ; END; ",
                    [Sql.INTEGER, anagrafe.getId(), tipoPratica.getId(), annoPratica, ((definitivo ?: ETipoSiNo.SI) == ETipoSiNo.SI ? null : ETipoSiNo.NO.name())]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in numerazione pratica", e)
            throw new De4gsdzkRuntimeException("Errore in numerazione pratica")
        }
        return ret
    }

    Long getCodCdf() {
        Long ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := f_CDF_numera() ; END; ",
                    [Sql.NUMERIC]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in codice cdf", e)
            throw new De4gsdzkRuntimeException("Errore in codice cdf")
        }
        return ret
    }

    Date calcolaDataScadenza(AnaTipoDocumento tipoDocumento, Date dataValidita, Integer matricola) {
        Date ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := f_DOC_d_data_scadenza( ?, ?, ?) ; END; ",
                    [Sql.DATE, tipoDocumento.id, new java.sql.Date(dataValidita.getTime()), matricola]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in calcolo data scadenza", e)
            throw new De4gsdzkRuntimeException("Errore in calcolo data scadenza")
        }
        return ret
    }

    Integer inserisciPatente(Integer matricola) {
        Integer ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := f_DOC_inserisci_PT( ? ) ; END; ",
                    [Sql.NUMERIC, matricola]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in inserimento Patente", e)
            throw new De4gsdzkRuntimeException("Errore in inserimento Patente")
        }
        return ret
    }

    Integer inserisciCC(Integer matricola) {
        Integer ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := f_DOC_inserisci_CC( ? ) ; END; ",
                    [Sql.NUMERIC, matricola]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in inserimento CC", e)
            throw new De4gsdzkRuntimeException("Errore in inserimento CC")
        }
        return ret
    }

    Integer annullaPatente(Integer matricola) {
        Integer ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := f_DOC_annulla_PT( ?, ? ) ; END; ",
                    [Sql.NUMERIC, matricola, utenteCustomService.loggedUserId]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in annullamento Patente", e)
            throw new De4gsdzkRuntimeException("Errore in annullamento Patente")
        }
        return ret
    }

    Integer annullaCC(Integer matricola) {
        Integer ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := f_DOC_annulla_CC( ?, ? ) ; END; ",
                    [Sql.NUMERIC, matricola, utenteCustomService.loggedUserId]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in annullamento CC", e)
            throw new De4gsdzkRuntimeException("Errore in annullamento CC")
        }
        return ret
    }

    Integer getSequenzaAvanzamento(AnaAvanzamentoPratica avanzamento) {
        Integer ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_TPR_GET_SEQUENZA_SAP( ?, ?, ?, ?, ? ) ; END; ",
                    [Sql.INTEGER, avanzamento.archivioAnagrafe.id, avanzamento.tipoPratica.id, avanzamento.annoPratica, avanzamento.numeroPratica, avanzamento.eventoPratica.codEp]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in sequenza avanzamento pratica", e)
            throw new De4gsdzkRuntimeException("Errore in sequenza avanzamento pratica")
        }
        return ret
    }

    void inserisciAvanzamento(ETipoAnagrafe archivioAnagrafe, ETipoPratica tipoPratica, Integer annoPratica, Integer numeroPratica, Integer eventoPratica) {
        Integer ret
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_TPR_INSERISCI_SAP( ?, ?, ?, ?, ?, ? ) ; END; ",
                    [Sql.INTEGER, archivioAnagrafe.id, tipoPratica.id, annoPratica, numeroPratica, eventoPratica, utenteCustomService.loggedUserId]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in inserimento avanzamento pratica", e)
            throw new De4gsdzkRuntimeException("Errore in inserimento avanzamento pratica")
        }
    }

    Long getCodiceFamiglia(EFascia fascia) {
        Long ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_ANA_GET_COD_FAM( ?, ? ) ; END; ",
                    [Sql.NUMERIC, null, fascia.id]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in codice famiglia", e)
            throw new De4gsdzkRuntimeException("Errore in codice famiglia")
        }
        return ret
    }

    String getCodiceFamigliaUnique(EFascia fascia, Long codiceFamiglia) {
        String ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_ANA_GET_COD_FAM_UNIQUE( ?, ? ) ; END; ",
                    [Sql.VARCHAR, fascia.id, codiceFamiglia]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in codice famiglia unique", e)
            throw new De4gsdzkRuntimeException("Errore in codice famiglia unique")
        }
        return ret
    }

    void inserisciEvento(ETipoAnagrafe archivioAnagrafe, ETipoPratica tipoPratica, Integer annoPratica, Integer numeroPratica, Boolean flagAnnullamento) {
        Integer ret
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_TPR_INSERISCI_EVE( ?, ?, ?, ?, ?, ? ) ; END; ",
                    [Sql.INTEGER, archivioAnagrafe.id, tipoPratica.id, annoPratica, numeroPratica, utenteCustomService.loggedUserId, flagAnnullamento ? 'S' : null]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in inserimento evento pratica", e)
            throw new De4gsdzkRuntimeException("Errore in inserimento evento pratica")
        }
    }


    void inserisciMovimento(ETipoAnagrafe archivioAnagrafe, ETipoPratica tipoPratica, Integer annoPratica, Integer numeroPratica, Boolean flagAnnullamento, Long codFam, String codFamUnique, String intestatario) {
        Integer ret
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_TPR_INSERISCI_MOV( ?, ?, ?, ?, ?, ?, ?, ?, ? ) ; END; ",
                    [Sql.INTEGER, archivioAnagrafe.id, tipoPratica.id, annoPratica, numeroPratica, utenteCustomService.loggedUserId, flagAnnullamento ? 'S' : null, codFam, codFamUnique, intestatario]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in inserimento movimento pratica", e)
            throw new De4gsdzkRuntimeException("Errore in inserimento movimento pratica")
        }
    }


    Boolean getFlagAnsc() {
        String ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_FLAG_ANSC() ; END; ",
                    [Sql.VARCHAR]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in ricerca flag ANSC", e)
            throw new De4gsdzkRuntimeException("Errore in ricerca flag ANSC")
        }
        return ret?.equals('S') ?: false
    }

    String popolaTestoTimbro(EleTimbro timbro, String sesso, Integer sezione, String tipoLista, boolean flagEstratto = false, String flagRevisione = null) {
        String ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_ELE_CAMBIA_TESTO_TIMBRO(?, ?, ?, ?, ?, ?, ?, ?) ; END; ",
                    [Sql.VARCHAR, timbro.tipo, timbro.progressivo, sesso, sezione, timbro.testo,
                     flagRevisione, tipoLista == EleTipoListaService.ID_LISTA_ORDINARIA ? null : tipoLista, flagEstratto ? 'S' : null]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in popolamento testo timbro", e)
            throw new De4gsdzkRuntimeException("Errore in popolamento testo timbro")
        }
        return ret
    }

    void popolaParametriTimbriGenerali(SpecificheListaGenerale sg) {
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            if (sg.tipoLista.id == EleTipoListaService.ID_LISTA_ORDINARIA) {
                sql.call(" BEGIN ? := F_LGA3_AGGIORNA_TABREP(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ; END; ",
                        [Sql.NUMERIC, sg.progressivoDa, sg.progressivoA, sg.stampaChiusura ? "S" : null,
                         sg.tipoFirma?.id?.substring(0, 1),
                         sg.verbale, DataUtils.fromDateToString(sg.dataVerbale, "yyyy-MM-dd"), sg.elezione?.anno, sg.elezione?.progressivo, DataUtils.fromDateToString(sg.elezione?.data, "yyyy-MM-dd"),
                         sg.revisione?.verbale, DataUtils.fromDateToString(sg.revisione?.dataVerbale, "yyyy-MM-dd"),
                         sg.verbaleCommissioneCircondariale1, DataUtils.fromDateToString(sg.dataVerbaleCommissioneCircondariale1, "yyyy-MM-dd"),
                         sg.verbaleCommissioneCircondariale2, DataUtils.fromDateToString(sg.dataVerbaleCommissioneCircondariale2, "yyyy-MM-dd"),
                         DataUtils.fromDateToString(sg.dataCommissioneCircondariale3, "yyyy-MM-dd"),
                         sg.timbroUffcioComunale1Check ? "S" : null, sg.timbroUffcioComunale2Check ? "S" : null, sg.timbroUffcioComunale3Check ? "S" : null,
                         sg.timbroCommissioneCircondariale1Check ? "S" : null, sg.timbroCommissioneCircondariale2Check ? "S" : null, sg.timbroCommissioneCircondariale3Check ? "S" : null])
            } else {
                sql.call(" BEGIN ? := F_LGAA_AGGIORNA_TABREP(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ; END; ",
                        [Sql.NUMERIC, sg.tipoLista.id, sg.progressivoDa, sg.progressivoA, sg.stampaChiusura ? "S" : null,
                         sg.tipoFirma?.id?.substring(0, 1),
                         sg.verbale, DataUtils.fromDateToString(sg.dataVerbale, "yyyy-MM-dd"), sg.elezione?.anno, sg.elezione?.progressivo, DataUtils.fromDateToString(sg.elezione?.data, "yyyy-MM-dd"),
                         sg.revisione?.verbale, DataUtils.fromDateToString(sg.revisione?.dataVerbale, "yyyy-MM-dd"),
                         sg.verbaleCommissioneCircondariale1, DataUtils.fromDateToString(sg.dataVerbaleCommissioneCircondariale1, "yyyy-MM-dd"),
                         sg.verbaleCommissioneCircondariale2, DataUtils.fromDateToString(sg.dataVerbaleCommissioneCircondariale2, "yyyy-MM-dd"),
                         DataUtils.fromDateToString(sg.dataCommissioneCircondariale3, "yyyy-MM-dd"),
                         sg.timbroUffcioComunale1Check ? "S" : null, sg.timbroUffcioComunale2Check ? "S" : null, sg.timbroUffcioComunale3Check ? "S" : null,
                         sg.timbroCommissioneCircondariale1Check ? "S" : null, sg.timbroCommissioneCircondariale2Check ? "S" : null, sg.timbroCommissioneCircondariale3Check ? "S" : null])
            }
        } catch (SQLException e) {
            log.error("Errore in popolamento tabrep", e)
            throw new De4gsdzkRuntimeException("Errore in compilazione oggetti database")
        }
    }

    void popolaParametriTimbriSezionali(SpecificheListaSezionale ss) {
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            if (ss.tipoLista.id == EleTipoListaService.ID_LISTA_ORDINARIA) {
                sql.call(" BEGIN ? := F_LSA3_AGGIORNA_TABREP(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ; END; ",
                        [Sql.NUMERIC, ss.sezioneDa, ss.sezioneA, ss.progressivoDa, ss.progressivoA,
                         ss.stampaSeggi ? "S" : null, ss.alfabetico ? "S" : null, ss.storico ? "S" : null,
                         ss.referendum ? "S" : null, ss.politiche ? "S" : null, ss.amministrative ? "S" : null, ss.descrizioneAmministrative,
                         ss.filtroCognome?.id,
                         ss.stampaVisto ? "S" : null, ss.stampaChiusura ? "S" : null,
                         ss.tipoFirma?.id?.substring(0, 1),
                         ss.verbale, DataUtils.fromDateToString(ss.dataVerbale, "yyyy-MM-dd"), ss.elezione?.anno, ss.elezione?.progressivo, DataUtils.fromDateToString(ss.elezione?.data, "yyyy-MM-dd"),
                         ss.revisione?.verbale, DataUtils.fromDateToString(ss.revisione?.dataVerbale, "yyyy-MM-dd"),
                         ss.verbaleCommissioneCircondariale1, DataUtils.fromDateToString(ss.dataVerbaleCommissioneCircondariale1, "yyyy-MM-dd"),
                         ss.verbaleCommissioneCircondariale2, DataUtils.fromDateToString(ss.dataVerbaleCommissioneCircondariale2, "yyyy-MM-dd"),
                         DataUtils.fromDateToString(ss.dataCommissioneCircondariale3, "yyyy-MM-dd"),
                         (ss.timbroUffcioComunaleALCheck || ss.timbroUffcioComunaleMZCheck) ? "S" : null, ss.timbroUffcioComunale1Check ? "S" : null, ss.timbroUffcioComunale2Check ? "S" : null, ss.timbroUffcioComunale3Check ? "S" : null,
                         (ss.timbroCommissioneCircondarialeALCheck || ss.timbroCommissioneCircondarialeMZCheck) ? "S" : null, ss.timbroCommissioneCircondariale1Check ? "S" : null, ss.timbroCommissioneCircondariale2Check ? "S" : null, ss.timbroCommissioneCircondariale3Check ? "S" : null])

            } else {
                sql.call(" BEGIN ? := F_LSAA_AGGIORNA_TABREP(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ; END; ",
                        [Sql.NUMERIC, ss.tipoLista.id, ss.sezioneDa, ss.sezioneA, ss.progressivoDa, ss.progressivoA,
                         ss.stampaSeggi ? "S" : null, ss.alfabetico ? "S" : null, ss.storico ? "S" : null,
                         ss.referendum ? "S" : null, ss.politiche ? "S" : null, ss.amministrative ? "S" : null, ss.descrizioneAmministrative,
                         ss.filtroCognome?.id,
                         ss.stampaVisto ? "S" : null, ss.stampaChiusura ? "S" : null,
                         ss.tipoFirma?.id?.substring(0, 1),
                         ss.verbale, DataUtils.fromDateToString(ss.dataVerbale, "yyyy-MM-dd"), ss.elezione?.anno, ss.elezione?.progressivo, DataUtils.fromDateToString(ss.elezione?.data, "yyyy-MM-dd"),
                         ss.revisione?.verbale, DataUtils.fromDateToString(ss.revisione?.dataVerbale, "yyyy-MM-dd"),
                         ss.verbaleCommissioneCircondariale1, DataUtils.fromDateToString(ss.dataVerbaleCommissioneCircondariale1, "yyyy-MM-dd"),
                         ss.verbaleCommissioneCircondariale2, DataUtils.fromDateToString(ss.dataVerbaleCommissioneCircondariale2, "yyyy-MM-dd"),
                         DataUtils.fromDateToString(ss.dataCommissioneCircondariale3, "yyyy-MM-dd"),
                         (ss.timbroUffcioComunaleALCheck || ss.timbroUffcioComunaleMZCheck) ? "S" : null, ss.timbroUffcioComunale1Check ? "S" : null, ss.timbroUffcioComunale2Check ? "S" : null, ss.timbroUffcioComunale3Check ? "S" : null,
                         (ss.timbroCommissioneCircondarialeALCheck || ss.timbroCommissioneCircondarialeMZCheck) ? "S" : null, ss.timbroCommissioneCircondariale1Check ? "S" : null, ss.timbroCommissioneCircondariale2Check ? "S" : null, ss.timbroCommissioneCircondariale3Check ? "S" : null])

            }
        } catch (SQLException e) {
            log.error("Errore in popolamento tabrep", e)
            throw new De4gsdzkRuntimeException("Errore in compilazione oggetti database")
        }
    }

    void popolaParametriTimbriSezionaliEstratto(SpecificheListaSezionale ss) {
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            if (ss.tipoLista.id == EleTipoListaService.ID_LISTA_ORDINARIA) {
                sql.call(" BEGIN ? := F_SELS_AGGIORNA_TABREP(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ; END; ",
                        [Sql.NUMERIC, ss.sezioneDa, ss.sezioneA, ss.progressivoDa, ss.progressivoA,
                         ss.stampaSeggi ? "S" : null, ss.alfabetico ? "S" : null, ss.storico ? "S" : null,
                         ss.referendum ? "S" : null, ss.politiche ? "S" : null, ss.amministrative ? "S" : null, ss.descrizioneAmministrative,
                         ss.filtroCognome?.id,
                         ss.stampaVisto ? "S" : null, ss.stampaChiusura ? "S" : null,
                         ss.tipoFirma?.id?.substring(0, 1),
                         ss.verbale, DataUtils.fromDateToString(ss.dataVerbale, "yyyy-MM-dd"), ss.elezione?.anno, ss.elezione?.progressivo, DataUtils.fromDateToString(ss.elezione?.data, "yyyy-MM-dd"),
                         ss.revisione?.verbale, DataUtils.fromDateToString(ss.revisione?.dataVerbale, "yyyy-MM-dd"),
                         ss.verbaleCommissioneCircondariale1, DataUtils.fromDateToString(ss.dataVerbaleCommissioneCircondariale1, "yyyy-MM-dd"),
                         ss.verbaleCommissioneCircondariale2, DataUtils.fromDateToString(ss.dataVerbaleCommissioneCircondariale2, "yyyy-MM-dd"),
                         DataUtils.fromDateToString(ss.dataCommissioneCircondariale3, "yyyy-MM-dd"),
                         (ss.timbroUffcioComunaleALCheck || ss.timbroUffcioComunaleMZCheck) ? "S" : null, ss.timbroUffcioComunale1Check ? "S" : null, ss.timbroUffcioComunale2Check ? "S" : null, ss.timbroUffcioComunale3Check ? "S" : null,
                         (ss.timbroCommissioneCircondarialeALCheck || ss.timbroCommissioneCircondarialeMZCheck) ? "S" : null, ss.timbroCommissioneCircondariale1Check ? "S" : null, ss.timbroCommissioneCircondariale2Check ? "S" : null, ss.timbroCommissioneCircondariale3Check ? "S" : null])

            } else {
                sql.call(" BEGIN ? := F_SELA_AGGIORNA_TABREP(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ; END; ",
                        [Sql.NUMERIC, ss.tipoLista.id, ss.sezioneDa, ss.sezioneA, ss.progressivoDa, ss.progressivoA,
                         ss.stampaSeggi ? "S" : null, ss.alfabetico ? "S" : null, ss.storico ? "S" : null,
                         ss.referendum ? "S" : null, ss.politiche ? "S" : null, ss.amministrative ? "S" : null, ss.descrizioneAmministrative,
                         ss.filtroCognome?.id,
                         ss.stampaVisto ? "S" : null, ss.stampaChiusura ? "S" : null,
                         ss.tipoFirma?.id?.substring(0, 1),
                         ss.verbale, DataUtils.fromDateToString(ss.dataVerbale, "yyyy-MM-dd"), ss.elezione?.anno, ss.elezione?.progressivo, DataUtils.fromDateToString(ss.elezione?.data, "yyyy-MM-dd"),
                         ss.revisione?.verbale, DataUtils.fromDateToString(ss.revisione?.dataVerbale, "yyyy-MM-dd"),
                         ss.verbaleCommissioneCircondariale1, DataUtils.fromDateToString(ss.dataVerbaleCommissioneCircondariale1, "yyyy-MM-dd"),
                         ss.verbaleCommissioneCircondariale2, DataUtils.fromDateToString(ss.dataVerbaleCommissioneCircondariale2, "yyyy-MM-dd"),
                         DataUtils.fromDateToString(ss.dataCommissioneCircondariale3, "yyyy-MM-dd"),
                         (ss.timbroUffcioComunaleALCheck || ss.timbroUffcioComunaleMZCheck) ? "S" : null, ss.timbroUffcioComunale1Check ? "S" : null, ss.timbroUffcioComunale2Check ? "S" : null, ss.timbroUffcioComunale3Check ? "S" : null,
                         (ss.timbroCommissioneCircondarialeALCheck || ss.timbroCommissioneCircondarialeMZCheck) ? "S" : null, ss.timbroCommissioneCircondariale1Check ? "S" : null, ss.timbroCommissioneCircondariale2Check ? "S" : null, ss.timbroCommissioneCircondariale3Check ? "S" : null])

            }
        } catch (SQLException e) {
            log.error("Errore in popolamento tabrep", e)
            throw new De4gsdzkRuntimeException("Errore in compilazione oggetti database")
        }
    }


    String controllaNumeroPratica(ETipoAnagrafe archivioAnagrafe, ETipoPratica tipoPratica, Integer annoPratica, Integer numeroPratica, String nomeTabella) {
        String ret
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_TPR_CTR_NUMERO_PRATICA( ?, ?, ?, ?, ?) ; END; ",
                    [Sql.VARCHAR, archivioAnagrafe.id, tipoPratica.id, annoPratica, numeroPratica, nomeTabella]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in controllo numero pratica", e)
            throw new De4gsdzkRuntimeException("Errore in controllo numero pratica")
        }

        return ret
    }

    Long getNumeroRegistro(Integer annoRegistro) {
        Integer ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_AUC_NUMERA_REGISTRO( ? ) ; END; ",
                    [Sql.NUMERIC, annoRegistro]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in numero registro", e)
            throw new De4gsdzkRuntimeException("Errore in numero registro")
        }
        return ret
    }

    String inserisciAggiornaComunicazioniAdempimenti(ETipoAnagrafe archivioAnagrafe, ETipoPratica tipoPratica, Integer annoPratica, Integer numeroPratica, Boolean priorita, Integer codiceCo) {
        String ret
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_ANA_POPOLA_ANACOM( ?, ?, ?, ?, ?, ?) ; END; ",
                    [Sql.VARCHAR, archivioAnagrafe.id, tipoPratica.id, annoPratica, numeroPratica, priorita ? 'S' : null, codiceCo]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in inserimento/aggiornamento comunicazioni e adempimenti pratica", e)
            throw new De4gsdzkRuntimeException("Errore in inserimento/aggiornamento comunicazioni e adempimenti pratica")
        }

        return ret
    }

    String getIdModelloAnagrafe(AnaModello m) {
        String ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_ANAMOD_NR(?,?) ; END; ", [Sql.VARCHAR, m.tipoModello.id, m.codModello]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in recupero identificativo modello anagrafe", e)
            throw new De4gsdzkRuntimeException("Errore in recupero identificativo modello anagrafe")
        }
        return ret?.trim()
    }


    String getIdComunicazionePratica(ETipoAnagrafe archivioAnagrafe, ETipoPratica tipoPratica, Integer codiceCo) {
        String ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_ANADCT_ZK_NR(?,?, ?) ; END; ", [Sql.VARCHAR, archivioAnagrafe.id, tipoPratica.id, codiceCo]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in recupero identificativo ANADCT", e)
            throw new De4gsdzkRuntimeException("Errore in recupero identificativo ANADCT")
        }
        return ret?.trim()
    }

    Long ricercaOperazioniANPR(String codiceFiscale, Long idSoggettoAnpr) {
        Long ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_ANPR_RICERCA_OPERAZIONI (NULL, ?, ?, ?) ; END; ",
                    [Sql.NUMERIC, codiceFiscale, utenteCustomService.loggedUserId, idSoggettoAnpr]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in ricerca ANPR", e)
            throw new SqlRuntimeException(e.message, e)
        }
        return ret
    }

    Long inviaComunicazioneANPR(Long idOperazione, String idServizio, Boolean flagRipetizione) {
        Long ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_ANPR_INVIA_COMUNICAZIONE (?, ?, ?) ; END; ",
                    [Sql.NUMERIC, idOperazione, idServizio, flagRipetizione ? 'S' : null]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in invio comunicazione ANPR", e)
            throw new SqlRuntimeException(e.message, e)
        }
        return ret
    }

    Long annullaComunicazioneANPR(Long idOperazione, String idServizio) {
        Long ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_ANPR_ANNULLA_COMUNICAZIONE (?, ?, ?) ; END; ",
                    [Sql.NUMERIC, idOperazione, idServizio, utenteCustomService.loggedUserId]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in annullamento comunicazione ANPR", e)
            throw new SqlRuntimeException(e.message, e)
        }
        return ret
    }

    String getNumeroSessioneOracle() {
        String ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_TABREP_TERMINALE() ; END; ",
                    [Sql.VARCHAR]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in ottenimento numero sessione Oracle", e)
            throw new De4gsdzkRuntimeException("Errore in ottenimento numero sessione Oracle")
        }
        return ret
    }

    Long popolaDatiEliminazione(Long idPratica, ModificaEvento modificaEvento) {
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_ELEV_AGGIORNA_TABREP(?, ?, ?, ?, ?) ; END; ",
                    [Sql.NUMERIC, idPratica, modificaEvento.ripristino ? 'S' : null, utenteCustomService.loggedUserId, modificaEvento.motivo, getNumeroSessioneOracle()])

        } catch (SQLException e) {
            log.error("Errore in popolamento TABREP (Eliminazione evento)", e)
            throw new SqlRuntimeException(e.message, e)
        }
    }

    Long popolaDatiAggiornamento(Long idPratica, ModificaEvento modificaEvento) {
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_AGEV_AGGIORNA_TABREP(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ; END; ",
                    [Sql.NUMERIC, idPratica, modificaEvento.pratica, modificaEvento.anno,
                     modificaEvento.comuneEvento.codiceProvincia, modificaEvento.comuneEvento.codice, DataUtils.fromDateToString(modificaEvento.dataRegistrazione, "yyyy-MM-dd"),
                     modificaEvento.comuneIscrizioneAire.codiceProvincia, modificaEvento.comuneIscrizioneAire.codice, utenteCustomService.loggedUserId, modificaEvento.motivo, getNumeroSessioneOracle()])

        } catch (SQLException e) {
            log.error("Errore in popolamento TABREP (Aggiornamento evento)", e)
            throw new SqlRuntimeException(e.message, e)
        }
    }

    String modificaEvento(Boolean aggiornamento) {
        String ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        String function = aggiornamento ? "F_ANA_AGGIORNAMENTO_EVENTO" : "F_ANA_ELIMINAZIONE_EVENTO"
        try {
            sql.call(" BEGIN ? := ${function}( ? ) ; END; ",
                    [Sql.VARCHAR, getNumeroSessioneOracle()]) {
                result -> ret = result
            }

        } catch (SQLException e) {
            log.error("Errore in invocazion ${function}", e)
            throw new SqlRuntimeException(e.message, e)
        }

        return ret
    }

    Long getNumeroPraticaCdf(String tipoCdf, Integer anno) {
        Long ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_CDF_NUMERA_PRATICA( ?, ? ) ; END; ",
                    [Sql.NUMERIC, tipoCdf, anno]) {
                result -> ret = result
            }
        } catch (SQLException e) {
            log.error("Errore in codice cdf", e)
            throw new De4gsdzkRuntimeException("Errore in codice cdf")
        }
        return ret
    }


    String eliminaPratica(AnaPratica pratica) {
        String ret = null
        Connection conn = DataSourceUtils.getConnection(dataSource)
        Sql sql = new Sql(conn)
        try {
            sql.call(" BEGIN ? := F_TPR_ELIMINA_PRATICA( ?, ?, ?, ?, ? ) ; END; ",
                    [Sql.VARCHAR, pratica.archivioAnagrafe.id, pratica.tipoPratica.id, pratica.anno, pratica.numero, utenteCustomService.loggedUserId]) {
                result -> ret = result
            }

        } catch (SQLException e) {
            log.error("Errore in invocazion F_TPR_ELIMINA_PRATICA", e)
            throw new SqlRuntimeException(e.message, e)
        }

        return ret
    }
}