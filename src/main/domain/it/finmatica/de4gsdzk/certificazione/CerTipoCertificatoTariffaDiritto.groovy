package it.finmatica.de4gsdzk.certificazione

import it.finmatica.de4gsdzk.GsdBaseDomain
import org.hibernate.annotations.Immutable

import javax.persistence.*

@Entity
@Immutable
@Table(name = "CERDDC")
@IdClass(CerTipoCertificatoTariffaDirittoCompositeId.class)
class CerTipoCertificatoTariffaDiritto extends GsdBaseDomain {

    @Id
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "COD_CERTIFICATO", nullable = false)
    CerTipoCertificato tipoCertificato

    @Id
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "ID_CERDTD", nullable = false)
    CerTariffaDiritto tariffaDiritto
}
