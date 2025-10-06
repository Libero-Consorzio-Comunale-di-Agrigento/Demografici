package it.finmatica.de4gsdzk.pagamento

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.certificazione.CerCertificatoEmesso

import javax.persistence.*

@Slf4j
@Entity
@Table(name = "WS_PAGAMENTI_V_DA_INVIARE")
@DiscriminatorColumn(discriminatorType = DiscriminatorType.STRING,
        name = "PROVIDER")
abstract class WspaPagamentoDaInviare extends GsdBaseDomain {
    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "ANNO_PAGAMENTO")
    Integer anno

    @Column(name = "PROGR_PAGAMENTO")
    Integer progressivo

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_TABELLA_RIF", nullable = false, updatable = false, insertable = false)
    CerCertificatoEmesso certificatoEmesso

}
