package it.finmatica.de4gsdzk.certificazione


import javax.persistence.*

@Entity
@Table(name = "CERSCE_V")
class CerStatisticaCertificatoEmesso {

    @Id
    @Column(name = "ID")
    Long id

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA", nullable = false)
    Date data

    @Column(name = "TERMINALISTA", nullable = false)
    String terminalista

    @Column(name = "CERTIFICATO", nullable = false)
    String certificato

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TIPO_PAGAMENTO", nullable = true)
    CerTipoPagamento tipoPagamento

    @Column(name = "DES_SEGRETERIA")
    String descrizioneSegreteria

    @Column(name = "SUM_SEGRETERIA")
    BigDecimal segreteria

    @Column(name = "DES_CARTA_IDENTITA")
    String descrizioneCartaIdentita

    @Column(name = "SUM_CARTA_IDENTITA")
    BigDecimal cartaIdentita

    @Column(name = "DES_STATO_CIVILE")
    String descrizioneStatoCivile

    @Column(name = "SUM_STATO_CIVILE")
    BigDecimal statoCivile

    @Column(name = "DES_RIMBORSO_ST")
    String descrizioneRimborsoStampati

    @Column(name = "SUM_RIMBORSO_ST")
    BigDecimal rimborsoStampati

    @Column(name = "DES_BOLLO")
    String descrizioneBollo

    @Column(name = "SUM_BOLLO")
    BigDecimal bollo

    @Column(name = "DES_DIVERSI_1")
    String descrizioneDiversi1

    @Column(name = "SUM_DIVERSI_1")
    BigDecimal diversi1

    @Column(name = "DES_DIVERSI_2")
    String descrizioneDiversi2

    @Column(name = "SUM_DIVERSI_2")
    BigDecimal diversi2

    @Column(name = "COUNT_VALIDI")
    Integer validi


}
