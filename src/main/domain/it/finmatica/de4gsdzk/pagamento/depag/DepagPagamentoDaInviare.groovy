package it.finmatica.de4gsdzk.pagamento.depag

import it.finmatica.de4gsdzk.pagamento.WspaPagamentoDaInviare
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@DiscriminatorValue("DEPAG")
class DepagPagamentoDaInviare extends WspaPagamentoDaInviare {
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "COD_SERVIZIO_DEPAG", nullable = false, updatable = false, insertable = false)
    DepagServizio servizio

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Servizio")]
}
