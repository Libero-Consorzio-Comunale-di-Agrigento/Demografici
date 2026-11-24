package it.finmatica.de4gsdzk.pagamento.depag


import it.finmatica.de4gsdzk.pagamento.WspaVoceCosto
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.Column
import javax.persistence.DiscriminatorValue
import javax.persistence.Entity

@Entity
@DiscriminatorValue("DEPAG")
class DepagVoceCosto extends WspaVoceCosto {
    @Column(name = "ANNO_ACCERTAMENTO", nullable = true)
    Integer annoAccertamento

    @Column(name = "NUMERO_ACCERTAMENTO", nullable = true)
    Long numeroAccertamento

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Anno_accertamento"), Etichette.getEtichetta("Numero_accertamento")]
}
