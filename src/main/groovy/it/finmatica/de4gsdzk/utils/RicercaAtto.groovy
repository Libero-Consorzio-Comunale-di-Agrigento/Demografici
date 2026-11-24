package it.finmatica.de4gsdzk.utils

class RicercaAtto implements IRicercaAtto{

    Integer anno
    Integer ufficio
    Integer parte
    private String serie

    String getSerie() {
        return serie
    }

    void setSerie(String serie) {
        this.serie = serie?.toUpperCase()
    }

    Integer atto
    String cognome
    String nome
    Date dataEvento
    EStatoAtto stato
    ETipoSiNo comunicazioniPendenti
    ETipoEvento tipo
    ETipoAtto tipoAtto

    String idAttoAnsc

    Long numeroUnico

    RicercaAtto() {}

    RicercaAtto(Integer anno) {
        super()
        this.anno = anno
    }

    RicercaAtto(ETipoAtto tipoAtto) {
        setTipoAtto(tipoAtto)
    }

    RicercaAtto(ETipoAtto tipoAtto, EStatoAtto stato) {
        setTipoAtto(tipoAtto)
        this.stato = stato
    }

    Boolean hasSerie(){
        return tipoAtto ? tipoAtto.hasSerie() : Boolean.TRUE
    }

    Boolean hasParte(){
        return tipoAtto ? tipoAtto.hasParte() : Boolean.TRUE
    }

    Boolean isAttoAnsc(){
        return tipoAtto ? tipoAtto.isAttoAnsc() : Boolean.FALSE
    }

    void setTipoAtto(ETipoAtto tipoAtto) {
        this.tipoAtto = tipoAtto
        cancella()
    }

    void cancella() {
        ufficio = null
        anno = null
        atto = null
        parte = null
        serie = null
        cognome = null
        nome = null
        idAttoAnsc = null
    }

    boolean isEmptyAtto() { !ufficio && !anno && !parte && !serie && !atto }

    @Override String toString() {
        String.format("COGNOME: %, NOME: %s, ANNO: %s, ATTO: %s",cognome,nome,anno,atto)
    }

    static final List<Map> etichetteRicercaDesc = [Etichette.getEtichetta("Parte"), Etichette.getEtichetta("Serie"), Etichette.getEtichetta("Ufficio"), Etichette.getEtichetta("Numero"),
                                                   Etichette.getEtichetta("Cognome"), Etichette.getEtichetta("Nome"), Etichette.getEtichetta("Id_Atto_Ansc"),
                                                   Etichette.getEtichetta("Stato"), Etichette.getEtichetta("Tipo"), Etichette.getEtichetta("Comunicazioni_pendenti"),
                                                   Etichette.getEtichetta("Effettua_Ricerca"), Etichette.getEtichetta("CONSOLIDATO"), Etichette.getEtichetta("PROVVISORIO"), Etichette.getEtichetta("IN_INSERIMENTO"), Etichette.getEtichetta("Tutti")]

}
