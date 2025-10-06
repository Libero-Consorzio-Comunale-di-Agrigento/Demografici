package it.finmatica.de4gsdzk.pagamento

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.certificazione.CerCertificatoEmesso

import javax.persistence.*

@Slf4j
@Entity
@Table(name = "WS_PAGAMENTI_V_INVIATI")
class WspaPagamentoInviatoDettaglio extends GsdBaseDomain {
    @Id
    @Column(name = "ID")
    Long id

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "ID_WS_PAGAMENTI_TES", nullable = false, updatable = false, insertable = false)
    WspaPagamentoInviato pagamentoInviato

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_TABELLA_RIF", nullable = false, updatable = false, insertable = false)
    CerCertificatoEmesso certificatoEmesso

    BigDecimal getImporto() {
        return certificatoEmesso.totale
    }

}
