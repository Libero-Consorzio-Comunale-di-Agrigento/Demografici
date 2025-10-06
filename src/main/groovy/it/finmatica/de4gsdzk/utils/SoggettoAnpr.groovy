package it.finmatica.de4gsdzk.utils

import it.finmatica.de4gsdzk.ISoggettoAnpr

class SoggettoAnpr implements ISoggettoAnpr {

    private final String  cognome
    private final String  nome
    private final Integer matricola
    private final Date dataNascita

    private final Integer codiceComuneNascita
    private final Integer codiceProvinciaNascita
    private final String  descrizioneComuneNascita
    private final String  siglaProvinciaNascita

    private final Integer codiceComuneResidenza
    private final Integer codiceProvinciaResidenza
    private final String  descrizioneComuneResidenza
    private final String  siglaProvinciaResidenza

    SoggettoAnpr(String cognome, String nome, Integer matricola, Date dataNascita,
                 Integer codiceComuneNascita, Integer codiceProvinciaNascita, String descrizioneComuneNascita, String siglaProvinciaNascita,
                 Integer codiceComuneResidenza, Integer codiceProvinciaResidenza, String descrizioneComuneResidenza, String siglaProvinciaResidenza) {
        this.cognome = cognome
        this.nome = nome
        this.matricola = matricola
        this.dataNascita = dataNascita

        this.codiceComuneNascita = codiceComuneNascita
        this.codiceProvinciaNascita = codiceProvinciaNascita
        this.descrizioneComuneNascita = descrizioneComuneNascita
        this.siglaProvinciaNascita = siglaProvinciaNascita

        this.codiceComuneResidenza = codiceComuneResidenza
        this.codiceProvinciaResidenza = codiceProvinciaResidenza
        this.descrizioneComuneResidenza = descrizioneComuneResidenza
        this.siglaProvinciaResidenza = siglaProvinciaResidenza
    }

    String getCognome() {
        return cognome
    }

    String getNome() {
        return nome
    }

    Integer getMatricola() {
        return matricola
    }

    Date getDataNascita() {
        return dataNascita
    }

    Integer getCodiceComuneNascita() {
        return codiceComuneNascita
    }

    Integer getCodiceProvinciaNascita() {
        return codiceProvinciaNascita
    }

    String getDescrizioneComuneNascita() {
        return descrizioneComuneNascita
    }

    String getSiglaProvinciaNascita() {
        return siglaProvinciaNascita
    }

    Integer getCodiceComuneResidenza() {
        return codiceComuneResidenza
    }

    Integer getCodiceProvinciaResidenza() {
        return codiceProvinciaResidenza
    }

    String getDescrizioneComuneResidenza() {
        return descrizioneComuneResidenza
    }

    String getSiglaProvinciaResidenza() {
        return siglaProvinciaResidenza
    }
}

