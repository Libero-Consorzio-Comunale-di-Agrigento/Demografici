package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.ad4.autenticazione.Ad4Utente
import it.finmatica.ad4.hibernate.UtenteUpd
import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ANADCI")
class AnaCittadinanza {

    public static final String ID_ITALIA = "I"

    @Id
    @Column(name = "COD_CI")
    String codCi

    @Column(name = "IST_CI")
    Integer istCi

    @Column(name = "DESCRIZIONE")
    String descrizione

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "CEE", nullable = true)
    Boolean ue

    @Column(name = "DESCRIZIONE_M")
    String descrizioneM

    @Column(name = "DESCRIZIONE_F")
    String descrizioneF

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TERMINALISTA", nullable = false)
    @UtenteUpd
    Ad4Utente terminalista

    static final List<Map> etichetteDomain = [
            Etichette.getEtichetta("Codice"),
            Etichette.getEtichetta("Istat"),
            Etichette.getEtichetta("Descrizione"),
            Etichette.getEtichetta("UE"),
            Etichette.getEtichetta("Descrizione_M"),
            Etichette.getEtichetta("Descrizione_F")
    ]

    @Override
    boolean equals(Object obj) {
        if (this.is(obj)) return true
        if (obj == null || getClass() != obj.getClass()) return false
        AnaCittadinanza that = (AnaCittadinanza) obj
        return codCi == that.codCi
    }

    @Override
    int hashCode() {
        return codCi != null ? codCi.hashCode() : 0
    }

    @Override
    String toString() {
        return "AnaCittadinanza{" +
                "codCi='" + codCi + '\'' +
                ", istCi=" + istCi +
                ", descrizione='" + descrizione + '\'' +
                ", cee=" + ue +
                ", descrizioneM='" + descrizioneM + '\'' +
                ", descrizioneF='" + descrizioneF + '\'' +
                '}'
    }
}