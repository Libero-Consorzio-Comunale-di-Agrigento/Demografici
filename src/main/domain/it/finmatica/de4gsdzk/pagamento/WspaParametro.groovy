package it.finmatica.de4gsdzk.pagamento

import it.finmatica.de4gsdzk.GsdParametroBaseDomain
import it.finmatica.de4gsdzk.utils.EGruppo

import javax.persistence.*

@Entity
@Table(name = "WS_PAGAMENTI_INP_V")
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(discriminatorType = DiscriminatorType.STRING,
        name = "PROVIDER")
abstract class WspaParametro extends GsdParametroBaseDomain {
    @Column(name = "NOTE")
    String note

    @Enumerated(EnumType.STRING)
    @Column(name = "GRUPPO")
    private EGruppo gruppo

    @PrePersist
    void preInsert() {
        gruppo = EGruppo.WSP
    }
}
