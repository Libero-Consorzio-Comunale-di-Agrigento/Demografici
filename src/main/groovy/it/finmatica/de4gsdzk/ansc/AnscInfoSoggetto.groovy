package it.finmatica.de4gsdzk.ansc

class AnscInfoSoggetto {

    private final String idSoggettoAnsc
    private final String nome
    private final String cognome

    AnscInfoSoggetto(String idSoggettoAnsc, String nome, String cognome){
        this.idSoggettoAnsc = idSoggettoAnsc
        this.nome = nome
        this.cognome = cognome
    }

    String getIdSoggettoAnsc() {
        return idSoggettoAnsc
    }

    String getNome() {
        return nome
    }

    String getCognome() {
        return cognome
    }

    String getNominativo(){
        return ( (this.cognome?:"") + ((this.cognome && this.nome)?" ":"") + (this.nome?:"") )
    }
}
