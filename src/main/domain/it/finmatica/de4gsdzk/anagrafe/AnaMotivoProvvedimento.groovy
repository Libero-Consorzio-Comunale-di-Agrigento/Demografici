package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.ad4.autenticazione.Ad4Utente
import it.finmatica.ad4.hibernate.UtenteUpd
import it.finmatica.de4gsdzk.GsdBaseDomain.BooleanToStringConverter
import it.finmatica.de4gsdzk.utils.Etichette
import org.hibernate.annotations.NotFound
import org.hibernate.annotations.NotFoundAction

import javax.persistence.Column
import javax.persistence.Convert
import javax.persistence.Entity
import javax.persistence.FetchType
import javax.persistence.Id
import javax.persistence.JoinColumn
import javax.persistence.ManyToOne
import javax.persistence.Table

@Entity
@Table(name = "ANATSE")
class AnaMotivoProvvedimento {

    @Id
    @Column(name = "COD_SE")
    Integer codice

    @Column(name = "DESCRIZIONE")
    String descrizione

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "PRIVACY", nullable = true)
    Boolean privacy

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_CER", nullable = true)
    Boolean certificazione

    @Convert(converter = ETipoDivorzioProvvedimento.EnumTipoDivorzioProvvedimentoToStringConverter.class)
    @Column(name = "FLAG_DIVORZIO", nullable = true)
    ETipoDivorzioProvvedimento tipoDivorzio

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TERMINALISTA", nullable = true)
    @UtenteUpd
    @NotFound(action = NotFoundAction.IGNORE)
    Ad4Utente terminalista

    static final List<Map> etichetteDomain = [
        Etichette.getEtichetta("Codice"),
        Etichette.getEtichetta("Descrizione"),
        Etichette.getEtichetta("Privacy"),
        Etichette.getEtichetta("Certificazione"),
        Etichette.getEtichetta("Tipo_Divorzio")
    ]

    @Override
    boolean equals(Object o) {
        if (this.is(o)) return true
        if (!(o instanceof AnaMotivoProvvedimento)) return false

        AnaMotivoProvvedimento that = (AnaMotivoProvvedimento) o

        if (codice != that.codice) return false

        return true
    }

    @Override
    int hashCode() {
        return codice != null ? codice.hashCode() : 0
    }

    @Override
    String toString() {
        return "AnaMotivoProvvedimento{" +
                "codice=" + codice +
                ", descrizione='" + descrizione + '\'' +
                ", privacy=" + privacy +
                ", certificazione=" + certificazione +
                ", tipoDivorzio=" + tipoDivorzio +
                '}'
    }
}