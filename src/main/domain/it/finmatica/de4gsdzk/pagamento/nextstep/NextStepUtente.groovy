package it.finmatica.de4gsdzk.pagamento.nextstep


import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "WS_PAGAMENTI_UTE_V")
class NextStepUtente extends GsdBaseDomain {

    @Id
    @Column(name = "COD_UTENTE", nullable = false)
    private String id

    String getId() { id }

    void setId(String id) { this.id = id?.toUpperCase() }

    @Column(name = "IDENTIFICATIVO_PROVIDER", nullable = false)
    String idEsterno

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Codice_Utente"), Etichette.getEtichetta("Nominativo"), Etichette.getEtichetta("Identificativo")]
}
