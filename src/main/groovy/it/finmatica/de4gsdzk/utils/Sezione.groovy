package it.finmatica.de4gsdzk.utils

class Sezione {

    public static final String NASCITE                         = "NASCITE"
    public static final String MATRIMONI                       = "MATRIMONI"
    public static final String DIVORZI                         = "DIVORZI"
    public static final String UNIONI_CIVILI                   = "UNIONI_CIVILI"
    public static final String DECESSI                         = "DECESSI"
    public static final String CITTADINANZE                    = "CITTADINANZE"

    public static final String COMUNICAZIONI                = "COMUNICAZIONI"
    public static final String COMUNICAZIONI_DA_ELABORARE   = "COMUNICAZIONI_DA_ELABORARE"
    public static final String COMUNICAZIONI_ELABORATE      = "COMUNICAZIONI_ELABORATE"

    public static final String ANNOTAZIONI                  = "ANNOTAZIONI"
    public static final String ANNOTAZIONI_DA_ELABORARE     = "ANNOTAZIONI_DA_ELABORARE"
    public static final String ANNOTAZIONI_ELABORATE        = "ANNOTAZIONI_ELABORATE"

    public static final String DOCUMENTI                    = "DOCUMENTI"
    public static final String DOCUMENTI_USCITA             = "DOCUMENTI_USCITA"
    public static final String DOCUMENTI_ENTRATA            = "DOCUMENTI_ENTRATA"

    public static final String ANSC                         = "ANSC"
    public static final String NOTIFICHE                    = "NOTIFICHE"
    public static final String RICERCA_ATTI_ANSC            = "RICERCA_ATTI_ANSC"

    public static final String RUBRICA_NASCITE              = "RUBRICA_NASCITE"

    public static final String PAGAMENTI                    = "PAGAMENTI"
    public static final String PAGAMENTI_DA_INVIARE         = "PAGAMENTI_DA_INVIARE"
    public static final String PAGAMENTI_INVIATI            = "PAGAMENTI_INVIATI"
    public static final String PAGAMENTI_RICERCA_PAGAMENTO  = "PAGAMENTI_RICERCA_PAGAMENTO"

    public static final String DIZIONARI                    = "DIZIONARI"
    public static final String DIZIONARIO_DATI_GENERALI     = "DIZIONARIO_DATI_GENERALI"
    public static final String DIZIONARIO_TIPI_ATTO         = "DIZIONARIO_TIPI_ATTO"
    public static final String DIZIONARIO_MINUTE            = "DIZIONARIO_MINUTE"
    public static final String DIZIONARIO_ANNOTAZIONI       = "DIZIONARIO_ANNOTAZIONI"
    public static final String DIZIONARIO_COMUNICAZIONI     = "DIZIONARIO_COMUNICAZIONI"
    public static final String DIZIONARIO_REGISTRI          = "DIZIONARIO_REGISTRI"
    public static final String DIZIONARIO_PAGAMENTO                 = "DIZIONARIO_PAGAMENTO"
    public static final String DIZIONARIO_PAGAMENTO_PARAMETRI       = "DIZIONARIO_PAGAMENTO_PARAMETRI"
    public static final String DIZIONARIO_PAGAMENTO_VOCI_DI_COSTO   = "DIZIONARIO_PAGAMENTO_VOCI_DI_COSTO"
    public static final String DIZIONARIO_PAGAMENTO_SERVIZI         = "DIZIONARIO_PAGAMENTO_SERVIZI"
    public static final String DIZIONARIO_PAGAMENTO_DOCUMENTI       = "DIZIONARIO_PAGAMENTO_DOCUMENTI"
    public static final String DIZIONARIO_PAGAMENTO_UTENTI          = "DIZIONARIO_PAGAMENTO_UTENTI"
    public static final String DIZIONARIO_CONFIGURAZIONE    = "DIZIONARIO_CONFIGURAZIONE"
    public static final String DIZIONARIO_ANPR    = "DIZIONARIO_ANPR"
    public static final String DIZIONARIO_WS_MININT = "DIZIONARIO_WS_MININT"
    public static final String DIZIONARIO_DOCUMENTI    = "DIZIONARIO_DOCUMENTI"
    public static final String DIZIONARIO_PROVVEDIMENTI    = "DIZIONARIO_PROVVEDIMENTI"

    public static final String DIZIONARI_ANSC               = "DIZIONARI_ANSC"
    public static final String DIZIONARIO_SERVIZIO          = "DIZIONARIO_SERVIZIO"

    public static final String CERTIFICAZIONE               = "CERTIFICAZIONE"
    public static final String GESTIONE_CERTIFICAZIONE      = "GESTIONE_CERTIFICAZIONE"

    public static final String VISUALIZZAZIONE = "VISUALIZZAZIONE"
    public static final String VISUALIZZAZIONE_INDIVIDUO = "VISUALIZZAZIONE_INDIVIDUO"
    public static final String VISUALIZZAZIONE_FAMIGLIA = "VISUALIZZAZIONE_FAMIGLIA"

    public static final String PRATICHE = "PRATICHE"
    public static final String GESTIONE_PRATICHE = "GESTIONE_PRATICHE"

    public static final String ARCHIVIO = "ARCHIVIO"
    public static final String ARCHIVIO_ELETTORI = "ARCHIVIO_ELETTORE"

    public static final String DIZIONARIO_NUMERAZIONE_CIVICA    = "DIZIONARIO_NUMERAZIONE_CIVICA"

    private final String label
    private final String value
    private final String tooltip
    private final String uri
    private final String img
    private final List<Sezione> subSezioni

    Sezione(String label, String value, String tooltip, String uri, String img="", List<Sezione> subSezioni = []) {
        this.label = label
        this.value = value
        this.tooltip = tooltip
        this.uri = uri
        this.img = img
        this.subSezioni = subSezioni
    }

    String getLabel(){
        return label
    }

    String getValue(){
        return value
    }

    String getTooltip(){
        return tooltip
    }

    String getUri(){
        return uri
    }

    String getImg(){
        return img
    }

    List<Sezione> getSubSezioni() {
        return subSezioni
    }

    boolean isInto(List<Sezione> sezioni){
        Boolean selected = Boolean.FALSE
        if (sezioni){
            for (Sezione s: sezioni){
                if (s.value == getValue()){
                    selected = Boolean.TRUE
                    break
                }
            }
        }
        return selected
    }

}

