package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.IMessaggio
import org.hibernate.annotations.Immutable

import javax.persistence.*

@Entity
@Immutable
@Table(name = "CIVMSG_ZK")
class CivMessaggio extends GsdBaseDomain implements IMessaggio {

    @EmbeddedId
    CivMessaggioCompositeId id

    @Column(name = "MESSAGGIO")
    String messaggio

    @Column(name = "DETTAGLIO")
    String dettaglio

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_AVVISO", nullable = true)
    Boolean flagAvviso

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_CER", nullable = true)
    Boolean flagCertificazione

    Boolean isBloccante() {
        return flagAvviso != true
    }


    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Bloccante"), Etichette.getEtichetta("Messaggio"), Etichette.getEtichetta("Dettaglio")]

}
