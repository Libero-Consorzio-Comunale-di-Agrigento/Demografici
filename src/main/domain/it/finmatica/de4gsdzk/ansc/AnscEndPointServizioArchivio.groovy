package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.ETipoArchivioAnsc
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ANSTWS_ARC")
class AnscEndPointServizioArchivio extends GsdBaseDomain{

    @Id
    @Column(name = "ID")
    Long id

    @Enumerated(EnumType.STRING)
    @Column(name = "ARCHIVIO", nullable = false)
    ETipoArchivioAnsc archivio

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_ANSTWS", nullable = false)
    AnscEndPointServizio servizio

    @Column(name = "ID_ANST03")
    Long idCasoUso

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_ANSTWS_PREC", nullable = false)
    AnscEndPointServizio servizioPrecedente

    @Column(name = "SEQUENZA")
    Integer sequenza

    @Column(name = "TIPO_EVENTO", nullable = true)
    String tipoEvento

    @Version
    Long version

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Sequenza, Etichette.Archivio]

}
