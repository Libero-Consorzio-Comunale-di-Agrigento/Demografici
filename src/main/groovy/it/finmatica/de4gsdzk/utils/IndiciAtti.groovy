package it.finmatica.de4gsdzk.utils

class IndiciAtti {

    private final Integer anno
    private final Integer atto
    private final Integer parte
    private final String serie
    private final Integer ufficio

    private final String cognome1Lista
    private final String nome1Lista

    private final String cognome2Lista
    private final String nome2Lista

    private final String idAtto

    IndiciAtti(){
        super()
    }

    IndiciAtti(Integer anno, Integer atto, Integer parte, String serie, Integer ufficio, String idAtto, String cognome1Lista, String nome1Lista, String cognome2Lista, String nome2Lista) {
        super()
        this.anno = anno
        this.atto = atto
        this.parte = parte
        this.serie = serie
        this.ufficio = ufficio
        this.idAtto = idAtto
        this.cognome1Lista = cognome1Lista
        this.nome1Lista = nome1Lista
        this.cognome2Lista = cognome2Lista
        this.nome2Lista = nome2Lista
    }

    Integer getAnno() {
        return anno
    }

    Integer getAtto() {
        return atto
    }

    String getParteRomana() {
        if ( parte != null ){
            return TestoUtils.getParteRomana(parte.intValue())
        }
        return null
    }

    String getSerie() {
        return serie
    }

    Integer getUfficio() {
        return ufficio
    }

    String getIdAtto() {
        return idAtto
    }

    String getCognome1Lista() {
        return cognome1Lista
    }

    String getNome1Lista() {
        return nome1Lista
    }

    String getCognome2Lista() {
        return cognome2Lista
    }

    String getNome2Lista() {
        return nome2Lista
    }
}
