package it.finmatica.de4gsdzk.pagamento.depag

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.certificazione.CerTipoCertificato
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "WS_PAGAMENTI_DOC_V")
class DepagDocumento extends GsdBaseDomain {

    @Id
    @Column(name = "ID", nullable = false)
    Long id

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "COD_CERTIFICATO_RIF", nullable = false, updatable = false)
    CerTipoCertificato tipoCertificato

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "COD_SERVIZIO", nullable = false)
    DepagServizio servizio

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Tipo_Certificato"), Etichette.getEtichetta("Servizio")]
}
