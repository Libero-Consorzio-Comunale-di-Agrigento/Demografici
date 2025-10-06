package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.IMessaggio
import org.hibernate.annotations.Immutable

import javax.persistence.*

@Entity
@Immutable
@Table(name = "ANAMSG")
class AnaMessaggio extends GsdBaseDomain implements IMessaggio {

    @EmbeddedId
    AnaMessaggioCompositeId id

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

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_ANA", nullable = true)
    Boolean flagAnagrafe

    Boolean isBloccante() {
        return flagAvviso != true
    }

    static final List<Map> etichetteDomain = [Etichette.Bloccante, Etichette.Messaggio, Etichette.Dettaglio]

}
