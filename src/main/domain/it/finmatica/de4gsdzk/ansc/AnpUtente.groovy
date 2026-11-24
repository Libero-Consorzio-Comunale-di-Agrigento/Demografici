package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ANPUTE")
class AnpUtente extends GsdBaseDomain {

    @Id
    @Column(name = "COD_UTENTE")
    private String id

    String getId() {
        return id
    }

    void setId(String val) {
        this.id = (val?.toUpperCase())
    }

    @Column(name = "COGNOME")
    private String cognome

    String getCognome() {
        return cognome
    }

    void setCognome(String val) {
        this.cognome = (val?.toUpperCase())
    }

    @Column(name = "NOME")
    private String nome

    String getNome() {
        return nome
    }

    void setNome(String val) {
        this.nome = (val?.toUpperCase())
    }

    @Column(name = "COD_FISCALE")
    private String codiceFiscale

    String getCodiceFiscale() {
        return codiceFiscale
    }

    void setCodiceFiscale(String val) {
        this.codiceFiscale = (val?.toUpperCase())
    }

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_DEFAULT", nullable = true)
    Boolean flagDefault

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_NOTIFICHE", nullable = true)
    Boolean flagNotifiche

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_NOTIFICHE_ELE", nullable = true)
    Boolean flagNotificheEle

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_NOTIFICHE_CIV", nullable = true)
    Boolean flagNotificheCiv

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [
            Etichette.getEtichetta("Codice_Utente"),
            Etichette.getEtichetta("Cognome"),
            Etichette.getEtichetta("Nome"),
            Etichette.getEtichetta("Codice_Fiscale"),
            Etichette.getEtichetta("Default"),
            Etichette.getEtichetta("Notifiche"),
            Etichette.getEtichetta("Notifiche_Elettorali"),
            Etichette.getEtichetta("Notifiche_Stato_Civile")
    ]

    @Override
    boolean equals(Object o) {
        if (this.is(o)) return true
        if (getClass() != o?.class) return false

        AnpUtente that = (AnpUtente) o

        if (id != that.id) return false

        return true
    }

    @Override
    int hashCode() {
        return (id != null ? id.hashCode() : 0)
    }

    @Override
    String toString() {
        return "AnpUtente{" +
                "id='" + id + '\'' +
                ", cognome='" + cognome + '\'' +
                ", nome='" + nome + '\'' +
                ", codiceFiscale='" + codiceFiscale + '\'' +
                '}'
    }
}