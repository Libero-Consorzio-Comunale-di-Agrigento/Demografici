package it.finmatica.de4gsdzk.certificazione

import javax.persistence.*

@Entity
@Table(name = "CERSCE_V_PAGAMENTI")
class CerDettaglioIncasso {

    @Id
    @Column(name = "ID")
    Long id

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA", nullable = false)
    Date data

    @Column(name = "DES_DIRITTO", nullable = false)
    String descrizione

    @Column(name = "TOTALE")
    BigDecimal totale

    @Column(name = "TOTALE_1")
    BigDecimal contanti

    @Column(name = "TOTALE_2")
    BigDecimal pos

    @Column(name = "TOTALE_3")
    BigDecimal pagopa

    @Column(name = "TOTALE_4")
    BigDecimal mastercard

    @Column(name = "TOTALE_5")
    BigDecimal tipoPagamento5

    @Column(name = "TOTALE_8")
    BigDecimal differito

    @Column(name = "TOTALE_9")
    BigDecimal altro
}
