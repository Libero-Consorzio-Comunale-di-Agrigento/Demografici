package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ANPINP")
class AnprParametro {

    @Id
    @Column(name = "PARAMETRO")
    String parametro

    @Column(name = "VALORE")
    String valore

    @Column(name = "DESCRIZIONE")
    String descrizione

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_VISIBILE", nullable = true)
    Boolean flagVisibile

    static List<Map> etichetteDomain = [Etichette.getEtichetta("Parametro"), Etichette.getEtichetta("Valore"), Etichette.getEtichetta("Descrizione")]

    @Override
    boolean equals(Object o) {
        if (this.is(o)) return true
        if (!(o instanceof AnprParametro)) return false

        AnprParametro that = (AnprParametro) o

        if (parametro != that.parametro) return false

        return true
    }

    @Override
    int hashCode() {
        return parametro != null ? parametro.hashCode() : 0
    }

    @Override
    String toString() {
        return "AnprParametro{" +
                "parametro='" + parametro + '\'' +
                ", valore='" + valore + '\'' +
                ", descrizione='" + descrizione + '\'' +
                ", flagVisibile=" + flagVisibile +
                '}'
    }
}