package it.finmatica.de4gsdzk.certificazione

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.Column
import javax.persistence.EmbeddedId
import javax.persistence.Entity
import javax.persistence.Table

@Entity
@Table(name = "CERFCT")
class CerFondoCassaTerminalista extends GsdBaseDomain {
    @EmbeddedId
    CerFondoCassaTerminalistaCompositeId id

    @Column(name = "FONDO_CASSA", nullable = false)
    BigDecimal fondoCassa

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Data"), Etichette.getEtichetta("Terminalista"), Etichette.getEtichetta("Fondo_Cassa")]
}