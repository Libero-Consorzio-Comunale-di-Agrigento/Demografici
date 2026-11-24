package it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni

import it.finmatica.ad4.autenticazione.Ad4Utente
import it.finmatica.ad4.hibernate.UtenteUpd
import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.ETipoComunicazioneAnagrafe
import it.finmatica.de4gsdzk.utils.ETipoModello
import it.finmatica.de4gsdzk.utils.Etichette
import org.hibernate.annotations.NotFound
import org.hibernate.annotations.NotFoundAction

import javax.persistence.*

@Entity
@Table(name = "ANAMOD")
class AnaModello extends GsdBaseDomain {

    @Id
    @Column(name = "ID")
    String id

    @Column(name = "COD_MODELLO")
    String codModello

    @Column(name = "DESCRIZIONE")
    String descrizione

    @Column(name = "NOTE")
    String note

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_MODELLO")
    ETipoModello tipoModello


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TERMINALISTA", nullable = true)
    @UtenteUpd
    @NotFound(action = NotFoundAction.IGNORE)
    Ad4Utente terminalista

    static final List<Map> etichetteDomain = [
            Etichette.getEtichetta("Codice"),
            Etichette.getEtichetta("Descrizione"),
            Etichette.getEtichetta("Note"),
            Etichette.getEtichetta("Modello"),
            Etichette.getEtichetta("Formato_testo"),
            Etichette.getEtichetta("Tipo")
    ]

    @Override
    boolean equals(Object obj) {
        if (this.is(obj)) return true
        if (obj == null || getClass() != obj.getClass()) return false
        AnaModello that = (AnaModello) obj
        return Objects.equals(id, that.id)
    }

    @Override
    int hashCode() {
        return Objects.hash(id)
    }

    @Override
    String toString() {
        return "AnaModello{id='${id}', codModello='${codModello}', descrizione='${descrizione}', tipoModello=${tipoModello}}"
    }
}
